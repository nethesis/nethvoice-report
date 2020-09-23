<template>
  <sui-form equal-width class="filters-form">
    <sui-form-fields>
      <sui-form-field>
        <label>Filter</label>
        <sui-dropdown
          fluid
          :options="filters"
          placeholder="Filter"
          search
          selection
          v-model="selectedFilter"
        />
      </sui-form-field>
      <sui-form-field>
        <v-date-picker
          mode="range"
          :value="selectedInterval"
        />
      </sui-form-field>
      <sui-form-field>
        <label>Null call</label>
        <sui-checkbox label="toggle" toggle v-model="selectedNullCall" />
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
          v-model="selectedAgent"
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
          v-model="selectedGroups"
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
          v-model="selectedQueues"
        />
      </sui-form-field>
    </sui-form-fields>
    <sui-button type="submit">Save</sui-button>
  </sui-form>
</template>

<script>
import LoginService from "../services/login";
import StorageService from "../services/storage";

export default {
  name: "Filters",
  mixins: [LoginService, StorageService],
  data() {
    return {
      showFilters: true,
      title: this.$i18n.t(this.$route.meta.name) || "", ////
      selectedFilter: null,
      selectedNullCall: false,
      selectedAgent: null,
      selectedQueues: [],
      selectedGroups: [],
      selectedInterval: null,
      // filter: { ////
      //   queues: [],
      //   groups: [],
      //   time: {
      //     time_range: "",
      //     value: "",
      //   },
      //   name: "",
      //   Agent: "",
      //   NullCall: false,
      // },
      filters: [
        { key: "1", value: "custom", text: "Custom" },
        { key: "2", value: "myfilter", text: "My filter" },
        { key: "3", value: "otherfilter", text: "Other filter" },
      ],
      queues: [
        { key: "200", value: "200", text: "200" },
        { key: "201", value: "201", text: "201" },
        { key: "300", value: "300", text: "300" },
      ],
      groups: [
        { key: "1", value: "dev", text: "Development" },
        { key: "2", value: "support", text: "Support" },
        { key: "3", value: "marketing", text: "Marketing" },
      ],
      agents: [
        { key: "11", value: "agent1", text: "Agent 1" },
        { key: "22", value: "agent2", text: "Agent 2" },
        { key: "33", value: "agent3", text: "Agent 3" },
      ],
    };
  },
  watch: {
    $route: function () {
      this.title =
        (this.$route.meta.section
          ? this.$i18n.t("menu." + this.$route.meta.section) + ": "
          : "") + this.$i18n.t(this.$route.meta.name); ////
    },
    filter: function () {
      ////
      console.log("watch filter", this.filter); ////
    },
    selectedFilter: function () {
      console.log("watch selectedFilter", this.selectedFilter); ////
    },
    selectedQueues: function () {
      console.log("watch selectedQueues", this.selectedQueues); ////
    },
    selectedGroups: function () {
      console.log("watch selectedGroups", this.selectedGroups); ////
    },
    selectedAgent: function () {
      console.log("watch selectedAgent", this.selectedAgent); ////
    },
    selectedNullCall: function () {
      console.log("watch selectedNullCall", this.selectedNullCall); ////
    },
    selectedInterval: function () {
      console.log("watch selectedInterval", this.selectedInterval); ////
    },
  },
  mounted() {
    
    
    //// get current filter
    // this.filter = {
    //   queues: [],
    //   groups: [],
    //   time: {
    //     time_range: "",
    //     value: "",
    //   },
    //   name: "",
    //   Agent: "",
    //   NullCall: false,
    // };
  },
  methods: {
    toggleFilters: function () {
      this.showFilters = !this.showFilters;
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
</style>
