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

package source

import (
	"database/sql"

	_ "github.com/go-sql-driver/mysql"

	"github.com/nethesis/nethvoice-report/api/configuration"
	"github.com/nethesis/nethvoice-report/api/utils"
	"github.com/pkg/errors"
)

var db *sql.DB

func QueueInstance() *sql.DB {
	if db == nil {
		db = QueueInit()
	}
	return db
}

func QueueInit() *sql.DB {
	// define uri connection string
	uri := configuration.Config.QueueDatabase.User + ":" + configuration.Config.QueueDatabase.Password + "@tcp(" + configuration.Config.QueueDatabase.Host + ":" + configuration.Config.QueueDatabase.Port + ")/" + configuration.Config.QueueDatabase.Name

	// connect to database
	db, err := sql.Open("mysql", uri+"?charset=utf8&parseTime=True")

	// handle error
	if err != nil {
		utils.LogError(errors.Wrap(err, "error connecting to database"))
	}

	// return db object
	return db
}
