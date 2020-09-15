package models

type UserAuthorizations struct {
	Username string   `json:"username"`
	Queues   []string `json:"queues"`
	Groups   []string `json:"groups"`
}
