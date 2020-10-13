var UtilService = {
  data() {
    return {
      filterValuesCacheDuration: false,
    }
  },
  methods: {
    formatDate(date) {
      var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

      if (month.length < 2)
        month = '0' + month;
      if (day.length < 2)
        day = '0' + day;

      return [year, month, day].join('-');
    },
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
          "lost_call": ["timeGroup", "time", "queue", "caller", "contactName", "reason"], //// verify
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
          "load": ["timeGroup", "time", "queue", "origin"], //// verify
          "hour": ["timeGroup", "time", "queue", "agent", "destination", "ivr", "choice"],
          "agent": ["timeGroup", "time", "queue", "agent"],
          "area": ["timeGroup", "time", "queue"],
          "queue_position": ["timeGroup", "time", "queue", "timeSplit"],
          "avg_duration": ["timeGroup", "time", "queue", "timeSplit"],
          "avg_wait": ["timeGroup", "time", "queue", "timeSplit"]
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
          return this.formatNumber(value);
        case "seconds":
          return this.formatTime(value);
        case "percent":
          return this.formatPercentage(value);
        case "label":
          return this.$i18n.t(value);
        case "yearDate":
          // no formatting needed
          return value;
        case "monthDate":
          return this.formatMonthDate(value);
        case "weekDate":
          return this.formatWeekDate(value);
        case "dayDate":
          // no formatting needed
          return value;
      }
    },
    formatMonthDate(value) {
      // value: e.g. "2020-10"
      const tokens = value.split("-");
      const year = tokens[0];
      const monthNum = tokens[1];
      const month = this.$i18n.t("month." + this.getMonthNames()[monthNum - 1]);
      return month + " " + year;
    },
    formatWeekDate(value) {
      // value: e.g. "2020-50"
      const tokens = value.split("-");
      const year = tokens[0];
      const weekNum = parseInt(tokens[1]);
      return this.$i18n.t("week") + " " + weekNum + " " + year;
    },
    getMonthNames() {
      return [
        "january",
        "february",
        "march",
        "april",
        "may",
        "june",
        "july",
        "august",
        "september",
        "october",
        "november",
        "december"
      ]
    },
    formatNumber(value) {
      const num = parseFloat(value);

      if (isNaN(num)) {
        return "-";
      }
      return num.toLocaleString();
    },
    formatPercentage(value) {
      const numFormatted = this.formatNumber(value);

      if (!numFormatted || numFormatted == "-") {
        return "-";
      } else {
        return numFormatted + " %";
      }
    },
    formatTime: function (value) {
      if (!value || value.length == 0) {
        return '-'
      }

      var ret = "";
      let hours = parseInt(Math.floor(value / 3600));
      let minutes = parseInt(Math.floor((value - hours * 3600) / 60));
      let seconds = parseInt((value - (hours * 3600 + minutes * 60)) % 60);

      let dHours = hours > 9 ? hours : hours;
      let dMins = minutes > 9 ? minutes : minutes;
      let dSecs = seconds > 9 ? seconds : seconds;

      ret = dSecs + "s";
      if (minutes) {
        ret = dMins + "m " + ret;
      }
      if (hours) {
        ret = dHours + "h " + ret;
      }

      return ret + " (" + value + ")";
    },
  },
};
export default UtilService;
