<template lang="html">
<div class="chart-container">
  <div v-for="(chart, index) in charts" v-bind:key="index" :class="{'table-chart': chart.type == 'table', 'line-chart': chart.type == 'line', 'pie-chart': chart.type == 'pie'}">
    <h4 is="sui-header">
      {{ $t("caption." + chart.caption) }}
    </h4>
    <div v-show="!chart.data">
      <sui-loader active centered inline class="loader-height" />
    </div>
    <div v-show="chart.data">
      <!-- table chart -->
      <div v-if="chart.type == 'table'">
        <TableChart :caption="chart.caption" :data="chart.data" />
      </div>
      <!-- line chart -->
      <div v-if="chart.type == 'line'">
        <line-chart :data="chart.data" :caption="chart.caption"></line-chart>
      </div>
      <!-- pie chart -->
      <div v-if="chart.type == 'pie'">
        <pie-chart :data="chart.data" :caption="chart.caption"></pie-chart>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import TableChart from "../components/TableChart.vue";
import LineChart from "../components/LineChart.vue";
import PieChart from "../components/PieChart.vue";

import QueriesService from "../services/queries";
import StorageService from "../services/storage";
import UtilService from "../services/utils";

export default {
  name: "QueueDashboard",
  components: { TableChart, LineChart, PieChart },
  mixins: [StorageService, QueriesService, UtilService],
  data() {
    return {
      queryTree: null,
      queryNames: [],
      charts: [],
    };
  },
  mounted() {
    this.retrieveQueryTree();

    this.$root.$on("applyFilters", (filter) => {
      this.applyFilters(filter);
    });
  },
  watch: {
    $route: function () {
      this.initCharts();
    },
  },
  methods: {
    retrieveQueryTree() {
      this.getQueryTree(
        (success) => {
          this.queryTree = success.body.query_tree;
          this.initCharts();
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
    initCharts() {
      let charts = [];

      this.queryNames = this.queryTree[this.$route.meta.section][
        this.$route.meta.view
      ];

      if (this.queryNames) {
        for (const queryName of this.queryNames) {
          const tokens = queryName.split("_");
          const position = parseInt(tokens[0]);
          const type = tokens[1];
          const caption = tokens[2];
          charts.push({
            name: queryName,
            position: position,
            type: type,
            caption: caption,
            data: null,
          });
        }
        this.charts = charts.sort(this.sortByProperty("position"));
        this.$root.$emit("requestApplyFilter");
      } else {
        this.charts = [];
      }
    },
    applyFilters(filter) {
      for (let chart of this.charts) {
        chart.data = null;

        this.execQuery(
          filter,
          this.$route.meta.section,
          this.$route.meta.view,
          chart.name,
          (success) => {
            const result = success.body;
            chart.data = result;
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
