var QueriesService = {
  methods: {
    execQuery(filter, section, view, graph, success, error) {
      // console.log("execQuery, filter", filter); ////
      // console.log("execQuery, url", this.$root.apiScheme + this.$root.apiEndpoint + "/queues" + "/" + section + "/" + view+ "?filter=" + encodeURIComponent(JSON.stringify(filter)) + "&graph=" + graph); ////

      this.$http
        .get(
          this.$root.apiScheme + this.$root.apiEndpoint + "/queues/" + section + "/" + view+ "?filter=" + encodeURIComponent(JSON.stringify(filter)) + "&graph=" + graph,
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
    getQueryTree(success, error) {
      this.$http
        .get(
          this.$root.apiScheme + this.$root.apiEndpoint + "/query_tree",
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
export default QueriesService;
