package cmd

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/cobra"

	"github.com/nethesis/nethvoice-report/api/queue/cache"
	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/api/queue/methods"
	"github.com/nethesis/nethvoice-report/api/queue/models"
)

var queriesCmd = &cobra.Command{
	Use:   "queries",
	Short: "Execute all report queries applying all saved filters",
	Args:  cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {
		executeReportQueries()
	},
}

func init() {
	RootCmd.AddCommand(queriesCmd)
}

func handleError(err error) {
	os.Stderr.WriteString(err.Error())
	os.Exit(1)
}

func getSearchesFromCache() []models.Search {
	userAuthorizationsList, err := methods.ParseUserAuthorizationsFile()
	if err != nil {
		handleError(err)
	}

	searches := []models.Search{}
	// init cache connection
	cacheConnection := cache.Instance()

	for _, userAuthorizations := range userAuthorizationsList {
		username := userAuthorizations.Username

		// get saved searches for this section and view
		results, errCache := cacheConnection.HGetAll(username).Result()
		if errCache != nil {
			handleError(err)
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
				handleError(err)
			}

			// assign filter
			search.Filter = filter

			// add object to array
			searches = append(searches, search)
		}
	}
	return searches
}

func getDefaultFilter(section string, view string, jwtToken string) models.Filter {
	client := &http.Client{}
	requestUrl := fmt.Sprintf("%s/filters/%s/%s", configuration.Config.APIEndpoint, section, view)

	fmt.Println("requesting default filer:", requestUrl) ////

	req, err := http.NewRequest("GET", requestUrl, nil)
	if err != nil {
		handleError(err)
	}

	req.Header.Add("Authorization", "Bearer "+jwtToken)
	resp, err := client.Do(req)
	if err != nil {
		handleError(err)
	}
	defer resp.Body.Close()
	var result map[string]models.Filter ////
	json.NewDecoder(resp.Body).Decode(&result)
	filter := result["filter"]
	return filter
}

func getQueryTree(jwtToken string) map[string]map[string][]string {
	client := &http.Client{}
	requestUrl := configuration.Config.APIEndpoint + "/query_tree"

	fmt.Println("requesting query tree:", requestUrl) ////

	req, err := http.NewRequest("GET", requestUrl, nil)
	if err != nil {
		handleError(err)
	}

	req.Header.Add("Authorization", "Bearer "+jwtToken)
	resp, err := client.Do(req)
	if err != nil {
		handleError(err)
	}
	defer resp.Body.Close()
	var result map[string]map[string]map[string][]string
	json.NewDecoder(resp.Body).Decode(&result)
	queryTree := result["query_tree"]

	if queryTree == nil {
		handleError(errors.New("Error retrieving query tree"))
	}
	return queryTree
}

func executeQuery(queryName string, filter models.Filter, section string, view string, jwtToken string) {
	client := &http.Client{}

	// encode filter for request URL
	filterString, err := json.Marshal(filter)
	if err != nil {
		handleError(err)
	}

	filterEncoded := url.QueryEscape(string(filterString))
	requestUrl := fmt.Sprintf("%s/queues/%s/%s?filter=%s&graph=%s", configuration.Config.APIEndpoint, section, view, filterEncoded, queryName)

	fmt.Println("requesting:", requestUrl) ////

	req, err := http.NewRequest("GET", requestUrl, nil)
	if err != nil {
		handleError(err)
	}

	req.Header.Add("Authorization", "Bearer "+jwtToken)
	resp, err := client.Do(req)
	if err != nil {
		handleError(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body) ////
	fmt.Println(string(body))              ////
	fmt.Println("===========")             ////
}

func executeReportQueries() {

	fmt.Println("Executing report queries") ////

	jwtToken, err := login()
	if err != nil {
		handleError(err)
	}

	// execute queries with default filters

	queryTree := getQueryTree(jwtToken)

	for section, views := range queryTree {
		fmt.Println("-- " + section) ////

		for view, queries := range views {
			fmt.Println("---- " + view) ////

			filter := getDefaultFilter(section, view, jwtToken)

			fmt.Println("filter", filter) ////

			for _, queryName := range queries {
				fmt.Println("------ " + queryName) ////

				executeQuery(queryName, filter, section, view, jwtToken)
			}
		}
	}

	// execute queries with saved searches

	searches := getSearchesFromCache()

	fmt.Println("searches", searches) ////

	for _, search := range searches {
		section := search.Section
		view := search.View
		queryNames, err := getQueryNames(section, view)
		if err != nil {
			handleError(err)
		}

		for _, queryName := range queryNames {
			executeQuery(queryName, search.Filter, section, view, jwtToken)
		}
	}
}

func getQueryNames(section string, view string) ([]string, error) { //// todo use query tree api?
	var files []string
	queryPath := configuration.Config.QueryPath + "/" + section + "/" + view
	err := filepath.Walk(queryPath, func(path string, info os.FileInfo, err error) error {
		if filepath.Ext(path) != ".sql" {
			return nil
		}
		fileName := info.Name()
		// trim .sql extension
		fileName = fileName[0 : len(fileName)-4]
		files = append(files, fileName)
		return nil
	})
	if err != nil {
		return files, err
	}
	return files, nil
}

func login() (string, error) {
	username := configuration.Config.Tasks.Username
	password := configuration.Config.Tasks.Password
	loginUrl := configuration.Config.APIEndpoint + "/login"
	resp, err := http.PostForm(loginUrl, url.Values{"username": {username}, "password": {password}})
	if err != nil {
		handleError(err)
	}

	defer resp.Body.Close()
	var result map[string]interface{}
	json.NewDecoder(resp.Body).Decode(&result)

	jwtToken := result["token"]
	if jwtToken == nil {
		return "", errors.New("Error retrieving JWT token")
	}
	return jwtToken.(string), nil
}
