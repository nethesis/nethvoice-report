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
      <sui-modal v-model="openSettingsModal">
        <sui-modal-header>{{ $t("menu.settings") }}</sui-modal-header>
        <sui-modal-content scrolling>
          <sui-modal-description>
            <sui-header>{{ $t('settings.general') }}</sui-header>
            <!-- office hours -->
            <sui-form-fields>
              <sui-form-field
                :error="errors.admin && this._.isEmpty(adminSettings.officeHourStart)"
              >
                <label>{{ $t("settings.office_hours_start") }}</label>
                <vue-timepicker
                  hide-clear-button
                  :minute-interval="5"
                  v-model="adminSettings.officeHourStart"
                ></vue-timepicker>
              </sui-form-field>
              <sui-form-field
                :error="errors.admin && this._.isEmpty(adminSettings.officeHourEnd)"
              >
                <label>{{ $t("settings.office_hours_end") }}</label>
                <vue-timepicker
                  hide-clear-button
                  :minute-interval="5"
                  v-model="adminSettings.officeHourEnd"
                ></vue-timepicker>
              </sui-form-field>
            </sui-form-fields>
            <sui-message error :visible="errors.admin">
              <p>{{ $t("message.error_admin_empty") }}</p>
            </sui-message>
            <div class="settings-description">{{
              $t("message.office_hours_description")
            }}</div>
            <!-- query limit -->
            <sui-form-fields>
              <sui-form-field width="three">
                <label>{{ $t("settings.query_limit") }}</label>
                <sui-input
                  v-model.number="adminSettings.queryLimit"
                  type="number"
                  min="10"
                />
              </sui-form-field>
            </sui-form-fields>
            <div class="settings-description">{{
              $t("message.query_limit_description")
            }}</div>
            <!-- currency -->
            <sui-form-fields>
              <sui-form-field width="three">
                <label>{{ $t("settings.currency") }}</label>
                <sui-input
                  v-model="adminSettings.currency"
                  required
                />
              </sui-form-field>
            </sui-form-fields>
            <div class="settings-description">{{
              $t("message.currency_description")
            }}</div>
            <!-- destinations -->
            <sui-header>{{ $t('settings.destinations') }}</sui-header>
            <div class="settings-description">{{
              $t("message.destinations_description")
            }}</div>
            <sui-card-group :items-per-row="3">
              <sui-card v-for="(destination, index) in adminSettings.destinations" v-bind:key="'destination-' + index" class="destination">
                <sui-card-content>
                  <sui-icon name="map marker alternate" class="right floated" />
                  <sui-card-header>{{ destination }}</sui-card-header>
                </sui-card-content>
                <sui-button basic negative attached="bottom" type="button" @click="showDeleteDestinationModal(destination)">
                  <sui-icon name="trash" /> {{ $t('command.delete') }}
                </sui-button>
              </sui-card>
              <!-- new destination -->
              <sui-card class="destination">
                <sui-card-content>
                  <sui-icon name="map marker alternate" class="right floated" />
                  <sui-input v-model="newDestination" :placeholder="$t('settings.new_destination')" />
                </sui-card-content>
                <sui-button basic positive attached="bottom" type="button" @click="createDestination()">
                  <sui-icon name="plus" /> {{ $t('command.create') }}
                </sui-button>
              </sui-card>
            </sui-card-group>
            <!-- call patterns -->
            <sui-header>{{ $t('settings.call_patterns') }}</sui-header>
            <div class="settings-description">{{
              $t("message.call_patterns_description")
            }}</div>
            <sui-form-fields v-for="(callPattern, index) in adminSettings.callPatterns" v-bind:key="'callPattern' + index">
              <sui-form-field width="three">
                <label>{{ $t("settings.prefix") }}</label>
                <sui-input
                  v-model="callPattern.prefix"
                  required
                />
              </sui-form-field>
              <sui-form-field width="five">
                <label>{{ $t("settings.destination") }}</label>
                <sui-dropdown
                  :placeholder="$t('settings.destination')"
                  search
                  selection
                  v-model="callPattern.destination"
                  :options="destinationOptions"
                />
              </sui-form-field>
              <sui-form-field>
                <label class="transparent">.</label>
                <sui-button basic negative type="button" @click="showDeleteCallPatternModal(callPattern)">
                  <sui-icon name="trash" /> {{ $t('command.delete') }}
                </sui-button>
              </sui-form-field>
            </sui-form-fields>
            <!-- new call pattern -->
            <sui-form-fields>
              <sui-form-field width="three">
                <label>{{ $t("settings.prefix") }}</label>
                <sui-input
                  v-model="newCallPattern.prefix"
                  :placeholder="$t('settings.new_prefix')"
                />
              </sui-form-field>
              <sui-form-field width="five">
                <label>{{ $t("settings.destination") }}</label>
                <sui-dropdown
                  :placeholder="$t('settings.destination')"
                  search
                  selection
                  v-model="newCallPattern.destination"
                  :options="destinationOptions"
                />
              </sui-form-field>
              <sui-form-field>
                <label class="transparent">.</label>
                <sui-button basic positive type="button" @click="createCallPattern()">
                  <sui-icon name="plus" /> {{ $t('command.create') }}
                </sui-button>
              </sui-form-field>
            </sui-form-fields>
            <!-- costs -->
            <sui-header>{{ $t('settings.costs') }}</sui-header>
            <div class="settings-description">{{
              $t("message.costs_description")
            }}</div>
            <sui-form-fields v-for="(cost, index) in adminSettings.costs" v-bind:key="'cost-' + index">
              <sui-form-field width="four">
                <label>{{ $t("settings.trunk") }}</label>
                <sui-dropdown
                  :placeholder="$t('settings.trunk')"
                  search
                  selection
                  v-model="cost.channelId"
                  :options="trunkOptions"
                />
              </sui-form-field>
              <sui-form-field width="four">
                <label>{{ $t("settings.destination") }}</label>
                <sui-dropdown
                  :placeholder="$t('settings.destination')"
                  search
                  selection
                  v-model="cost.destination"
                  :options="destinationOptions"
                />
              </sui-form-field>
              <sui-form-field width="three">
                <label>{{ $t("settings.cost") }}</label>
                <input
                  type="number"
                  v-model.number="cost.cost"
                  min="0"
                  step=".01"
                  :placeholder="adminSettings.currency + ' ' + $t('misc.per_second')"
                >
              </sui-form-field>
              <sui-form-field width="three">
                <label class="transparent">.</label>
                <sui-button basic negative type="button" @click="showDeleteCostModal(cost)">
                  <sui-icon name="trash" /> {{ $t('command.delete') }}
                </sui-button>
              </sui-form-field>
            </sui-form-fields>
            <!-- new cost detail -->
            <sui-form-fields>
              <sui-form-field width="four">
                <label>{{ $t("settings.trunk") }}</label>
                <sui-dropdown
                  :placeholder="$t('settings.trunk')"
                  search
                  selection
                  v-model="newCost.channelId"
                  :options="trunkOptions"
                  direction="upward"
                />
              </sui-form-field>
              <sui-form-field width="four">
                <label>{{ $t("settings.destination") }}</label>
                <sui-dropdown
                  :placeholder="$t('settings.destination')"
                  search
                  selection
                  v-model="newCost.destination"
                  :options="destinationOptions"
                  direction="upward"
                />
              </sui-form-field>
              <sui-form-field width="three">
                <label>{{ $t("settings.cost") }}</label>
                <input
                  type="number"
                  v-model.number="newCost.cost"
                  min="0"
                  step=".01"
                  :placeholder="adminSettings.currency + ' ' + $t('misc.per_second')"
                >
              </sui-form-field>
              <sui-form-field width="three">
                <label class="transparent">.</label>
                <sui-button basic positive type="button" @click="createCost()">
                  <sui-icon name="plus" /> {{ $t('command.create') }}
                </sui-button>
              </sui-form-field>
            </sui-form-fields>
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

    <!-- configure costs modal -->
    <sui-form @submit.prevent="configureCosts">
      <sui-modal v-model="openCostsConfigModal" size="tiny">
        <sui-modal-header>{{ $t("message.welcome") }}</sui-modal-header>
        <sui-modal-content>
          <sui-modal-description>
            <sui-header>{{ $t('message.configure_call_costs') }}</sui-header>
            <p>
              {{ $t('message.configure_call_costs_description') }}
            </p>
          </sui-modal-description>
        </sui-modal-content>
        <sui-modal-actions>
          <sui-button type="button" @click.native="skipCostsConfiguration">{{
            $t("command.skip")
          }}</sui-button>
          <sui-button
            primary
            type="submit"
            :content="$t('command.configure')"
          ></sui-button>
        </sui-modal-actions>
      </sui-modal>
    </sui-form>

    <!-- delete destination modal -->
    <sui-form @submit.prevent="deleteDestination()" warning>
      <sui-modal v-model="openDeleteDestinationModal" size="tiny">
        <sui-modal-header>{{ $t('command.delete_destination') }}</sui-modal-header>
        <sui-modal-content>
          <sui-modal-description>
            <sui-message warning>
              <i class="exclamation triangle icon"></i> {{ $t("message.you_are_about_to_delete") }} <b>{{ destinationToDelete }}</b>
            </sui-message>
            <p>{{ $t("message.are_you_sure") }}</p>
          </sui-modal-description>
        </sui-modal-content>
        <sui-modal-actions>
          <sui-button type="button" @click.native="hideDeleteDestinationModal()"
            >{{ $t("command.cancel") }}</sui-button
          >
          <sui-button
            negative
            type="submit"
            :loading="loader.deleteDestination"
            :content="$t('command.delete')"
          ></sui-button>
        </sui-modal-actions>
      </sui-modal>
    </sui-form>

    <!-- delete call pattern modal -->
    <sui-form @submit.prevent="deleteCallPattern()" warning>
      <sui-modal v-model="openDeleteCallPatternModal" size="tiny">
        <sui-modal-header>{{ $t('command.delete_call_pattern') }}</sui-modal-header>
        <sui-modal-content>
          <sui-modal-description>
            <sui-message warning>
              <i class="exclamation triangle icon"></i> {{ $t("message.you_are_about_to_delete") }} <b>{{ callPatternToDelete.prefix }}</b>
            </sui-message>
            <p>{{ $t("message.are_you_sure") }}</p>
          </sui-modal-description>
        </sui-modal-content>
        <sui-modal-actions>
          <sui-button type="button" @click.native="hideDeleteCallPatternModal()"
            >{{ $t("command.cancel") }}</sui-button
          >
          <sui-button
            negative
            type="submit"
            :loading="loader.deleteCallPattern"
            :content="$t('command.delete')"
          ></sui-button>
        </sui-modal-actions>
      </sui-modal>
    </sui-form>

    <!-- delete cost modal -->
    <sui-form @submit.prevent="deleteCost()" warning>
      <sui-modal v-model="openDeleteCostModal" size="tiny">
        <sui-modal-header>{{ $t('command.delete_cost') }}</sui-modal-header>
        <sui-modal-content>
          <sui-modal-description>
            <sui-message warning>
              <i class="exclamation triangle icon"></i> {{ $t("message.you_are_about_to_delete") }} {{ $t('settings.cost') }} <b>{{ costToDelete.channelId }}, {{ costToDelete.destination }}</b>
            </sui-message>
            <p>{{ $t("message.are_you_sure") }}</p>
          </sui-modal-description>
        </sui-modal-content>
        <sui-modal-actions>
          <sui-button type="button" @click.native="hideDeleteCostModal()"
            >{{ $t("command.cancel") }}</sui-button
          >
          <sui-button
            negative
            type="submit"
            :loading="loader.deleteCost"
            :content="$t('command.delete')"
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
import FilterService from "../services/filter";

export default {
  name: "TopBar",
  components: {
    Filters: Filters,
    VueTimepicker,
  },
  mixins: [LoginService, StorageService, SettingsService, FilterService],
  data() {
    return {
      showFilters: true,
      title: this.$i18n.t(this.$route.meta.name) || "",
      openSettingsModal: false,
      adminSettings: {
        officeHourStart: "",
        officeHourEnd: "",
        queryLimit: 0,
        destinations: [],
        callPatterns: [],
        costs: [],
      },
      trunks: [],
      openCostsConfigModal: false,
      isAdmin: false,
      dataAvailable: true,
      newDestination: "",
      openDeleteDestinationModal: false,
      destinationToDelete: "",
      destinationOptions: [],
      newCallPattern: {
        prefix: "",
        destination: null,
      },
      callPatternToDelete: {
        prefix: "",
        destination: null,
      },
      openDeleteCallPatternModal: false,
      trunkOptions: [],
      newCost: {
        channelId: null,
        destination: null,
        cost: "",
      },
      costToDelete: {
        channelId: null,
        destination: null,
        cost: "",
      },
      openDeleteCostModal: false,
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
        deleteDestination: false,
        deleteCallPattern: false,
        deleteCost: false,
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
    this.$root.$on("logout", this.doLogout);

    // event "dataNotAvailable" is triggered by $http interceptor if report tables don't exist yet
    this.$root.$on("dataNotAvailable", this.onDataNotAvailable);

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
    onDataNotAvailable() {
      this.showFilters = false;
      this.dataAvailable = false;
    },
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
      }
      this.openSettingsModal = value;
    },
    saveAdminSettings(closeModal = true) {
      // reset errors
      this.resetErrors();
      if (
        this._.isEmpty(this.adminSettings.officeHourStart) ||
        this._.isEmpty(this.adminSettings.officeHourEnd)
      ) {
        // validate inputs
        this.errors.admin = true;
        return;
      }

      // apply changes

      if (closeModal) {
        this.loader.saveSettings = true;
      }

      this.updateSettings(
        {
          start_hour: this.adminSettings.officeHourStart,
          end_hour: this.adminSettings.officeHourEnd,
          query_limit: this.adminSettings.queryLimit.toString(),
          currency: this.adminSettings.currency,
          destinations: this.adminSettings.destinations,
          call_patterns: this.adminSettings.callPatterns,
          costs: this.mapCostsForBackend(),
        },
        () => {
          this.loader.saveSettings = false;
          this.loader.deleteDestination = false;
          this.loader.deleteCallPattern = false;
          this.loader.deleteCost = false;
          this.hideDeleteDestinationModal();
          this.hideDeleteCallPatternModal();
          this.hideDeleteCostModal();

          if (closeModal) {
            this.showSettingsModal(false);
          }
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
          this.adminSettings.officeHourStart = settings.start_hour;
          this.adminSettings.officeHourEnd = settings.end_hour;
          this.adminSettings.queryLimit = Number(settings.query_limit);
          this.adminSettings.currency = settings.currency;
          this.adminSettings.destinations = settings.destinations;

          // sort call patterns by prefix length
          this.adminSettings.callPatterns = settings.call_patterns.sort((cp1, cp2) => {
            return cp2.prefix.length - cp1.prefix.length;
          });

          // destinationOptions is used for destinations dropdown
          this.destinationOptions = this.adminSettings.destinations.map((d) => {
            return {value: d, text: d}
          });

          // costs
          this.adminSettings.costs = this.mapCostsFromBackend(settings.costs);

          // need to show costs configuration modal?
          const costsConfigured = this.get("costsConfigured");
          if (!costsConfigured && (!this.adminSettings.costs || !this.adminSettings.costs.length)) {
            this.openCostsConfigModal = true;
          }

          this.retrieveTrunks();
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
    configureCosts() {
      this.openCostsConfigModal = false;
      this.showSettingsModal(true);
      this.set("costsConfigured", true);
    },
    skipCostsConfiguration() {
      this.openCostsConfigModal = false;
      this.set("costsConfigured", true);
    },
    createDestination() {
      this.adminSettings.destinations.push(this.newDestination);
      this.saveAdminSettings(false);
      this.newDestination = "";
    },
    createCallPattern() {
      this.adminSettings.callPatterns.push(this.newCallPattern);
      this.saveAdminSettings(false);
      this.newCallPattern = { prefix: "", destination: null };
    },
    showDeleteDestinationModal(destinationToDelete) {
      this.destinationToDelete = destinationToDelete;
      this.openDeleteDestinationModal = true;
    },
    showDeleteCallPatternModal(callPatternToDelete) {
      this.callPatternToDelete = callPatternToDelete;
      this.openDeleteCallPatternModal = true;
    },
    showDeleteCostModal(costToDelete) {
      this.costToDelete = costToDelete;
      this.openDeleteCostModal = true;
    },
    hideDeleteDestinationModal() {
      this.destinationToDelete = "";
      this.openDeleteDestinationModal = false;
    },
    hideDeleteCallPatternModal() {
      this.callPatternToDelete = { prefix: "", destination: null };
      this.openDeleteCallPatternModal = false;
    },
    hideDeleteCostModal() {
      this.costToDelete = { channelId: null, destination: null, cost: "" };
      this.openDeleteCostModal = false;
    },
    deleteDestination() {
      this.loader.deleteDestination = true;
      this.adminSettings.destinations = this.adminSettings.destinations.filter((d) => d !== this.destinationToDelete);
      this.saveAdminSettings(false);
    },
    deleteCallPattern() {
      this.loader.deleteCallPattern = true;
      this.adminSettings.callPatterns = this.adminSettings.callPatterns.filter((cp) => cp.prefix !== this.callPatternToDelete.prefix);
      this.saveAdminSettings(false);
    },
    deleteCost() {
      this.loader.deleteCost = true;
      this.adminSettings.costs = this.adminSettings.costs.filter((c) => !(c.channelId == this.costToDelete.channelId && c.destination == this.costToDelete.destination));
      this.saveAdminSettings(false);
    },
    createCost() {
      this.adminSettings.costs.push(this.newCost);
      this.saveAdminSettings(false);
      this.newCost = { channelId: null, destination: null, cost: "" };
    },
    retrieveTrunks() {
      this.getFilterField(
        "trunks",
        (success) => {
          const trunkStrings = success.body.filter;
          let trunks = [];

          for (const trunkString of trunkStrings) {
            const split = trunkString.split(",");
            trunks.push({ name: split[0], channelId: split[1]});
          }
          this.trunks = trunks;

          // trunkOptions is used for trunks dropdown
          this.trunkOptions = this.trunks.map((t) => {
            return {value: t.channelId, text: t.name}
          });
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
    mapCostsFromBackend(costsBackend) {
      let costs = [];

      for (const c of costsBackend) {
        costs.push({
          channelId: c.channel_id,
          destination: c.destination,
          cost: c.cost,
        });
      }
      return costs;
    },
    mapCostsForBackend() {
        let costsBackend = [];

        for (const c of this.adminSettings.costs) {
          costsBackend.push({
            channel_id: c.channelId,
            destination: c.destination,
            cost: c.cost.toString(),
          });
        }
        return costsBackend;
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

.input-warning {
    background-color: #fffaf3 !important;
    color: #573a08 !important;
    border: none !important;
    -webkit-box-shadow: 0 0 0 1px #c9ba9b inset, 0 0 0 0 transparent !important;
    box-shadow: 0 0 0 1px #c9ba9b inset, 0 0 0 0 transparent !important;
}

.destination {
  min-height: 8rem !important;
}

.destination .header {
  font-size: 1.1em !important;
}

.destination .icon {
  margin: 0;
}

.destination .input {
  width: 85%;
}
</style>
