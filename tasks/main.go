package main

import (
	"github.com/nethesis/nethvoice-report/tasks/cmd"
	"github.com/nethesis/nethvoice-report/tasks/configuration"
)

func main() {
	// read and init configuration
	configuration.Init()

	// initialize CLI
	cmd.Execute()
}
