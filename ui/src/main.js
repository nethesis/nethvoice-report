import Vue from "vue";
import VueResource from "vue-resource";
import VueI18n from "vue-i18n";
import PortalVue from "portal-vue";
import VCalendar from 'v-calendar';
import VueLodash from 'vue-lodash';
import lodash from 'lodash';
import VueScrollTo from 'vue-scrollto';

import App from "./App.vue";
import router from "./router";
import languages from "./i18n/lang";

import SuiVue from "semantic-ui-vue";
import "semantic-ui-css/semantic.min.css";
import "./styles/main.css";

import "./filters/filters";

Vue.config.productionTip = false;
Vue.use(SuiVue);

Vue.use(VueResource);
Vue.http.interceptors.push(function () {
  return function (response) {
    if (response.status == 401 && response.body && response.body.message == "Token is expired") {
      // authentication token has expired, show login page
      this.$root.$emit("logout");
    } else if (response.status == 400 && response.body && response.body.status) {
      const match = /Table '(.+)' doesn't exist/.exec(response.body.status);

      if (match && match[1]) {
        // a table used in a query does not exist
        this.$root.nonexistentTables.add(match[1]);
        const numNonexistentTables = this.$root.nonexistentTables.size;

        if (numNonexistentTables > this.$root.maxNonexistentTables) {
          // report data are not yet available
          this.$root.$emit("dataNotAvailable");
        }
      }
    }
  };
});

Vue.use(VueI18n);
Vue.use(PortalVue);
Vue.use(VueLodash, { name: 'ldsh' , lodash: lodash });
Vue.use(VueScrollTo)
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
    this.apiEndpoint = window.location.host + window.location.pathname + "api";
    this.apiScheme = window.location.protocol + "//";
    this.currentLocale = langConf.locale;
    this.currentView = "";
    this.config = window.CONFIG;
    this.nonexistentTables = new Set();
    this.maxNonexistentTables = 2;
  },
  render: (h) => h(App),
}).$mount("#app");
