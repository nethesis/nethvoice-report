var SearchesService = {
  methods: {
    getSearches(success, error) {
      this.$http
        .get(
          this.$root.apiScheme + this.$root.apiEndpoint + "/searches",
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
    createSearch(body, success, error) {
      this.$http
        .post(this.$root.apiScheme + this.$root.apiEndpoint + "/searches", body,
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
    }
  },
};
export default SearchesService;
