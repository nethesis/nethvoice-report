package models

type Filter struct {
	Queues []string `json:"queues"`
	Groups []string `json:"groups"`
	Time   struct {
		TimeRange string `json:"time_range"`
		Value     string `json:"value"`
	} `json:"time"`
	Caller   string `json:"caller"`
	Agent    string `json:"agent"`
	NullCall bool   `json:"null_call"`
}

type Search struct {
	Name    string `json:"name"`
	Section string `json:"section"`
	View    string `json:"view"`
	Filter  Filter `json:"filter"`
}
