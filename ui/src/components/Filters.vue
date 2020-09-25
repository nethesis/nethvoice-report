<template>
  <sui-form equal-width class="filters-form">
    <sui-form-fields>
      <sui-form-field>
        <label>Saved search</label>
        <sui-dropdown
          fluid
          placeholder="Saved search"
          search
          selection
          class="savedSearch"
          v-model="selectedSearch"
          :options="savedSearches"
          @click="hackDropdown"
        />
      </sui-form-field>
    </sui-form-fields>
    <sui-form-fields>
      <sui-form-field>
        <label>Time interval</label>
        <sui-button-group class="fluid">
          <sui-button
            :active="selectedTimeType=='yesterday'"
            @click="selectTime('yesterday')"
            type="button"
          >Yesterday</sui-button>
          <sui-button
            :active="selectedTimeType=='last_week'"
            @click="selectTime('last_week')"
            type="button"
          >Last week</sui-button>
          <sui-button
            :active="selectedTimeType=='last_month'"
            @click="selectTime('last_month')"
            type="button"
          >Last month</sui-button>
          <!-- <sui-button :active="selectedTimeType=='custom'" @click="selectTime('custom')">Custom</sui-button> //// -->
        </sui-button-group>
      </sui-form-field>
      <sui-form-field>
        <label>Date start/end</label>
        <v-date-picker mode="range" v-model="filter.selectedTimeInterval" />
      </sui-form-field>
      <sui-form-field>
        <label>Null call</label>
        <sui-checkbox label toggle v-model="filter.selectedNullCall" />
      </sui-form-field>
    </sui-form-fields>
    <sui-form-fields>
      <sui-form-field>
        <label>Agent</label>
        <sui-dropdown
          fluid
          :options="agents"
          placeholder="Agent"
          search
          selection
          v-model="filter.selectedAgent"
        />
      </sui-form-field>
      <sui-form-field>
        <label>Groups</label>
        <sui-dropdown
          multiple
          fluid
          :options="groups"
          placeholder="Groups"
          search
          selection
          v-model="filter.selectedGroups"
        />
      </sui-form-field>
      <sui-form-field>
        <label>Queues</label>
        <sui-dropdown
          multiple
          fluid
          :options="queues"
          placeholder="Queues"
          search
          selection
          v-model="filter.selectedQueues"
        />
      </sui-form-field>
    </sui-form-fields>
    <sui-button primary type="submit" @click="applyFilters()">Apply filters</sui-button>
    <sui-button type="button" @click.native="showSaveSearchModal(true)">Save search</sui-button>
    <sui-button
      type="button"
      :disabled="!selectedSearch"
      @click.native="showOverwriteSearchModal(true)"
    >Overwrite search</sui-button>

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
              <p>{{errorMessage}}</p>
            </sui-message>
          </sui-form>
        </sui-modal-description>
      </sui-modal-content>
      <sui-modal-actions>
        <sui-button @click.native="showSaveSearchModal(false)">Cancel</sui-button>
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
          <p>You are about to overwrite "{{selectedSearch}}" search</p>
          <p>Are you sure?</p>
        </sui-modal-description>
      </sui-modal-content>
      <sui-modal-actions>
        <sui-button @click.native="showOverwriteSearchModal(false)">Cancel</sui-button>
        <sui-button primary @click.native="saveSearch(selectedSearch)">Overwrite</sui-button>
      </sui-modal-actions>
    </sui-modal>
  </sui-form>
</template>

<script>
import LoginService from "../services/login";
import StorageService from "../services/storage";
import SearchesService from "../services/searches";

export default {
  name: "Filters",
  mixins: [LoginService, StorageService, SearchesService],
  data() {
    return {
      showFilters: true,
      title: this.$i18n.t(this.$route.meta.name) || "", ////
      selectedSearch: null,
      filter: {
        selectedAgent: null,
        selectedQueues: [],
        selectedGroups: [],
        selectedTimeInterval: null,
        selectedNullCall: false,
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
      // searchesMatchingView: [], ////
      // searchesNotMatchingView: [],
      openSaveSearchModal: false,
      openOverwriteSearchModal: false,
      newSearchName: "",
      errorNewSearch: false, ////
      errorMessage: "", ////
      loader: {
        saveSearch: false,
      },
    };
  },
  watch: {
    $route: function () {
      console.log("$route", this.$route); ////

      this.getSavedSearches();
    },
    selectedSearch: function () {
      //// needed?
      console.log("watch selectedSearch", this.selectedSearch); ////
      this.setFilterValues();
    },
    "filter.selectedQueues": function () {
      console.log("watch filter.selectedQueues", this.filter.selectedQueues); ////
    },
    "filter.selectedGroups": function () {
      console.log("watch filter.selectedGroups", this.filter.selectedGroups); ////
    },
    "filter.selectedAgent": function () {
      console.log("watch filter.selectedAgent", this.filter.selectedAgent); ////
    },
    "filter.selectedNullCall": function () {
      console.log(
        "watch filter.selectedNullCall",
        this.filter.selectedNullCall
      ); ////
    },
    "filter.selectedTimeInterval": function () {
      console.log(
        "watch filter.selectedTimeInterval",
        this.filter.selectedTimeInterval
      ); ////
    },
    selectedTimeType: function () {
      console.log("watch selectedTimeType", this.selectedTimeType); ////
    },
  },
  mounted() {
    this.getSavedSearches();

    console.log("this.$route.path", this.$route.path); //// asdf
  },
  methods: {
    toggleFilters: function () {
      this.showFilters = !this.showFilters;
    },
    getSavedSearches() {
      this.getSearches(
        (success) => {
          const savedSearches = success.body.searches;
          console.log(savedSearches); ////
          this.mapSavedSearches(savedSearches);
        },
        (error) => {
          console.error(error.body.message);
        }
      );
    },
    mapSavedSearches(savedSearches) {
      // let i = 0;
      let searchesMatchingView = [];
      let searchesNotMatchingView = [];

      console.log("$route", this.$route); ////

      for (const search of savedSearches) {
        // search.key = i;
        search.value = search.name;
        search.text = search.name;
        // i++;

        // const regex = new RegExp("^.+/" + search.section + "/" + search.view); ////
        // const searchMatchesView = regex.test(this.$route.path);

        // console.log(
        //   "search matches path?",
        //   search.section,
        //   search.view,
        //   searchMatchesView
        // ); ////

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
          //// debug switching view
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

      // this.searchesMatchingView = searchesMatchingView; ////
      // this.searchesNotMatchingView = searchesNotMatchingView;
    },
    setFilterValues() {
      // retrieve search object
      let search = this.savedSearches.find(
        (s) => s.name === this.selectedSearch
      );

      // let search = this.searchesMatchingView.find( ////
      //   (s) => s.name === this.selectedSearch
      // );

      // // look in other searches if needed
      // if (!search) {
      //   search = this.searchesNotMatchingView.find(
      //     (s) => s.name === this.selectedSearch
      //   );
      // }

      console.log("setFilterValues(), search found", search); ////

      // const filter = search.filter;

      console.log("search filter", search.filter); ////

      // set filter values
      this.filter.selectedAgent = search.filter.agent;
      this.filter.selectedGroups = search.filter.groups;
      this.filter.selectedQueues = search.filter.queues;
      this.filter.selectedNullCall = search.filter.null_call;
      //// todo time interval
    },
    selectTime(interval) {
      this.selectedTimeType = interval;
      const today = new Date();

      if (this.selectedTimeType == "yesterday") {
        this.filter.selectedTimeInterval = {
          start: this.addDays(today, -1),
          end: today,
        };
      } else if (this.selectedTimeType == "last_week") {
        this.filter.selectedTimeInterval = {
          start: this.addDays(today, -7),
          end: today,
        };
      } else if (this.selectedTimeType == "last_month") {
        this.filter.selectedTimeInterval = {
          start: this.addDays(today, -30),
          end: today,
        };
      }
    },
    addDays(date, days) {
      var result = new Date(date);
      result.setDate(result.getDate() + days);
      return result;
    },
    applyFilters() {
      this.$root.filter.queues = this.filter.selectedQueues;
      this.$root.filter.groups = this.filter.selectedGroups;
      // this.$root.filter.name = ???; ////
      this.$root.filter.agent = this.filter.selectedAgent;
      this.$root.filter.nullCall = this.filter.selectedNullCall;
      //// TODO time interval

      console.log("this.$root.filter", this.$root.filter); ////
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

      if (!/^[a-zA-Z][a-zA-Z0-9 -]+$/.test(this.newSearchName)) {
        this.errorNewSearch = true;
        this.errorMessage =
          "Search name must begin with a letter and contain only letters, spaces, numbers and dashes";
        return;
      }
      this.saveSearch(this.newSearchName);
    },
    saveSearch(searchName) {
      console.log("saving", searchName); ////

      this.loader.saveSearch = true;
      this.createSearch(
        {
          name: searchName,
          section: this.$route.meta.section,
          view: this.$route.meta.view,
          filter: {
            queues: this.filter.selectedQueues,
            groups: this.filter.selectedGroups,
            time: {
              time_range: "", ////
              value: "", ////
            },
            name: "?", ////
            agent: this.filter.selectedAgent,
            null_call: this.filter.selectedNullCall,
          },
        },
        () => {
          this.loader.saveSearch = false;
          this.showSaveSearchModal(false);
          this.showOverwriteSearchModal(false);
          this.getSavedSearches();
        },
        (error) => {
          this.loader.saveSearch = false;
          console.error(error.body.message);
        }
      );
    },
    getCurrentSection() {
      //// move to utils file/service?
      return this.$route.path; //// asdf
    },
    getCurrentView() {
      //// move to utils file/service?
      return this.$route.path; //// asdf
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
          console.error(error.body.message);
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

.savedSearch {
  width: 33% !important ;
}
</style>
