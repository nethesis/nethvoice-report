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

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/pkg/errors"

	"github.com/nethesis/nethvoice-report/api/cache"
	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/models"
	"github.com/nethesis/nethvoice-report/api/source"
	"github.com/nethesis/nethvoice-report/api/utils"
)

func GetQueueReports(c *gin.Context) {
	// extract section, view and graph
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
		queryResult, err = executeSqlQuery(filter, section, view, graph, c)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "error executing SQL query", "status": err.Error()})
			return
		}
	default:
		queryResult, err = executeRrdQuery(filter, section, view, graph)
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

func executeSqlQuery(filter models.Filter, section string, view string, graph string, c *gin.Context) (string, error) {
	queryFile := configuration.Config.QueryPath + "/" + section + "/" + view + "/" + graph + ".sql"

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

	// parse template
	q := template.Must(template.New(path.Base(queryFile)).Funcs(template.FuncMap{"ExtractStrings": utils.ExtractStrings}).Funcs(template.FuncMap{"ExtractPhones": utils.ExtractPhones}).Funcs(template.FuncMap{"ExtractOrigins": utils.ExtractOrigins}).Funcs(template.FuncMap{"ExtractSettings": utils.ExtractSettings}).ParseFiles(queryFile))

	// compile query with filter object
	var queryString bytes.Buffer
	errTpl := q.Execute(&queryString, &filter)
	if errTpl != nil {
		return "", errors.Wrap(errTpl, "invalid query template compiling")
	}

	// execute query
	db := source.QueueInstance()
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

func executeRrdQuery(filter models.Filter, section string, view string, graph string) (string, error) {
	queryFile := configuration.Config.QueryPath + "/" + section + "/" + view + "/" + graph + ".rrd"

	// check if query file exists
	if _, errExists := os.Stat(queryFile); os.IsNotExist(errExists) {
		return "", errExists
	}

	rrdFilePathContent, errRead := ioutil.ReadFile(queryFile)
	if errRead != nil {
		return "", errors.Wrap(errRead, "cannot open RRD file")
	}

	rrdFilePath := strings.TrimSpace(string(rrdFilePathContent))
	zone, _ := time.Now().Zone()

	officeHoursStart := utils.ExtractSettings("StartHour")
	officeHoursEnd := utils.ExtractSettings("EndHour")

	dateTimeStart := filter.Time.Interval.Start + " " + officeHoursStart + " " + zone
	dateTimeEnd := filter.Time.Interval.End + " " + officeHoursEnd + " " + zone

	start, errTime := time.Parse("2006-01-02 15:04 MST", dateTimeStart)
	if errTime != nil {
		return "", errors.Wrap(errTime, "cannot parse time")
	}

	end, errTime := time.Parse("2006-01-02 15:04 MST", dateTimeEnd)
	if errTime != nil {
		return "", errors.Wrap(errTime, "cannot parse time")
	}

	results, errRrd := QueryRrd(rrdFilePath, filter, start, end, graph)
	if errRrd != nil {
		return "", errRrd
	}

	return results, nil
}
