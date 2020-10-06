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
        <div class="mg-3-em">
          <router-view />
        </div>
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
    document.title = this.$root.config.APP_NAME;
    // hide body
    document.body.classList.add("hide");

    // check token validity and refresh
    this.execRefresh(
      () => {
        this.isLogged = true;
        document.body.classList.add("show");
      },
      () => {
        // error
        this.isLogged = false;
        document.body.classList.add("show");
      }
    );
  },
  data() {
    return {
      isLogged: false,
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

.ui.multiple.search.dropdown > input.search {
  width: 100% !important;
}

.chart-caption {
  text-align: left;
}

.mg-bottom-lg {
  margin-bottom: 3rem;
}

.mg-3-em {
  margin: 3em;
}

.line-chart {
  max-width: 50%;
  margin: 3rem auto;
}

.pie-chart {
  max-width: 33%;
  margin: 3rem auto;
}

.loader-height {
  height: 6rem !important;
}
</style>
