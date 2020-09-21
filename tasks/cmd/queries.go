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

func executeReportQueries() {

	fmt.Println("Executing report queries") ////

	jwtToken, err := login()
	if err != nil {
		handleError(err)
	}

	// TODO retrieve default filter ////

	// retrieve searches from redis cache
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
			client := &http.Client{}

			// encode filter for request URL
			filterString, err := json.Marshal(search.Filter)
			if err != nil {
				handleError(err)
			}

			filterEncoded := url.QueryEscape(string(filterString))
			requestUrl := fmt.Sprintf("%s/queues/%s/%s?filter=%s&graph=%s", configuration.Config.APIEndpoint, section, view, filterEncoded, queryName)

			fmt.Println("requesting:", requestUrl) ////

			// execute query

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
	}
}

func getQueryNames(section string, view string) ([]string, error) {
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
