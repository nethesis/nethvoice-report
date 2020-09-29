<template>
<div id="app">
  <!-- handle popups -->
  <portal-target name="semantic-ui-vue"></portal-target>
  <!-- login view -->
  <div v-if="!isLogged">
    <Login />
  </div>
  <!-- end login view -->
  <!-- logged view -->
  <div v-if="isLogged">
    <!-- start leftsidebar -->
    <LeftSidebar />
    <div class="docs-container">
      <!-- start leftsidebar -->
      <TopBar />
      <!-- end topbar -->
      <router-view />
    </div>
  </div>
  <!-- end logged view -->
</div>
</template>

<script>
import Login from "./views/Login.vue";
import LeftSidebar from "./components/LeftSidebar.vue";
import TopBar from "./components/TopBar.vue";

import LoginService from "./services/login";
import StorageService from "./services/storage";

export default {
  name: "App",
  components: {
    Login: Login,
    LeftSidebar: LeftSidebar,
    TopBar: TopBar,
  },
  mixins: [LoginService, StorageService],
  mounted() {
    // hide body
    document.body.classList.add('hide');

    // check token validity and refresh
    this.execRefresh(() => {
        this.isLogged = true;
        document.body.classList.add('show');

        console.log("execRefresh success"); ////
      },
      () => { // error
        this.isLogged = false;
        document.body.classList.add('show'); //// redundant navigation
      })
  },
  data() {
    return {
      isLogged: false,
      // filter: { ////
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
      // },
    };
  },
  methods: {
    didLogin() {
      this.isLogged = true;

      console.log("didLogin"); ////
    },
    didLogout() {
      this.isLogged = false;
    },
  },
};
</script>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.hide {
  display: none;
}

.show {
  display: block;
}

.docs-container {
  margin-left: 260px;
  min-width: 550px;
  height: 100vh;
  overflow-y: scroll;
}

#nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}

.mg-right-sm {
  margin-right: 1rem !important;
}
</style>
