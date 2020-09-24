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

	"github.com/pkg/errors"

	jwt "github.com/appleboy/gin-jwt/v2"
	"github.com/gin-gonic/gin"

	"github.com/msteinert/pam"
	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/models"
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
