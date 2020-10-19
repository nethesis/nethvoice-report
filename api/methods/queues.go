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
	"text/template"
	"time"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/mysql"

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

	queryFile := configuration.Config.QueryPath + "/" + section + "/" + view + "/" + graph

	// check if query file exists
	if _, errExists := os.Stat(queryFile); os.IsNotExist(errExists) {
		c.JSON(http.StatusBadRequest, gin.H{"message": "query file does not exists", "status": errExists.Error()})
		return
	}

	var err error
	var queryResult string

	switch queryType {
	case "sql":
		queryResult, err = executeSqlQuery(queryFile, filter, section, view, graph, c)
		if err != nil {
			return
		}
	default:
		queryResult, err = executeRrdQuery(queryFile, filter, section, view, graph, c)
		if err != nil {
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

func executeSqlQuery(queryFile string, filter models.Filter, section string, view string, graph string, c *gin.Context) (string, error) {

	// parse template
	q := template.Must(template.New(path.Base(queryFile)).Funcs(template.FuncMap{"ExtractStrings": utils.ExtractStrings}).Funcs(template.FuncMap{"ExtractPhones": utils.ExtractPhones}).Funcs(template.FuncMap{"ExtractOrigins": utils.ExtractOrigins}).Funcs(template.FuncMap{"ExtractSettings": utils.ExtractSettings}).ParseFiles(queryFile))

	// compile query with filter object
	var queryString bytes.Buffer
	errTpl := q.Execute(&queryString, &filter)
	if errTpl != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid query template compiling", "status": errTpl.Error()})
		return "", errTpl
	}

	// execute query
	db := source.QueueInstance()
	results, errQuery := db.Query(queryString.String())
	if errQuery != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid query execution", "status": errQuery.Error()})
		return "", errQuery
	}

	// close results
	defer results.Close()

	// parse results
	data := utils.ParseResults(results)
	return data, nil
}

func executeRrdQuery(queryFile string, filter models.Filter, section string, view string, graph string, c *gin.Context) (string, error) {
	rrdFile, errRead := ioutil.ReadFile(queryFile)
	if errRead != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "cannot open rrd file", "status": errRead.Error()})
		return "", errRead
	}

	rrdFileString := string(rrdFile)

	fmt.Println("rrdFileString", rrdFileString) ////

	hostname, errHostname := os.Hostname()
	if errHostname != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "cannot retrieve hostname", "status": errHostname.Error()})
		return "", errHostname
	}

	fmt.Println("==========================")
	fmt.Println("==========================")
	fmt.Println(hostname)
	fmt.Println("==========================")
	fmt.Println("==========================")

	return "", nil ////
}
