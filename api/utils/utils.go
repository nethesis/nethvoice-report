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
	"os"
	"fmt"

	"github.com/pkg/errors"
	"github.com/juliangruber/go-intersect"
)

var excludedRoutes = [...]string{"/api/searches", "/api/filters/:section/:view"}

func ParseResults(rows *sql.Rows) string {
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
