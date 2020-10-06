<script>
import { Line } from "vue-chartjs";

export default {
  extends: Line,
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
          this.renderLineChart();
        }
      }
    },
  },
  methods: {
    renderLineChart() {
      const chartData = {
        labels: this.labels,
        datasets: [
          {
            label: this.$i18n.t("caption." + this.caption),
            backgroundColor: "rgb(111, 180, 232)", ////
            borderColor: "rgb(33, 133, 208)", ////
            data: this.values.map(v => parseFloat(v)),
          },
        ],
      };
      this.renderChart(chartData, this.options);
    },
  },
};
</script>
