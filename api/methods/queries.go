/*
 * Copyright (C) 2020 Nethesis S.r.l.
 * http://www.nethesis.it - info@nethesis.it
 *
 * This file is part of NethVoice Report project.
 *
 * NethVoice Report is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License,
 * or any later version.
 *
 * NethVoice Report is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with NethVoice Report.  If not, see COPYING.
 *
 * author: Edoardo Spadoni <edoardo.spadoni@nethesis.it>
 */

package methods

import (
	"bytes"
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"path"
	"strings"
	"text/template"
	"time"

	"github.com/nleeper/goment"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/pkg/errors"

	"github.com/nethesis/nethvoice-report/api/cache"
	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/models"
	"github.com/nethesis/nethvoice-report/api/source"
	"github.com/nethesis/nethvoice-report/api/utils"
)

func GetCallDetails(c *gin.Context) {
	// extract info
	linkedid := c.Param("linkedid")

	// init cache connection
	cacheConnection := cache.Instance()

	// check if call detail is locally cached
	data, errCache := cacheConnection.Get(linkedid).Result()

	// data is cached, return immediately
	if errCache == nil {
		c.Data(http.StatusOK, "application/json; charset=utf-8", []byte(data))
		return
	}

	// call detail is not cached, execute query

	db := source.CDRInstance()
	results, errQuery := db.Query("SELECT * FROM cdr WHERE linkedid = ? ORDER BY calldate", linkedid)
	if errQuery != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error executing SQL query", "status": errQuery.Error()})
		return
	}

	// close results
	defer results.Close()

	// parse results
	callDetails := utils.ParseSqlResults(results)

	// save call details to cache
	errCache = cacheConnection.Set(linkedid, callDetails, 0).Err()
	if errCache != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "cannot save call details to cache", "status": errCache.Error()})
		return
	}

	// return data
	c.Data(http.StatusOK, "application/json; charset=utf-8", []byte(callDetails))
}

func GetGraphData(c *gin.Context) {
	// extract report, section, view and graph
	report := c.Param("report")
	section := c.Param("section")
	view := c.Param("view")
	graph := c.Query("graph")
	queryType := c.Query("type")

	// extract filter
	filterParam := c.Query("filter")

	// convert to struct
	var filter models.Filter
	errJson := json.Unmarshal([]byte(filterParam), &filter)
	if errJson != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid filter params", "status": errJson.Error()})
		return
	}

	// convert struct to json to preserve item orders
	filterString, errConvert := json.Marshal(filter)
	if errConvert != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error in filter conversion to string", "status": errConvert.Error()})
		return
	}

	// calculate hash
	h := sha256.New()
	h.Write([]byte(section + view + graph + queryType + string(filterString)))
	hash := fmt.Sprintf("%x", h.Sum(nil))

	// init cache connection
	cacheConnection := cache.Instance()

	// check if hash is locally cached
	data, errCache := cacheConnection.Get(hash).Result()

	// data is cached, return immediately
	if errCache == nil {
		c.Data(http.StatusOK, "application/json; charset=utf-8", []byte(data))
		return
	}

	// query result is not cached, execute query

	var err error
	var queryResult string

	switch queryType {
	case "sql":
		queryResult, err = executeSqlQuery(filter, report, section, view, graph, c)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "error executing SQL query", "status": err.Error()})
			return
		}
	default:
		queryResult, err = executeRrdQuery(filter, report, section, view, graph)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "error executing RRD query", "status": err.Error()})
			return
		}
	}

	// save calculated query result to cache
	errCache = cacheConnection.Set(hash, queryResult, 0).Err()
	cacheConnection.Expire(hash, time.Duration(configuration.Config.TTLCache)*time.Minute)
	if errCache != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error on saving to cache", "status": errCache.Error()})
		return
	}

	// return data
	c.Data(http.StatusOK, "application/json; charset=utf-8", []byte(queryResult))
}

func executeSqlQuery(filter models.Filter, report string, section string, view string, graph string, c *gin.Context) (string, error) {
	// get current user
	user := GetClaims(c)["id"].(string)
	filter.CurrentUser = user

	if report != "queue" && report != "cdr" {
		return "", errors.Errorf("unknown report: %s", report)
	}

	queryFile := configuration.Config.QueryPath + "/" + report + "/" + section + "/" + view + "/" + graph + ".sql"

	// check if query file exists
	if _, errExists := os.Stat(queryFile); os.IsNotExist(errExists) {
		return "", errors.Wrap(errExists, "query file does not exists")
	}

	// if no queue has been selected, restrict filter to allowed queues
	if len(filter.Queues) == 0 {
		allowedQueues, errQueues := GetAllowedQueues(c)
		if errQueues != nil {
			return "", errors.Wrap(errQueues, "cannot retrieve allowed queues")
		}
		filter.Queues = allowedQueues
	}

	// if no agent has been selected, restrict filter to allowed agents
	if len(filter.Agents) == 0 {
		allowedAgents, errAgents := GetAllowedAgents(c)
		if errAgents != nil {
			return "", errors.Wrap(errAgents, "cannot retrieve allowed agents")
		}
		filter.Agents = allowedAgents
	}

	// create template
	q := template.New(path.Base(queryFile)).Funcs(template.FuncMap{"ExtractStrings": utils.ExtractStrings}).Funcs(template.FuncMap{"ExtractPhones": utils.ExtractPhones}).Funcs(template.FuncMap{"ExtractOrigins": utils.ExtractOrigins}).Funcs(template.FuncMap{"ExtractSettings": utils.ExtractSettings}).Funcs(template.FuncMap{"PivotGroup": utils.PivotGroup}).Funcs(template.FuncMap{"ExtractUserExtensions": utils.ExtractUserExtensions})

	// parse template

	if report == "queue" {
		q = template.Must(q.ParseFiles(queryFile))
	} else {
		// retrieve partitioned CDR tables
		query, err := buildCdrQuery(queryFile, filter)
		if err != nil {
			return "", err
		}
		q = template.Must(q.Parse(query))
	}

	// compile query with filter object
	var queryString bytes.Buffer
	errTpl := q.Execute(&queryString, &filter)
	if errTpl != nil {
		return "", errors.Wrap(errTpl, "invalid query template compiling")
	}

	// execute query
	db := source.CDRInstance()
	results, errQuery := db.Query(queryString.String())
	if errQuery != nil {
		return "", errors.Wrap(errQuery, "invalid query execution")
	}

	// close results
	defer results.Close()

	// parse results
	data := utils.ParseSqlResults(results)
	return data, nil
}

func executeRrdQuery(filter models.Filter, report string, section string, view string, graph string) (string, error) {
	queryFile := configuration.Config.QueryPath + "/" + report + "/" + section + "/" + view + "/" + graph + ".rrd"

	// check if query file exists
	if _, errExists := os.Stat(queryFile); os.IsNotExist(errExists) {
		return "", errExists
	}

	rrdFilePathContent, errRead := ioutil.ReadFile(queryFile)
	if errRead != nil {
		return "", errors.Wrap(errRead, "cannot open RRD file")
	}
	rrdFilePath := strings.TrimSpace(string(rrdFilePathContent))

	// adjust time interval for RRD query
	start, end, err := utils.DatesTimeInterval(filter.Time.Interval.Start, filter.Time.Interval.End, filter.Time.Group)
	if err != nil {
		return "", errors.Wrap(err, "cannot retrieve time interval")
	}

	results, errRrd := QueryRrd(rrdFilePath, filter, start, end)
	if errRrd != nil {
		return "", errRrd
	}

	return results, nil
}

func buildCdrQuery(queryFile string, filter models.Filter) (string, error) {
	timeIntervalStart := filter.Time.Interval.Start
	timeIntervalEnd := filter.Time.Interval.End
	start, err := goment.New(timeIntervalStart, "YYYY-MM-DD")
	if err != nil {
		return "", errors.Wrap(err, "cannot create start goment")
	}
	start.StartOf("month")

	end, err := goment.New(timeIntervalEnd, "YYYY-MM-DD")
	if err != nil {
		return "", errors.Wrap(err, "cannot create end goment")
	}
	end.StartOf("month")

	// get first month with data to prevent access to non-existent tables (e.g. cdr_1999-12)

	cacheConnection := cache.Instance()
	firstMonthWithDataString, errCache := cacheConnection.Get("cdr_first_month").Result()
	if errCache != nil {
		return "", errors.Wrap(errCache, "cannot retrieve CDR first month from cache")
	}

	firstMonthWithData, err := goment.New(firstMonthWithDataString, "YYYY-MM")
	if err != nil {
		return "", errors.Wrap(err, "cannot create firstMonth goment")
	}
	firstMonthWithData.StartOf("month")

	if start.IsBefore(firstMonthWithData) {
		start = firstMonthWithData
	}

	var cdrTables []string

	for !start.IsAfter(end) {
		cdrTables = append(cdrTables, "cdr_"+start.Format("YYYY-MM"))
		start.Add(1, "month")
	}

	// read query from file

	content, err := ioutil.ReadFile(queryFile)
	if err != nil {
		return "", errors.Wrap(err, "cannot ready CDR query file")
	}
	queryWithTablePlaceholder := string(content)

	// build a query for every month and append all of them with UNION ALL

	var queryBuilder strings.Builder
	var query string

	for i, cdrTable := range cdrTables {
		query = strings.ReplaceAll(queryWithTablePlaceholder, "<CDR_TABLE>", cdrTable)
		query = strings.ReplaceAll(query, ";", "") // remove trailing semicolon
		queryBuilder.WriteString(query)

		if i < len(cdrTables)-1 {
			queryBuilder.WriteString(" UNION ALL ")
		}
	}

	// get query limit

	var queryLimit string

	settingsString, errCache := cacheConnection.Get("admin_settings").Result()

	if errCache == nil {
		// admin settings are cached

		// convert to struct
		var settingsCache map[string]models.Settings

		errJson := json.Unmarshal([]byte(settingsString), &settingsCache)
		if errJson != nil {
			return "", errors.Wrap(err, "cannot unmarshal admin settings")
		}
		settings := settingsCache["settings"]
		queryLimit = settings.QueryLimit
	} else {
		// get settings struct from configuration
		settings := configuration.Config.Settings
		queryLimit = settings.QueryLimit
	}

	// append limit to query

	queryBuilder.WriteString(" LIMIT " + queryLimit)

	return queryBuilder.String(), nil
}
