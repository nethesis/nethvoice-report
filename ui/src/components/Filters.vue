<template>
  <div>
    <sui-form class="filters-form">
      <sui-form-fields v-if="savedSearches.length">
        <sui-form-field width="six">
          <sui-dropdown
            placeholder="Saved search"
            search
            selection
            v-model="selectedSearch"
            :options="savedSearches"
            @click="hackDropdown"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <sui-button
            negative
            :disabled="!selectedSearch"
            @click.native="showDeleteSearchModal(true)"
            >Delete search</sui-button
          >
        </sui-form-field>
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field width="six">
          <label>Time interval</label>
          <sui-button-group class="fluid">
            <sui-button
              :active="selectedTimeType == 'yesterday'"
              @click="selectTime('yesterday')"
              type="button"
              >Yesterday</sui-button
            >
            <sui-button
              :active="selectedTimeType == 'lastWeek'"
              @click="selectTime('lastWeek')"
              type="button"
              >Last week</sui-button
            >
            <sui-button
              :active="selectedTimeType == 'lastMonth'"
              @click="selectTime('lastMonth')"
              type="button"
              >Last month</sui-button
            >
          </sui-button-group>
        </sui-form-field>
        <sui-form-field width="four">
          <label>Date start/end</label>
          <v-date-picker mode="range" v-model="filter.time.interval" />
        </sui-form-field>
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field width="four">
          <label>Agent</label>
          <sui-dropdown
            multiple
            :options="agents"
            placeholder="Agent"
            search
            selection
            v-model="filter.agents"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Groups</label>
          <sui-dropdown
            multiple
            :options="groups"
            placeholder="Groups"
            search
            selection
            v-model="filter.groups"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Queues</label>
          <sui-dropdown
            multiple
            :options="queues"
            placeholder="Queues"
            search
            selection
            v-model="filter.queues"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>IVRs</label>
          <sui-dropdown
            multiple
            :options="ivrs"
            placeholder="IVRs"
            search
            selection
            v-model="filter.ivrs"
          />
        </sui-form-field>
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field width="four">
          <label>Reasons</label>
          <sui-dropdown
            multiple
            :options="reasons"
            placeholder="Reasons"
            search
            selection
            v-model="filter.reasons"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Actions</label>
          <sui-dropdown
            multiple
            :options="actions"
            placeholder="Actions"
            search
            selection
            v-model="filter.actions"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Results</label>
          <sui-dropdown
            multiple
            :options="results"
            placeholder="Results"
            search
            selection
            v-model="filter.results"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Choices</label>
          <sui-dropdown
            multiple
            :options="choices"
            placeholder="Choices"
            search
            selection
            v-model="filter.choices"
          />
        </sui-form-field>
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field width="four">
          <label>Destinations</label>
          <sui-dropdown
            multiple
            :options="destinations"
            placeholder="Destinations"
            search
            selection
            v-model="filter.destinations"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Origins</label>
          <sui-dropdown
            multiple
            :options="origins"
            placeholder="Origins"
            search
            selection
            v-model="filter.origins"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Group by time</label>
          <sui-dropdown
            :options="groupByTimeValues"
            placeholder="Group by time"
            search
            selection
            v-model="filter.time.group"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Split by time</label>
          <sui-dropdown
            :options="splitByTimeValues"
            placeholder="Split by time"
            search
            selection
            v-model="filter.time.division"
          />
        </sui-form-field>
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field width="four">
          <label>Caller</label>
          <sui-dropdown
            :options="callers"
            placeholder="Caller"
            search
            selection
            v-model="filter.caller"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Contact name</label>
          <sui-dropdown
            :options="contactNames"
            placeholder="Contact name"
            search
            selection
            v-model="filter.contactName"
          />
        </sui-form-field>
        <sui-form-field width="four">
          <label>Null call</label>
          <sui-checkbox label toggle v-model="filter.nullCall" />
        </sui-form-field>
      </sui-form-fields>
      <sui-form-fields>
        <sui-button
          primary
          type="submit"
          class="mg-right-sm"
          @click="applyFilters()"
          >Apply filters</sui-button
        >
        <sui-button type="button" @click.native="showSaveSearchModal(true)"
          >Save search</sui-button
        >
        <sui-button
          type="button"
          :disabled="!selectedSearch"
          @click.native="showOverwriteSearchModal(true)"
          >Overwrite search</sui-button
        >
      </sui-form-fields>
    </sui-form>

    <!-- save search modal -->
    <sui-modal v-model="openSaveSearchModal" size="tiny">
      <sui-modal-header>Save search</sui-modal-header>
      <sui-modal-content>
        <sui-modal-description>
          <p>Enter a name for your new saved search</p>
          <sui-form :error="errorNewSearch">
            <sui-form-field>
              <input placeholder="Search name" v-model="newSearchName" />
            </sui-form-field>
            <sui-message error v-show="errorNewSearch">
              <p>{{ errorMessage }}</p>
            </sui-message>
          </sui-form>
        </sui-modal-description>
      </sui-modal-content>
      <sui-modal-actions>
        <sui-button @click.native="showSaveSearchModal(false)"
          >Cancel</sui-button
        >
        <sui-button
          primary
          @click.native="validateSaveNewSearch()"
          :loading="loader.saveSearch"
          content="Save"
        ></sui-button>
      </sui-modal-actions>
    </sui-modal>

    <!-- overwrite search modal -->
    <sui-modal v-model="openOverwriteSearchModal" size="tiny">
      <sui-modal-header>Overwrite search</sui-modal-header>
      <sui-modal-content>
        <sui-modal-description>
          <sui-message warning>
            <i class="exclamation triangle icon"></i>You are about to overwrite
            "{{ selectedSearch }}" search
          </sui-message>
          <p>Are you sure?</p>
        </sui-modal-description>
      </sui-modal-content>
      <sui-modal-actions>
        <sui-button @click.native="showOverwriteSearchModal(false)"
          >Cancel</sui-button
        >
        <sui-button negative @click.native="saveSearch(selectedSearch)"
          >Overwrite</sui-button
        >
      </sui-modal-actions>
    </sui-modal>

    <!-- delete search modal -->
    <sui-modal v-model="openDeleteSearchModal" size="tiny">
      <sui-modal-header>Delete search</sui-modal-header>
      <sui-modal-content>
        <sui-modal-description>
          <sui-message warning>
            <i class="exclamation triangle icon"></i>You are about to delete "{{
              selectedSearch
            }}" search
          </sui-message>
          <p>Are you sure?</p>
        </sui-modal-description>
      </sui-modal-content>
      <sui-modal-actions>
        <sui-button @click.native="showDeleteSearchModal(false)"
          >Cancel</sui-button
        >
        <sui-button
          negative
          @click.native="deleteSelectedSearch()"
          :loading="loader.deleteSearch"
          content="Delete"
        ></sui-button>
      </sui-modal-actions>
    </sui-modal>
  </div>
</template>

<script>
import LoginService from "../services/login";
import StorageService from "../services/storage";
import SearchesService from "../services/searches";
import UtilService from "../services/utils";

export default {
  name: "Filters",
  mixins: [LoginService, StorageService, SearchesService, UtilService],
  data() {
    return {
      showFilters: true,
      title: this.$i18n.t(this.$route.meta.name) || "", ////
      selectedSearch: null,
      filter: {
        queues: [],
        groups: [],
        agents: [],
        ivrs: [],
        reasons: [],
        actions: [],
        results: [],
        choices: [],
        destinations: [],
        origins: [],
        time: {
          group: "",
          division: "",
          interval: {
            start: null,
            end: null,
          },
        },
        caller: "",
        contactName: "",
        nullCall: false,
      },
      selectedTimeType: "",
      savedSearches: [],
      queues: [
        { value: "200", text: "200" },
        { value: "201", text: "201" },
        { value: "300", text: "300" },
      ],
      groups: [
        { value: "development", text: "Development" },
        { value: "support", text: "Support" },
        { value: "marketing", text: "Marketing" },
      ],
      agents: [
        { value: "Agent 1", text: "Agent 1" },
        { value: "Agent 2", text: "Agent 2" },
        { value: "Agent 3", text: "Agent 3" },
      ],
      ivrs: [
        { value: "IVR 1", text: "IVR 1" },
        { value: "IVR 2", text: "IVR 2" },
        { value: "IVR 3", text: "IVR 3" },
      ],
      reasons: [
        { value: "Reason 1", text: "Reason 1" },
        { value: "Reason 2", text: "Reason 2" },
      ],
      actions: [
        { value: "Action 1", text: "Action 1" },
        { value: "Action 2", text: "Action 2" },
      ],
      results: [
        { value: "Results 1", text: "Results 1" },
        { value: "Results 2", text: "Results 2" },
      ],
      choices: [
        { value: "Choices 1", text: "Choices 1" },
        { value: "Choices 2", text: "Choices 2" },
      ],
      destinations: [
        { value: "Destinations 1", text: "Destinations 1" },
        { value: "Destinations 2", text: "Destinations 2" },
      ],
      origins: [
        { value: "Origins 1", text: "Origins 1" },
        { value: "Origins 2", text: "Origins 2" },
      ],
      callers: [
        { value: "", text: "-" },
        { value: "Caller 1", text: "Caller 1" },
        { value: "Caller 2", text: "Caller 2" },
      ],
      contactNames: [
        { value: "", text: "-" },
        { value: "Contact 1", text: "Contact 1" },
        { value: "Contact 2", text: "Contact 2" },
      ],
      openSaveSearchModal: false,
      openOverwriteSearchModal: false,
      openDeleteSearchModal: false,
      newSearchName: "",
      errorNewSearch: false, ////
      errorMessage: "", ////
      loader: {
        saveSearch: false,
        deleteSearch: false,
      },
      groupByTimeValues: [
        { value: "", text: "-" },
        { value: "day", text: "Day" },
        { value: "week", text: "Week" },
        { value: "month", text: "Month" },
        { value: "year", text: "Year" },
      ],
      splitByTimeValues: [
        { value: "", text: "-" },
        { value: "10", text: "10 minutes" },
        { value: "15", text: "15 minutes" },
        { value: "30", text: "30 minutes" },
        { value: "60", text: "1 hour" },
      ],
    };
  },
  watch: {
    filter: function () {
      console.log("watch filter", this.filter); ////
    },
    // $route: function () { ////
    //   console.log("$route", this.$route); ////

    //   this.getSavedSearches();
    // },
    selectedSearch: function () {
      //// needed?
      console.log("watch selectedSearch", this.selectedSearch); ////
      this.setFilterValuesFromSearch();
    },
    "filter.reasons": function () {
      console.log("watch filter.reasons", this.filter.reasons); ////
    },
    "filter.selectedQueues": function () {
      console.log("watch filter.selectedQueues", this.filter.selectedQueues); ////
    },
    "filter.groups": function () {
      console.log("watch filter.groups", this.filter.groups); ////
    },
    "filter.selectedAgents": function () {
      console.log("watch filter.selectedAgents", this.filter.selectedAgents); ////
    },
    "filter.nullCall": function () {
      console.log("watch filter.nullCall", this.filter.nullCall); ////
    },
    "filter.time.interval": function () {
      console.log("watch filter.time.interval", this.filter.time.interval); ////

      this.selectedTimeType = "";

      if (
        this.filter.time.interval &&
        this.filter.time.interval.start &&
        this.filter.time.interval.end
      ) {
        console.log("this.filter.time.interval", this.filter.time.interval); ////

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

        if (
          this.filter.time.interval.end.getTime() == this.getToday().getTime()
        ) {
          if (
            this.filter.time.interval.start.getTime() ==
            this.getYesterday().getTime()
          ) {
            this.selectedTimeType = "yesterday";
          } else if (
            this.filter.time.interval.start.getTime() ==
            this.getLastWeek().getTime()
          ) {
            this.selectedTimeType = "lastWeek";
          } else if (
            this.filter.time.interval.start.getTime() ==
            this.getLastMonth().getTime()
          ) {
            this.selectedTimeType = "lastMonth";
          }
        }
      }
    },
    selectedTimeType: function () {
      console.log("watch selectedTimeType", this.selectedTimeType); ////
    },
  },
  mounted() {
    this.getSavedSearches();

    // console.log("this.$route.path", this.$route.path); ////
  },
  methods: {
    toggleFilters: function () {
      this.showFilters = !this.showFilters;
    },
    getSavedSearches(searchToSelect) {
      this.getSearches(
        (success) => {
          const savedSearches = success.body.searches;
          this.mapSavedSearches(savedSearches);

          if (searchToSelect) {
            this.selectedSearch = searchToSelect; //// test
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

      // console.log("$route", this.$route); ////

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

      if (searchesNotMatchingView.length) {
        // show divider and searches of other views
        const divider = {
          //// debug switching views
          value: "-",
          text: "-",
        };
        this.savedSearches = searchesMatchingView
          .concat([divider])
          .concat(searchesNotMatchingView);
      } else {
        this.savedSearches = searchesMatchingView;
      }
      console.log("savedSearches", this.savedSearches); ////
    },
    setFilterValuesFromSearch() {
      // retrieve search object
      let search = this.savedSearches.find(
        (s) => s.name === this.selectedSearch
      );

      console.log("setFilterValuesFromSearch(), search found", search); ////
      console.log("search filter", search.filter); ////

      // set filter values
      this.filter = search.filter;

      // this.filter.selectedQueues = search.filter.queues; ////
      // this.filter.groups = search.filter.groups;
      // this.filter.selectedAgents = search.filter.agents;
      // this.filter.ivrs = search.filter.ivrs;
      // this.filter.reasons = search.filter.reasons;
      // this.filter.actions = search.filter.actions;
      // this.filter.results = search.filter.results;
      // this.filter.choices = search.filter.choices;
      // this.filter.destinations = search.filter.destinations;
      // this.filter.origins = search.filter.origins;

      // this.filter.time.group = search.filter.time.group;
      // this.filter.time.division = search.filter.time.division;
      // this.filter.time.start = search.filter.time.start;
      // this.filter.time.end = search.filter.time.end;

      // this.filter.caller = search.filter.caller;
      // this.filter.contactName = search.filter.name;
      // this.filter.nullCall = search.filter.nullCall;
    },
    getToday() {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      return today;
    },
    getYesterday() {
      return this.addDays(this.getToday(), -1);
    },
    getLastWeek() {
      return this.addDays(this.getToday(), -7);
    },
    getLastMonth() {
      return this.addDays(this.getToday(), -30);
    },
    selectTime(interval) {
      this.selectedTimeType = interval;

      if (this.selectedTimeType == "yesterday") {
        this.filter.time.interval = {
          start: this.getYesterday(),
          end: this.getToday(),
        };
      } else if (this.selectedTimeType == "lastWeek") {
        this.filter.time.interval = {
          start: this.getLastWeek(),
          end: this.getToday(),
        };
      } else if (this.selectedTimeType == "lastMonth") {
        this.filter.time.interval = {
          start: this.getLastMonth(),
          end: this.getToday(),
        };
      }
    },
    addDays(date, days) {
      var result = new Date(date);
      result.setDate(result.getDate() + days);
      return result;
    },
    applyFilters() {
      this.$root.$emit("applyFilters", this.filter);

      console.log("applyFilters emitted", this.filter); ////
    },
    hackDropdown(e) {
      console.log("hackDropdown"); ////

      e.target.parentNode
        .querySelectorAll("div[role=option]")
        .forEach((item) => {
          if (item.textContent === "-") {
            console.log("hackDropdown, item found", item); ////

            item.textContent = "";
            item.classList.remove("item");
            item.classList.add("divider");
            item.disabled = true; //// need testing
          }
        });
    },
    showSaveSearchModal(value) {
      this.newSearchName = "";
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
    saveSearch(searchName) {
      this.loader.saveSearch = true;
      let filterToSave = JSON.parse(JSON.stringify(this.filter));

      // convert time interval to string
      filterToSave.time.interval.start = this.formatDate(
        this.filter.time.interval.start
      );
      filterToSave.time.interval.end = this.formatDate(
        this.filter.time.interval.end
      );

      // filterToSave.time.interval.start = this.filter.time.interval.start.toUTCString(); ////
      // filterToSave.time.interval.end = this.filter.time.interval.end.toUTCString();

      console.log("saving", searchName, filterToSave); ////

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
    getCurrentSection() {
      //// move to utils file/service?
      return this.$route.meta.section;
    },
    getCurrentView() {
      //// move to utils file/service?
      return this.$route.meta.view;
    },
    showDeleteSearchModal(value) {
      this.openDeleteSearchModal = value;
    },
    deleteSelectedSearch() {
      this.loader.deleteSearch = true;
      const searchId =
        this.selectedSearch +
        "_" +
        this.getCurrentSection() +
        "_" +
        this.getCurrentView();

      console.log("deleting", searchId); ////

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
    showOverwriteButton() {
      //// asdf
    },
    doLogout() {
      this.execLogout(
        () => {
          // remove from localstorage
          this.delete("loggedUser");

          // change route
          this.$parent.didLogout();
          this.$router.push("/");
        },
        (error) => {
          // print error
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
