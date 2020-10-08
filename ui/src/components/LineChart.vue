<script>
import { Line } from "vue-chartjs";

export default {
  extends: Line,
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
          height: `22rem`,
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
      if (this.data && this.data.length > 1) {
        this.parseData();
      }
    },
  },
  methods: {
    renderLineChart() {
      const chartData = {
        labels: this.labels,
        datasets: this.datasets,
      };
      this.renderChart(chartData, this.options);
    },
    parseData() {
      // remove first element (query columns)
      const rows = this.data.filter((_, i) => i !== 0);
      this.labels = [];
      this.datasets = [];
      let currentDataset = null;
      let labelsProcessed = false;

      rows.forEach((row, index) => {
        const datasetName = row[0];
        const label = row[1];
        const value = parseFloat(row[2]);

        if (currentDataset != null && datasetName == currentDataset.label) {
          // add data to dataset
          currentDataset.data.push(value);

          if (!labelsProcessed) {
            this.labels.push(label);
          }
        } else {
          // new dataset

          if (currentDataset != null && !labelsProcessed) {
            labelsProcessed = true;
          }

          const color = this.colors[index % this.colors.length];
          currentDataset = {
            label: datasetName,
            data: [value],
            borderColor: color,
            backgroundColor: color,
            fill: false,
          };
          this.datasets.push(currentDataset);
        }
      });
      this.renderLineChart();
    },
  },
};
</script>
