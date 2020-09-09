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

 package main

 import (
	"flag"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"

	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/api/queue/methods"
	"github.com/nethesis/nethvoice-report/api/queue/middleware"
)

func main() {
	// read and init configuration
	ConfigFilePtr := flag.String("c", "/opt/nethvoice-report/queue/conf.json", "Path to configuration file")
	flag.Parse()
	configuration.Init(ConfigFilePtr)

	// init routers
	router := gin.Default()

	// cors
	corsConf := cors.DefaultConfig()
	corsConf.AllowOrigins = configuration.Config.Cors.Origins
	corsConf.AllowHeaders = configuration.Config.Cors.Headers
	corsConf.AllowMethods = configuration.Config.Cors.Methods
	router.Use(cors.New(corsConf))

	// define API
	api := router.Group("/api")

	// define login endpoint
	api.POST("/login", methods.Login)
	api.POST("/logout", methods.Logout)

	// define JWT middleware
	api.Use(middleware.JWT)
	{
		queues := api.Group("/queues/:section")
		{
			queues.GET("", methods.GetQueueReports)
		}
	}

	// handle missing endpoint
	router.NoRoute(func(c *gin.Context) {
		c.JSON(http.StatusNotFound, gin.H{"message": "API not found"})
	})

	router.Run()
}
