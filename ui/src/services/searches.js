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
    },
    deleteSearch(searchId, success, error) {
      this.$http
        .delete(this.$root.apiScheme + this.$root.apiEndpoint + "/searches/" + searchId,
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
    getDefaultFilter(section, view, success, error) {
      this.$http
        .get(
          this.$root.apiScheme + this.$root.apiEndpoint + "/filters/" + section + "/" + view,
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
export default SearchesService;
