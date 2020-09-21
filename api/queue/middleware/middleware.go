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
	"os"
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
			if err != nil {
				os.Stderr.WriteString("PAM authentication failed")
				return nil, jwt.ErrFailedAuthentication
			}

			return &models.UserAuthorizations{
				Username: username,
			}, nil

		},
		PayloadFunc: func(data interface{}) jwt.MapClaims {
			// read authorization file for current user
			if user, ok := data.(*models.UserAuthorizations); ok {
				userAuthorization, err := methods.GetUserAuthorizations(user.Username)
				if err != nil {
					os.Stderr.WriteString(err.Error())
					return jwt.MapClaims{}
				}

				// create claims map
				return jwt.MapClaims{
					identityKey: userAuthorization.Username,
					"queues":    userAuthorization.Queues,
					"groups":    userAuthorization.Groups,
				}
			}

			// return claims map
			return jwt.MapClaims{}
		},
		IdentityHandler: func(c *gin.Context) interface{} {
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
			user := &models.UserAuthorizations{
				Username: claims[identityKey].(string),
				Queues:   queues,
				Groups:   groups,
			}

			// return user
			return user
		},
		Authorizator: func(data interface{}, c *gin.Context) bool {
			// extract data payload and check authorizations
			if v, ok := data.(*models.UserAuthorizations); ok {
				// exclude authorization for some routes
				if utils.ExcludedRoute(c.FullPath()) {
					return true
				}

				if v.Username == "admin" {
					return true
				}

				authorizedQueues := v.Queues
				authorizedGroups := v.Groups
				filterParam := c.Query("filter")

				// convert to struct
				var filter models.Filter
				errJson := json.Unmarshal([]byte(filterParam), &filter)
				if errJson != nil {
					c.JSON(http.StatusBadRequest, gin.H{"message": "invalid filter params", "status": errJson.Error()})
					return false
				}

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
		os.Stderr.WriteString(errDefine.Error())
	}

	// init middleware
	errInit := authMiddleware.MiddlewareInit()

	// check error on initialization
	if errInit != nil {
		os.Stderr.WriteString(errInit.Error())

	}

	// return object
	return authMiddleware
}
