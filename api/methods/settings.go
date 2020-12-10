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
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/nethesis/nethvoice-report/api/cache"
	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/models"
)

func GetSettings(c *gin.Context) {
	// init cache connection
	cacheConnection := cache.Instance()

	// check if settings is locally cached
	settings, errCache := cacheConnection.Get("admin_settings").Result()

	// settings is cached, return immediately
	if errCache == nil {
		c.Data(http.StatusOK, "application/json; charset=utf-8", []byte(settings))
		return
	}

	// return default settings
	c.JSON(http.StatusOK, gin.H{"settings": configuration.Config.Settings})

}

func SetSettings(c *gin.Context) {
	// get current user
	user := GetClaims(c)["id"].(string)

	// check if user admin or API key
	if user != "admin" && user != "X" {
		c.JSON(http.StatusNotFound, gin.H{"message": "no settings to update found"})
		return
	}

	// bind json body
	var jsonSettings models.Settings
	if err := c.BindJSON(&jsonSettings); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "request fields malformed", "status": err.Error()})
		return
	}

	// create admin settings struct
	settingsCache := gin.H{"settings": jsonSettings}

	// convert settings to string
	settingsString, errConvert := json.Marshal(settingsCache)
	if errConvert != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error in filter conversion to string", "status": errConvert.Error()})
		return
	}

	// init cache connection
	cacheConnection := cache.Instance()

	// set custom search to cache
	errCache := cacheConnection.Set("admin_settings", settingsString, 0).Err()

	// handle cache error
	if errCache != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error on saving to cache", "status": errCache.Error()})
		return
	}

	// return settings updated
	c.JSON(http.StatusCreated, gin.H{"message": "settings updated successfully"})

}

func DeleteSettings(c *gin.Context) {
	// init cache connection
	cacheConnection := cache.Instance()

	errCache := cacheConnection.Del("admin_settings").Err()

	// handle cache error
	if errCache != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "error on deleting admin settings in cache", "status": errCache.Error()})
		return
	}

	// return status created
	c.JSON(http.StatusOK, gin.H{"message": "admin settings deleted successfully"})
}
