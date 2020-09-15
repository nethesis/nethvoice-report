package models

type UserAuthorizations struct {
	UserAuthorization []UserAuthorization `json:"user_authorizations"`
}

type UserAuthorization struct {
	Username string   `json:"username"`
	Queues   []string `json:"queues"`
	Groups   []string `json:"groups"`
}
