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
          position: "relative",
        };
      },
    },
  },
  data() {
    return {
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
      this.labels = [];
      this.datasets = [];

      // remove first element (query columns)
      const rows = this.data.filter((_, i) => i !== 0);

      // build a data structure (datasetMap) like this:
      // {
      //   datasetName: {2018: 0, 2019: 18, 2020: 4}
      //   otherDatasetName: {2018: 0, 2019: 39, 2020: 210}
      //   yetAnotherDataset: {2018: 0, 2019: 526, 2020: 28}
      // }

      let labelSet = new Set();
      let datasetNameSet = new Set();
      let datasetMap = {};

      rows.forEach((row) => {
        datasetNameSet.add(row[0]);
        labelSet.add(row[1]);
      });

      datasetNameSet.forEach((datasetName) => {
        datasetMap[datasetName] = {};
      });

      rows.forEach((row) => {
        const datasetName = row[0];
        const label = row[1];
        const value = parseFloat(row[2]);

        datasetMap[datasetName][label] = value;
      });

      this.labels = Array.from(labelSet).sort();

      // add missing data with zero values

      for (const [datasetName, data] of Object.entries(datasetMap)) {
        const labels = Object.keys(data);
        let missingLabels = this.labels.filter((l) => !labels.includes(l));

        missingLabels.forEach((missingLabel) => {
          datasetMap[datasetName][missingLabel] = 0;
        });
      }

      // initialize line chart data

      Object.entries(datasetMap).forEach(([datasetName, data], index) => {
        const sortedLabels = Object.keys(data).sort();
        let datasetValues = [];

        sortedLabels.forEach((label) => {
          datasetValues.push(data[label]);
        });

        const color = this.colors[index % this.colors.length];

        this.datasets.push({
          label: datasetName,
          data: datasetValues,
          borderColor: color,
          backgroundColor: color,
          fill: false,
        });
      });
      this.renderLineChart();
    },
  },
};
</script>
