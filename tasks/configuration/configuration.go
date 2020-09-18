package configuration

import (
	"encoding/json"
	"os"
)

type Configuration struct { //// keep only used attributes
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
	Tasks        struct {
		Username string `json:"username"`
		Password string `json:"password"`
	} `json:"tasks`
	UserAuthorizationsFile string `json:"user_auth_file"`
	APIEndpoint            string `json:"api_endpoint"`
}

var Config = Configuration{}

func Init() {
	// read configuration
	file, _ := os.Open("/opt/nethvoice-report/conf.json")
	decoder := json.NewDecoder(file)

	// check errors or parse JSON
	err := decoder.Decode(&Config)
	if err != nil {
		os.Stderr.WriteString(err.Error())
	}
}
