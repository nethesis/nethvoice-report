package cmd

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"

	"github.com/nethesis/nethvoice-report/api/queue/cache"
	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/api/queue/methods"
	"github.com/nethesis/nethvoice-report/api/queue/models"
	"github.com/nethesis/nethvoice-report/tasks/helper"
)

// Define command handled by cobra
var queriesCmd = &cobra.Command{
	Use:   "queries",
	Short: "Execute all report queries applying all saved filters",
	Args:  cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {
		executeReportQueries()
	},
}

// Register "queries" command to root command
func init() {
	RootCmd.AddCommand(queriesCmd)
}

// Get saved searches from redis cache.
func getSearchesFromCache() ([]models.Search, error) {
	// get users list from authorizations file
	userAuthorizationsList, err := methods.ParseUserAuthorizationsFile()
	if err != nil {
		return nil, errors.Wrap(err, "Error parsing auth file")
	}

	searches := []models.Search{}
	// init cache connection
	cacheConnection := cache.Instance()

	for _, userAuthorizations := range userAuthorizationsList {
		username := userAuthorizations.Username

		// get saved searches for this section and view
		results, errCache := cacheConnection.HGetAll(username).Result()
		if errCache != nil {
			return nil, errors.Wrap(err, "Error reading cache")
		}

		// iterate over results
		for k, v := range results {
			// define model
			var search models.Search
			var filter models.Filter

			// extract name, section, view
			s := strings.Split(k, "_")
			search.Name = s[0]
			search.Section = s[1]
			search.View = s[2]

			// convert filter string to struct
			errJson := json.Unmarshal([]byte(v), &filter)
			if errJson != nil {
				return nil, errors.Wrap(err, "Error unmarshalling filter")
			}

			// assign filter
			search.Filter = filter

			// add object to array
			searches = append(searches, search)
		}
	}
	return searches, nil
}

// Get default filter for input section and view
func getDefaultFilter(section string, view string, jwtToken string) (models.Filter, error) {
	// create request
	client := &http.Client{}
	requestUrl := fmt.Sprintf("%s/filters/%s/%s", configuration.Config.APIEndpoint, section, view)
	req, err := http.NewRequest("GET", requestUrl, nil)
	if err != nil {
		return models.Filter{}, errors.Wrap(err, "Error creating request")
	}

	// add authorization header
	req.Header.Add("Authorization", "Bearer "+jwtToken)

	// perform request
	resp, err := client.Do(req)
	if err != nil {
		return models.Filter{}, errors.Wrap(err, "Error retrieving default filter")
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return models.Filter{}, errors.Errorf("Error retrieving default filter [STATUS]: %d", resp.StatusCode)
	}

	// decode response
	var result map[string]models.Filter
	json.NewDecoder(resp.Body).Decode(&result)
	filter := result["filter"]
	return filter, nil
}

// Retrieve the list of queries for the report, organized by section and view
func getQueryTree(jwtToken string) (map[string]map[string][]string, error) {
	// create request
	client := &http.Client{}
	requestUrl := configuration.Config.APIEndpoint + "/query_tree"
	req, err := http.NewRequest("GET", requestUrl, nil)
	if err != nil {
		return nil, errors.Wrap(err, "Error creating request")
	}

	// add authorization header
	req.Header.Add("Authorization", "Bearer "+jwtToken)

	// perform request
	resp, err := client.Do(req)
	if err != nil {
		return nil, errors.Wrap(err, "Error retrieving query tree")
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, errors.Errorf("Error retrieving query tree [STATUS]: %d", resp.StatusCode)
	}

	// decode response
	var result map[string]map[string]map[string][]string
	json.NewDecoder(resp.Body).Decode(&result)
	queryTree := result["query_tree"]
	return queryTree, nil
}

// Request the execution of a report query specifying an input filter
func executeQuery(queryName string, filter models.Filter, section string, view string, jwtToken string) (string, error) {
	client := &http.Client{}

	// encode filter for request URL
	filterString, err := json.Marshal(filter)
	if err != nil {
		return "", errors.Wrap(err, "Error marshalling filter")
	}
	filterEncoded := url.QueryEscape(string(filterString))
	requestUrl := fmt.Sprintf("%s/queues/%s/%s?filter=%s&graph=%s", configuration.Config.APIEndpoint, section, view, filterEncoded, queryName)

	// create request
	req, err := http.NewRequest("GET", requestUrl, nil)
	if err != nil {
		return "", errors.Wrap(err, "Error creating request")
	}

	// add authorization header
	req.Header.Add("Authorization", "Bearer "+jwtToken)

	// perform request
	resp, err := client.Do(req)
	if err != nil {
		return "", errors.Wrap(err, "Error executing query")
	}
	defer resp.Body.Close()

	// decode response
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", errors.Wrap(err, "Error reading response body")
	}

	if resp.StatusCode != 200 {
		return "", errors.Errorf("Error executing query [BODY]: %s [STATUS]: %d", string(body), resp.StatusCode)
	}
	return string(body), nil
}

// Entry point for "queries" command
func executeReportQueries() {
	// login
	jwtToken, err := login()
	if err != nil {
		helper.FatalError(err)
	}

	// get query tree
	queryTree, err := getQueryTree(jwtToken)
	if err != nil {
		helper.FatalError(err)
	}

	// step 1: default filters
	helper.LogDebug("\nExecuting queries with default filters")

	for section, views := range queryTree {
		for view, queries := range views {
			helper.LogDebug("\n[VIEW]: %s/%s", section, view)

			// get default filter for current section/view
			filter, err := getDefaultFilter(section, view, jwtToken)
			if err != nil {
				helper.LogError(errors.Wrap(err, fmt.Sprintf("error retrieving default filter, skipping all queries in %s/%s", section, view)))
				continue
			}

			// exectue queries of current section/view
			for _, queryName := range queries {
				helper.LogDebug("\n    [QUERY]: %s [FILTER]: %#v", queryName, filter)
				_, err := executeQuery(queryName, filter, section, view, jwtToken)

				if err != nil {
					helper.LogError(errors.Wrap(err, fmt.Sprintf("[QUERY]: %s [FILTER]: %#v", queryName, filter)))
					continue
				}
			}
		}
	}

	// step 2: saved searches
	searches, err := getSearchesFromCache()
	if err != nil {
		helper.FatalError(err)
	}
	helper.LogDebug("\n\nExecuting queries for %d saved searches", len(searches))

	for _, search := range searches {
		// get section, view, and query names for current search
		section := search.Section
		view := search.View
		queryNames := queryTree[section][view]

		// exectue queries of section/view
		for _, queryName := range queryNames {
			helper.LogDebug("\n    [QUERY]: %s [SEARCH]: %#v", queryName, search)
			_, err := executeQuery(queryName, search.Filter, section, view, jwtToken)

			if err != nil {
				helper.LogError(errors.Wrap(err, fmt.Sprintf("[QUERY]: %s [SEARCH]: %#v", queryName, search)))
				continue
			}
		}
	}
}

// Perform login and retrieve JWT token
func login() (string, error) {
	username := configuration.Config.Tasks.Username
	password := configuration.Config.Tasks.Password
	loginUrl := configuration.Config.APIEndpoint + "/login"

	// login request
	resp, err := http.PostForm(loginUrl, url.Values{"username": {username}, "password": {password}})
	if err != nil {
		return "", errors.Wrap(err, "Login error")
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return "", errors.Errorf("Login error, [STATUS]: %d", resp.StatusCode)
	}

	// decode response
	var result map[string]interface{}
	json.NewDecoder(resp.Body).Decode(&result)

	// get JWT token
	jwtToken := result["token"]
	if jwtToken == nil {
		return "", errors.New("Error retrieving JWT token")
	}
	return jwtToken.(string), nil
}
