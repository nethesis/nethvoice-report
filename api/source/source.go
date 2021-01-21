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

package source

import (
	"database/sql"

	_ "github.com/go-sql-driver/mysql"

	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/utils"
	"github.com/pkg/errors"
)

var dbQ *sql.DB
var dbP *sql.DB
var dbF *sql.DB

func CDRInstance() *sql.DB {
	if dbQ == nil {
		dbQ = CDRInit()
	}
	return dbQ
}

func PhonebookInstance() *sql.DB {
	if dbP == nil {
		dbP = PhonebookInit()
	}
	return dbP
}

func FreePBXInstance() *sql.DB {
        if dbF == nil {
                dbF = FreePBXInit()
        }
        return dbF
}

func CDRInit() *sql.DB {
	// define uri connection string
	uri := configuration.Config.CDRDatabase.User + ":" + configuration.Config.CDRDatabase.Password + "@tcp(" + configuration.Config.CDRDatabase.Host + ":" + configuration.Config.CDRDatabase.Port + ")/" + configuration.Config.CDRDatabase.Name

	// connect to database
	db, err := sql.Open("mysql", uri+"?charset=utf8&parseTime=True&multiStatements=true")

	// handle error
	if err != nil {
		utils.LogError(errors.Wrap(err, "error connecting to database"))
	}

	// return db object
	return db
}

func PhonebookInit() *sql.DB {
	// define uri connection string
	uri := configuration.Config.PhonebookDatabase.User + ":" + configuration.Config.PhonebookDatabase.Password + "@tcp(" + configuration.Config.PhonebookDatabase.Host + ":" + configuration.Config.PhonebookDatabase.Port + ")/" + configuration.Config.PhonebookDatabase.Name

	// connect to database
	db, err := sql.Open("mysql", uri+"?charset=utf8&parseTime=True")

	// handle error
	if err != nil {
		utils.LogError(errors.Wrap(err, "error connecting to database"))
	}

	// return db object
	return db
}

func FreePBXInit() *sql.DB {
        // define uri connection string
        uri := configuration.Config.FreePBXDatabase.User + ":" + configuration.Config.FreePBXDatabase.Password + "@tcp(" + configuration.Config.FreePBXDatabase.Host + ":" + configuration.Config.FreePBXDatabase.Port + ")/" + configuration.Config.FreePBXDatabase.Name

        // connect to database
        db, err := sql.Open("mysql", uri+"?charset=utf8&parseTime=True")

        // handle error
        if err != nil {
                utils.LogError(errors.Wrap(err, "error connecting to database"))
        }

        // return db object
        return db
}
