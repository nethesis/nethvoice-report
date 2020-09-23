package cmd

import (
	"fmt"

	"github.com/spf13/cobra"

	"github.com/nethesis/nethvoice-report/tasks/helper"
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Show NethVoice Tasks support CLI version",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(RootCmd.Use + " " + helper.CyanString("0.0.1"))
	},
}

func init() {
	RootCmd.AddCommand(versionCmd)
}
