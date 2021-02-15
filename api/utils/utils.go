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
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/juliangruber/go-intersect"
	"github.com/nethesis/nethvoice-report/api/cache"
	"github.com/nethesis/nethvoice-report/api/models"
	"github.com/nleeper/goment"
	"github.com/pkg/errors"

	"github.com/nethesis/nethvoice-report/api/configuration"
)

var excludedRoutes = [...]string{"/api/searches", "/api/filters"}

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
			if fmt.Sprintf("%T", value) == "time.Time" {
				t := value.(time.Time)
				value, _ = t.MarshalText()
			}
			if fmt.Sprintf("%T", value) == "int64" {
				s := fmt.Sprint(value)
				value = []byte(s)
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

func Contains(a string, values []string) bool {
	for _, b := range values {
		if b == a {
			return true
		}
	}
	return false
}

func Intersect(a []string, b []string, objType string) []string {
	// define result
	var result []string

	// clean values before intersect
	switch objType {
	case "queues":
		// create regexp to extract queue number
		var rgx = regexp.MustCompile(`\((.*?)\)`)
		for i, q := range a {
			rs := rgx.FindStringSubmatch(q)
			queue := rs[1]
			if Contains(queue, b) {
				result = append(result, a[i])
			}
		}

		return result

	case "groups":
		// loop a array and check groups name
		for i, g := range a {
			parts := strings.Split(g, "|")
			var group = parts[0]

			if Contains(group, b) {
				result = append(result, a[i])
			}
		}

		return result

	case "agents":
		// intersect arrays and return []interface{}
		r := intersect.Simple(a, b).([]interface{})

		// iterate over []interface{}
		result := make([]string, len(r))
		for i, v := range r {
			result[i] = fmt.Sprint(v)
		}

		return result

	case "users":
		// loop a array and check users name
		for i, u := range a {
			parts := strings.Split(u, "|")
			var user = parts[0]

			if Contains(user, b) {
				result = append(result, a[i])
			}
		}

		return result
	}

	// return empty array
	return result
}

func ExtractStrings(v []string) string {
	result := strings.Join(v, `","`)

	return "\"" + result + "\""
}

func ExtractRegexpSrcOrDst(v []string) string {
	// escape "+" character, it is used in country calling codes (e.g. "+39")
	// add "." before "*" character
	// match whole string, adding "^" and "$"
	// e.g. "+391234*" -> "^\+391234.*$"
	regExps := []string{}

	for _, r := range v {
		replacer := strings.NewReplacer("+", "\\\\+", "*", ".*")
		regExp := replacer.Replace(r)
		regExps = append(regExps, "^"+regExp+"$")
	}
	result := strings.Join(regExps, `|`)
	return "'" + result + "'"
}

func ExtractRegexpTrunks(v []string) string {
	result := strings.Join(v, `|`)
	return "'" + result + "'"
}

func ExtractRegexpStrings(v []string) string {
	// match whole string, adding "^" and "$"
	regExps := []string{}

	for _, r := range v {
		regExps = append(regExps, "^"+r+"$")
	}
	result := strings.Join(regExps, `|`)
	return "'" + result + "'"
}

func ExtractCallDestinations(v []string) string {
	// init result var
	var callDestinations []string

	// loop destinations
	for _, d := range v {
		parts := strings.Split(d, ",")

		// switch type of destination
		switch parts[0] {
		case "dcontext":
			callDestinations = append(callDestinations, "dcontext = '" + parts[1] + "'")
		case "lastapp":
			callDestinations = append(callDestinations, "lastapps REGEXP '" + parts[1] + "$'")
		}
	}
	return strings.Join(callDestinations[:], " OR ")
}

func ExtractPatterns() string {
	var patterns string

	// get settings struct from configuration
	settings := configuration.Config.Settings

	// init cache connection
	cacheConnection := cache.Instance()

	// check if settings is locally cached
	settingsString, errCache := cacheConnection.Get("admin_settings").Result()

	if errCache == nil {
		// settings is cached

		// convert to struct
		var settingsMap map[string]models.Settings

		errJson := json.Unmarshal([]byte(settingsString), &settingsMap)
		if errJson != nil {
			return ""
		}
		settingsCache := settingsMap["settings"]

		v := reflect.ValueOf(&settingsCache).Elem()
		typeOfV := v.Type()

		for i := 0; i < v.NumField(); i++ {
			f := v.Field(i)

			// override default call patterns value if value from cache is nonempty

			if typeOfV.Field(i).Type.String() == "[]models.CallPattern" && len(f.Interface().([]models.CallPattern)) != 0 {
				reflect.ValueOf(&settings).Elem().FieldByName(typeOfV.Field(i).Name).Set(reflect.ValueOf(f.Interface()))
			}
		}
	}

	// sort patterns by long
	sort.Slice(settings.CallPatterns, func(i, j int) bool {
		return len(settings.CallPatterns[i].Prefix) > len(settings.CallPatterns[j].Prefix)
	})

	// loop patterns
	for _, p := range settings.CallPatterns {
		patterns += "IF (dst LIKE \"" + p.Prefix + "%\", \"" + p.Destination + "\", "
	}
	patterns += "\"\"" + strings.Repeat(")", len(settings.CallPatterns))

	// return value
	return patterns
}

func PivotGroup(timeDivisionString string) string {
	timeDivision, _ := strconv.Atoi(timeDivisionString)

	if timeDivision > 0 && timeDivision < 60 {
		return "Group"
	} else {
		return ""
	}
}

func ExtractDispositions(d []string) string {
	// declare numbers array
	var dispositions []string

	// loop dispositions: dispositions REGEXP <d1> OR dispositions = <d2> OR ...
	for _, disposition := range d {
		if disposition == "ANSWERED" {
			dispositions = append(dispositions, "dispositions REGEXP 'ANSWERED'")
		} else if disposition == "FAILED" {
			dispositions = append(dispositions, "dispositions NOT REGEXP 'ANSWERED' AND (dispositions REGEXP 'FAILED$' OR dispositions REGEXP 'CONGESTION$')")
		} else {
			dispositions = append(dispositions, "dispositions NOT REGEXP 'ANSWERED' AND dispositions REGEXP '"+disposition+"$'")
		}
	}
	return strings.Join(dispositions[:], " OR ")
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
	// get settings struct from configuration
	settings := configuration.Config.Settings

	// init cache connection
	cacheConnection := cache.Instance()

	// check if settings is locally cached
	settingsString, errCache := cacheConnection.Get("admin_settings").Result()

	if errCache == nil {
		// settings is cached

		// convert to struct
		var settingsMap map[string]models.Settings

		errJson := json.Unmarshal([]byte(settingsString), &settingsMap)
		if errJson != nil {
			return ""
		}
		settingsCache := settingsMap["settings"]

		v := reflect.ValueOf(&settingsCache).Elem()
		typeOfV := v.Type()

		for i := 0; i < v.NumField(); i++ {
			f := v.Field(i)

			// override default admin setting value if value from cache is nonempty

			if typeOfV.Field(i).Type.String() == "string" && f.Interface().(string) != "" {
				reflect.ValueOf(&settings).Elem().FieldByName(typeOfV.Field(i).Name).SetString(f.Interface().(string))
			} else if typeOfV.Field(i).Type.String() == "[]string" && len(f.Interface().([]string)) != 0 {
				reflect.ValueOf(&settings).Elem().FieldByName(typeOfV.Field(i).Name).Set(reflect.ValueOf(f.Interface()))
			} else if typeOfV.Field(i).Type.String() == "[]models.CallPattern" && len(f.Interface().([]models.CallPattern)) != 0 {
				reflect.ValueOf(&settings).Elem().FieldByName(typeOfV.Field(i).Name).Set(reflect.ValueOf(f.Interface()))
			} else if typeOfV.Field(i).Type.String() == "[]models.Cost" && len(f.Interface().([]models.Cost)) != 0 {
				reflect.ValueOf(&settings).Elem().FieldByName(typeOfV.Field(i).Name).Set(reflect.ValueOf(f.Interface()))
			}
		}
	}

	// reflect settings struct
	r := reflect.ValueOf(settings)
	f := reflect.Indirect(r).FieldByName(settingName)

	// return value
	return string(f.String())
}

func ExtractUserExtensions(user string) string {
	// init extensions var
	var extensions string

	// init cache connection
	cacheConnection := cache.Instance()

	// read default filter from cache
	valuesFilterString, errCache := cacheConnection.Get("values_filter").Result()

	// check error for filter
	if errCache != nil {
		LogError(errors.Wrap(errCache, "error reading filter from cache"))
		return ""
	}

	// convert to struct
	var valuesFilter models.Filter
	errJson := json.Unmarshal([]byte(valuesFilterString), &valuesFilter)
	if errJson != nil {
		LogError(errors.Wrap(errJson, "error converting filter"))
		return ""
	}

	users := valuesFilter.Users
	for _, u := range users {
		parts := strings.Split(u, "|")
		if parts[0] == user {
			extensions = parts[2]
			return extensions
		}
	}

	return ""
}

func EpochToHumanDate(epochTime int) string {
	i, err := strconv.ParseInt(strconv.Itoa(epochTime), 10, 64)
	if err != nil {
		return "-"
	}
	tm := time.Unix(i, 0)
	return tm.Format("2006-01-02 15:04:05")
}

func ParseRrdResults(rrdData [][]interface{}) (string, error) {
	data := [][]string{}

	for _, row := range rrdData {
		record := []string{}

		for _, value := range row {
			record = append(record, fmt.Sprint(value))
		}

		// add record to data array
		data = append(data, record)
	}

	// convert to json
	dataJSON, _ := json.Marshal(data)

	// return value
	return string(dataJSON), nil
}

func DatesTimeInterval(intervalStart string, intervalEnd string, timeGroup string) (time.Time, time.Time, error) {
	var start, end *goment.Goment
	var err error

	switch timeGroup {
	case "year":
		start, err = goment.New(intervalStart, "YYYY")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		start = start.StartOf("year")

		end, err = goment.New(intervalEnd, "YYYY")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		end = end.EndOf("year")
	case "month":
		start, err = goment.New(intervalStart, "YYYY-MM")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		start = start.StartOf("month")

		end, err = goment.New(intervalEnd, "YYYY-MM")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		end = end.EndOf("month")
	case "week":
		start, err = goment.New(intervalStart, "YYYY-WW")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		start = start.StartOf("week")

		end, err = goment.New(intervalEnd, "YYYY-WW")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		end = end.EndOf("week")
		end.SetHour(23)
		end.SetMinute(59)
		end.SetSecond(59)
	case "day":
		start, err = goment.New(intervalStart, "YYYY-MM-DD")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		start = start.StartOf("day")

		end, err = goment.New(intervalEnd, "YYYY-MM-DD")
		if err != nil {
			return time.Time{}, time.Time{}, err
		}
		end = end.EndOf("day")
	default:
		return time.Time{}, time.Time{}, errors.New("unknown timeGroup: " + timeGroup)
	}

	// convert from goment to time

	return start.ToTime(), end.ToTime(), nil
}
