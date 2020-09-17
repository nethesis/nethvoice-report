<template>
  <div id="app">
    <!-- login view -->
    <div v-if="!isLogged">
      <Login/>
    </div>
    <!-- end login view -->
    <!-- logged view -->
    <div v-if="isLogged" >
      <!-- start leftsidebar -->
      <LeftSidebar/>
      <div class="docs-container">
        <!-- start leftsidebar -->
        <TopBar/>
        <!-- end topbar -->
        <router-view/>
      </div>
    </div>
    <!-- end logged view -->
  </div>
</template>

<script>

import Login from "./views/Login.vue";
import LeftSidebar from "./components/LeftSidebar.vue";
import TopBar from "./components/TopBar.vue";

export default {
  name: "app",
  components: {
    Login: Login,
    LeftSidebar: LeftSidebar,
    TopBar: TopBar
  },
  data() {
    var isLogged = false;

    return {
      isLogged: isLogged
    }
  },
  methods: {
    didLogin () {
      this.isLogged = true
    }
  },
}

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
