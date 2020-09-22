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
	"net/http"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
	"github.com/nethesis/nethvoice-report/api/queue/configuration"
)

func GetQueryTree(c *gin.Context) {
	queryMap := make(map[string]map[string][]string)
	queryPath := configuration.Config.QueryPath

	err := filepath.Walk(queryPath, func(path string, info os.FileInfo, err error) error {
		if filepath.Ext(path) != ".sql" {
			return nil
		}

		queryName := filepath.Base(path)
		// remove .sql extension
		queryName = queryName[0 : len(queryName)-4]
		viewPath := filepath.Dir(path)
		viewName := filepath.Base(viewPath)
		sectionName := filepath.Base(filepath.Dir(viewPath))

		if queryMap[sectionName] == nil {
			queryMap[sectionName] = make(map[string][]string)
		}
		queryMap[sectionName][viewName] = append(queryMap[sectionName][viewName], queryName)
		return nil
	})
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error retrieving views", "status": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"query_tree": queryMap})
}
