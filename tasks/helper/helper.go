package helper

import (
	"fmt"
	"os"

	"github.com/fatih/color"
)

var (
	SuccessLog  = color.New(color.FgHiGreen).PrintfFunc()
	ErrorLog    = color.New(color.FgHiRed).PrintfFunc()
	GreenString = color.HiGreenString
	RedString   = color.HiRedString
	CyanString  = color.HiCyanString
)

// Print to stdout a formatted debug message, only if environment variable "DEBUG" is set to "1".
func LogDebug(format string, v ...interface{}) {
	debug := os.Getenv("DEBUG") == "1"

	if debug {
		// message is rendered in green
		fmt.Println(GreenString(format, v...))
	}
}

// Print an error message to stderr
func LogError(err error) {
	errorMsg := "[ERROR]: " + err.Error()
	debug := os.Getenv("DEBUG") == "1"

	if debug {
		// message is rendered in red
		println(RedString(errorMsg))
	} else {
		println(errorMsg)
	}
}

// Print an error message to stderr and exit with non-zero status code
func FatalError(err error) {
	LogError(err)
	os.Exit(1)
}
