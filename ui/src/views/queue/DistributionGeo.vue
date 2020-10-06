<template lang="html">
<div>
  <GraphTable v-for="graph in graphs" v-bind:key="graph.name" :caption="graph.name" :data="graph.data" />
</div>
</template>

<script>
import GraphTable from "../../components/GraphTable.vue";

import QueriesService from "../../services/queries";
import StorageService from "../../services/storage";

export default {
  name: "DistributionGeo",
  components: { GraphTable: GraphTable },
  mixins: [GraphTable, StorageService, QueriesService],
  data() {
    return {
      graphNames: [],
      graphs: [],
    };
  },
  mounted() {
    this.retrieveQueryTree();
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$off("applyFilters");
    next();
  },
  methods: {
    retrieveQueryTree() {
      this.getQueryTree(
        (success) => {
          const queryTree = success.body.query_tree;
          this.loadGraphs(queryTree);
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
    loadGraphs(queryTree) {
      this.graphNames =
        queryTree[this.$route.meta.section][this.$route.meta.view];

      this.$root.$on("applyFilters", (filter) => {
        this.applyFilters(filter);
      });
    },
    applyFilters(filter) {
      //// copy code from dashboard

      this.graphs = [];

      for (const graphName of this.graphNames) {
        this.execQuery(
          filter,
          this.$route.meta.section,
          this.$route.meta.view,
          graphName,
          (success) => {
            const result = success.body;
            this.graphs.push({ name: graphName, data: result });
          },
          (error) => {
            console.error(error.body);
            this.graphs.push({ name: graphName, data: null });
          }
        );
      }
    },
  },
};
</script>
