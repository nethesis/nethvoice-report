<script>
import { Pie } from "vue-chartjs";

export default {
  extends: Pie,
  props: {
    caption: {
      type: String,
    },
    data: {
      type: Array,
    },
    styles: {
      type: Object,
      default: function () {
        return {
          height: `20rem`,
          position: "relative",
        };
      },
    },
  },
  data() {
    return {
      labels: [],
      values: [],
      format: "",
      mergeFunction: "",
      chartData: {},
      options: {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          position: "right",
        },
        plugins: {
          colorschemes: {
            scheme: this.$root.colorScheme,
          },
        },
        tooltips: {
          callbacks: {
            label: (tooltipItem, data) => {
              const index = tooltipItem.index;
              const label = data.labels[index];
              const formattedValue = this.formatValue(
                data.datasets[0].data[index]
              );
              return label + ": " + formattedValue;
            },
          },
        },
      },
    };
  },
  watch: {
    data: function () {
      if (this.data && this.data.length > 1) {
        // data format
        const dataColumn = this.data[0][1];
        this.format = dataColumn.split("£")[1];

        // function to merge minor entries
        if (
          dataColumn.toLowerCase().includes("avg") ||
          dataColumn.toLowerCase().includes("average")
        ) {
          this.mergeFunction = "avg";
        } else {
          this.mergeFunction = "sum";
        }

        // remove first element (query columns)
        const entries = this.data.filter((_, i) => i !== 0);

        let labels = entries.map((entry) => {
          return entry[0];
        });
        let values = entries.map((entry) => {
          return parseFloat(entry[1]);
        });

        if (entries.length <= this.$parent.MAX_CHART_ENTRIES) {
          this.labels = labels;
          this.values = values;
        } else {
          // too many entries, merge some of them
          this.mergeMinorEntries(labels, values);
        }
        this.renderPieChart();
      }
    },
    "$root.colorScheme": function () {
      this.options.plugins.colorschemes.scheme = this.$root.colorScheme;
      this.renderChart(this.chartData, this.options);
    },
  },
  methods: {
    renderPieChart() {
      const chartData = {
        labels: this.labels,
        datasets: [
          {
            label: this.$i18n.t("caption." + this.caption),
            data: this.values,
          },
        ],
      };
      this.chartData = chartData;
      this.renderChart(this.chartData, this.options);
    },
    mergeMinorEntries(labels, values) {
      // assume entries are already sorted by backend in descending order
      labels = labels.filter((_, i) => i < this.$parent.MAX_CHART_ENTRIES - 1);
      labels.push(this.$i18n.t("misc.others"));
      this.labels = labels;
      let firstValues = values.filter(
        (_, i) => i < this.$parent.MAX_CHART_ENTRIES - 1
      );

      // merge minor values
      let othersValue = 0;
      let numMerged = 0;

      for (let i = this.$parent.MAX_CHART_ENTRIES - 1; i < values.length; i++) {
        othersValue += values[i];
        numMerged++;
      }

      if (this.mergeFunction == "avg") {
        othersValue = othersValue / numMerged;
      }

      firstValues.push(othersValue);
      this.values = firstValues;
    },
    formatValue(value) {
      if (!this.format || this.format == "num") {
        return this.$options.filters.formatNumber(value);
      } else if (this.format && this.format == "twoDecimals") {
        return this.$options.filters.formatTwoDecimals(value);
      } else if (this.format && this.format == "seconds") {
        return this.$options.filters.formatTime(value);
      } else if (this.format && this.format == "currency") {
        return this.$options.filters.formatCurrency(value) + " " + this.$parent.$data.adminSettings.currency;
      } else {
        return value;
      }
    },
  },
};
</script>
