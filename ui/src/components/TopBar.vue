<template>
  <div class="masthead topbar">
    <sui-container>
      <sui-menu floated="right">
        <sui-dropdown class="item top floating pointing" icon="paint brush no-margin">
          <sui-dropdown-menu class="color-scheme">
            <sui-dropdown-item
              v-for="(colorScheme, index) in colorSchemes"
              v-bind:key="index"
              @click="setColorScheme(colorScheme)"
            >
              <span
                v-for="n in 8"
                v-bind:key="n"
                class="color-sample"
                :style="{ backgroundColor: colors[colorScheme][n - 1] }"
              ></span>
              <sui-icon v-if="colorScheme == $root.colorScheme" name="check" />
            </sui-dropdown-item>
          </sui-dropdown-menu>
        </sui-dropdown>
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
          v-bind:content="
            showFilters ? $t('menu.hide_filters') : $t('menu.show_filters')
          "
        >
          <a
            slot="trigger"
            is="sui-menu-item"
            v-on:click="toggleFilters()"
            class="filter-button"
            :active="showFilters"
            :disabled="!dataAvailable"
            :content="$t('menu.filters')"
            icon="filter"
          />
        </sui-popup>
      </sui-menu>
      <h1 is="sui-header" class="view-title">
        {{ title }}
      </h1>
    </sui-container>
    <Filters :showFiltersForm="showFilters" />

    <!-- settings modal -->
    <sui-form @submit.prevent="saveAdminSettings()">
      <sui-modal v-model="openSettingsModal" size="tiny">
        <sui-modal-header>{{ $t("menu.settings") }}</sui-modal-header>
        <sui-modal-content>
          <sui-modal-description>
            <sui-form-fields>
              <sui-form-field
                :error="errors.admin && this._.isEmpty(officeHourStart)"
              >
                <label>{{ $t("misc.office_hours_start") }}</label>
                <vue-timepicker
                  hide-clear-button
                  :minute-interval="5"
                  v-model="officeHourStart"
                ></vue-timepicker>
              </sui-form-field>
              <sui-form-field
                :error="errors.admin && this._.isEmpty(officeHourEnd)"
              >
                <label>{{ $t("misc.office_hours_end") }}</label>
                <vue-timepicker
                  hide-clear-button
                  :minute-interval="5"
                  v-model="officeHourEnd"
                ></vue-timepicker>
              </sui-form-field>
            </sui-form-fields>
            <sui-message error :visible="errors.admin">
              <p>{{ $t("message.error_admin_empty") }}</p>
            </sui-message>
            <span class="gray">{{
              $t("message.office_hours_description")
            }}</span>
          </sui-modal-description>
        </sui-modal-content>
        <sui-modal-actions>
          <sui-button type="button" @click.native="showSettingsModal(false)">{{
            $t("command.cancel")
          }}</sui-button>
          <sui-button
            primary
            type="submit"
            :loading="loader.saveSettings"
            :content="$t('command.save')"
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
      title: this.$i18n.t(this.$route.meta.name) || "",
      openSettingsModal: false,
      officeHourStart: "",
      officeHourEnd: "",
      isAdmin: false,
      dataAvailable: true,
      colorSchemes: [
        "tableau.Classic10",
        "brewer.DarkTwo8",
        "brewer.SetOne8",
        "tableau.MillerStone11",
        "brewer.Accent8",
        "tableau.GreenOrangeTeal12",
        "brewer.RdYlGn8",
        "brewer.PiYG8",
        "brewer.PRGn8",
        "tableau.PurplePinkGray12",
      ],
      colors: {
        "tableau.Classic10": [
          "#1f77b4",
          "#ff7f0e",
          "#2ca02c",
          "#d62728",
          "#9467bd",
          "#8c564b",
          "#e377c2",
          "#7f7f7f",
          "#bcbd22",
          "#17becf",
        ],
        "brewer.DarkTwo8": [
          "#1b9e77",
          "#d95f02",
          "#7570b3",
          "#e7298a",
          "#66a61e",
          "#e6ab02",
          "#a6761d",
          "#666666",
        ],
        "brewer.SetOne8": [
          "#e41a1c",
          "#377eb8",
          "#4daf4a",
          "#984ea3",
          "#ff7f00",
          "#ffff33",
          "#a65628",
          "#f781bf",
        ],
        "tableau.MillerStone11": [
          "#4f6980",
          "#849db1",
          "#a2ceaa",
          "#638b66",
          "#bfbb60",
          "#f47942",
          "#fbb04e",
          "#b66353",
          "#d7ce9f",
          "#b9aa97",
          "#7e756d",
        ],
        "brewer.Accent8": [
          "#7fc97f",
          "#beaed4",
          "#fdc086",
          "#ffff99",
          "#386cb0",
          "#f0027f",
          "#bf5b17",
          "#666666",
        ],
        "tableau.GreenOrangeTeal12": [
          "#4e9f50",
          "#87d180",
          "#ef8a0c",
          "#fcc66d",
          "#3ca8bc",
          "#98d9e4",
          "#94a323",
          "#c3ce3d",
          "#a08400",
          "#f7d42a",
          "#26897e",
          "#8dbfa8",
        ],
        "brewer.RdYlGn8": [
          "#d73027",
          "#f46d43",
          "#fdae61",
          "#fee08b",
          "#d9ef8b",
          "#a6d96a",
          "#66bd63",
          "#1a9850",
        ],
        "brewer.PiYG8": [
          "#c51b7d",
          "#de77ae",
          "#f1b6da",
          "#fde0ef",
          "#e6f5d0",
          "#b8e186",
          "#7fbc41",
          "#4d9221",
        ],
        "brewer.PRGn8": [
          "#762a83",
          "#9970ab",
          "#c2a5cf",
          "#e7d4e8",
          "#d9f0d3",
          "#a6dba0",
          "#5aae61",
          "#1b7837",
        ],
        "tableau.PurplePinkGray12": [
          "#8074a8",
          "#c6c1f0",
          "#c46487",
          "#ffbed1",
          "#9c9290",
          "#c5bfbe",
          "#9b93c9",
          "#ddb5d5",
          "#7c7270",
          "#f498b6",
          "#b173a0",
          "#c799bc",
        ],
      },
      loader: {
        saveSettings: false,
      },
      errors: {
        admin: false,
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

    // event "dataNotAvailable" is triggered by $http interceptor if report tables don't exist yet
    this.$root.$on("dataNotAvailable", () => {
      this.showFilters = false;
      this.dataAvailable = false;
    });

    this.retrieveColorScheme();
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
      if (this.dataAvailable) {
        this.showFilters = !this.showFilters;
        this.set("showFilters", this.showFilters);
        this.$root.$emit("toggleFilters");
      }
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
    resetErrors() {
      this.errors.admin = false;
    },
    showSettingsModal(value) {
      if (value) {
        // on show modal
        this.resetErrors();
        this.getAdminSettings();
      }
      this.openSettingsModal = value;
    },
    saveAdminSettings() {
      // reset errors
      this.resetErrors();
      if (
        this._.isEmpty(this.officeHourStart) ||
        this._.isEmpty(this.officeHourEnd)
      ) {
        // validate inputs
        this.errors.admin = true;
        return;
      }
      // apply changes
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
    retrieveColorScheme() {
      let colorScheme = this.get("reportColorScheme");

      if (colorScheme) {
        this.$root.colorScheme = colorScheme;
      } else {
        this.$root.colorScheme = this.colorSchemes[0];

        // save to local storage
        this.set("reportColorScheme", this.$root.colorScheme);
      }
    },
    setColorScheme(colorScheme) {
      this.$root.colorScheme = colorScheme;

      // save to local storage
      this.set("reportColorScheme", this.$root.colorScheme);
    },
  },
};
</script>

<style lang="scss">

.topbar .top.floating.dropdown .menu {
  left: -60px !important;
  margin-top: 12px !important;
}

.filter-button {
  width: calc(100% + 1px);
  
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

.ui.menu .dropdown.item .menu.color-scheme {
  min-width: 12rem;
}

.color-sample {
  display: inline-block;
  width: 1rem;
  height: 1rem;
}

.ui.menu:not(.vertical) .right.item, .ui.menu:not(.vertical) .right.menu {
  border-right: 1px solid rgba(34,36,38,.15);
}

.filters-form .ui.multiple.search.dropdown>.text {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
