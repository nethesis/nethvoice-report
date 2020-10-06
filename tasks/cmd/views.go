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
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"

	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/source"
	"github.com/nethesis/nethvoice-report/tasks/helper"
)

// Define command handled by cobra
var viewsCmd = &cobra.Command{
	Use:   "views",
	Short: "Calculate query views to combine data and columns",
	Args:  cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {
		executeReportViews()
	},
}

// Register "views" command to root command
func init() {
	RootCmd.AddCommand(viewsCmd)
}

// Entry point for "views" command
func executeReportViews() {
	// define views path
	viewsPath := configuration.Config.ViewsPath

	// get all .sql files inside views path
	errWalk := filepath.Walk(viewsPath, func(path string, info os.FileInfo, err error) error {
		// handle file different from sql
		if filepath.Ext(path) != ".sql" {
			return nil
		}

		// get value name
		value := filepath.Base(path)

		// read value content
		queryString, errRead := ioutil.ReadFile(viewsPath + "/" + value)

		// handle reading error
		if errRead != nil {
			return errors.Wrap(errRead, "Error reading views content")
		}

		// execute query
		db := source.QueueInstance()
		rows, errQuery := db.Query(string(queryString))
		if errQuery != nil {
			return errors.Wrap(errQuery, "Error in query execution")
		}

		// close results
		defer rows.Close()

		return nil
	})

	// handle read errors
	if errWalk != nil {
		helper.FatalError(errors.Wrap(errWalk, "Error reading views directory"))
	}
}
