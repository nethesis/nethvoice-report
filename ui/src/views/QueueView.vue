<template lang="html">
<div>
  <div v-show="!dataAvailable" class="ui placeholder segment report-data-not-available">
    <div class="ui icon header">
      <i class="frown outline icon mg-bottom-sm"></i>
      {{ $t("message.come_back_tomorrow") }}
    </div>
    <div class="inline">
      {{ $t("message.come_back_tomorrow_desc") }}
    </div>
  </div>
  <div v-show="dataAvailable">
    <div class="chart-container">
      <div
        v-for="(chart, index) in charts" v-bind:key="index"
        :id="`export_${index}`"
        :class="{'table-chart': chart.type == 'table', 'line-chart': chart.type == 'line', 'pie-chart': chart.type == 'pie', 'bar-chart': chart.type == 'bar'}"
      >
        <div class="align-center h-20">
          <h4 is="sui-header" class="chart-caption">
            {{ $t("caption." + chart.caption) }}
          </h4>
        </div>
        <div class="export-container">
          <ExportData
            :data="chart.data"
            :filename="$t(`caption.${chart.caption}`)"
            :pdfElementContainerId="`#export_${index}`"
            pdfElementHeaderClass=".header"
            :type="chart.type"
          />
        </div>
        <div v-show="!chart.data">
            <sui-loader v-if="!chart.message" active centered inline class="loader-height" />
            <div v-else>
              <sui-message warning>
                <i class="exclamation triangle icon"></i>{{ $t("message." + chart.message) }}
              </sui-message>
            </div>
        </div>
        <div v-show="chart.data">
          <div v-show="chart.data && chart.data.length < 2">
            <!-- no data, only query header is present -->
            <sui-message warning>
              <i class="exclamation triangle icon"></i>{{ $t("message.no_data_for_current_filter") }}
            </sui-message>
          </div>
          <div v-show="chart.data && chart.data.length > 1">
            <!-- table chart -->
            <div v-if="chart.type == 'table'">
              <TableChart :caption="chart.caption" :data="chart.data" :chartKey="`${index}`"/>
            </div>
            <!-- line chart -->
            <div v-if="chart.type == 'line'">
              <line-chart :data="chart.data" :caption="chart.caption"></line-chart>
            </div>
            <!-- bar chart -->
            <div v-if="chart.type == 'bar'">
              <bar-chart :data="chart.data" :caption="chart.caption" :type="chart.type"></bar-chart>
            </div>
            <!-- pie chart -->
            <div v-if="chart.type == 'pie'">
              <pie-chart :data="chart.data" :caption="chart.caption"></pie-chart>
            </div>
          </div>
        </div>
        <div v-show="chart.details" class="show-details">
          <sui-button type="button" size="tiny" icon="zoom" @click.native="showDetailsModal(chart)">
            {{ $t("command.show_details") }}
          </sui-button>
        </div>
      </div>
    </div>
    <!-- show details modal -->
    <sui-form @submit.prevent="hideDetailsModal()">
      <sui-modal v-if="chartDetails" v-model="openDetailsModal" size="small">
        <sui-modal-header>{{ $t("caption." + chartDetails.caption) }}</sui-modal-header>
        <sui-modal-content scrolling ref="chartDetailsContent">
          <TableChart :minimal="true" :caption="chartDetails.caption" :data="chartDetails.data" class="chart-details"/>
        </sui-modal-content>
        <sui-modal-actions>
          <sui-button type="submit" primary>
            {{ $t("command.close") }}
          </sui-button>
        </sui-modal-actions>
      </sui-modal>
    </sui-form>
  </div>
</div>
</template>

<script>
import TableChart from "../components/TableChart.vue";
import LineChart from "../components/LineChart.vue";
import BarChart from "../components/BarChart.vue";
import PieChart from "../components/PieChart.vue";
import ExportData from "../components/ExportData.vue";

import QueriesService from "../services/queries";
import StorageService from "../services/storage";
import UtilService from "../services/utils";

export default {
  name: "QueueDashboard",
  components: { TableChart, LineChart, BarChart, ExportData, PieChart },
  mixins: [StorageService, QueriesService, UtilService],
  data() {
    return {
      queryTree: null,
      queryNames: [],
      charts: [],
      MAX_PIE_ENTRIES: 8,
      openDetailsModal: false,
      chartDetails: null,
      dataAvailable: true,
    };
  },
  mounted() {
    this.retrieveQueryTree();

    this.$root.$on("applyFilters", (filter) => {
      this.applyFilters(filter);
    });

    // event "dataNotAvailable" is triggered by $http interceptor if report tables don't exist yet
    this.$root.$on("dataNotAvailable", () => {
      this.dataAvailable = false;
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
          let queryTree = success.body.query_tree;

          for (const section of Object.keys(queryTree)) {
            for (const view of Object.keys(queryTree[section])) {
              queryTree[section][view].forEach(function (query, index) {
                const tokens = query.split(".");
                const queryName = tokens[0];
                const queryType = tokens[1];
                this[index] = { name: queryName, type: queryType };
              }, queryTree[section][view]);
            }
          }
          this.queryTree = queryTree;
          this.initCharts();
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
    initCharts() {
      if (this.dataAvailable) {
        let charts = [];

        this.queries = this.queryTree[this.$route.meta.section][
          this.$route.meta.view
        ];

        if (this.queries) {
          this.queries.forEach((query) => {
            const queryName = query.name;
            const queryType = query.type;
            const tokens = queryName.split("_");
            const position = parseInt(tokens[0]);
            const chartType = tokens[1];
            const caption = tokens[2];
            charts.push({
              name: queryName,
              position: position,
              type: chartType,
              queryType: queryType,
              caption: caption,
              data: null,
              message: null,
              details: null,
            });
          });
          this.charts = charts.sort(this.sortByProperty("position"));
          this.$root.$emit("requestApplyFilter");
        } else {
          this.charts = [];
        }
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
          chart.queryType,
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
                chart.details = true;
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

<style lang="scss" scoped>
.table-container {
  overflow-y: hidden;
  overflow-x: auto;
}

.export-container {
  position: relative;
  height: 12px;
}

.chart-caption {
  display: inline-block;
  margin-bottom: 1rem !important;
}

.ui.table.chart-details {
  margin: 0 auto;
}
</style>