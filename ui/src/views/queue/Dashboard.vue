<template lang="html">
<div class="masthead">
  <sui-container>
    <!-- <div>
      Queue Dashboard
    </div> -->

    <!-- <div v-for="graph in graphs" v-bind:key="graph.name">
      {{ graph.name }}: {{ graph.data }}
    </div> -->

    <!-- <div>graphs names: {{graphNames}}</div>
    <div>graphs: {{graphs.length}}</div> -->

    <GraphTable v-for="graph in graphs" v-bind:key="graph.name" :data="graph.data" />
    
  </sui-container>
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
        queues: [],
        groups: [],
        agents: [],
        ivrs: [],
        reasons: [],
        actions: [],
        results: [],
        choices: [],
        destinations: [],
        origins: [],
        time: {
          group: "",
          division: "",
          start: null,
          end: null,
        },
        caller: "",
        contactName: "",
        nullCall: false,
      };
      this.applyFilters(filter);

      this.$root.$on("applyFilters", (filter) => {
        let newFilter = { time: {} }; ////
        newFilter.queues = filter.selectedQueues;
        newFilter.groups = filter.selectedGroups;
        newFilter.agents = filter.selectedAgents;
        newFilter.ivrs = filter.selectedIvrs;
        newFilter.reasons = filter.selectedReasons;
        newFilter.action = filter.selectedActions;
        newFilter.results = filter.selectedResults;
        newFilter.choices = filter.selectedChoices;
        newFilter.destinations = filter.selectedDestinations;
        newFilter.origins = filter.selectedOrigins;
        newFilter.time.group = filter.time.selectedGroup;
        newFilter.time.division = filter.time.selectedDivision;
        newFilter.time.start = filter.time.selectedStart;
        newFilter.time.end = filter.time.selectedEnd;
        newFilter.caller = filter.selectedCaller;
        newFilter.name = filter.selectedContactName;
        newFilter.null_call = filter.selectedNullCall;
        this.applyFilters(newFilter);
      });
    },
    applyFilters(filter) {
      console.log("[Dashboard.vue] applyFilters", filter); ////

      filter.agents = ["0721", "0722"]; ////

      this.graphs = [];

      for (const graphName of this.graphNames) {
        this.execQuery(
          filter,
          this.$route.meta.section,
          this.$route.meta.view,
          graphName,
          (success) => {
            console.log("execQuery", graphName, success.body); ////

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
