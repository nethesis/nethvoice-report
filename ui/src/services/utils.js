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
          "default": ["time", "queue"],
        },
        "data": {
          "summary": ["timeGroup", "time", "queue"],
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
          "hourly": ["timeGroup", "time", "queue", "timeSplit", "agent", "destination", "ivr"],
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
  },
};
export default UtilService;
