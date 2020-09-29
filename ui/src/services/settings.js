var SettingsService = {
  methods: {
    getSettings(success, error) {
      this.$http
        .get(
          this.$root.apiScheme + this.$root.apiEndpoint + "/settings",
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
    updateSettings(body, success, error) {
      this.$http
        .put(this.$root.apiScheme + this.$root.apiEndpoint + "/settings", body,
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
export default SettingsService;
