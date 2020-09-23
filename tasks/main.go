package main

import (
	"flag"

	"github.com/nethesis/nethvoice-report/api/queue/configuration"
	"github.com/nethesis/nethvoice-report/tasks/cmd"
)

func main() {
	// read and init configuration
	ConfigFilePtr := flag.String("c", "/opt/nethvoice-report/api/conf.json", "Path to configuration file")
	flag.Parse()
	configuration.Init(ConfigFilePtr)

	// initialize CLI
	cmd.Execute()
}
