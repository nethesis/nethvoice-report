<template lang="html">
<div>
  <div v-for="(chart, index) in charts" v-bind:key="index">
    <h4 is="sui-header" class="chart-caption">
      ({{chart.position}}) {{ $t("caption." + chart.caption) }}
    </h4>
    <div v-show="!chart.data">
      <sui-loader active centered inline class="loader-height" />
    </div>
    <div v-show="chart.data">
      <!-- table chart -->
      <div class="mg-bottom-lg">
        <TableChart v-if="chart.type == 'table'" :caption="chart.caption" :data="chart.data" />
      </div>
      <!-- line chart -->
      <div v-if="chart.type == 'line'" class="line-chart">
        <line-chart :data="chart.data" :caption="chart.caption"></line-chart>
      </div>
      <!-- pie chart -->
      <div v-if="chart.type == 'pie'" class="pie-chart">
        <pie-chart :data="chart.data" :caption="chart.caption"></pie-chart>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import TableChart from "../../components/TableChart.vue";
import LineChart from "../../components/LineChart.vue";
import PieChart from "../../components/PieChart.vue";

import QueriesService from "../../services/queries";
import StorageService from "../../services/storage";
import UtilService from "../../services/utils";

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
    console.log("$parent", this.$parent); ////

    this.retrieveQueryTree(); ////

    this.$root.$on("applyFilters", (filter) => {
      this.applyFilters(filter);
    });
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$off("applyFilters");
    next();
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
    },
    applyFilters(filter) {
      // clear charts data
      this.initCharts();

      filter.agents = ["0721", "0722"]; ////

      for (let chart of this.charts) {
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
