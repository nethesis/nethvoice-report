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
      },
      MAX_ENTRIES: 8,
    };
  },
  watch: {
    data: function () {
      if (this.data && this.data.length > 1) {
        // remove first element (query columns)
        const entries = this.data.filter((_, i) => i !== 0);

        let labels = entries.map((entry) => {
          return entry[0];
        });
        let values = entries.map((entry) => {
          return parseFloat(entry[1]);
        });

        if (entries.length <= this.MAX_ENTRIES) {
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
      labels = labels.filter((_, i) => i < this.MAX_ENTRIES - 1);
      labels.push(this.$i18n.t("misc.others"));
      this.labels = labels;
      let firstValues = values.filter((_, i) => i < this.MAX_ENTRIES - 1);

      // merge minor values
      let othersValue = 0;

      for (let i = this.MAX_ENTRIES - 1; i < values.length; i++) {
        othersValue += values[i];
      }
      firstValues.push(othersValue);
      this.values = firstValues;
    },
  },
};
</script>
