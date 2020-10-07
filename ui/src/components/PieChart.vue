<script>
import { Pie } from "vue-chartjs";

export default {
  extends: Pie,
    props: ["caption", "data"],
  data() {
    return {
      labels: [],
      values: [],
    };
  },
  watch: {
    data: function () {
      if (this.data) {
        if (this.data.length > 1) {
          this.labels = this.data[1];
        }

        if (this.data.length > 2) {
          this.values = this.data[2];
          this.renderPieChart();
        }
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
            backgroundColor: ["rgb(111, 180, 232)", "rgb(154,202,238)", "rgb(197,225,245)", "rgb(125,187,234)", "rgb(168,210,241)", "rgb(197,225,245)"], ////
            borderColor: "rgb(33, 133, 208)", ////
            data: this.values.map(v => parseInt(v)),
          },
        ],
      };
      this.renderChart(chartData, this.options);
    },
  },
};
</script>
