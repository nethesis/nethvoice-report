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
	"fmt"
	"net/http"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
	"github.com/nethesis/nethvoice-report/api/queue/configuration"
)

func GetQueryTree(c *gin.Context) { ////
	// var views []models.View ////
	// viewsMap := make(map[string][]string)
	// viewsMap := make(map[string]models.View)
	queryMap := make(map[string]map[string][]string)
	queryPath := configuration.Config.QueryPath

	err := filepath.Walk(queryPath, func(path string, info os.FileInfo, err error) error {
		if filepath.Ext(path) != ".sql" { ////
			return nil
		}

		queryName := filepath.Base(path)
		// remove .sql extension
		queryName = queryName[0 : len(queryName)-4]
		viewPath := filepath.Dir(path)
		// _, found := viewsMap[viewPath]

		// if !found {
		viewName := filepath.Base(viewPath)
		sectionName := filepath.Base(filepath.Dir(viewPath))
		// 	view := models.View{Name: viewName, Section: section}
		// 	viewsMap[viewPath] = view
		// 	views = append(views, view)
		// }
		// return nil

		// viewPath := filepath.Dir(path)
		// _, found := viewsMap[viewPath]

		// if !found {
		// viewName := filepath.Base(viewPath)
		// section := filepath.Base(filepath.Dir(viewPath))
		// view := models.View{Name: viewName, Section: section}

		fmt.Println("queryName, viewName, section", queryName, viewName, sectionName) ////

		if queryMap[sectionName] == nil {
			queryMap[sectionName] = make(map[string][]string)
		}
		queryMap[sectionName][viewName] = append(queryMap[sectionName][viewName], queryName)
		// queryMap[section] = append(viewsMap[section], viewName)
		// views = append(views, view)
		// }
		return nil
	})
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error retrieving views", "status": err.Error()})
		return
	}

	// c.JSON(http.StatusOK, gin.H{"views": views}) ////
	c.JSON(http.StatusOK, gin.H{"query_tree": queryMap})
}

// func GetViews(c *gin.Context) {
// 	viewsMap := make(map[string][]string)
// 	queryPath := configuration.Config.QueryPath

// 	sectionsDirs, err := ioutil.ReadDir(queryPath)
// 	if err != nil {
// 		c.JSON(http.StatusBadRequest, gin.H{"message": "error reading query path", "status": err.Error()})
// 		return
// 	}

// 	for _, sectionDir := range sectionsDirs {
// 		if !sectionDir.IsDir() {
// 			continue
// 		}

// 		sectionName := sectionDir.Name()
// 		viewsDirs, err := ioutil.ReadDir(queryPath + "/" + sectionName)
// 		if err != nil {
// 			c.JSON(http.StatusBadRequest, gin.H{"message": "error reading section path", "status": err.Error()})
// 			return
// 		}

// 		for _, viewDir := range viewsDirs {
// 			if !viewDir.IsDir() {
// 				continue
// 			}

// 			viewName := viewDir.Name()
// 			viewsMap[sectionName] = append(viewsMap[sectionName], viewName)
// 		}
// 	}
// 	c.JSON(http.StatusOK, gin.H{"views": viewsMap})
// }

// func GetViews(c *gin.Context) { ////
// 	// var views []models.View ////
// 	viewsMap := make(map[string][]string)
// 	// viewsMap := make(map[string]models.View)
// 	queryPath := configuration.Config.QueryPath

// 	err := filepath.Walk(queryPath, func(path string, info os.FileInfo, err error) error {
// 		if filepath.Ext(path) != ".sql" { ////
// 			return nil
// 		}

// 		// viewPath := filepath.Dir(path)
// 		// _, found := viewsMap[viewPath]

// 		// if !found {
// 		// 	viewName := filepath.Base(viewPath)
// 		// 	section := filepath.Base(filepath.Dir(viewPath))
// 		// 	view := models.View{Name: viewName, Section: section}
// 		// 	viewsMap[viewPath] = view
// 		// 	views = append(views, view)
// 		// }
// 		// return nil

// 		// if !info.IsDir() { ////
// 		// 	return nil
// 		// }

// 		viewPath := filepath.Dir(path)
// 		// _, found := viewsMap[viewPath]

// 		// if !found {
// 		viewName := filepath.Base(viewPath)
// 		section := filepath.Base(filepath.Dir(viewPath))
// 		// view := models.View{Name: viewName, Section: section}
// 		viewsMap[section] = append(viewsMap[section], viewName)
// 		// views = append(views, view)
// 		// }
// 		return nil
// 	})
// 	if err != nil {
// 		c.JSON(http.StatusBadRequest, gin.H{"message": "error retrieving views", "status": err.Error()})
// 		return
// 	}

// 	// skip duplicates

// 	// c.JSON(http.StatusOK, gin.H{"views": views}) ////
// 	c.JSON(http.StatusOK, gin.H{"views": viewsMap})
// }
