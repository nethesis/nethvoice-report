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
	"encoding/json"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"

	"github.com/nethesis/nethvoice-report/api/cache"
	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/models"
	"github.com/nethesis/nethvoice-report/api/utils"
)

func GetDefaultFilter(c *gin.Context) {
	// get current user
	user := GetClaims(c)["id"].(string)

	// extract section and view
	section := c.Param("section")
	view := c.Param("view")

	// override filter path
	filterOverrideFile := configuration.Config.QueryPath + "/" + section + "/" + view + "/default_filter.json"

	// define return filter
	var defaultFilter models.Filter

	// check if override filter exists
	if _, errExists := os.Stat(filterOverrideFile); os.IsNotExist(errExists) {
		// override filter NOT exists, return default one
		defaultFilter = configuration.Config.DefaultFilter
	} else {
		// open json file
		jsonFile, errRead := os.Open(filterOverrideFile)

		// handle open error
		if errRead != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "invalid default filter reading", "status": errRead.Error()})
			return
		}

		// override filter exists, read it and return
		byteJSON, _ := ioutil.ReadAll(jsonFile)

		// convert json file to struct
		errJson := json.Unmarshal(byteJSON, &defaultFilter)
		if errJson != nil {
			c.JSON(http.StatusBadRequest, gin.H{"message": "invalid default filter parsing", "status": errJson.Error()})
			return
		}
	}

	// init cache connection
        cacheConnection := cache.Instance()

        // read default filter from cache
        valuesFilterString, errCache := cacheConnection.Get("values_filter").Result()

        // check error for default filter
        if errCache != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"message": "error reading values for filter from cache", "status": errCache.Error()})
                return
        }

        // convert to struct
        var valuesFilter models.Filter
        errJson := json.Unmarshal([]byte(valuesFilterString), &valuesFilter)
        if errJson != nil {
                c.JSON(http.StatusBadRequest, gin.H{"message": "invalid default filter unmarshal", "status": errJson.Error()})
                return
        }

        // read user authorizations
        auths, _ := GetUserAuthorizations(user)

        // assign defult filter intersection
	defaultFilter = valuesFilter
        defaultFilter.Queues = utils.Intersect(valuesFilter.Queues, auths.Queues)
        defaultFilter.Groups = utils.Intersect(valuesFilter.Groups, auths.Groups)
        defaultFilter.Agents = utils.Intersect(valuesFilter.Agents, auths.Agents)

        // return in JSON format
        c.JSON(http.StatusOK, gin.H{"filter": defaultFilter})
        return
}
