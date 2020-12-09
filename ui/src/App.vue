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
      <!-- mobile topbar -->
      <MobileTopBar />
      <div views-wrapper="true" class="docs-container" @click="hideSidebar()">
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
import MobileTopBar from "./components/MobileTopBar.vue";
import LoginService from "./services/login";
import StorageService from "./services/storage";

export default {
  name: "App",
  components: {
    Login: Login,
    LeftSidebar: LeftSidebar,
    TopBar: TopBar,
    BackToTop: BackToTop,
    MobileTopBar: MobileTopBar
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

    // handle viewport width
    this.$nextTick(() => {
      window.addEventListener('resize', this.resizeHandler, true)
    })
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

      // remove from localstorage
      this.delete("loggedUser");

      // remove all event listeners
      this.$root.$off();

      // reset state of $root
      this.$root.filtersReady = false;
      this.$root.phonebook = [];
      this.$root.reversePhonebook = {};
      this.$root.colorScheme = "";
    },
    hideSidebar() {
      if (window.innerWidth < this.$mobileBound) {
        document.querySelector("#docs-menu").style.transform = "translateX(-270px)"
        this.$root.$emit("sidebarHide");
      }
    },
    resizeHandler() {
      let sidebar = document.querySelector("#docs-menu")
      if ((window.innerWidth > this.$mobileBound) && (sidebar.style.transform == "translateX(-270px)")) {
        sidebar.style.transform = "translateX(0px)"
      }
    }
  },
};
</script>

<style lang="scss">

@import "./styles/theming.scss";

body {
  min-width: 421px !important;

  @media only screen and (max-width: $mobile-bound) {
    & {
      height: calc(100% - 40px) !important;
    }
  }
}

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
  height: 100vh;
  overflow-y: scroll;
  overflow-x: hidden;

  @media only screen and (max-width: $mobile-bound) {
    & {
      margin-top: 40px;
      height: calc(100vh - 40px);
      margin-left: 0px;
      width: calc(100%);
    }
  }
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

.no-mg-top {
  margin-top: 0 !important;
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

.settings-description {
  color: gray;
  margin-top: 1em;
  margin-bottom: 1.5rem;
}

.component-body {
    position: relative;
    margin-left: 3em !important;
    margin-right: 3em !important;
    padding: 2em 0em 7em;
    width: auto;
}

.modals {
  z-index: 100 !important;
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

  @media only screen and (max-width: $mobile-bound) {
     & {
      border-bottom: 1px solid rgba(34, 36, 38, 0.15);
      box-shadow: -2px 1px 2px 0 rgba(34, 36, 38, 0.15) !important;
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

.ui.selection.dropdown {
  min-width: min-content !important;
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

.error-color {
  color: #9f3a38 !important;
}

.time-interval-error input {
  background-color: #fff6f6 !important;
  color: #9f3a38 !important;
  border-color: #e0b4b4 !important;
}

.no-margin {
  margin: 0 !important;
}

.filters-form .mx-datepicker input {
  height: 38px !important;
  margin-top: -2px !important;
}

.mx-datepicker-main {
  margin-top: 5px;
  border-radius: .28571429rem !important;
  color: rgba(0,0,0,.87) !important;
  font-weight: 600;
}


.ui.dimmer .ui.fix.loader:before {
  border-color: rgba(0,0,0,.1);
}

.ui.dimmer .ui.fix.loader:after {
  border-color: #767676 transparent transparent;
}

.color-transparent {
  color: transparent !important;
}

.input-error input {
  background: #fff6f6 !important;
  border-color: #e0b4b4 !important;
  color: #9f3a38 !important;
}
</style>
