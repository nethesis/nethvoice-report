package cmd

import (
	"os"

	"github.com/pkg/errors"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"

	"github.com/nethesis/nethvoice-report/tasks/helper"
)

var RootCmd = &cobra.Command{
	Use:   "tasks",
	Short: helper.CyanString("NethVoice reports support CLI"),
}

func Execute() {
	if err := RootCmd.Execute(); err != nil {
		helper.LogError(errors.Wrap(err, "error executing command"))
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)
}

func initConfig() {
	viper.SetConfigName(".tasks")

	// read in environment variables that match
	viper.AutomaticEnv()
}
