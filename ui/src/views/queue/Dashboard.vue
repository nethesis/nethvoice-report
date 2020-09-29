<template lang="html">
<div>
  <div>
    Queue Dashboard
  </div>

  <!-- <div v-for="graph in graphs" v-bind:key="graph.name">
    {{ graph.name }}: {{ graph.data }}
  </div> -->

  <GraphTable v-for="graph in graphs" v-bind:key="graph.name" :data="graph.data" />
  
</div>
</template>

<script>
import GraphTable from "../../components/GraphTable.vue";

import QueriesService from "../../services/queries";
import StorageService from "../../services/storage";

export default {
  name: "QueueDashboard",
  components: { GraphTable: GraphTable },
  mixins: [GraphTable, StorageService, QueriesService],
  data() {
    return {
      graphNames: [], ////
      // graphData: {}, ////
      graphs: [],
    };
  },
  mounted() {
    console.log("mounted Dashboard"); ////

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

      console.log("graphNames", this.graphNames); ////

      var filter = {
        //// where should it be retrieved? local storage?
        selectedQueues: [],
        selectedGroups: [],
        selectedAgents: [],
        selectedIvrs: [],
        selectedReasons: [],
        selectedActions: [],
        selectedResults: [],
        selectedChoices: [],
        selectedDestinations: [],
        selectedOrigins: [],
        selectedTimeInterval: null,
        time: {
          selectedGroup: "",
          selectedDivision: "",
          selectedStart: null,
          selectedEnd: null,
        },
        selectedCaller: "",
        selectedContactName: "",
        selectedNullCall: false,
      };
      this.applyFilters(filter);

      this.$root.$on("applyFilters", (filter) => {
        this.applyFilters(filter);
      });
    },
    applyFilters(filter) {
      console.log("[Dashboard.vue] applyFilters", filter); ////

      filter.selectedAgents = ["0721"]; ////

      this.graphs = [];

      for (const graphName of this.graphNames) {
        this.execQuery(
          filter,
          this.$route.meta.section,
          this.$route.meta.view,
          graphName,
          (success) => {
            console.log("execQuery success", success); ////

            const result = [
              ["prefisso", "comune", "siglaprov", "provincia", "regione"],
              ["0721", "Pesaro", "PU", "PUUU", "Marche"],
            ]; ////

            // this.graphData[graphName] = result;

            this.graphs.push({ name: graphName, data: result });
          },
          (error) => {
            console.error(error.body);
          }
        );
      }
    },
  },
};
</script>
