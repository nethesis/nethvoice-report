<script>
import { Line } from "vue-chartjs";
import UtilService from "../services/utils";

export default {
  extends: Line,
  mixins: [UtilService],
  props: {
    type: {
      type: String,
    },
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
          height: `22rem`,
          position: "relative",
        };
      },
    },
  },
  data() {
    return {
      MAX_ENTRIES: 8,
      labels: [],
      datasets: [],
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
    };
  },
  watch: {
    data: function () {
      this.watchDataLineOrBarChart(this);
    },
    "$root.colorScheme": function () {
      this.options.plugins.colorschemes.scheme = this.$root.colorScheme;
      this.renderChart(this.chartData, this.options);
    },
  },
};
</script>
