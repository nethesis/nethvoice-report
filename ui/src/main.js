import Vue from "vue";
import VueResource from "vue-resource";
import VueI18n from "vue-i18n";
import PortalVue from "portal-vue";
import VCalendar from 'v-calendar';

import App from "./App.vue";
import router from "./router";
import languages from "./i18n/lang";

import SuiVue from "semantic-ui-vue";
import "semantic-ui-css/semantic.min.css";
import "./styles/main.css";

Vue.config.productionTip = false;
Vue.use(SuiVue);
Vue.use(VueResource);
Vue.use(VueI18n);
Vue.use(PortalVue);
Vue.use(VCalendar);

// configure i18n
var langConf = languages.initLang();
const i18n = new VueI18n({
  locale: langConf.locale,
  messages: langConf.messages,
});

new Vue({
  router,
  i18n,
  created: function () {
    this.apiEndpoint = "192.168.5.82:8585/api"; //window.location.host ////
    this.apiScheme = "http://"; //window.location.protocol + "//"; ////
    this.currentLocale = langConf.locale;
    this.currentView = "";
    // this.filter = { ////
    //   "queues": [],
    //   "groups": [],
    //   "agents": [],
    //   "ivrs": [],
    //   "reasons": [],
    //   "actions": [],
    //   "results": [],
    //   "choices": [],
    //   "destinations": [],
    //   "origins": [],
    //   "time": {
    //     "group": "",
    //     "division": "",
    //     "start": "",
    //     "end": "",
    //   },
    //   "caller": "",
    //   "name": "",
    //   "nullCall": false
    // };

    // this.$root.$on('applyFilters', (newFilter) => { ////
    //   console.log("applyFilters event handler", newFilter); ////

    //   newFilter.agents = ["0721"]; ////

    //   this.execQuery(newFilter, "data", "agent", "graph_call_distribution_per_queue",
    //     (success) => {
    //       console.log("success", success); ////
    //     },
    //     (error) => {
    //       console.error(error.body);
    //     }); ////
    // });
  },
  render: (h) => h(App),
}).$mount("#app");
