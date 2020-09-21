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
	"encoding/json"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"

	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/models"
)

func GetDefaultFilter(c *gin.Context) {
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

		// return in JSON format
		c.JSON(http.StatusOK, gin.H{"filter": defaultFilter})
		return
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

		// return in JSON format
		c.JSON(http.StatusOK, gin.H{"filter": defaultFilter})
		return
	}
}
