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

package configuration

import (
	"encoding/json"
	"os"
)

type Configuration struct {
	QueueDatabase struct {
		Host     string `json:"host"`
		Port     string `json:"port"`
		User     string `json:"user"`
		Name     string `json:"name"`
		Password string `json:"password"`
	} `json:"queue_database"`
	RedisAddress string `json:"redis_address"`
	TTLCache     int    `json:"ttl_cache"`
	Secret       string `json:"secret"`
	QueryPath    string `json:"query_path"`
}

var Config = Configuration{}

func Init(ConfigFilePtr *string) {
	// read configuration
	if _, err := os.Stat(*ConfigFilePtr); err == nil {
		file, _ := os.Open(*ConfigFilePtr)
		decoder := json.NewDecoder(file)
		// check errors or parse JSON
		err := decoder.Decode(&Config)
		if err != nil {
			panic(err)
		}
	}
}
