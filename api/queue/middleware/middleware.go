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

package middleware

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"

	jwt "github.com/appleboy/gin-jwt/v2"

	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/api/queue/methods"
	"github.com/nethesis/nethvoice-report/api/queue/models"
	"github.com/nethesis/nethvoice-report/api/queue/utils"
)

type login struct {
	Username string `form:"username" json:"username" binding:"required"`
	Password string `form:"password" json:"password" binding:"required"`
}

var jwtMiddleware *jwt.GinJWTMiddleware
var identityKey = "id"

func InstanceJWT() *jwt.GinJWTMiddleware {
	if jwtMiddleware == nil {
		jwtMiddleware := InitJWT()
		return jwtMiddleware
	}
	return jwtMiddleware
}

func InitJWT() *jwt.GinJWTMiddleware {
	// define jwt middleware
	authMiddleware, errDefine := jwt.New(&jwt.GinJWTMiddleware{
		Realm:       "queue-report",
		Key:         []byte(configuration.Config.Secret),
		Timeout:     time.Hour,
		MaxRefresh:  time.Hour,
		IdentityKey: identityKey,
		Authenticator: func(c *gin.Context) (interface{}, error) {

			fmt.Println("Authenticator") ////

			// check login credentials exists
			var loginVals login
			if err := c.ShouldBind(&loginVals); err != nil {
				return "", jwt.ErrMissingLoginValues
			}

			// set login credentials
			username := loginVals.Username
			password := loginVals.Password

			// try PAM authentication
			err := methods.PamAuth(username, password)
			if err == nil {
				return &models.UserAuthorization{
					Username: username,
				}, nil
			}

			// PAM authentication failed
			return nil, jwt.ErrFailedAuthentication
		},
		PayloadFunc: func(data interface{}) jwt.MapClaims {

			fmt.Println("PayloadFunc") ////

			// read authorization file for the current user

			// create claims map
			if user, ok := data.(*models.UserAuthorization); ok {
				UserAuthorization, err := utils.GetUserAuthorizations(user.Username)
				if err != nil {
					//// how to log error?
					fmt.Println(err) ////
					return jwt.MapClaims{}
				}

				fmt.Println("UserAuthorization", UserAuthorization) ////

				return jwt.MapClaims{
					identityKey: user.Username,
					"queues":    UserAuthorization.Queues,
					"groups":    UserAuthorization.Groups,
				}
			}

			// return claims map
			return jwt.MapClaims{}
		},
		IdentityHandler: func(c *gin.Context) interface{} {

			fmt.Println("IdentityHandler") ////

			// handle identity and extract claims
			claims := jwt.ExtractClaims(c)

			// extract queues
			queues := make([]string, len(claims["queues"].([]interface{})))
			for i, v := range claims["queues"].([]interface{}) {
				queues[i] = fmt.Sprint(v)
			}

			// extract groups
			groups := make([]string, len(claims["groups"].([]interface{})))
			for i, v := range claims["groups"].([]interface{}) {
				groups[i] = fmt.Sprint(v)
			}

			// create user object
			user := &models.UserAuthorization{
				Username: claims[identityKey].(string),
				Queues:   queues,
				Groups:   groups,
			}

			// return user
			return user
		},
		Authorizator: func(data interface{}, c *gin.Context) bool {

			fmt.Println("Authorizator") ////

			// extract data payload and check authorizations
			if v, ok := data.(*models.UserAuthorization); ok {
				authorizedQueues := v.Queues
				authorizedGroups := v.Groups

				fmt.Println("authorized queues", authorizedQueues, "authorized groups", authorizedGroups) ////

				filterParam := c.Query("filter")

				fmt.Println("filterParam", filterParam) ////

				// convert to struct
				var filter models.Filter
				errJson := json.Unmarshal([]byte(filterParam), &filter)
				if errJson != nil {
					c.JSON(http.StatusBadRequest, gin.H{"message": "invalid filter params", "status": errJson.Error()})
					return false
				}

				fmt.Println("requested queues", filter.Queues, "requested groups", filter.Groups) ////

				// check queues authorization
				for _, requestedQueue := range filter.Queues {
					queueAllowed := false
					for _, authorizedQueue := range authorizedQueues {
						if requestedQueue == authorizedQueue {
							queueAllowed = true
						}
					}
					if !queueAllowed {
						return false
					}
				}

				// check groups authorization
				for _, requestedGroup := range filter.Groups {
					groupAllowed := false
					for _, authorizedGroup := range authorizedGroups {
						if requestedGroup == authorizedGroup {
							groupAllowed = true
						}
					}
					if !groupAllowed {
						return false
					}
				}
				return true
			}
			return false
		},
		Unauthorized: func(c *gin.Context, code int, message string) {
			c.JSON(code, gin.H{
				"message": message,
			})
			return
		},
		TokenLookup:   "header: Authorization, query: token, cookie: jwt",
		TokenHeadName: "Bearer",
		TimeFunc:      time.Now,
	})

	// check middleware errors
	if errDefine != nil {
		panic(errDefine)
	}

	// init middleware
	errInit := authMiddleware.MiddlewareInit()

	// check error on initialization
	if errInit != nil {
		panic(errInit)
	}

	// return object
	return authMiddleware
}
