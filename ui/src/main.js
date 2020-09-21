import Vue from "vue";
import VueResource from "vue-resource";
import VueI18n from "vue-i18n";

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

// configure i18n
var langConf = languages.initLang();
const i18n = new VueI18n({
  locale: langConf.locale,
  messages: langConf.messages,
});

new Vue({
  router,
  i18n,
  created: function() {
    this.api_host = "192.168.5.82:8080"; //window.location.host
    this.api_scheme = "http://"; //window.location.protocol + "//";
    this.currentLocale = langConf.locale;
    this.currentView = "";
  },
  render: (h) => h(App),
}).$mount("#app");
