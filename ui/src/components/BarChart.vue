<script>
import { Bar } from "vue-chartjs";
import UtilService from "../services/utils";

export default {
  extends: Bar,
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
      options: {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          position: "right",
        },
      },
      colors: [
        "#2185d0",
        "#134f7c",
        "#79b5e2",
        "#061a29",
        "#d2e6f5",
        "#0d3553",
        "#a6ceec",
        "#4d9dd9",
        "#1a6aa6",
      ],
    };
  },
  watch: {
    data: function () {
      this.lineOrBarChartWatchData(this);
    },
  },
  methods: {
    render() {
      this.renderLineOrBarChart(this);
    },
    parseData() {
      this.lineOrBarChartParseData(this);
    },
  },
};
</script>
