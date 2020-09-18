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

	"github.com/nethesis/nethvoice-report/tasks/configuration"
	"github.com/spf13/cobra"
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

func executeReportQueries() {

	fmt.Println("Executing report queries") ////

	jwtToken, err := login()
	if err != nil {
		handleError(err)
	}

	// TODO retrieve filters from redis cache

	filterJson := `{"queues": ["20", "30"],"groups": ["1", "2"], "time": {"time_range": "day","value": "monday"},"name": "Edoardo","agent": "0721","null_call": true}`
	filterForUrl := url.QueryEscape(filterJson)

	queryFiles, err := getQueryFiles()
	if err != nil {
		handleError(err)
	}

	// execute queries

	for _, queryFile := range queryFiles {
		pathSegments := strings.Split(queryFile, "/")

		// take last path segment and remove .sql extension
		queryName := pathSegments[len(pathSegments)-1]
		queryName = queryName[:len(queryName)-4]

		fmt.Println("queryName", queryName) ////

		view := pathSegments[len(pathSegments)-2]
		section := pathSegments[len(pathSegments)-3]

		fmt.Println("view", view)       ////
		fmt.Println("section", section) ////

		// execute query

		client := &http.Client{}
		requestUrl := fmt.Sprintf("%s/queues/%s/%s?filter=%s&graph=%s", configuration.Config.APIEndpoint, section, view, filterForUrl, queryName)

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

func getQueryFiles() ([]string, error) {
	var files []string
	queryPath := configuration.Config.QueryPath
	err := filepath.Walk(queryPath, func(path string, info os.FileInfo, err error) error {
		if filepath.Ext(path) != ".sql" {
			return nil
		}
		files = append(files, path)
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
