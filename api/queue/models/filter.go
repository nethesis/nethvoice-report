package models

type Filter struct {
	Queues []string `json:"queues"`
	Groups []string `json:"groups"`
	Time   struct {
		TimeRange string `json:"time_range"`
		Value     string `json:"value"`
	} `json:"time"`
	Name     string `json:"name"`
	Agent    string `json:"agent"`
	NullCall bool   `json:"null_call"`
}
