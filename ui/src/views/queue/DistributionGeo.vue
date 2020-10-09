<template lang="html">
<div>
  <TableChart v-for="(chart, index) in charts" v-bind:key="index" :caption="chart.name" :data="chart.data" />
</div>
</template>

<script>
import TableChart from "../../components/TableChart.vue";

import QueriesService from "../../services/queries";
import StorageService from "../../services/storage";

export default {
  name: "DistributionGeo",
  components: { TableChart: TableChart },
  mixins: [StorageService, QueriesService],
  data() {
    return {
      chartNames: [],
      charts: [],
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
      this.chartNames =
        queryTree[this.$route.meta.section][this.$route.meta.view];

      this.$root.$on("applyFilters", (filter) => {
        this.applyFilters(filter);
      });
    },
    applyFilters(filter) {
      //// copy code from dashboard

      this.charts = [];

      for (const chartName of this.chartNames) {
        this.execQuery(
          filter,
          this.$route.meta.section,
          this.$route.meta.view,
          chartName,
          (success) => {
            const result = success.body;
            this.charts.push({ name: chartName, data: result });
          },
          (error) => {
            console.error(error.body);
            this.charts.push({ name: chartName, data: null });
          }
        );
      }
    },
  },
};
</script>
