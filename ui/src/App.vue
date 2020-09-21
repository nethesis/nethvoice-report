<template>
<div id="app">
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
  data() {
    // get current logged user
    var loggedUser = this.get("loggedUser") || null
    var isLogged = false;

    // refresh token
    if (loggedUser) {
      this.execRefresh(() => { // success
          this.isLogged = true;
        },
        () => { // error
          this.isLogged = false;
        })
    }

    return {
      isLogged: isLogged,
    };
  },
  methods: {
    didLogin() {
      this.isLogged = true;
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
</style>
