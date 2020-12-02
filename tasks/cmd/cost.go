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
	"path"
	"text/template"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"

	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/source"
	"github.com/nethesis/nethvoice-report/tasks/helper"
)

// Define command handled by cobra
var costCmd = &cobra.Command{
	Use:   "cost",
	Short: "Calculate cost for each record based on cost configuration",
	Args:  cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {
		executeReportCost()
	},
}

// Register "cost" command to root command
func init() {
	RootCmd.AddCommand(costCmd)
}

type CostObj struct {
	Table string
}

// Entry point for "cost" command
func executeReportCost() {
	// define cost object
	var objTemplate CostObj

	// define template cost
	templateCost := configuration.Config.TemplatePath + "/cdr_cost.sql"

	// define db instance
	db := source.CDRInstance()

	// get all cdr tables
	cdrTables, errQuery := db.Query("SHOW TABLES LIKE 'cdr_%'")
	if errQuery != nil {
		helper.FatalError(errors.Wrap(errQuery, "Error getting cdr tables"))
	}

	// loop cdr tables
	for cdrTables.Next() {
		// define record
		var table string

		// handle scan error
		errScan := cdrTables.Scan(&table)
		if errScan != nil {
			helper.FatalError(errors.Wrap(errScan, "Error in query scan field"))
		}
		objTemplate.Table = table

		// define query
		var query bytes.Buffer

		// compile template
		tpl := template.Must(template.New(path.Base(templateCost)).ParseFiles(templateCost))
		errTpl := tpl.Execute(&query, &objTemplate)
		if errTpl != nil {
			helper.FatalError(errors.Wrap(errTpl, "invalid query template compiling"))
		}

		helper.LogDebug("\nExecuting query %s for [%s]:\n%s", templateCost, table, query.String())

		// execute query
		rows, errQueryCost := db.Query(query.String())
		if errQueryCost != nil {
			helper.FatalError(errors.Wrap(errQueryCost, "Error in query [cdr] execution:\n"+query.String()))
		}

		// close results
		rows.Close()
	}
}
