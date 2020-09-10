/*
 * Copyright (C) 2020 Nethesis S.r.l.
 * http://www.nethesis.it - info@nethesis.it
 *
 * This file is part of Icaro project.
 *
 * Icaro is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License,
 * or any later version.
 *
 * Icaro is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Icaro.  If not, see COPYING.
 *
 * author: Edoardo Spadoni <edoardo.spadoni@nethesis.it>
 */

 package methods

 import (
	"bytes"
	"crypto/sha256"
	"net/http"
	"time"
	"fmt"
	"html/template"
	"encoding/json"
	"os"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/bdwilliams/go-jsonify/jsonify"

	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/api/queue/cache"
	"github.com/nethesis/nethvoice-report/api/queue/source"
)

type filterObject struct {
	Queue string `json:"queue"`
	Time  struct {
		TimeRange string `json:"time_range"`
		Value     string `json:"value"`
	} `json:"time"`
	Name     string `json:"name"`
	Agent    string `json:"agent"`
	NullCall bool   `json:"null_call"`
}

func GetQueueReports(c *gin.Context) {
	// extract section, view and graph
	section := c.Param("section")
	view := c.Param("view")
	graph := c.Query("graph")

	// extract filter
	filter := c.Query("filter")

	// convert to struct
	var filterObject filterObject
	errJson := json.Unmarshal([]byte(filter), &filterObject)
	if errJson != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid filter params", "status": errJson.Error()})
                return
	}

	// convert struct to json to preserve item orders
	filterString, errConvert := json.Marshal(filterObject)
	if errConvert != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error in filter conversion to string", "status": errJson.Error()})
                return
	}

	// calculate hash
	h := sha256.New()
	h.Write([]byte(section + view + graph + string(filterString)))
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

	// data is not cached, find query path
	queryFile := configuration.Config.QueryPath + "/" + section + "/" + view + "/" + graph + ".sql"

	// check if query file exists
	if _, errExists := os.Stat(queryFile); os.IsNotExist(errExists) {
		c.JSON(http.StatusBadRequest, gin.H{"message": "query file does not exists", "status": errExists.Error()})
                return
	}

	// parse template
	q, _ := template.ParseFiles(queryFile)

	// compile query with filter object
	var queryString bytes.Buffer
	errTpl := q.Execute(&queryString, &filterObject)
	if errTpl != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid query template compiling", "status": errTpl.Error()})
		return
	}

	// execute query
	db := source.QueueInstance()
	results, errQuery := db.Query(queryString.String())
	if errQuery != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid query execution", "status": errQuery.Error()})
                return
	}

	// parse results
	jsonResults := jsonify.Jsonify(results)
	data = fmt.Sprintf("%s", jsonResults)

	// save calculated data to cache
	errCache = cacheConnection.Set(hash, data, 0).Err()
	cacheConnection.Expire(hash, time.Duration(configuration.Config.TTLCache)*time.Minute)
	if errCache != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error on saving to cache", "status": errCache.Error()})
                return
	}

	// close results
	defer results.Close()
	defer db.Close()

	// return data
	c.Data(http.StatusOK, "application/json; charset=utf-8", []byte(data))
}
