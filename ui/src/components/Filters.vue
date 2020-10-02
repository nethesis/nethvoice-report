<template>
  <div>
    <sui-loader v-if="loader.filter" active centered inline />
    <sui-form v-else class="filters-form">
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

      <sui-form-fields v-if="showFilterTime">
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
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field v-if="showFilterAgent" width="four">
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
        <sui-form-field v-if="showFilterGroup" width="four">
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
        <sui-form-field v-if="showFilterQueue" width="four">
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
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field v-if="showFilterReason" width="four">
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
        <sui-form-field v-if="showFilterResult" width="four">
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
        <sui-form-field v-if="showFilterIvr" width="four">
          <label>IVR</label>
          <sui-dropdown
            multiple
            :options="ivrs"
            placeholder="IVR"
            search
            selection
            v-model="filter.ivrs"
          />
        </sui-form-field>
        <sui-form-field v-if="showFilterChoice" width="four">
          <label>IVR choices</label>
          <sui-dropdown
            multiple
            :options="choices"
            placeholder="IVR choices"
            search
            selection
            v-model="filter.choices"
          />
        </sui-form-field>
      </sui-form-fields>

      <sui-form-fields>
        <sui-form-field v-if="showFilterOrigin" width="four">
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
        <sui-form-field v-if="showFilterDestination" width="four">
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
        <sui-form-field v-if="showFilterTimeSplit" width="four">
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
        <sui-form-field v-if="showFilterCaller" width="four">
          <label>Caller</label>
          <sui-input placeholder="Caller" v-model="filter.caller" />
        </sui-form-field>
        <sui-form-field v-if="showFilterContactName" width="four">
          <label>Contact name / Company</label>
          <sui-search
            :searchFields="['title', 'cleanName']"
            :source="phoneBook"
            ref="filterContactName"
            placeholder="Contact name / Company"
            :fullTextSearch="'exact'"
            :maxResults="20"
            class="searchContactName"
          />
        </sui-form-field>
        <sui-form-field v-if="showFilterNullCall" width="four">
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
import SearchService from "../services/searches";
import PhonebookService from "../services/phonebook";

export default {
  name: "Filters",
  mixins: [
    LoginService,
    StorageService,
    SearchesService,
    UtilService,
    SearchService,
    PhonebookService,
  ],
  data() {
    return {
      showFilters: true,
      title: this.$i18n.t(this.$route.meta.name) || "", //// i18n
      selectedSearch: null,
      filter: {
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
      queues: [],
      groups: [],
      agents: [],
      ivrs: [],
      reasons: [],
      results: [],
      choices: [],
      destinations: [],
      origins: [],
      callers: [],
      contactNames: [],
      openSaveSearchModal: false,
      openOverwriteSearchModal: false,
      openDeleteSearchModal: false,
      newSearchName: "",
      errorNewSearch: false,
      errorMessage: "",
      loader: {
        filter: false,
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
      phoneBook: [],
      queueReportViewFilterMap: null,
    };
  },
  watch: {
    filter: function () {
      console.log("watch filter", this.filter); ////
    },
    selectedSearch: function () {
      console.log("watch selectedSearch", this.selectedSearch); ////
      this.setFilterValuesFromSearch();
    },
    "filter.ivrs": function () {
      console.log("watch filter.ivrs", this.filter.ivrs); ////
      this.updateIvrChoices();
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
    "filter.contactName": function () {
      console.log("watch filter.contactName", this.filter.contactName); ////
    },
  },
  mounted() {
    this.getSavedSearches();

    //// todo check if filter is present in local storage
    this.retrieveDefaultFilter();
    this.retrievePhonebook();
  },
  methods: {
    toggleFilters: function () {
      this.showFilters = !this.showFilters;
    },
    retrieveDefaultFilter() {
      this.getDefaultFilter(
        this.$route.meta.section,
        this.$route.meta.view,
        (success) => {
          console.log("getDefaultFilter", success.body.filter); ////
          this.defaultFilter = success.body.filter;

          // queues
          if (this.defaultFilter.queues) {
            let queues = this.defaultFilter.queues.map((queue) => {
              return { value: queue, text: queue };
            });
            this.queues = queues.sort(this.sortByProperty("text"));
          }

          // agents
          if (this.defaultFilter.agents) {
            let agents = this.defaultFilter.agents.map((agent) => {
              return { value: agent, text: agent };
            });
            this.agents = agents.sort(this.sortByProperty("text"));
          }

          // groups
          if (this.defaultFilter.groups) {
            let groups = this.defaultFilter.groups.map((group) => {
              return { value: group, text: group };
            });
            this.groups = groups.sort(this.sortByProperty("text"));
          }

          // ivr
          if (this.defaultFilter.ivrs) {
            let ivrs = this.defaultFilter.ivrs.map((ivr) => {
              const tokens = ivr.split(",");
              const idIvr = tokens[0];
              const ivrName = tokens[1];
              return { value: ivrName, text: ivrName, id: idIvr };
            });
            this.ivrs = ivrs.sort(this.sortByProperty("text"));
          }

          // choices: hide duplicates
          if (this.defaultFilter.choices) {
            this.allChoices = [];
            let choiceSet = new Set();
            this.defaultFilter.choices.forEach((choice) => {
              const tokens = choice.split(",");
              const idIvr = tokens[0];
              const choiceName = tokens[1];
              this.allChoices.push({
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

            this.choices = choices.sort(this.sortByProperty("text"));
          }

          // reasons
          if (this.defaultFilter.reasons) {
            let reasons = this.defaultFilter.reasons.map((reason) => {
              return { value: reason, text: reason };
            });
            this.reasons = reasons.sort(this.sortByProperty("text"));
          }

          // results
          if (this.defaultFilter.results) {
            let results = this.defaultFilter.results.map((result) => {
              return { value: result, text: result };
            });
            this.results = results.sort(this.sortByProperty("text"));
          }

          // origins
          if (this.defaultFilter.origins) {
            let districtSet = new Set();
            let provinceSet = new Set();
            let regionSet = new Set();

            this.defaultFilter.origins.forEach((origin) => {
              const tokens = origin.split(",");
              districtSet.add(tokens[0]);
              provinceSet.add(tokens[1]);
              regionSet.add(tokens[2]);
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

            this.origins = districts
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
            this.destinations = destinations.sort(this.sortByProperty("text"));
          }

          // time
          this.filter.time = this.defaultFilter.time; //// test with group and division too

          // null call
          this.filter.nullCall = this.defaultFilter.nullCall;
        },
        (error) => {
          console.error(error.body);
        }
      );
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
      console.log("searchhhh", this.$refs.filterContactName.$el.textContent); ////

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
    updateIvrChoices() {
      // show only IVR choices related to selected IVRs

      let selectedIvrs = this.filter.ivrs;

      if (this.filter.ivrs.length == 0) {
        // selecting no IVR is the same as selecting all of them
        selectedIvrs = this.ivrs.map((ivr) => {
          return ivr.value;
        });
      }

      let relatedChoiceValues = new Set();

      selectedIvrs.forEach((selectedIvr) => {
        const ivr = this.ivrs.find((i) => {
          return i.value == selectedIvr;
        });

        // find related IVR choices
        let relatedChoices = this.allChoices.filter((choice) => {
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
      this.choices = choices.sort(this.sortByProperty("text"));

      console.log("this.choices", this.choices); ////
    },
    retrievePhonebook() {
      this.getPhonebook(
        (success) => {
          // console.log("success.body", success.body); ////

          const phoneBook = success.body;

          console.log("phoneBook len", Object.keys(success.body).length); ////

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

          console.log("this.phoneBook", this.phoneBook); ////
        },
        (error) => {
          console.error(error.body);
        }
      );
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
    showFilterTime: function () {
      return this.isFilterInView("time");
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

.searchContactName > .results {
  overflow: auto;
  max-height: 300px;
}
</style>
