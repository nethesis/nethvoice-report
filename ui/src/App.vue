<template>
  <div id="app">
    <!-- handle popups -->
    <portal-target name="semantic-ui-vue"></portal-target>
    <!-- login view -->
    <div v-show="!isLogged">
      <Login />
    </div>
    <!-- end login view -->
    <!-- logged view -->
    <div v-if="isLogged">
      <!-- start leftsidebar -->
      <LeftSidebar />
      <div views-wrapper="true" class="docs-container">
        <!-- start topbar -->
        <TopBar />
        <!-- end topbar -->
        <div class="mg-3-em">
          <router-view />
        </div>
        <BackToTop scrollTop="400" />
      </div>
    </div>
    <!-- end logged view -->
  </div>
</template>

<script>
import Login from "./views/Login.vue";
import LeftSidebar from "./components/LeftSidebar.vue";
import TopBar from "./components/TopBar.vue";
import BackToTop from "./components/BackToTop.vue";

import LoginService from "./services/login";
import StorageService from "./services/storage";

export default {
  name: "App",
  components: {
    Login: Login,
    LeftSidebar: LeftSidebar,
    TopBar: TopBar,
    BackToTop: BackToTop
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
  width: calc(100% - 260px);
  min-width: 550px;
  height: 100vh;
  overflow-y: scroll;
  overflow-x: hidden;
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

.mg-right-xl {
  margin-right: 4rem !important;
}

.ui.multiple.search.dropdown > input.search {
  width: 100% !important;
}

.mg-top-md {
  margin-top: 2rem !important;
  padding-left: 7px;
}

.mg-bottom-sm {
  margin-bottom: 1rem !important;
}

.mg-bottom-md {
  margin-bottom: 2rem !important;
}

.mg-3-em {
  margin: 0 3em 3em;
}

.table-chart {
  width: 95%;
  margin: 2rem;
}

.line-chart {
  width: 95%;
  margin: 2rem;
}

.bar-chart {
  width: 95%;
  margin: 2rem;
}

.pie-chart {
  max-width: 26rem;
  margin: 2rem 2rem 3rem 2rem;
}

.loader-height {
  height: 6rem !important;
}

.chart-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}

.show-details {
  margin-top: 1rem;
}

.gray {
  color: gray;
}

.component-body {
    position: relative;
    margin-left: 3em !important;
    margin-right: 3em !important;
    padding: 2em 0em 7em;
    width: auto;
}

.modals {
  z-index: 11000 !important;
}

.icon.cursor-default {
  cursor: default !important;
}

.masthead.topbar {
  padding: 14px 0px 15px 0px !important;
  min-height: 65px;
  margin-bottom: 0 !important;
  border-bottom: none;
  box-shadow: none;

  .ui.container {
    margin-right: 3em !important;
    margin-left: 3em !important;
    width: auto !important;

    .ui.header {
      margin: 0px !important;
    }

    .ui.right.floated.menu {
      margin-top: -2px;
    }
  }
}

.ui.pagination.menu.no-border {
  box-shadow: none;
  border: 0;
  background: initial;
}

.ui.input.current-page > input {
  width: 4rem !important;
  text-align: center;
}

.ui.selection.dropdown.rows-per-page {
  width: 5.5rem;
  min-width: 0;
}

.ui.pagination.menu .item.select-rows-per-page {
  padding-left: 0.4rem;
  padding-right: 0.4rem;
  min-width: 0;
}

.ui.menu .dropdown.item.select-rows-per-page .menu {
  min-width: 10.5rem;
}

.menu-item-padding.ui.dropdown {
  padding-left: 0;
}

.ui.menu .item.small-pad {
  padding-left: 0.8rem;
  padding-right: 0.8rem;
}

.ui.menu .item.select-rows-per-page>i.dropdown.icon {
  margin: 0;
}

.ui.menu .ui.dropdown .menu>.item .icon:not(.dropdown).check {
  float: right !important;
  margin-right: 0 !important;
}

.no-border.ui.menu .item:before {
  background: none;
}

.report-data-not-available {
  width: 100%;
}
</style>
