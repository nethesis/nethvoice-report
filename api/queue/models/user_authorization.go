package models

type UserAuthorizationsList struct {
	UserAuthorizations []UserAuthorizations `json:"user_authorizations"`
}

type UserAuthorizations struct {
	Username string   `json:"username"`
	Queues   []string `json:"queues"`
	Groups   []string `json:"groups"`
}
