package models

type Filter struct {
	Queues []string `json:"queues"`
	Groups []string `json:"groups"`
	Agents []string `json:"agents"`
	IVRs   []string `json:"ivrs"`

	Reasons      []string `json:"reasons"`
	Actions      []string `json:"actions"`
	Results      []string `json:"results"`
	Choices      []string `json:"choices"`
	Destinations []string `json:"destinations"`
	Origins      []string `json:"origins"`

	Time struct {
		Group    string `json:"group"`
		Division string `json:"division"`
		Start    string `json:"start"`
		End      string `json:"end"`
	} `json:"time"`

	Caller   string `json:"caller"`
	Name     string `json:"name"`
	NullCall bool   `json:"null_call"`
}

type Search struct {
	Name    string `json:"name"`
	Section string `json:"section"`
	View    string `json:"view"`
	Filter  Filter `json:"filter"`
}
