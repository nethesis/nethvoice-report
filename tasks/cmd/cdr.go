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
	"path"
	"bytes"
	"text/template"
	"fmt"
	"strconv"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"

	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/source"
	"github.com/nethesis/nethvoice-report/tasks/helper"
)

// Define command handled by cobra
var cdrCmd = &cobra.Command{
	Use:   "cdr",
	Short: "Group cdr records into date-based tables (by year, month, week etc...)",
	Args:  cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {
		executeReportCDR()
	},
}

// Register "views" command to root command
func init() {
	RootCmd.AddCommand(cdrCmd)
}

// Define objects and utilities
type CDRObj struct {
	Year int
	Month int
}

func yearMap(year int) string {
	return fmt.Sprintf("%d", year)
}

func monthMap(month int) string {
	return fmt.Sprintf("%02d", month)
}

// Entry point for "cdr" command
func executeReportCDR() {
	// define vars
	var minYear int
	var maxYear int
	var minMonth int
	var maxMonth int
	var objTemplate CDRObj

	// define template path
	templateY := configuration.Config.CDR.TemplatePath.Year
	templateM := configuration.Config.CDR.TemplatePath.Month

	// define db instance
	db := source.CDRInstance()

	// get min and max year
	rowMinMax := db.QueryRow("SELECT year(min(calldate)), year(max(calldate)) FROM cdr")
	errQueryMinMax := rowMinMax.Scan(&minYear, &maxYear)

	// check errors
	if errQueryMinMax != nil {
		helper.FatalError(errors.Wrap(errQueryMinMax, "error getting min and max year"))
	}

	// loop years
	for y := minYear; y <= maxYear; y++ {
		// create query for y year
		var queryY bytes.Buffer
		objTemplate.Year = y
		objTemplate.Month = 0

		tplY := template.Must(template.New(path.Base(templateY)).Funcs(template.FuncMap{"YearMap": yearMap}).Funcs(template.FuncMap{"MonthMap": monthMap}).ParseFiles(templateY))
		errTpl := tplY.Execute(&queryY, &objTemplate)
		if errTpl != nil {
			helper.FatalError(errors.Wrap(errTpl, "invalid query template compiling"))
		}

		helper.LogDebug("\nExecuting query %s for [%d]:\n%s", templateY, y, queryY.String())

		// execute query
		rowsY, errQueryY := db.Query(queryY.String())
		if errQueryY != nil {
			helper.FatalError(errors.Wrap(errQueryY, "Error in query [year] execution: " + queryY.String()))
		}

		// close results
		rowsY.Close()

		// get min and max month
		rowMinMax = db.QueryRow("SELECT month(min(calldate)), month(max(calldate)) FROM `cdr_" + strconv.Itoa(y)  + "`")
		errQueryMinMax = rowMinMax.Scan(&minMonth, &maxMonth)

		// check errors
		if errQueryMinMax != nil {
			helper.FatalError(errors.Wrap(errQueryMinMax, "error getting min and max month"))
		}

		// loop months
		for m := minMonth; m <= maxMonth; m++ {
			// create query for m month
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
				helper.FatalError(errors.Wrap(errQueryM, "Error in query [month] execution: " + queryM.String()))
			}

			// close results
			rowsM.Close()
		}
	}
}
