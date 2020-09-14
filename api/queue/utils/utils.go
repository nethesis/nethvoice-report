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

package utils

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"

	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/api/queue/models"
)

func ParseResults(rows *sql.Rows) string {
	// define data to return
	data := [][]string{}

	// extract columns
	columns, err := rows.Columns()
	if err != nil {
		panic(err.Error())
	}

	// initialize object based on field count
	fieldCount := make([]interface{}, len(columns))
	fields := make([]interface{}, len(fieldCount))
	for i := range fieldCount {
		fields[i] = &fieldCount[i]
	}

	// add columns names to data
	data = append(data, columns)

	// loop rows
	for rows.Next() {
		// scan values
		err = rows.Scan(fields...)
		if err != nil {
			panic(err.Error())
		}

		// compose record
		record := []string{}
		for _, value := range fieldCount {
			value := string(value.([]byte))
			record = append(record, value)
		}

		// add record to data array
		data = append(data, record)

	}

	// convert to json
	dataJSON, _ := json.Marshal(data)

	// return value
	return string(dataJSON)
}

// func ParseUserAuthorizationsFile() (map[string]interface{}, error) { ////
func ParseUserAuthorizationsFile() (models.UserAuthorizationsList, error) { ////

	fmt.Println("PARSING") ////

	userAuthorizationsList := models.UserAuthorizationsList{} ////
	file, err := ioutil.ReadFile(configuration.Config.UserAuthorizationsFile)
	if err != nil {
		return userAuthorizationsList, err
	}

	err = json.Unmarshal([]byte(file), &userAuthorizationsList)
	if err != nil {
		return userAuthorizationsList, err
	}
	return userAuthorizationsList, nil

	//// USING DIRECT ACCESS TO USER AUTH AND map[string]interface{}

	// var userAuthorization map[string]interface{}

	// jsonFile, err := os.Open(configuration.Config.UserAuthorizationsFile)
	// if err != nil {
	// 	return userAuthorization, err
	// }

	// fmt.Println("Successfully Opened user authorization file") ////
	// defer jsonFile.Close()

	// byteValue, _ := ioutil.ReadAll(jsonFile)
	// json.Unmarshal([]byte(byteValue), &userAuthorization)

	// fmt.Println(userAuthorization["user_authorization"]) ////
	// fmt.Println(userAuthorization["2"])                  ////
	// return userAuthorization, nil
}

func GetUserAuthorizations(username string) (models.UserAuthorizations, error) { ////
	userAuthorizations := models.UserAuthorizations{}
	authorizations, err := ParseUserAuthorizationsFile()
	if err != nil {
		return userAuthorizations, err
	}

	for _, ua := range authorizations.UserAuthorizations {
		if ua.Username == username {
			fmt.Println("user found", ua) ////
			userAuthorizations.Queues = ua.Queues
			userAuthorizations.Groups = ua.Groups
			return userAuthorizations, nil
		}
	}

	return userAuthorizations, errors.New("Username not found")

	//// USING DIRECT ACCESS TO USER AUTH AND map[string]interface{}

	// userAuthorizations := models.UserAuthorizations{}

	// authorizations, err := ParseUserAuthorizationsFile()
	// if err != nil {
	// 	return userAuthorizations, err
	// }

	// username = "2"                        //// remove
	// fmt.Println(authorizations[username]) ////

	// ua, ok := authorizations[username].(map[string]interface{})
	// if !ok {
	// 	return userAuthorizations, err
	// }

	// userAuthorizations.Queues = ua["queues"].([]string)
	// userAuthorizations.Groups = ua["groups"].([]string)

	// return userAuthorizations, nil
}
