<template>
  <div>
    <sui-container v-if="this.showFiltersForm">
      <sui-form class="filters-form" @submit.prevent="applyFilters">
        <sui-form-fields v-if="savedSearches.length" class="mg-bottom-md">
          <sui-form-field width="six">
            <sui-dropdown
              :placeholder="$t('filter.saved_search')"
              search
              selection
              v-model="selectedSearch"
              :options="savedSearches"
            />
          </sui-form-field>
          <sui-form-field width="four">
            <sui-button
              type="button"
              negative
              :disabled="!selectedSearch"
              @click.native="showDeleteSearchModal(true)"
              icon="trash"
              >{{$t('filter.delete_search')}}</sui-button
            >
          </sui-form-field>
        </sui-form-fields>

        <sui-form-fields>
          <sui-form-field v-if="showFilterTimeGroup" width="four">
            <label>{{$t('filter.group_by')}}</label>
            <sui-dropdown
              :options="groupByTimeValues"
              :placeholder="$t('filter.group_by')"
              search
              selection
              v-model="filter.time.group"
            />
          </sui-form-field>
          <!-- if time group is day -->
          <sui-form-field v-if="(showFilterTime && filter.time.group == 'day') || (showFilterTime && !showFilterTimeGroup)" width="six">
            <label>{{$t('filter.time_interval')}}</label>
            <sui-button-group class="fluid">
              <sui-button
                :active="filter.time.range == 'yesterday'"
                @click="selectTime('yesterday')"
                type="button"
                >{{$t('filter.yesterday')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_week'"
                @click="selectTime('last_week')"
                type="button"
                >{{$t('filter.last_week')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_month'"
                @click="selectTime('last_month')"
                type="button"
                >{{$t('filter.last_month')}}</sui-button
              >
            </sui-button-group>
          </sui-form-field>
          <!-- if time group is week -->
          <sui-form-field v-if="showFilterTime && filter.time.group == 'week' && showFilterTimeGroup" width="seven">
            <label>{{$t('filter.time_interval')}}</label>
            <sui-button-group class="fluid">
              <sui-button
                :active="filter.time.range == 'last_week'"
                @click="selectTime('last_week')"
                type="button"
                >{{$t('filter.last_week')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_two_weeks'"
                @click="selectTime('last_two_weeks')"
                type="button"
                >{{$t('filter.last_two_weeks')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_month'"
                @click="selectTime('last_month')"
                type="button"
                >{{$t('filter.last_month')}}</sui-button
              >
            </sui-button-group>
          </sui-form-field>
          <!-- if time group is month -->
          <sui-form-field v-if="showFilterTime && filter.time.group == 'month' && showFilterTimeGroup" width="six">
            <label>{{$t('filter.time_interval')}}</label>
            <sui-button-group class="fluid">
              <sui-button
                :active="filter.time.range == 'last_month'"
                @click="selectTime('last_month')"
                type="button"
                >{{$t('filter.last_month')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_two_months'"
                @click="selectTime('last_two_months')"
                type="button"
                >{{$t('filter.last_two_months')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_six_months'"
                @click="selectTime('last_six_months')"
                type="button"
                >{{$t('filter.last_six_months')}}</sui-button
              >
            </sui-button-group>
          </sui-form-field>
          <!-- if time group is year -->
          <sui-form-field v-if="showFilterTime && filter.time.group == 'year' && showFilterTimeGroup" width="six">
            <label>{{$t('filter.time_interval')}}</label>
            <sui-button-group class="fluid">
              <sui-button
                :active="filter.time.range == 'last_year'"
                @click="selectTime('last_year')"
                type="button"
                >{{$t('filter.last_year')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_two_years'"
                @click="selectTime('last_two_years')"
                type="button"
                >{{$t('filter.last_two_years')}}</sui-button
              >
              <sui-button
                :active="filter.time.range == 'last_three_years'"
                @click="selectTime('last_three_years')"
                type="button"
                >{{$t('filter.last_three_years')}}</sui-button
              >
            </sui-button-group>
          </sui-form-field>
          <sui-form-field width="four">
            <label>{{$t('filter.dates_label')}}</label>
            <v-date-picker
              mode="range"
              v-model="filter.time.interval"
              :input-props='{ placeholder: $t("filter.dates_placeholder") }'
              :available-dates="{ start: null, end: new Date() }"
              :masks="{ input: 'YYYY/MM/DD' }"
            />
          </sui-form-field>
        </sui-form-fields>

        <sui-grid>
          <sui-form-field v-if="showFilterQueue" width="four">
            <label>{{$t('filter.queues_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.queues"
              :placeholder="$t('filter.queues_label')"
              search
              selection
              v-model="filter.queues"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterGroup" width="four">
            <label>{{$t('filter.groups_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.groups"
              :placeholder="$t('filter.groups_label')"
              search
              selection
              v-model="filter.groups"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterAgent" width="four">
            <label>{{$t('filter.agents_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.agents"
              :placeholder="$t('filter.agents_label')"
              search
              selection
              v-model="filter.agents"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterReason" width="four">
            <label>{{$t('filter.reasons_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.reasons"
              :placeholder="$t('filter.reasons_label')"
              search
              selection
              v-model="filter.reasons"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterResult" width="four">
            <label>{{$t('filter.results_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.results"
              :placeholder="$t('filter.results_label')"
              search
              selection
              v-model="filter.results"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterIvr" width="four">
            <label>{{$t('filter.ivrs_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.ivrs"
              :placeholder="$t('filter.ivrs_label')"
              search
              selection
              v-model="filter.ivrs"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterChoice" width="four">
            <label>{{$t('filter.choices_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.choices"
              :placeholder="$t('filter.choices_label')"
              search
              selection
              v-model="filter.choices"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterOrigin" width="six">
            <label>{{$t('filter.origins_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.origins"
              :placeholder="$t('filter.origins_placeholder')"
              search
              selection
              v-model="filter.origins"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterDestination" width="six">
            <label>{{$t('filter.destinations_label')}}</label>
            <sui-dropdown
              multiple
              :options="filterValues.destinations"
              :placeholder="$t('filter.destinations_label')"
              search
              selection
              v-model="filter.destinations"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterTimeSplit" width="four">
            <label>{{$t('filter.time_split_label')}}</label>
            <sui-dropdown
              :options="splitByTimeValues"
              :placeholder="$t('filter.time_split_label')"
              search
              selection
              v-model="filter.time.division"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterCaller" width="four">
            <label>{{$t('filter.caller_label')}}</label>
            <sui-input
              :placeholder="$t('filter.caller_label')"
              v-model="filter.caller"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterContactName" width="six">
            <label>{{$t('filter.contact_name_label')}}</label>
            <sui-search
              :searchFields="['title', 'cleanName']"
              :source="phoneBook"
              ref="filterContactName"
              :placeholder="$t('filter.contact_name_label')"
              :fullTextSearch="'exact'"
              :maxResults="20"
              class="searchContactName"
              @input="contactNameInput"
              :value="filter.contactName"
            />
          </sui-form-field>
          <sui-form-field v-if="showFilterNullCall" width="four">
            <label>{{$t('filter.null_call_label')}}</label>
            <sui-checkbox label toggle v-model="filter.nullCall" />
          </sui-form-field>
        </sui-grid>
        <sui-form-fields class="mg-top-md">
          <sui-button
            primary
            type="submit"
            icon="search"
            :disabled="loader.filter"
            class="mr-15"
            >Search</sui-button
          >
          <sui-button-group>
            <sui-button
              type="button"
              @click.native="showSaveSearchModal(true)"
              icon="save"
              >Save search</sui-button
            >
            <sui-button
              type="button"
              :disabled="!selectedSearch"
              @click.native="showOverwriteSearchModal(true)"
              icon="edit"
              >Overwrite search</sui-button
            >
          </sui-button-group>
        </sui-form-fields>
      </sui-form>

      <!-- save search modal -->
      <sui-form @submit.prevent="validateSaveNewSearch()" :error="errorNewSearch">
        <sui-modal v-model="openSaveSearchModal" size="tiny">
          <sui-modal-header>Save search</sui-modal-header>
          <sui-modal-content>
            <sui-modal-description>
              <p>Enter a name for your new saved search</p>
              <sui-form-field>
                <input placeholder="Search name" v-model="newSearchName" />
              </sui-form-field>
              <sui-message error v-show="errorNewSearch">
                <p>{{ errorMessage }}</p>
              </sui-message>
            </sui-modal-description>
          </sui-modal-content>
          <sui-modal-actions>
            <sui-button type="button" @click.native="showSaveSearchModal(false)"
              >Cancel</sui-button
            >
            <sui-button
              type="submit"
              primary
              :loading="loader.saveSearch"
              content="Save"
            ></sui-button>
          </sui-modal-actions>
        </sui-modal>
      </sui-form>

      <!-- overwrite search modal -->
      <sui-form @submit.prevent="saveSearch(selectedSearch)" warning>
        <sui-modal v-model="openOverwriteSearchModal" size="tiny">
          <sui-modal-header>Overwrite search</sui-modal-header>
          <sui-modal-content>
            <sui-modal-description>
              <sui-message warning>
                <i class="exclamation triangle icon"></i>You are about to
                overwrite "{{ selectedSearch }}" search
              </sui-message>
              <p>Are you sure?</p>
            </sui-modal-description>
          </sui-modal-content>
          <sui-modal-actions>
            <sui-button
              type="button"
              @click.native="showOverwriteSearchModal(false)"
              >Cancel</sui-button
            >
            <sui-button type="submit" negative>Overwrite</sui-button>
          </sui-modal-actions>
        </sui-modal>
      </sui-form>

      <!-- delete search modal -->
      <sui-form @submit.prevent="deleteSelectedSearch()" warning>
        <sui-modal v-model="openDeleteSearchModal" size="tiny">
          <sui-modal-header>Delete search</sui-modal-header>
          <sui-modal-content>
            <sui-modal-description>
              <sui-message warning>
                <i class="exclamation triangle icon"></i>You are about to delete
                "{{ selectedSearch }}" search
              </sui-message>
              <p>Are you sure?</p>
            </sui-modal-description>
          </sui-modal-content>
          <sui-modal-actions>
            <sui-button type="button" @click.native="showDeleteSearchModal(false)"
              >Cancel</sui-button
            >
            <sui-button
              negative
              type="submit"
              :loading="loader.deleteSearch"
              content="Delete"
            ></sui-button>
          </sui-modal-actions>
        </sui-modal>
      </sui-form>
    </sui-container>
    <FixedBar
      :filter="filter"
      :selectedSearch="selectedSearch"
      :showFilterTimeGroup="showFilterTimeGroup"
      :showFilterTime="showFilterTime"
      :showFilterQueue="showFilterQueue"
      :showFilterGroup="showFilterGroup"
      :showFilterAgent="showFilterAgent"
      :showFilterReason="showFilterReason"
      :showFilterResult="showFilterResult"
      :showFilterIvr="showFilterIvr"
      :showFilterChoice="showFilterChoice"
      :showFilterOrigin="showFilterOrigin"
      :showFilterDestination="showFilterDestination"
      :showFilterTimeSplit="showFilterTimeSplit"
      :showFilterCaller="showFilterCaller"
      :showFilterContactName="showFilterContactName"
      :showFilterNullCall="showFilterNullCall"
    />
  </div>
</template>

<script>
import LoginService from "../services/login";
import StorageService from "../services/storage";
import SearchesService from "../services/searches";
import UtilService from "../services/utils";
import SearchService from "../services/searches";
import PhonebookService from "../services/phonebook";
import FixedBar from "../components/FixedBar.vue";

import moment from "moment";

export default {
  name: "Filters",
  components: {
    FixedBar: FixedBar
  },
  mixins: [
    LoginService,
    StorageService,
    SearchesService,
    UtilService,
    SearchService,
    PhonebookService,
  ],
  props: ["showFiltersForm"],
  data() {
    return {
      selectedSearch: null,
      filter: {
        queues: [],
        groups: [],
        agents: [],
        ivrs: [],
        reasons: [],
        results: [],
        choices: [],
        destinations: [],
        origins: [],
        time: {
          group: "",
          division: "",
          range: null,
          interval: {
            start: null,
            end: null,
          },
        },
        caller: "",
        contactName: "",
        nullCall: false, ////
      },
      filterValues: {
        queues: [],
        groups: [],
        agents: [],
        ivrs: [],
        reasons: [],
        results: [],
        choices: [],
        allChoices: [],
        destinations: [],
        origins: [],
        callers: [],
        contactNames: [],
      },
      savedSearches: [],
      openSaveSearchModal: false,
      openOverwriteSearchModal: false,
      openDeleteSearchModal: false,
      newSearchName: "",
      errorNewSearch: false,
      errorMessage: "",
      loader: {
        filter: true,
        saveSearch: false,
        deleteSearch: false,
      },
      groupByTimeValues: [
        { value: "day", text: this.$i18n.t('filter.day') },
        { value: "week", text: this.$i18n.t('filter.week') },
        { value: "month", text: this.$i18n.t('filter.month') },
        { value: "year", text: this.$i18n.t('filter.year') },
      ],
      splitByTimeValues: [
        { value: "60", text: "1 hour" },
        { value: "30", text: "30 minutes" },
        { value: "15", text: "15 minutes" },
        { value: "10", text: "10 minutes" },
      ],
      phoneBook: [],
      queueReportViewFilterMap: null
    };
  },
  watch: {
    $route: function () {
      if (this.savedSearches) {
        this.mapSavedSearches(this.savedSearches);
      }
    },
    selectedSearch: function () {
      this.setFilterValuesFromSearch();
    },
    "filter.ivrs": function () {
      this.updateIvrChoices();
    },
    "filter.time.interval": function () {
      if (
        this.filter.time.interval &&
        this.filter.time.interval.start &&
        this.filter.time.interval.end
      ) {
        this.filter.time.range = "";

        // convert to date object if needed
        if (typeof this.filter.time.interval.start == "string") {
          this.filter.time.interval.start = new Date(
            this.filter.time.interval.start
          );
        }

        if (typeof this.filter.time.interval.end == "string") {
          this.filter.time.interval.end = new Date(
            this.filter.time.interval.end
          );
        }
        if (this.filter.time.interval.end.getTime() == this.getToday().getTime()) {
          // check time range starting from dates
          switch (this.filter.time.interval.start.getTime()) {
            case this.getYesterday().getTime():
              this.filter.time.range = "yesterday";
              break;
            case this.getLastWeek().getTime():
              this.filter.time.range = "last_week";
              break;
            case this.getLastTwoWeeks().getTime():
              this.filter.time.range = "last_two_weeks";
              break;
            case this.getLastMonth().getTime():
              this.filter.time.range = "last_month";
              break;
            case this.getLastTwoMonths().getTime():
              this.filter.time.range = "last_two_months";
              break;
            case this.getLastSixMonths().getTime():
              this.filter.time.range = "last_six_months";
              break;
            case this.getLastYear().getTime():
              this.filter.time.range = "last_year";
              break;
            case this.getLastTwoYears().getTime():
              this.filter.time.range = "last_two_years";
              break;
            case this.getLastThreeYears().getTime():
              this.filter.time.range = "last_three_years";
              break;
            default:
              break;
          }
        }
      }
    },
  },
  mounted() {
    this.retrieveFilter();
    this.getSavedSearches();
    this.retrievePhonebook();

    // views request to apply filter on loading
    this.$root.$on("requestApplyFilter", () => {
      if (this.loader.filter == false) {
        this.applyFilters();
      }
    });
    this.$root.$on("clearFilters", () => {
      this.clearFilters()
    });
  },
  methods: {
    retrieveFilter() {
      this.loader.filter = true;
      let filter = this.get(this.reportFilterStorageName);
      let filterValues = this.get(this.reportFilterValuesStorageName);

      if (
        filter &&
        filterValues &&
        new Date().getTime() < filterValues.expiry
      ) {
        console.log("reading filter from local storage"); ////

        // get object from local storage item
        filterValues = filterValues.item;

        this.filterValues = filterValues;

        // set selected values in filter
        this.setFilterSelection(filter, true);
      } else {
        console.log("retrieving default filter from backend:"); ////

        this.retrieveDefaultFilter();
      }
    },
    retrieveDefaultFilter() {
      this.getDefaultFilter(
        this.$route.meta.section,
        this.$route.meta.view,
        (success) => {
          this.defaultFilter = success.body.filter;

          // queues
          if (this.defaultFilter.queues) {
            let queues = this.defaultFilter.queues.map((queue) => {
              return { value: queue, text: queue };
            });
            this.filterValues.queues = queues.sort(this.sortByProperty("text"));
          }

          // agents
          if (this.defaultFilter.agents) {
            let agents = this.defaultFilter.agents.map((agent) => {
              return { value: agent, text: agent };
            });
            this.filterValues.agents = agents.sort(this.sortByProperty("text"));
          }

          // groups
          if (this.defaultFilter.groups) {
            let groups = this.defaultFilter.groups.map((group) => {
              return { value: group, text: group };
            });
            this.filterValues.groups = groups.sort(this.sortByProperty("text"));
          }

          // ivr
          if (this.defaultFilter.ivrs) {
            let ivrs = this.defaultFilter.ivrs.map((ivr) => {
              const tokens = ivr.split(",");
              const idIvr = tokens[0];
              const ivrName = tokens[1];
              return { value: ivrName, text: ivrName, id: idIvr };
            });
            this.filterValues.ivrs = ivrs.sort(this.sortByProperty("text"));
          }

          // choices: hide duplicates
          if (this.defaultFilter.choices) {
            this.filterValues.allChoices = [];
            let choiceSet = new Set();
            this.defaultFilter.choices.forEach((choice) => {
              const tokens = choice.split(",");
              const idIvr = tokens[0];
              const choiceName = tokens[1];
              this.filterValues.allChoices.push({
                value: choiceName,
                text: choiceName,
                idIvr: idIvr,
              });
              choiceSet.add(choiceName);
            });

            let choices = [];
            choiceSet.forEach((choice) => {
              choices.push({ value: choice, text: choice });
            });

            this.filterValues.choices = choices.sort(
              this.sortByProperty("text")
            );
          }

          // reasons
          if (this.defaultFilter.reasons) {
            let reasons = this.defaultFilter.reasons.map((reason) => {
              return { value: reason, text: reason };
            });
            this.filterValues.reasons = reasons.sort(
              this.sortByProperty("text")
            );
          }

          // results
          if (this.defaultFilter.results) {
            let results = this.defaultFilter.results.map((result) => {
              return { value: result, text: result };
            });
            this.filterValues.results = results.sort(
              this.sortByProperty("text")
            );
          }

          // origins
          if (this.defaultFilter.origins) {
            let areaCodeSet = new Set();
            let districtSet = new Set();
            let provinceSet = new Set();
            let regionSet = new Set();

            this.defaultFilter.origins.forEach((origin) => {
              const tokens = origin.split(",");
              areaCodeSet.add(tokens[0]);
              districtSet.add(tokens[1]);
              provinceSet.add(tokens[2]);
              regionSet.add(tokens[3]);
            });

            let areaCodes = [];
            areaCodeSet.forEach((areaCode) => {
              areaCodes.push({
                value: "areaCode_" + areaCode,
                text: areaCode + " (Area code)",
              }); //// i18n
            });

            let districts = [];
            districtSet.forEach((district) => {
              districts.push({
                value: "district_" + district,
                text: district + " (District)",
              }); //// i18n
            });

            let provinces = [];
            provinceSet.forEach((province) => {
              provinces.push({
                value: "province_" + province,
                text: province + " (Province)",
              }); //// i18n
            });

            let regions = [];
            regionSet.forEach((region) => {
              regions.push({
                value: "region_" + region,
                text: region + " (Region)",
              }); //// i18n
            });

            this.filterValues.origins = areaCodes
              .concat(districts)
              .concat(provinces)
              .concat(regions)
              .sort(this.sortByProperty("text"));
          }

          // destinations
          if (this.defaultFilter.destinations) {
            let destinations = this.defaultFilter.destinations.map(
              (destination) => {
                return { value: destination, text: destination };
              }
            );
            this.filterValues.destinations = destinations.sort(
              this.sortByProperty("text")
            );
          }

          // save filter values to local storage (with expiry)
          this.saveToLocalStorageWithExpiry(
            this.reportFilterValuesStorageName,
            this.filterValues,
            10
          ); //// TODO use 8 * 60 (i.e. 8 hours)

          // set selected values in filter
          this.setFilterSelection(this.defaultFilter, false);
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
    setFilterSelection(filter, fromLocalStorage) {
      if (fromLocalStorage) {
        this.filter.queues = filter.queues;
        this.filter.groups = filter.groups;
        this.filter.agents = filter.agents;
        this.filter.reasons = filter.reasons;
        this.filter.results = filter.results;
        this.filter.ivrs = filter.ivrs;
        this.filter.choices = filter.choices;
        this.filter.origins = filter.origins;
        this.filter.destinations = filter.destinations;
        this.filter.caller = filter.caller;
        this.filter.nullCall = filter.nullCall;
        this.filter.contactName = filter.contactName;
      }

      // time
      this.filter.time.range = filter.time.range;

      if (this.filter.time.range) {
        this.filter.time.range = filter.time.range;
        this.filter.time.interval = this.selectTime(this.filter.time.range);
      } else {
        this.filter.time.interval = filter.time.interval;
      }
      this.filter.time.group = filter.time.group;
      this.filter.time.division = filter.time.division;
      this.selectTime(filter.time.range);

      // null call
      this.filter.nullCall = filter.nullCall;

      if (!fromLocalStorage) {
        // save filter to local storage
        this.set(this.reportFilterStorageName, this.filter);
      }

      this.loader.filter = false;
    },
    getSavedSearches(searchToSelect) {
      this.getSearches(
        (success) => {
          const savedSearches = success.body.searches;
          this.mapSavedSearches(savedSearches);

          if (searchToSelect) {
            this.selectedSearch = searchToSelect;
          }
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
    mapSavedSearches(savedSearches) {
      let searchesMatchingView = [];
      let searchesNotMatchingView = [];

      for (const search of savedSearches) {
        search.value = search.name;
        search.text = search.name;

        if (
          search.section == this.$route.meta.section &&
          search.view == this.$route.meta.view
        ) {
          searchesMatchingView.push(search);
        } else {
          searchesNotMatchingView.push(search);
        }
      }
      this.savedSearches = searchesMatchingView.concat(searchesNotMatchingView);
    },
    setFilterValuesFromSearch() {
      // retrieve search object
      let search = this.savedSearches.find(
        (s) => s.name === this.selectedSearch
      );

      // set filter values
      this.filter = JSON.parse(JSON.stringify(search.filter));
    },
    getToday() {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      return today;
    },
    getYesterday() {
      return moment().subtract(1, 'day').startOf('day').toDate();
    },
    getLastWeek() {
      return moment().subtract(1, 'week').startOf('day').toDate();
    },
    getLastTwoWeeks() {
      return moment().subtract(2, 'weeks').startOf('day').toDate();
    },
    getLastMonth() {
      return moment().subtract(1, 'month').startOf('day').toDate();
    },
    getLastTwoMonths() {
      return moment().subtract(2, 'months').startOf('day').toDate();
    },
    getLastSixMonths() {
      return moment().subtract(6, 'months').startOf('day').toDate();
    },
    getLastYear() {
      return moment().subtract(1, 'year').startOf('day').toDate();
    },
    getLastTwoYears() {
      return moment().subtract(2, 'years').startOf('day').toDate();
    },
    getLastThreeYears() {
      return moment().subtract(3, 'years').startOf('day').toDate();
    },
    selectTime(range) {
      this.filter.time.range = range;

      if (range == "yesterday") {
        this.filter.time.interval = {
          start: this.getYesterday(),
          end: this.getToday(),
        };
      } else if (range == "last_week") {
        this.filter.time.interval = {
          start: this.getLastWeek(),
          end: this.getToday(),
        };
      } else if (range == "last_two_weeks") {
        this.filter.time.interval = {
          start: this.getLastTwoWeeks(),
          end: this.getToday(),
        };
      } else if (range == "last_month") {
        this.filter.time.interval = {
          start: this.getLastMonth(),
          end: this.getToday(),
        };
      } else if (range == "last_two_months") {
        this.filter.time.interval = {
          start: this.getLastTwoMonths(),
          end: this.getToday(),
        };
      } else if (range == "last_six_months") {
        this.filter.time.interval = {
          start: this.getLastSixMonths(),
          end: this.getToday(),
        };
      } else if (range == "last_year") {
        this.filter.time.interval = {
          start: this.getLastYear(),
          end: this.getToday(),
        };
      } else if (range == "last_two_years") {
        this.filter.time.interval = {
          start: this.getLastTwoYears(),
          end: this.getToday(),
        };
      } else if (range == "last_three_years") {
        this.filter.time.interval = {
          start: this.getLastThreeYears(),
          end: this.getToday(),
        };
      }
    },
    applyFilters() {
      // save filter to local storage
      this.set(this.reportFilterStorageName, this.filter);

      let filterToApply = JSON.parse(JSON.stringify(this.filter));
      filterToApply.phones = [];

      // retrieve contact name phones
      if (this.filter.contactName) {
        const contact = this.phoneBook.find((c) => {
          return c.title == this.filter.contactName;
        });

        if (contact) {
          let phoneNumbers = [];

          for (const [phoneType, phoneList] of Object.entries(contact.phones)) {
            for (const phoneNumber of phoneList) {
              if (phoneNumber) {
                phoneNumbers.push(phoneType + "_" + phoneNumber);
              }
            }
          }

          if (phoneNumbers.length) {
            filterToApply.phones = phoneNumbers;
          }
        }
      }

      // set group by day if "Group by time" field is hidden

      if (!this.showFilterTimeGroup) {
        filterToApply.time.group = "day";
      }

      // set splity by 1 hour if "Split by time" field is hidden

      if (!this.showFilterTimeSplit) {
        filterToApply.time.division = "60";
      }

      // format time interval

      if (filterToApply.time.interval) {
        let dateFormat = "";

        if (filterToApply.time.group == "year") {
          dateFormat = "YYYY";
        } else if (filterToApply.time.group == "month") {
          dateFormat = "YYYY-MM";
        } else if (filterToApply.time.group == "week") {
          dateFormat = "YYYY-WW";
        } else if (filterToApply.time.group == "day") {
          dateFormat = "YYYY-MM-DD";
        }
        filterToApply.time.interval.start = moment(
          filterToApply.time.interval.start
        ).format(dateFormat);
        filterToApply.time.interval.end = moment(
          filterToApply.time.interval.end
        ).format(dateFormat);
      }

      console.log("filterToApply", filterToApply); ////

      // apply filters
      this.$root.$emit("applyFilters", filterToApply);
    },
    showSaveSearchModal(value) {
      this.newSearchName = "";
      this.errorMessage = "";
      this.errorNewSearch = false;
      this.openSaveSearchModal = value;
    },
    showOverwriteSearchModal(value) {
      this.openOverwriteSearchModal = value;
    },
    validateSaveNewSearch() {
      this.errorNewSearch = false;
      this.errorMessage = "";

      if (!this.newSearchName) {
        this.errorNewSearch = true;
        this.errorMessage = "Search name is required";
        return;
      }

      let exists = this.savedSearches.find(
        (s) => s.name === this.newSearchName
      );

      if (exists) {
        this.errorNewSearch = true;
        this.errorMessage = "A search with the same name already exists";
        return;
      }

      if (!/^[a-zA-Z][a-zA-Z0-9 -,/]+$/.test(this.newSearchName)) {
        this.errorNewSearch = true;
        this.errorMessage =
          "Search name must begin with a letter and contain only letters, spaces, numbers and dashes";
        return;
      }
      this.saveSearch(this.newSearchName);
    },
    computeFilterToSave() {
      let filterToSave = JSON.parse(JSON.stringify(this.filter));

      // remove hidden filters

      if (!this.showFilterQueue) {
        filterToSave.queues = [];
      }

      if (!this.showFilterGroup) {
        filterToSave.groups = [];
      }

      if (!this.showFilterAgent) {
        filterToSave.agents = [];
      }

      if (!this.showFilterIvr) {
        filterToSave.ivrs = [];
      }

      if (!this.showFilterReason) {
        filterToSave.reasons = [];
      }

      if (!this.showFilterResult) {
        filterToSave.results = [];
      }

      if (!this.showFilterChoice) {
        filterToSave.choices = [];
      }

      if (!this.showFilterDestination) {
        filterToSave.destinations = [];
      }

      if (!this.showFilterOrigin) {
        filterToSave.origins = [];
      }

      if (!this.showFilterTimeGroup) {
        filterToSave.time.group = "";
      }

      if (!this.showFilterTimeSplit) {
        filterToSave.time.division = "";
      }

      if (!this.showFilterCaller) {
        filterToSave.caller = "";
      }

      if (!this.showFilterNullCall) {
        filterToSave.contactName = "";
      }

      // convert time interval to string
      if (this.filter.time.interval) {
        filterToSave.time.interval.start = this.$options.filters.formatDate(
          this.filter.time.interval.start
        );
        filterToSave.time.interval.end = this.$options.filters.formatDate(
          this.filter.time.interval.end
        );
      }

      return filterToSave;
    },
    saveSearch(searchName) {
      this.loader.saveSearch = true;
      let filterToSave = this.computeFilterToSave();

      this.createSearch(
        {
          name: searchName,
          section: this.$route.meta.section,
          view: this.$route.meta.view,
          filter: filterToSave,
        },
        () => {
          this.loader.saveSearch = false;
          this.showSaveSearchModal(false);
          this.showOverwriteSearchModal(false);
          this.getSavedSearches(searchName);
        },
        (error) => {
          this.loader.saveSearch = false;
          console.error(error.body);
        }
      );
    },
    showDeleteSearchModal(value) {
      this.openDeleteSearchModal = value;
    },
    deleteSelectedSearch() {
      this.loader.deleteSearch = true;
      const searchId =
        this.selectedSearch +
        "_" +
        this.$route.meta.section +
        "_" +
        this.$route.meta.view;

      this.deleteSearch(
        searchId,
        () => {
          this.loader.deleteSearch = false;
          this.showDeleteSearchModal(false);
          this.getSavedSearches();
        },
        (error) => {
          this.loader.deleteSearch = false;
          console.error(error.body);
        }
      );
    },
    updateIvrChoices() {
      if (!this.filter.ivrs) {
        return;
      }

      // show only IVR choices related to selected IVRs
      let selectedIvrs = this.filter.ivrs;

      if (this.filter.ivrs.length == 0) {
        // selecting no IVR is the same as selecting all of them
        selectedIvrs = this.filterValues.ivrs.map((ivr) => {
          return ivr.value;
        });
      }

      let relatedChoiceValues = new Set();

      selectedIvrs.forEach((selectedIvr) => {
        const ivr = this.filterValues.ivrs.find((i) => {
          return i.value == selectedIvr;
        });

        // find related IVR choices
        let relatedChoices = this.filterValues.allChoices.filter((choice) => {
          return choice.idIvr == ivr.id;
        });

        // add to set to avoid duplicates in choices dropdown
        relatedChoices.forEach((choice) => {
          relatedChoiceValues.add(choice.value);
        });
      });

      // create array of objects for choices dropdow
      let choices = Array.from(relatedChoiceValues).map((choiceName) => {
        return { value: choiceName, text: choiceName };
      });
      this.filterValues.choices = choices.sort(this.sortByProperty("text"));
    },
    retrievePhonebook() {
      let phoneBook = this.get("reportPhoneBook");

      if (phoneBook && new Date().getTime() < phoneBook.expiry) {
        console.log("reading phonebook from local storage"); ////

        // get object from local storage item
        phoneBook = phoneBook.item;

        this.phoneBook = phoneBook;
      } else {
        console.log("retrieving phonebook from backend"); ////

        this.getPhonebook(
          (success) => {
            const phoneBook = success.body;
            this.phoneBook = [];

            for (const [contactName, contactPhones] of Object.entries(
              phoneBook
            )) {
              const cleanName = contactName
                .replace(/[^a-zA-Z0-9]/g, "")
                .toLowerCase();
              this.phoneBook.push({
                title: contactName,
                phones: contactPhones,
                cleanName: cleanName,
              });
            }

            // save phonebook to local storage (with expiry)
            this.saveToLocalStorageWithExpiry(
              "reportPhoneBook",
              this.phoneBook,
              10
            ); //// TODO use 8 * 60 (i.e. 8 hours)
          },
          (error) => {
            console.error(error.body);
          }
        );
      }
    },
    contactNameInput(event) {
      if (typeof event == "string") {
        this.filter.contactName = event;
      }
    },
    clearFilters() {
      this.filter.queues = [];
      this.filter.groups = [];
      this.filter.agents = [];
      this.filter.ivrs = [];
      this.filter.reasons = [];
      this.filter.results = [];
      this.filter.choices = [];
      this.filter.destinations = [];
      this.filter.origins = [];
      this.filter.caller = "";
      this.filter.contactName = "";
      this.applyFilters()
    },
  },
  computed: {
    showFilterTime: function () {
      return this.isFilterInView("time");
    },
    showFilterTimeGroup: function () {
      return this.isFilterInView("timeGroup");
    },
    showFilterTimeSplit: function () {
      return this.isFilterInView("timeSplit");
    },
    showFilterAgent: function () {
      return this.isFilterInView("agent");
    },
    showFilterGroup: function () {
      return this.isFilterInView("group");
    },
    showFilterQueue: function () {
      return this.isFilterInView("queue");
    },
    showFilterReason: function () {
      return this.isFilterInView("reason");
    },
    showFilterResult: function () {
      return this.isFilterInView("result");
    },
    showFilterIvr: function () {
      return this.isFilterInView("ivr");
    },
    showFilterChoice: function () {
      return this.isFilterInView("choice");
    },
    showFilterOrigin: function () {
      return this.isFilterInView("origin");
    },
    showFilterDestination: function () {
      return this.isFilterInView("destination");
    },
    showFilterCaller: function () {
      return this.isFilterInView("caller");
    },
    showFilterContactName: function () {
      return this.isFilterInView("contactName");
    },
    showFilterNullCall: function () {
      return this.isFilterInView("nullCall");
    },
    reportFilterStorageName: function () {
      return "reportFilter-" + this.get("loggedUser").username;
    },
    reportFilterValuesStorageName: function () {
      return "reportFilterValues-" + this.get("loggedUser").username;
    },
  },
};
</script>

<style lang="scss" scoped>
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

.searchContactName > .results {
  overflow: auto;
  max-height: 300px;
}

.filters-form .ui.grid {
  margin-top: 1rem;
  margin-bottom: 0;
}
</style>
