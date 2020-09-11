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

package methods

import (
	"errors"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/msteinert/pam"
)

func Login(c *gin.Context) {
	c.JSON(http.StatusCreated, gin.H{"status": "success"})
}

func Logout(c *gin.Context) {
	c.JSON(http.StatusCreated, gin.H{"status": "success"})
}

func PamAuth(username string, password string) error {
	t, err := pam.StartFunc("system-auth", username, func(s pam.Style, msg string) (string, error) {
		switch s {
		case pam.PromptEchoOff:
			return password, nil
		case pam.PromptEchoOn:
			// fmt.Print(msg + " ") ////
			// input, err := bufio.NewReader(os.Stdin).ReadString('\n')
			// if err != nil {
			return username, nil
			// } ////
			// return input[:len(input)-1], nil
		case pam.ErrorMsg:
			fmt.Print(msg)
			return "", nil
		case pam.TextInfo:
			fmt.Println(msg)
			return "", nil
		}
		return "", errors.New("Unrecognized message style")
	})
	if err != nil {
		log.Fatalf("Start: %s", err.Error())
		return err
	}
	err = t.Authenticate(0)
	if err != nil {
		log.Fatalf("Authenticate: %s", err.Error())
		return err
	}
	fmt.Println("Authentication succeeded!") ////
	return nil

}
