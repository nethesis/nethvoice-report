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
	"crypto/sha256"
	"net/http"
	"time"
	"fmt"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/mysql"

	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/api/queue/cache"

)

func GetQueueReports(c *gin.Context) {
	// extract section and view
	section := c.Param("section")
	view := c.Query("view")

	// extract filter
	filter := c.Query("filter")

	// calculate hash
	h := sha256.New()
	h.Write([]byte(section+view+filter))
	hash := fmt.Sprintf("%x", h.Sum(nil))

	// init cache connection
	cacheConnection := cache.Instance()

	// check if hash is locally cached
	data, err := cacheConnection.Get(hash).Result()

	// data is cached, return immediately
	if err == nil {
		c.JSON(http.StatusOK, gin.H{"data": data})
		return
	}

	// data is not cached, calculate it
	data = ""

	// save calculated data to cache
	err = cacheConnection.Set(hash, data, 0).Err()
	cacheConnection.Expire(hash, time.Duration(configuration.Config.TTLCache)*time.Minute)
	if err != nil {
		panic(err)
	}

	// return data
	c.JSON(http.StatusOK, gin.H{"data": data})
}
