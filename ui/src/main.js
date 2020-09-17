import Vue from 'vue'
import VueResource from "vue-resource";
import App from './App.vue'
import router from './router'
import SuiVue from 'semantic-ui-vue';
import 'semantic-ui-css/semantic.min.css';
import './styles/main.css';

Vue.use(SuiVue)
Vue.use(VueResource)

Vue.config.productionTip = false

new Vue({
  router,
  created: function() {
    this.api_host= '192.168.5.82',
    this.api_scheme= 'http//'
  },
  render: h => h(App)
}).$mount('#app')
