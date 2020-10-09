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
          position: 'relative'
        }
      },
    },
  },
  data() {
    return {
      labels: [],
      values: [],
      options: {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          position: "right",
        },
      },
    };
  },
  watch: {
    data: function () {
      if (this.data && this.data.length > 1) {
        // remove first element (query columns)
        const entries = this.data.filter((_, i) => i !== 0);
        this.labels = entries.map((entry) => {
          return entry[0];
        });
        this.values = entries.map((entry) => {
          return entry[1];
        });
        this.renderPieChart();
      }
    },
  },
  methods: {
    renderPieChart() {
      const chartData = {
        labels: this.labels,
        datasets: [
          {
            label: this.$i18n.t("caption." + this.caption),
            backgroundColor: [
              "#d2e6f5",
              "#a6ceec",
              "#79b5e2",
              "#4d9dd9",
              "#2185d0",
              "#1a6aa6",
              "#134f7c",
              "#0d3553",
              "#061a29",
            ],
            borderColor: "#2185d0",
            data: this.values.map((v) => parseFloat(v)),
          },
        ],
      };
      this.renderChart(chartData, this.options);
    },
  },
};
</script>
