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
	"os"
	"net/http"

	"github.com/pkg/errors"

	jwt "github.com/appleboy/gin-jwt/v2"
	"github.com/gin-gonic/gin"

	"github.com/msteinert/pam"
	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/models"
	"github.com/nethesis/nethvoice-report/api/source"
	"github.com/nethesis/nethvoice-report/api/utils"
)

func PamAuth(username string, password string) error {
	// init PAM authentication
	t, errInit := pam.StartFunc("system-auth", username, func(s pam.Style, msg string) (string, error) {
		switch s {
		case pam.PromptEchoOff:
			return password, nil
		case pam.PromptEchoOn:
			return username, nil
		default:
			return "", errors.New("error during PAM authentication")
		}
	})

	// check error
	if errInit != nil {
		return errInit
	}

	// check authentication
	errAuth := t.Authenticate(0)
	if errAuth != nil {
		return errAuth
	}
	return nil
}

func ParseUserAuthorizationsFile() ([]models.UserAuthorizations, error) {
	file, err := ioutil.ReadFile(configuration.Config.UserAuthorizationsFile)
	if err != nil {
		utils.LogError(errors.Wrap(err, "error reading user authorizations file"))
		return []models.UserAuthorizations{}, err
	}

	userAuthorizationsList := []models.UserAuthorizations{}
	err = json.Unmarshal([]byte(file), &userAuthorizationsList)
	if err != nil {
		utils.LogError(errors.Wrap(err, "error unmarshalling user authorizations file"))
		return []models.UserAuthorizations{}, err
	}
	return userAuthorizationsList, nil
}

func GetUserAuthorizations(username string) (models.UserAuthorizations, error) {
	userAuthorizations := models.UserAuthorizations{}
	userAuthorizationsList, err := ParseUserAuthorizationsFile()
	if err != nil {
		return userAuthorizations, err
	}

	for _, ua := range userAuthorizationsList {
		if ua.Username == username {
			userAuthorizations.Username = ua.Username
			userAuthorizations.Queues = ua.Queues
			userAuthorizations.Groups = ua.Groups
			userAuthorizations.Agents = ua.Agents
			userAuthorizations.Users  = ua.Users
			return userAuthorizations, nil
		}
	}
	return userAuthorizations, errors.New("username not found in authorizations file")
}

func GetClaims(c *gin.Context) jwt.MapClaims {
	// extract claims from jwt gin context
	claims := jwt.ExtractClaims(c)

	// return claims
	return claims
}

func GetAdminHashPass() string {
	// init hash var
	var hash string

	// read hash from db
	db := source.FreePBXInstance()
	row := db.QueryRow("SELECT password_sha1 FROM ampusers WHERE username = 'admin'")
	errQuery := row.Scan(&hash)

	// check error
	if errQuery != nil {
		utils.LogError(errors.Wrap(errQuery, "error in admin pass query execution"))
	}

	return hash
}

func GetAllowedQueues(c *gin.Context) ([]string, error) {
	// get current user
	user := GetClaims(c)["id"].(string)

	// get user auths
	auths, err := GetUserAuthorizations(user)
	if err != nil {
		return nil, err
	}
	return auths.Queues, nil
}

func GetAllowedAgents(c *gin.Context) ([]string, error) {
	// get current user
	user := GetClaims(c)["id"].(string)

	// get user auths
	auths, err := GetUserAuthorizations(user)
	if err != nil {
		return nil, err
	}
	return auths.Agents, nil
}

func GetAllowedGroups(c *gin.Context) ([]string, error) {
	// get current user
	user := GetClaims(c)["id"].(string)

	// get user auths
	auths, err := GetUserAuthorizations(user)
	if err != nil {
		return nil, err
	}
	return auths.Groups, nil
}

func GetAllowedUsers(c *gin.Context) ([]string, error) {
	// get current user
	user := GetClaims(c)["id"].(string)

	// get user auths
	auths, err := GetUserAuthorizations(user)
	if err != nil {
		return nil, err
	}
	return auths.Users, nil
}

func GetAuthFileStats(c *gin.Context) {
	// get authorizations file stat
	fileInfo, err := os.Stat(configuration.Config.UserAuthorizationsFile)
	if err != nil {
		utils.LogError(errors.Wrap(err, "error reading user authorizations file stats"))
		// return not found status
		c.JSON(http.StatusNotFound, gin.H{"message": "error reading user authorizations file stats"})
		return
	}
	authStats := &models.AuthStats{
		FileName: fileInfo.Name(),
		ModTime: fileInfo.ModTime().Unix(),
	}
	// return mofification time and file name
	c.JSON(http.StatusOK, authStats)
	return
}

func ParseAuthMap(c *gin.Context) (models.AuthMap, error) {
	// get current user
	user := GetClaims(c)["id"].(string)
	// get user auths
	auths, err := GetUserAuthorizations(user)
	if err != nil {
		return models.AuthMap{}, err
	}
	// parse authorizations
	authMap := models.AuthMap{}
	if len(auths.Queues) > 0 {
		authMap.Queues = true
	}
	if len(auths.Groups) > 0 {
		authMap.CdrPbx = true
	}
	if len(auths.Users) > 0 {
		authMap.CdrPersonal = true
	}
	return authMap, nil
}

func GetAuthMap(c *gin.Context) {
	// parse authorizations map
	authMap, err := ParseAuthMap(c)
	if err != nil  {
		c.JSON(http.StatusNotFound, gin.H{"message": "error parsing user authorizations file"})
		return
	}
	// return authorizations map
	c.JSON(http.StatusOK, authMap)
	return
}
