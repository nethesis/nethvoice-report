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
      if (this.$route.meta.section && this.$route.meta.view) {
        return this.getQueueReportViewFilterMap()[this.$route.meta.section][
          this.$route.meta.view
        ].includes(filter);
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
          //// ...
        },
      }
    },
  },
};
export default UtilService;
