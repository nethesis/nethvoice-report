<template>
<div class="masthead">
  <sui-container>
    <sui-menu floated="right">
      <sui-popup basic position="bottom center" :content="$t('menu.settings')">
        <a slot="trigger" is="sui-menu-item" icon="cog" />
      </sui-popup>
      <sui-popup position="bottom center" :content="$t('menu.logout')">
        <a @click="doLogout()" slot="trigger" is="sui-menu-item" icon="sign-out" />
      </sui-popup>
    </sui-menu>
    <sui-menu floated="right">
      <sui-popup position="bottom center" class="labeled icon" v-bind:content="toggleFiltersPopup">
        <a slot="trigger" is="sui-menu-item" v-on:click="toggleFilters()" class="filter-button" :active="showFilters" content="Filters" icon="filter" />
      </sui-popup>
    </sui-menu>
    <h1 is="sui-header" class="view-title">
      {{title}}
    </h1>
    <div v-show="this.showFilters">
      <Filters />
    </div>
  </sui-container>
</div>
</template>

<script>
import Filters from "./Filters.vue";
import LoginService from "../services/login";
import StorageService from "../services/storage";

export default {
  name: 'TopBar',
  components: {
    Filters: Filters,
  },
  mixins: [LoginService, StorageService],
  data() {
    return {
      showFilters: true,
      title: this.$i18n.t(this.$route.meta.name) || "" ////
    }
  },
  watch: {
    $route: function () {
      if (this.$route.meta.name == "menu.dashboard") {
        console.log("setting dashboard title"); ////

        this.title = this.$i18n.t("menu.dashboard");
      } else {
        this.title = (this.$route.meta.section ? (this.$i18n.t("menu." + this.$route.meta.section) + ": ") : "") + this.$i18n.t(this.$route.meta.name)
      }
    }
  },
  methods: {
    toggleFilters: function () {
      this.showFilters = !this.showFilters
    },
    doLogout() {
      this.execLogout(() => {
        // remove from localstorage
        this.delete("loggedUser");

        // change route
        this.$parent.didLogout();
        this.$router.push("/");
      }, error => {
        // print error
        console.error(error.body.message);
      })
    }
  },
  computed: {
    toggleFiltersPopup: function () {
      return this.showFilters ? this.$i18n.t("menu.hide_filters") : this.$i18n.t("menu.show_filters")
    }
  }
};
</script>

<style lang="scss">
.masthead {
  padding: 14px 0px 15px 0px !important;
  min-height: 65px;
  margin-bottom: 0 !important;
  border-bottom: 1px solid rgba(34, 36, 38, .15);
  box-shadow: 0 1px 2px 0 rgba(34, 36, 38, .15);

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

.filter-button {
  .icon {
    margin-right: 10px !important;
  }
}

.filters-form {
  text-align: left;
  margin-top: 30px;
}

.view-title {
  text-align: left;
}

.component-head-menu {
  margin: 3rem 0rem 0rem !important;
}
</style>
