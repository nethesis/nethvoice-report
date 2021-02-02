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

package cmd

import (
	"bytes"
	"fmt"
	"path"
	"text/template"
	"time"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"github.com/thoas/go-funk"

	"github.com/nethesis/nethvoice-report/api/cache"
	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/source"
	"github.com/nethesis/nethvoice-report/api/utils"
	"github.com/nethesis/nethvoice-report/tasks/helper"
)

var (
	pattern string
)

// Define command handled by cobra
var cdrCmd = &cobra.Command{
	Use:   "cdr",
	Short: "Group cdr records into date-based tables (by year, month, week etc...)",
	Run: func(cmd *cobra.Command, args []string) {
		flagsN := cmd.Flags().NFlag()
		if flagsN > 0 { // at least one flag is set
			// check flags
			if !cmd.Flags().Changed("from") {
				helper.FatalError(errors.New("Missing <from> flag"))
			}
			if !cmd.Flags().Changed("to") {
				helper.FatalError(errors.New("Missing <to> flag"))
			}
			if !cmd.Flags().Changed("destination") {
				helper.FatalError(errors.New("Missing <destination> flag"))
			}
			if !cmd.Flags().Changed("pattern") {
				helper.FatalError(errors.New("Missing <pattern> flag"))
			}

			// execute command with flags
			executeReportCDR(true)

		} else {
			// execute command without flags
			executeReportCDR(false)

		}
	},
}

// Register "cdr" command to root command
func init() {
	RootCmd.AddCommand(cdrCmd)

	// add flags
	cdrCmd.Flags().StringVarP(&from, "from", "f", "", "Date interval <from> to update cdr records")
	cdrCmd.Flags().StringVarP(&to, "to", "t", "", "Date interval <to> to update cdr records")
	cdrCmd.Flags().StringVarP(&destination, "destination", "d", "", "Type of call to update: national, international, cell etc...")
	cdrCmd.Flags().StringVarP(&pattern, "pattern", "p", "", "Pattern to match dst number. Ex. 00390 to match italian national numbers")
}

// Define objects and utilities
type CDRObj struct {
	Year        int
	Month       int
	Destination string
	Pattern     string
	Table       string
}

func yearMap(year int) string {
	return fmt.Sprintf("%d", year)
}

func monthMap(month int) string {
	return fmt.Sprintf("%02d", month)
}

// Entry point for "cdr" command
func executeReportCDR(flags bool) {
	// define db instance
	db := source.CDRInstance()

	// check if flags is passed
	if flags {
		var objTemplate CDRObj
		objTemplate.Destination = destination
		objTemplate.Pattern = pattern

		// get date
		tFrom, errFrom := time.Parse("2006-01-02", from)
		if errFrom != nil {
			helper.FatalError(errors.Wrap(errFrom, "Error parsing <from> date. Format date: YYYY-MM-DD"))
		}

		tTo, errTo := time.Parse("2006-01-02", to)
		if errTo != nil {
			helper.FatalError(errors.Wrap(errTo, "Error parsing <to> date. Format date: YYYY-MM-DD"))
		}

		// iterate over dates
		var tables []string
		for f := tFrom; f.After(tTo) == false; f = f.AddDate(0, 0, 1) {
			y := int(f.Year())
			m := int(f.Month())

			table := fmt.Sprintf("cdr_%d", y)
			tables = append(tables, table)
			table = fmt.Sprintf("cdr_%d-%02d", y, m)
			tables = append(tables, table)
		}

		// remove duplicates from tables
		tables = funk.UniqString(tables)

		// loop tables
		for _, t := range tables {
			// compile query
			objTemplate.Table = t

			// define template cdr update
			templateCDR := configuration.Config.TemplatePath + "/cdr_update.sql"

			// define query
			var query bytes.Buffer

			tpl := template.Must(template.New(path.Base(templateCDR)).ParseFiles(templateCDR))
			errTpl := tpl.Execute(&query, &objTemplate)
			if errTpl != nil {
				helper.FatalError(errors.Wrap(errTpl, "invalid query template compiling"))
			}

			helper.LogDebug("\nExecuting query %s for [%s]:\n%s", templateCDR, t, query.String())

			// execute query
			rows, errQueryCDR := db.Query(query.String())
			if errQueryCDR != nil {
				helper.LogDebug(errQueryCDR.Error() + ". Skipping...")
				continue
			}

			// close results
			rows.Close()
		}
	} else {
		// define vars
		var minYear int
		var minMonth int
		var objTemplate CDRObj

		// define template path
		templateY := configuration.Config.TemplatePath + "/cdr_year.sql"
		templateM := configuration.Config.TemplatePath + "/cdr_month.sql"

		// get min year and min month
		rowMin := db.QueryRow("SELECT year(min(calldate)), month(min(calldate)) FROM cdr")
		errQueryMin := rowMin.Scan(&minYear, &minMonth)

		// check errors
		if errQueryMin != nil {
			helper.FatalError(errors.Wrap(errQueryMin, "error getting min year and min month"))
		}

		// save minYear and minMonth in cache
		cacheConnection := cache.Instance()
		errCache := cacheConnection.Set("cdr_first_month", fmt.Sprintf("%d-%02d", minYear, minMonth), 0).Err()
		if errCache != nil {
			helper.FatalError(errors.Wrap(errCache, "error saving to cache"))
		}

		now := time.Now()

		// used to generate cdr tables
		cdrTime := time.Date(minYear, time.Month(minMonth), now.Day(), now.Hour(), now.Minute(), now.Second(), now.Nanosecond(), now.Location())

		// loop months from minYear-minMonth to maxYear-maxMonth
		for cdrTime.Before(now) || cdrTime.Equal(now) {
			y := cdrTime.Year()
			m := int(cdrTime.Month())

			// create year table on minYear-minMonth and on every January
			if m == 1 || (y == minYear && m == minMonth) {
				// create query for year
				var queryY bytes.Buffer
				objTemplate.Year = y
				objTemplate.Month = 0

				tplY := template.Must(template.New(path.Base(templateY)).Funcs(template.FuncMap{"YearMap": yearMap}).Funcs(template.FuncMap{"MonthMap": monthMap}).Funcs(template.FuncMap{"ExtractPatterns": utils.ExtractPatterns}).ParseFiles(templateY))
				errTpl := tplY.Execute(&queryY, &objTemplate)
				if errTpl != nil {
					helper.FatalError(errors.Wrap(errTpl, "invalid query template compiling"))
				}

				helper.LogDebug("\nExecuting query %s for [%d]:\n%s", templateY, y, queryY.String())

				// execute query
				rowsY, errQueryY := db.Query(queryY.String())
				if errQueryY != nil {
					helper.FatalError(errors.Wrap(errQueryY, "Error in query [year] execution:\n"+queryY.String()))
				}

				// close results
				rowsY.Close()
			}

			var queryM bytes.Buffer
			objTemplate.Year = y
			objTemplate.Month = m

			tplM := template.Must(template.New(path.Base(templateM)).Funcs(template.FuncMap{"YearMap": yearMap}).Funcs(template.FuncMap{"MonthMap": monthMap}).ParseFiles(templateM))
			errTpl := tplM.Execute(&queryM, &objTemplate)
			if errTpl != nil {
				helper.FatalError(errors.Wrap(errTpl, "invalid query template compiling"))
			}

			helper.LogDebug("\nExecuting query %s for [%d-%d]:\n%s", templateM, y, m, queryM.String())

			// execute query
			rowsM, errQueryM := db.Query(queryM.String())
			if errQueryM != nil {
				helper.FatalError(errors.Wrap(errQueryM, "Error in query [month] execution:\n"+queryM.String()))
			}

			// close results
			rowsM.Close()

			// go to next month for loop iteration
			cdrTime = cdrTime.AddDate(0, 1, 0)
		}
	}
}
