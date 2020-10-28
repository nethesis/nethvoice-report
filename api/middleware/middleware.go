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

package middleware

import (
	"crypto/sha1"
	"encoding/json"

	"github.com/pkg/errors"

	"fmt"
	"time"

	"github.com/gin-gonic/gin"

	jwt "github.com/appleboy/gin-jwt/v2"

	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/methods"
	"github.com/nethesis/nethvoice-report/api/models"
	"github.com/nethesis/nethvoice-report/api/utils"
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
		Timeout:     time.Hour * 4, //// set production timeout
		MaxRefresh:  time.Hour * 4, //// set production max refresh
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

			// check if login is with API key or User and Password
			if username == "X" {
				// try API key authentication
				if password != configuration.Config.APIKey {
					utils.LogError(errors.New("API key authentication failed for user " + username))
					return nil, jwt.ErrFailedAuthentication
				}

				return &models.UserAuthorizations{
					Username: username,
				}, nil
				// if username is admin check on freepbx users
			} else if username == "admin" {
				// convert password to sha1 encryption
				h := sha1.New()
				h.Write([]byte(password))
				bs := h.Sum(nil)
				hash := fmt.Sprintf("%x", bs)

				// get hash from db
				hashCompare := methods.GetAdminHashPass()

				// compare hashes
				if hash != hashCompare {
					utils.LogError(errors.New("Authentication failed for user " + username))
					return nil, jwt.ErrFailedAuthentication
				}

				return &models.UserAuthorizations{
					Username: username,
				}, nil
				// it's a normal system PAM user
			} else {
				// try PAM authentication
				err := methods.PamAuth(username, password)
				if err != nil {
					utils.LogError(errors.Wrap(err, "PAM authentication failed for user "+username))
					return nil, jwt.ErrFailedAuthentication
				}

				return &models.UserAuthorizations{
					Username: username,
				}, nil
			}
		},
		PayloadFunc: func(data interface{}) jwt.MapClaims {
			// read authorization file for current user
			if user, ok := data.(*models.UserAuthorizations); ok {
				userAuthorization, err := methods.GetUserAuthorizations(user.Username)
				if err != nil {
					utils.LogError(errors.Wrap(err, "error retrieving user authorizations"))

					// return a token with no authorization on queues and groups
					return jwt.MapClaims{
						identityKey: user.Username,
						"queues":    []string{},
						"groups":    []string{},
					}
				}

				// create claims map
				return jwt.MapClaims{
					identityKey: user.Username,
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

			queues := make([]string, len(claims["queues"].([]interface{})))
			for i, v := range claims["queues"].([]interface{}) {
				queues[i] = fmt.Sprint(v)
			}

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

				// X user (api key auth) and admin are always authorized to access all resources (queues, groups, ...)
				if v.Username == "X" || v.Username == "admin" {
					return true
				}

				authorizedQueues := v.Queues
				authorizedGroups := v.Groups
				filterParam := c.Query("filter")

				if filterParam == "" {
					// no filter in request, access is granted
					return true
				}

				// convert to struct
				var filter models.Filter
				errJson := json.Unmarshal([]byte(filterParam), &filter)
				if errJson != nil {
					utils.LogError(errors.Wrap(errJson, "error unmarshalling filter"))
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
		utils.LogError(errors.Wrap(errDefine, "middleware definition error"))
	}

	// init middleware
	errInit := authMiddleware.MiddlewareInit()

	// check error on initialization
	if errInit != nil {
		utils.LogError(errors.Wrap(errInit, "middleware initialization error"))
	}

	// return object
	return authMiddleware
}
