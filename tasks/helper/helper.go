package helper

import (
	"fmt"
	"os"

	"github.com/fatih/color"
	"github.com/pkg/errors"
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
		os.Stderr.WriteString(RedString(errorMsg) + "\n")
	} else {
		os.Stderr.WriteString(errorMsg + "\n")
	}
}

// Print an error message to stderr and exit with non-zero status code
func FatalError(err error) {
	LogError(errors.Wrap(err, "FATAL"))
	os.Exit(1)
}
