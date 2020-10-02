var UtilService = {
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

      // console.log("isFilterInView, section", section, "view", view); ////

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
          "summary": ["time", "queue"],
          "agent": ["time", "queue", "agent"],
          "session": ["time", "queue", "reason"],
          "caller": ["time", "queue", "caller", "contactName"],
          "call": ["time", "queue", "caller", "contactName", "agent", "result"],
          "lostCall": ["time", "queue", "caller", "contactName", "reason"], //// verify
          "ivr": ["time", "ivr", "choice"]
        },
        "performance": {
          "default": ["time", "queue"]
        },
        "distribution": {
          "hour": ["time", "queue", "timeSplit", "agent", "destination", "ivr"],
          "geo": ["time", "queue", "origin"],
        },
        "graphs": {
          "load": ["time", "queue", "origin"], //// verify
          "hour": ["time", "queue", "agent", "destination", "ivr", "choice"],
          "agent": ["time", "queue", "agent"],
          "area": ["time", "queue", "origin"],
          "queue_position": ["time", "queue", "timeSplit"],
          "avg_duration": ["time", "queue", "timeSplit"],
          "avg_wait": ["time", "queue", "timeSplit"]
        }
      }
    },
  },
};
export default UtilService;
