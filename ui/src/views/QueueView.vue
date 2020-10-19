<template lang="html">
<div class="chart-container">
  <div v-for="(chart, index) in charts" v-bind:key="index" :class="{'table-chart': chart.type == 'table', 'line-chart': chart.type == 'line', 'pie-chart': chart.type == 'pie'}">
    <h4 is="sui-header">
      {{ $t("caption." + chart.caption) }}
    </h4>
    <div v-show="!chart.data">
        <sui-loader v-if="!chart.message" active centered inline class="loader-height" />
        <div v-else>
          <sui-message warning>
            <i class="exclamation triangle icon"></i>{{ $t("message." + chart.message) }}
          </sui-message>
        </div>
    </div>
    <div v-show="chart.data">
      <div v-show="chart.data && chart.data.length == 1">
        <!-- no data, only query header is present -->
        <sui-message warning>
          <i class="exclamation triangle icon"></i>{{ $t("no_data_for_current_filter") }}
        </sui-message>
      </div>
      <div v-show="chart.data && chart.data.length > 1">
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
    <div v-show="chart.details" class="show-details">
      <sui-button type="button" size="tiny" icon="zoom" @click.native="showDetailsModal(chart)">
        {{ $t("show_details") }}
      </sui-button>
    </div>
  </div>

  <!-- show details modal -->
  <sui-form @submit.prevent="hideDetailsModal()">
    <sui-modal v-if="chartDetails" v-model="openDetailsModal" size="tiny">
      <sui-modal-header>{{ $t("caption." + chartDetails.caption) }}</sui-modal-header>
      <sui-modal-content scrolling ref="chartDetailsContent">
        <sui-table compact celled selectable striped collapsing class="chart-details">
          <sui-table-body>
            <sui-table-row v-for="(entry, index) in chartDetails.details" v-bind:key="index">
              <sui-table-cell>
                {{ entry[0] }}
              </sui-table-cell>
              <sui-table-cell>
                {{ entry[1] | formatNumber }}
              </sui-table-cell>
            </sui-table-row>
          </sui-table-body>
        </sui-table>
      </sui-modal-content>
      <sui-modal-actions>
        <sui-button type="submit" primary>
          {{ $t("close") }}
        </sui-button>
      </sui-modal-actions>
    </sui-modal>
  </sui-form>
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
      MAX_PIE_ENTRIES: 8,
      openDetailsModal: false,
      chartDetails: null,
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
          console.log("success.body.query_tree", success.body.query_tree); ////

          for (const viewData of Object.values(success.body.query_tree)) {
            for (const queries of Object.values(viewData)) {
              queries.forEach(function (query, index) {

                console.log("query", query) ////

                const tokens = query.split(".");
                const queryName = tokens[0];
                const queryType = tokens[1];
                this[index] = { name: queryName, type: queryType };
              }, this.queries);
            }
          }
          this.queryTree = success.body.query_tree;

          console.log("this.queryTree", this.queryTree); ////

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
            message: null,
            details: null,
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
        chart.message = null;
        chart.details = null;

        this.execQuery(
          filter,
          this.$route.meta.section,
          this.$route.meta.view,
          chart.name,
          (success) => {
            const result = success.body;

            // check warning message
            if (
              result.length == 2 &&
              result[0].length == 1 &&
              result[0][0] == "!message"
            ) {
              chart.message = result[1][0].replace(/ /g, "_");
            } else {
              chart.data = result;

              // show details button for pie chart with a lot of entries
              if (
                chart.type == "pie" &&
                result.length > this.MAX_PIE_ENTRIES + 1
              ) {
                chart.details = result.filter((_, i) => i !== 0);
              }
            }
          },
          (error) => {
            console.error(error.body);
          }
        );
      }
    },
    showDetailsModal(chart) {
      this.chartDetails = chart;
      this.openDetailsModal = true;

      // scroll modal to top
      this.$nextTick(() => {
        this.$refs.chartDetailsContent.$el.scrollTop = 0;
      });
    },
    hideDetailsModal() {
      this.openDetailsModal = false;
    },
  },
};
</script>
