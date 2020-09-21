var LoginService = {
  methods: {
    execLogin(body, success, error) {
      this.$http
        .post(this.$root.api_scheme + this.$root.api_host + "/api/login", body)
        .then(success, error);
    },
    execLogout(success, error) {
      this.$http
        .post(
          this.$root.api_scheme + this.$root.api_host + "/api/logout",
          {},
          {
            headers: {
              Bearer:
                (this.get("loggedUser") && this.get("loggedUser").token) || "",
            },
          }
        )
        .then(success, error);
    },
    execRefresh(success, error) {
      this.$http
        .get(
          this.$root.api_scheme + this.$root.api_host + "/api/refresh_token",
          {
            headers: {
              Bearer:
                (this.get("loggedUser") && this.get("loggedUser").token) || "",
            },
          }
        )
        .then(success, error);
    },
  },
};
export default LoginService;
