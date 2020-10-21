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

package utils

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"os"
	"reflect"
	"strconv"
	"strings"
	"time"

	"github.com/juliangruber/go-intersect"
	"github.com/pkg/errors"

	"github.com/nethesis/nethvoice-report/api/configuration"
)

var excludedRoutes = [...]string{"/api/searches", "/api/filters/:section/:view"}

func ParseSqlResults(rows *sql.Rows) string {
	// define data to return
	data := [][]string{}

	// extract columns
	columns, err := rows.Columns()
	if err != nil {
		LogError(errors.Wrap(err, "error extracting columns"))
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
			LogError(errors.Wrap(err, "error scanning field values"))
		}

		// compose record
		record := []string{}
		for _, value := range fieldCount {
			if value == nil {
				value = []uint8{}
			}
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

func ExcludedRoute(route string) bool {
	// loop for all exclued routes
	for _, r := range excludedRoutes {
		// check if passing route match
		if r == route {
			return true
		}
	}
	return false
}

func LogError(err error) {
	os.Stderr.WriteString(err.Error() + "\n")
}

func Intersect(a []string, b []string) []string {
	// intersect arrays and return []interface{}
	result := intersect.Simple(a, b).([]interface{})

	// iterate over []interface{}
	s := make([]string, len(result))
	for i, v := range result {
		s[i] = fmt.Sprint(v)
	}

	// return []string result
	return s
}

func ExtractStrings(v []string) string {
	result := strings.Join(v, `","`)

	return "\"" + result + "\""
}

func ExtractPhones(p []string, plain bool) string {
	// declare numbers array
	var numbers []string

	// loop numbers in plain mode: <number>, <number>, <number>, ...
	if plain {
		for _, r := range p {
			number := strings.Split(r, "_")
			numbers = append(numbers, number[1])
		}

		return "\"" + strings.Join(numbers[:], `","`) + "\""
	}

	// loop numbers in type mode: <type> = <number> OR <type> = <number> OR ...
	for _, r := range p {
		number := strings.Split(r, "_")
		numbers = append(numbers, number[0]+" = \""+number[1]+"\"")
	}

	return strings.Join(numbers[:], " OR ")

}

func ExtractOrigins(o []string, plain bool) string {
	// declare origins array
	var origins []string

	// loop origins in plain mode: <origin>, <origin>, <origin>, ...
	if plain {
		for _, r := range o {
			origin := strings.Split(r, "_")
			origins = append(origins, origin[1])
		}

		return "\"" + strings.Join(origins[:], `","`) + "\""
	}

	// loop origins in type mode: <type> = <origin> OR <type> = <origin> OR ...
	for _, r := range o {
		origin := strings.Split(r, "_")

		// convert origin to table fields
		var field string

		switch origin[0] {
		case "district":
			field = "comune"
		case "province":
			field = "provincia"
		case "region":
			field = "regione"
		case "areaCode":
			field = "prefisso"

		}

		origins = append(origins, field+" = \""+origin[1]+"\"")
	}

	return strings.Join(origins[:], " OR ")
}

func ExtractSettings(settingName string) string {
	// get settings struct
	settings := configuration.Config.Settings

	// reflect settings struct
	r := reflect.ValueOf(settings)
	f := reflect.Indirect(r).FieldByName(settingName)

	// return value
	return string(f.String())
}

func EpochToHumanDate(epochTime int) string {
	i, err := strconv.ParseInt(strconv.Itoa(epochTime), 10, 64)
	if err != nil {
		return "-"
	}
	tm := time.Unix(i, 0)
	return tm.Format("2006-01-02 15:04:05")
}
