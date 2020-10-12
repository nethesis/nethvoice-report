<template>
  <div>
    <sui-loader v-if="loader.filter" active centered inline />
    <sui-form v-else class="filters-form" @submit.prevent="applyFilters">
      <sui-form-fields v-if="savedSearches.length" class="mg-bottom-md">
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
            type="button"
            negative
            :disabled="!selectedSearch"
            @click.native="showDeleteSearchModal(true)"
            >Delete search</sui-button
          >
        </sui-form-field>
      </sui-form-fields>

      <sui-form-fields v-if="showFilterTime">
        <sui-form-field width="four">
          <label>Group by</label>
          <sui-dropdown
            :options="groupByTimeValues"
            placeholder="Group by time"
            search
            selection
            v-model="filter.time.group"
          />
        </sui-form-field>
        <sui-form-field width="six">
          <label>Time interval</label>
          <sui-button-group class="fluid">
            <sui-button
              :active="filter.time.range == 'yesterday'"
              @click="selectTime('yesterday')"
              type="button"
              >Yesterday</sui-button
            >
            <sui-button
              :active="filter.time.range == 'last_week'"
              @click="selectTime('last_week')"
              type="button"
              >Last week</sui-button
            >
            <sui-button
              :active="filter.time.range == 'last_month'"
              @click="selectTime('last_month')"
              type="button"
              >Last month</sui-button
            >
          </sui-button-group>
        </sui-form-field>
        <sui-form-field width="four">
          <label>Date start/end</label>
          <v-date-picker
            mode="range"
            v-model="filter.time.interval"
            :available-dates="{ start: null, end: new Date() }"
            :masks="{ input: 'YYYY/MM/DD' }"
          />
        </sui-form-field>
      </sui-form-fields>

      <sui-grid>
        <sui-form-field v-if="showFilterQueue" width="four">
          <label>Queues</label>
          <sui-dropdown
            multiple
            :options="filterValues.queues"
            placeholder="Queues"
            search
            selection
            v-model="filter.queues"
          />
        </sui-form-field>
        <sui-form-field v-if="showFilterGroup" width="four">
          <label>Groups</label>
          <sui-dropdown
            multiple
            :options="filterValues.groups"
            placeholder="Groups"
            search
            selection
            v-model="filter.groups"
          />
        </sui-form-field>
        <sui-form-field v-if="showFilterAgent" width="four">
          <label>Agent</label>
          <sui-dropdown
            multiple
            :options="filterValues.agents"
            placeholder="Agent"
            search
            selection
            v-model="filter.agents"
          />
        </sui-form-field>
        <sui-form-field v-if="showFilterReason" width="four">
          <label>Reasons</label>
          <sui-dropdown
            multiple
            :options="filterValues.reasons"
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
            :options="filterValues.results"
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
            :options="filterValues.ivrs"
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
            :options="filterValues.choices"
            placeholder="IVR choices"
            search
            selection
            v-model="filter.choices"
          />
        </sui-form-field>
        <sui-form-field v-if="showFilterOrigin" width="six">
          <label>Origins</label>
          <sui-dropdown
            multiple
            :options="filterValues.origins"
            placeholder="Area code, district, province or region"
            search
            selection
            v-model="filter.origins"
          />
        </sui-form-field>
        <sui-form-field v-if="showFilterDestination" width="six">
          <label>Destinations</label>
          <sui-dropdown
            multiple
            :options="filterValues.destinations"
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
        <sui-form-field v-if="showFilterCaller" width="four">
          <label>Caller</label>
          <sui-input placeholder="Caller" v-model="filter.caller" />
        </sui-form-field>
        <sui-form-field v-if="showFilterContactName" width="six">
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
      </sui-grid>

      <sui-form-fields class="mg-top-md">
        <sui-button primary type="submit" class="mg-right-sm"
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
        nullCall: false,
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
        filter: false,
        saveSearch: false,
        deleteSearch: false,
      },
      groupByTimeValues: [
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
    selectedSearch: function () {
      this.setFilterValuesFromSearch();
    },
    "filter.ivrs": function () {
      this.updateIvrChoices();
    },
    "filter.time.range": function () {
      console.log("watch filter.time.range", this.filter.time.range); ////
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

        if (
          this.filter.time.interval.end.getTime() == this.getToday().getTime()
        ) {
          if (
            this.filter.time.interval.start.getTime() ==
            this.getYesterday().getTime()
          ) {
            this.filter.time.range = "yesterday";
          } else if (
            this.filter.time.interval.start.getTime() ==
            this.getLastWeek().getTime()
          ) {
            this.filter.time.range = "last_week";
          } else if (
            this.filter.time.interval.start.getTime() ==
            this.getLastMonth().getTime()
          ) {
            this.filter.time.range = "last_month";
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
      this.applyFilters();
    });
  },
  methods: {
    retrieveFilter() {
      let filter = this.get("reportFilter");
      let filterValues = this.get("reportFilterValues");

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
        this.setFilterSelection(filter);

        // setTimeout(() => {
        //   this.applyFilters(); ////
        // }, 1000); ////
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
            "reportFilterValues",
            this.filterValues,
            1
          ); //// TODO use 8 * 60 (i.e. 8 hours)

          // set selected values in filter
          this.setFilterSelection(this.defaultFilter);

          // setTimeout(() => {
          //   this.applyFilters(); ////
          // }, 1000); ////
        },
        (error) => {
          console.error(error.body);
        }
      );
    },
    setFilterSelection(filter) {
      // time
      this.filter.time.group = filter.time.group;
      this.filter.time.division = filter.time.division;
      this.filter.time.interval = filter.time.interval;
      this.filter.time.range = filter.time.range;
      this.selectTime(filter.time.range);

      // null call
      this.filter.nullCall = filter.nullCall;

      // save filter to local storage
      this.set("reportFilter", this.filter);
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
    },
    setFilterValuesFromSearch() {
      // retrieve search object
      let search = this.savedSearches.find(
        (s) => s.name === this.selectedSearch
      );

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
      } else if (range == "last_month") {
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
      // save filter to local storage
      this.set("reportFilter", this.filter);

      let filterToApply = JSON.parse(JSON.stringify(this.filter));

      if (
        this.$refs.filterContactName &&
        this.$refs.filterContactName.$el &&
        this.$refs.filterContactName.$el.firstChild &&
        this.$refs.filterContactName.$el.firstChild.value
      ) {
        const contactName = this.$refs.filterContactName.$el.firstChild.value;
        const contact = this.phoneBook.find((c) => {
          return c.title == contactName;
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

      this.$root.$emit("applyFilters", filterToApply);
    },
    hackDropdown(e) {
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
      //// use local storage (with expiry)
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
