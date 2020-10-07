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

package models

type Filter struct {
	Queues []string `json:"queues"`
	Groups []string `json:"groups"`
	Agents []string `json:"agents"`
	IVRs   []string `json:"ivrs"`

	Reasons      []string `json:"reasons"`
	Results      []string `json:"results"`
	Choices      []string `json:"choices"`
	Destinations []string `json:"destinations"`
	Origins      []string `json:"origins"`

	Time struct {
		Group    string `json:"group"`
		Division string `json:"division"`
		Range    string `json:"range"`
		Interval struct {
			Start string `json:"start"`
			End   string `json:"end"`
		} `json:"interval"`
	} `json:"time"`

	Caller   string `json:"caller"`
	Name     string `json:"contactName"`
	NullCall bool   `json:"nullCall"`
}

type Search struct {
	Name    string `json:"name"`
	Section string `json:"section"`
	View    string `json:"view"`
	Filter  Filter `json:"filter"`
}
