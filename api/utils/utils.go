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
	"os"

	"github.com/pkg/errors"
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
