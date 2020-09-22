package helper

import (
	"github.com/fatih/color"
)

var (
	SuccessLog  = color.New(color.FgHiGreen).PrintfFunc()
	ErrorLog    = color.New(color.FgHiRed).PrintfFunc()
	GreenString = color.HiGreenString
	RedString   = color.HiRedString
	CyanString  = color.HiCyanString
)
