var LoginService = {
  methods: {
    execLogin(body, success, error) {
      this.$http
        .post(this.$root.apiScheme + this.$root.apiHost + "/api/login", body)
        .then(success, error);
    },
    execLogout(success, error) {
      this.$http
        .post(
          this.$root.apiScheme + this.$root.apiHost + "/api/logout",
          {},
          {
            headers: {
              Authorization:
                "Bearer " +
                  (this.get("loggedUser") && this.get("loggedUser").token) ||
                "",
            },
          }
        )
        .then(success, error);
    },
    execRefresh(success, error) {
      this.$http
        .get(
          this.$root.apiScheme + this.$root.apiHost + "/api/refresh_token",
          {
            headers: {
              Authorization:
                "Bearer " +
                  (this.get("loggedUser") && this.get("loggedUser").token) ||
                "",
            },
          }
        )
        .then(success, error);
    },
  },
};
export default LoginService;
