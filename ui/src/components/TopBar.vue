<template>
  <div class="masthead">
    <sui-container>
      <sui-menu floated="right">
        <sui-popup
          v-if="isAdmin"
          position="bottom center"
          :content="$t('menu.settings')"
        >
          <a
            slot="trigger"
            is="sui-menu-item"
            icon="cog"
            @click="showSettingsModal(true)"
          />
        </sui-popup>
        <sui-popup position="bottom center" :content="$t('menu.logout')">
          <a
            @click="doLogout()"
            slot="trigger"
            is="sui-menu-item"
            icon="sign-out"
          />
        </sui-popup>
      </sui-menu>
      <sui-menu floated="right">
        <sui-popup
          position="bottom center"
          class="labeled icon"
          v-bind:content="toggleFiltersPopup"
        >
          <a
            slot="trigger"
            is="sui-menu-item"
            v-on:click="toggleFilters()"
            class="filter-button"
            :active="showFilters"
            content="Filters"
            icon="filter"
          />
        </sui-popup>
      </sui-menu>
      <h1 is="sui-header" class="view-title">
        {{ title }}
      </h1>
      <div v-show="this.showFilters">
        <Filters />
      </div>
    </sui-container>

    <!-- settings modal -->
    <sui-form @submit.prevent="saveAdminSettings()">
      <sui-modal v-model="openSettingsModal" size="tiny">
        <sui-modal-header>Settings</sui-modal-header>
        <sui-modal-content>
          <sui-modal-description>
            <sui-form-fields>
              <sui-form-field>
                <label>Office hours start</label>
                <vue-timepicker
                  :minute-interval="5"
                  v-model="officeHourStart"
                ></vue-timepicker>
              </sui-form-field>
              <sui-form-field>
                <label>Office hours end</label>
                <vue-timepicker
                  :minute-interval="5"
                  v-model="officeHourEnd"
                ></vue-timepicker>
              </sui-form-field>
            </sui-form-fields>
            <span class="gray">{{ $t("office_hours_description") }}</span>
          </sui-modal-description>
        </sui-modal-content>
        <sui-modal-actions>
          <sui-button type="button" @click.native="showSettingsModal(false)"
            >Cancel</sui-button
          >
          <sui-button
            primary
            type="submit"
            :loading="loader.saveSettings"
            content="Save"
          ></sui-button>
        </sui-modal-actions>
      </sui-modal>
    </sui-form>
  </div>
</template>

<script>
import Filters from "./Filters.vue";
import LoginService from "../services/login";
import StorageService from "../services/storage";
import VueTimepicker from "vue2-timepicker";
import "vue2-timepicker/dist/VueTimepicker.css";
import SettingsService from "../services/settings";

export default {
  name: "TopBar",
  components: {
    Filters: Filters,
    VueTimepicker,
  },
  mixins: [LoginService, StorageService, SettingsService],
  data() {
    return {
      showFilters: true,
      title: this.$i18n.t(this.$route.meta.name) || "", //// i18n
      openSettingsModal: false,
      officeHourStart: "",
      officeHourEnd: "",
      isAdmin: false,
      loader: {
        saveSettings: false,
      },
    };
  },
  mounted() {
    this.retrieveShowFilter();

    if (this.get("loggedUser") && this.get("loggedUser").username == "admin") {
      this.isAdmin = true;
    } else {
      this.isAdmin = false;
    }

    if (this.isAdmin) {
      this.getAdminSettings();
    }

    // event "logout" is triggered by $http interceptor if token has expired
    this.$root.$on("logout", () => {
      this.doLogout();
    });
  },
  watch: {
    $route: function () {
      if (this.$route.meta.view == "default") {
        this.title = this.$i18n.t(this.$route.meta.name);
      } else {
        this.title =
          (this.$route.meta.section
            ? this.$i18n.t("menu." + this.$route.meta.section) + ": "
            : "") + this.$i18n.t(this.$route.meta.name);
      }
    },
  },
  methods: {
    retrieveShowFilter() {
      const showFilters = this.get("showFilters");

      if (showFilters != null) {
        this.showFilters = showFilters;
      } else {
        this.showFilters = true;
      }
      this.$forceUpdate();
    },
    toggleFilters: function () {
      this.showFilters = !this.showFilters;
      this.set("showFilters", this.showFilters);
    },
    doLogout() {
      this.execLogout(
        () => {
          // remove from localstorage
          this.delete("loggedUser");

          // change route
          this.$parent.didLogout();
        },
        (error) => {
          // print error
          console.error(error.body);
        }
      );
    },
    showSettingsModal(value) {
      this.openSettingsModal = value;
    },
    saveAdminSettings() {
      this.loader.saveSettings = true;
      this.updateSettings(
        {
          start_hour: this.officeHourStart,
          end_hour: this.officeHourEnd,
        },
        () => {
          this.loader.saveSettings = false;
          this.showSettingsModal(false);
          this.getAdminSettings();
        },
        (error) => {
          this.loader.saveSettings = false;
          console.error(error.body);
        }
      );
    },
    getAdminSettings() {
      this.getSettings(
        (success) => {
          const settings = success.body.settings;
          this.officeHourStart = settings.start_hour;
          this.officeHourEnd = settings.end_hour;
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
  },
  computed: {
    toggleFiltersPopup: function () {
      return this.showFilters
        ? this.$i18n.t("menu.hide_filters")
        : this.$i18n.t("menu.show_filters");
    },
  },
};
</script>

<style lang="scss">
.masthead {
  padding: 14px 0px 15px 0px !important;
  min-height: 65px;
  margin-bottom: 0 !important;
  border-bottom: 1px solid rgba(34, 36, 38, 0.15);
  box-shadow: 0 1px 2px 0 rgba(34, 36, 38, 0.15);

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

.view-title {
  text-align: left;
}

.component-head-menu {
  margin: 3rem 0rem 0rem !important;
}
</style>
