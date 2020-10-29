var UtilService = {
  data() {
    return {
      filterValuesCacheDuration: false,
    }
  },
  methods: {
    sortByProperty(property) {
      return function (a, b) {
        if (a[property] < b[property]) {
          return -1;
        }
        if (a[property] > b[property]) {
          return 1;
        }
        return 0;
      }
    },
    isFilterInView(filter) {
      const section = this.$route.meta.section;
      const view = this.$route.meta.view;

      if (section && view) {
        return this.getQueueReportViewFilterMap()[section][view].includes(filter);
      } else {
        return false;
      }
    },
    getQueueReportViewFilterMap() {
      return {
        "dashboard": {
          "default": ["time", "queue", "agent"],
        },
        "data": {
          "summary": ["timeGroup", "time", "queue", "agent"],
          "agent": ["timeGroup", "time", "queue", "agent"],
          "session": ["time", "queue", "reason", "agent"],
          "caller": ["timeGroup", "time", "queue", "caller", "contactName"],
          "call": ["time", "queue", "caller", "contactName", "agent", "result"],
          "lost_call": ["timeGroup", "time", "queue", "caller", "contactName", "reason"],
          "ivr": ["timeGroup", "time", "ivr", "choice"]
        },
        "performance": {
          "default": ["timeGroup", "time", "queue"]
        },
        "distribution": {
          "hourly": ["timeGroup", "time", "queue", "timeSplit", "agent", "ivr"],
          "geographic": ["timeGroup", "time", "queue", "origin"],
        },
        "graphs": {
          "load": ["timeGroup", "time", "queue", "origin"],
          "hour": ["time", "queue", "agent", "destination", "ivr", "choice"],
          "agent": ["timeGroup", "time", "queue", "agent"],
          "area": ["timeGroup", "time", "queue"],
          "queue_position": ["time", "queue", "timeSplit"],
          "avg_duration": ["time", "queue", "timeSplit"],
          "avg_wait": ["time", "queue", "timeSplit"]
        }
      }
    },
    saveToLocalStorageWithExpiry(key, item, ttlMinutes) {
      // save an object to local storage attaching its expiry date
      const expiry = new Date().getTime() + ttlMinutes * 60 * 1000;
      this.set(key, { item: item, expiry: expiry });
    },
    formatValue(value, format) {
      switch (format) {
        case "num":
          return this.$options.filters.formatNumber(value);
        case "seconds":
          return this.$options.filters.formatTime(value);
        case "percent":
          return this.$options.filters.formatPercentage(value);
        case "label":
          return this.$i18n ? this.$i18n.t(value) : value;
        case "yearDate":
          // no formatting needed
          return value;
        case "monthDate":
          return this.$options.filters.formatMonthDate(value, this.$i18n);
        case "weekDate":
          return this.$options.filters.formatWeekDate(value, this.$i18n);
        case "dayDate":
          // no formatting needed
          return value;
      }
    },
    formatDate(date) {
      let d = new Date(date),
      month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();
      if (month.length < 2) 
          month = '0' + month;
      if (day.length < 2) 
          day = '0' + day;
      return [year, month, day].join('/');
    },
    lineOrBarChartWatchData(that) {
      if (that.data && that.data.length > 1) {
        that.parseData();
      }
    },
    lineOrBarChartParseData(that) {
      that.labels = [];
      that.datasets = [];

      // remove first element (query columns)
      const rows = that.data.filter((_, i) => i !== 0);

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

      that.labels = Array.from(labelSet).sort();

      // add missing data with zero values

      for (const [datasetName, data] of Object.entries(datasetMap)) {
        const labels = Object.keys(data);
        let missingLabels = that.labels.filter((l) => !labels.includes(l));

        missingLabels.forEach((missingLabel) => {
          datasetMap[datasetName][missingLabel] = 0;
        });
      }

      // initialize bar chart data

      Object.entries(datasetMap).forEach(([datasetName, data], index) => {
        const sortedLabels = Object.keys(data).sort();
        let datasetValues = [];

        sortedLabels.forEach((label) => {
          datasetValues.push(data[label]);
        });

        const color = that.colors[index % that.colors.length];

        that.datasets.push({
          label: datasetName,
          data: datasetValues,
          borderColor: color,
          backgroundColor: color,
          fill: false,
        });
      });
      that.renderBarChart();
    },
    renderLineOrBarChart(that) {
      const chartData = {
        labels: that.labels,
        datasets: that.datasets,
      };
      that.renderChart(chartData, that.options);
    }
  },
};
export default UtilService;
