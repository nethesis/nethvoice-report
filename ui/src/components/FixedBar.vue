<template>
  <div v-show="dataAvailable" class="fixedbar-container" :style="styleObject">
    <div class="fixedbar" :class="{ fixed: isFixed }">
      <sui-container>
        <strong class="activeFilters">{{$t('menu.active_filters')}}: </strong>
        <!-- label: selected saved search -->
        <div class="ui label" v-if="activeSelectedSearch">
          <span class="field">
            {{$t('filter.saved_search')}}:
          </span>
          <span class="value">
            {{activeSelectedSearch}}
          </span>
        </div>
        <!-- label: group by time value -->
        <div class="ui label" v-if="showFilterTimeGroup && activeFilters.time && activeFilters.time.group">
          <span class="field">
            {{$t('filter.group_by')}}:
          </span>
          <span class="value">
            {{$t(`filter.${activeFilters.time.group}`)}}
          </span>
        </div>
        <!-- label: time interval value -->
        <div class="ui label" v-if="showFilterTime && activeFilters.time && activeFilters.time.range">
          <span class="field">
            {{$t('filter.time_interval')}}:
          </span>
          <span class="value">
            {{$t(`filter.${activeFilters.time.range}`)}}
          </span>
        </div>
        <!-- label: time interval value -->
        <div class="ui label" v-if="activeFilters.time && activeFilters.time.interval">
          <span class="field">
            {{$t('filter.time_interval')}}:
          </span>
          <span class="value">
            {{`${activeFilters.time.interval.start} - ${activeFilters.time.interval.end}`}}
          </span>
        </div>
        <!-- label: queues list -->
        <div class="ui label" v-if="showFilterQueue && activeFilters.queues && (activeFilters.queues.length > 0)">
          <span class="field">
            {{$t('filter.queues_label')}}:
          </span>
          <span class="value">
            {{activeFilters.queues}}
          </span>
        </div>
        <!-- label: groups list -->
        <div class="ui label" v-if="showFilterGroup && activeFilters.groups && (activeFilters.groups.length > 0)">
          <span class="field">
            {{$t('filter.groups_label')}}:
          </span>
          <span class="value">
            {{activeFilters.groups}}
          </span>
        </div>
        <!-- label: agents list -->
        <div class="ui label" v-if="showFilterAgent && activeFilters.agents && (activeFilters.agents.length > 0)">
          <span class="field">
            {{$t('filter.agents_label')}}:
          </span>
          <span class="value">
            {{activeFilters.agents}}
          </span>
        </div>
        <!-- label: reasons list -->
        <div class="ui label" v-if="showFilterReason && activeFilters.reasons && (activeFilters.reasons.length > 0)">
          <span class="field">
            {{$t('filter.reasons_label')}}:
          </span>
          <span class="value">
            {{activeFilters.reasons}}
          </span>
        </div>
        <!-- label: results list -->
        <div class="ui label" v-if="showFilterResult && activeFilters.results && (activeFilters.results.length > 0)">
          <span class="field">
            {{$t('filter.results_label')}}:
          </span>
          <span class="value">
            {{activeFilters.results}}
          </span>
        </div>
        <!-- label: ivrs list -->
        <div class="ui label" v-if="showFilterIvr && activeFilters.ivrs && (activeFilters.ivrs.length > 0)">
          <span class="field">
            {{$t('filter.ivrs_label')}}:
          </span>
          <span class="value">
            {{activeFilters.ivrs}}
          </span>
        </div>
        <!-- label: choices list -->
        <div class="ui label" v-if="showFilterChoice && activeFilters.choices && (activeFilters.choices.length > 0)">
          <span class="field">
            {{$t('filter.choices_label')}}:
          </span>
          <span class="value">
            {{activeFilters.choices}}
          </span>
        </div>
        <!-- label: origins list -->
        <div class="ui label" v-if="showFilterOrigin && activeFilters.origins && (activeFilters.origins.length > 0)">
          <span class="field">
            {{$t('filter.origins_label')}}:
          </span>
          <span class="value">
            {{activeFilters.origins}}
          </span>
        </div>
        <!-- label: destinations list -->
        <div class="ui label" v-if="showFilterDestination && activeFilters.destinations && (activeFilters.destinations.length > 0)">
          <span class="field">
            {{$t('filter.destinations_label')}}:
          </span>
          <span class="value">
            {{activeFilters.destinations}}
          </span>
        </div>
        <!-- label: time split value -->
        <div class="ui label" v-if="showFilterTimeSplit && activeFilters.time && activeFilters.time.division">
          <span class="field">
            {{$t('filter.time_split_label')}}:
          </span>
          <span class="value">
            {{activeFilters.time.division}}
          </span>
        </div>
        <!-- label: caller value -->
        <div class="ui label" v-if="showFilterCaller && activeFilters.caller">
          <span class="field">
            {{$t('filter.caller_label')}}:
          </span>
          <span class="value">
            {{activeFilters.caller}}
          </span>
        </div>
        <!-- label: contactName value -->
        <div class="ui label" v-if="showFilterContactName && activeFilters.contactName">
          <span class="field">
            {{$t('filter.contact_name_label')}}:
          </span>
          <span class="value">
            {{activeFilters.contactName}}
          </span>
        </div>
        <!-- label: nullCall value -->
        <div class="ui label" v-if="showFilterNullCall && activeFilters.nullCall">
          <span class="field">
            {{$t('filter.null_call_label')}}:
          </span>
          <span class="value">
            {{activeFilters.nullCall}}
          </span>
        </div>
        <!-- start cdr -->
        <!-- label: caller sources active filter -->
        <div class="ui label" v-if="showFilterCdrCaller && activeFilters.sources && activeFilters.sources.title != ''">
          <span class="field">
            {{$t('filter.caller_label')}}:
          </span>
          <span class="value">
            {{activeFilters.sources.title}}
          </span>
        </div>
        <!-- label: caller destinations active filter -->
        <div class="ui label" v-if="showFilterCdrCallee && activeFilters.caller_destinations && activeFilters.caller_destinations.title != ''">
          <span class="field">
            {{$t('filter.callee')}}:
          </span>
          <span class="value">
            {{activeFilters.caller_destinations.title}}
          </span>
        </div>
        <!-- label: call type active filter -->
        <div class="ui label" v-if="showFilterCdrCallType && activeFilters.call_type && (activeFilters.call_type.length > 0)">
          <span class="field">
            {{$t('filter.call_type')}}:
          </span>
          <span class="value">
            {{activeFilters.call_type}}
          </span>
        </div>
        <!-- label: call duration active filter -->
        <div class="ui label" v-if="showFilterCdrCallDuration &&  activeFilters.duration && activeFilters.duration.title != ''">
          <span class="field">
            {{$t('filter.call_duration')}}:
          </span>
          <span class="value">
            {{activeFilters.duration.title}}
          </span>
        </div>
        <!-- label: did active filter -->
        <div class="ui label" v-if="showFilterCdrDid && activeFilters.dids && (activeFilters.dids.length > 0)">
          <span class="field">
            {{$t('filter.did')}}:
          </span>
          <span class="value">
            {{activeFilters.dids}}
          </span>
        </div>
        <!-- label: trunk active filter -->
        <div class="ui label" v-if="showFilterCdrTrunk && activeFilters.trunks && (activeFilters.trunks.length > 0)">
          <span class="field">
            {{$t('filter.trunk')}}:
          </span>
          <span class="value">
            {{activeFilters.trunks}}
          </span>
        </div>
        <!-- label: cti groups active filter -->
        <div class="ui label" v-if="showFilterCdrCtiGroups && activeFilters.groups && (activeFilters.groups.length > 0)">
          <span class="field">
            {{$t('filter.cti_group')}}:
          </span>
          <span class="value">
            {{activeFilters.groups}}
          </span>
        </div>
        <!-- label: users active filter -->
        <div class="ui label" v-if="showFilterCdrUser && activeFilters.users && (activeFilters.users.length > 0)">
          <span class="field">
            {{$t('filter.user')}}:
          </span>
          <span class="value">
            {{activeFilters.users}}
          </span>
        </div>
        <!-- label: destination type active filter -->
        <div class="ui label" v-if="showFilterCdrCallDestination && activeFilters.callDestinations && (activeFilters.callDestinations.length > 0)">
          <span class="field">
            {{$t('filter.call_destination')}}:
          </span>
          <span class="value">
            {{activeFilters.call_destination}}
          </span>
        </div>
        <!-- label: destination patterns type active filter -->
        <div class="ui label" v-if="showFilterCdrDestination && activeFilters.patterns && (activeFilters.patterns.length > 0)">
          <span class="field">
            {{$t('filter.destination')}}:
          </span>
          <span class="value">
            {{activeFilters.patterns}}
          </span>
        </div>
        <!-- clear filters action -->
        <div class="clear-filters">
          <a @click="clearFilters()">{{$t('filter.clear_filters')}}</a>
        </div>
      </sui-container>
    </div>
  </div>
</template>

<script>

import UtilService from "../services/utils";

export default {
  name: "FixedBar",
  mixins: [
    UtilService,
  ],
  props: [
    "filter",
    "selectedSearch",
    "showFilterTimeGroup",
    "showFilterTime",
    "showFilterQueue",
    "showFilterGroup",
    "showFilterAgent",
    "showFilterReason",
    "showFilterResult",
    "showFilterIvr",
    "showFilterChoice",
    "showFilterOrigin",
    "showFilterDestination",
    "showFilterTimeSplit",
    "showFilterCaller",
    "showFilterContactName",
    "showFilterNullCall",
    "showFilterCdrFastTimeRange",
    "showFilterCdrCaller",
    "showFilterCdrCallee",
    "showFilterCdrCallType",
    "showFilterCdrCallDuration",
    "showFilterCdrDid",
    "showFilterCdrTrunk",
    "showFilterCdrCtiGroups",
    "showFilterCdrUser",
    "showFilterCdrCalleeType",
    "showFilterCdrCallDestination",
    "showFilterCdrDestination",
    "cdrCallDurationMap",
    "callDestinationsMap",
    "filterValues"
  ],
  data() {
    return {
      activeFilters: {},
      activeSelectedSearch: "",
      isFixed: false,
      offsetTop: "",
      dataAvailable: true,
      styleObject: {
        "min-height": "62px"
      }
    }
  },
  mounted() {
    this.$root.$on("applyFilters", this.onApplyFilters);

    this.$nextTick(() => {
      window.addEventListener('scroll', this.scrollHandler, true)
    })

    // event "dataNotAvailable" is triggered by $http interceptor if report tables don't exist yet
    this.$root.$on("dataNotAvailable", this.onDataNotAvailable);
  },
  destroyed() {
    window.removeEventListener('scroll', this.scrollHandler);
  },
  methods: {
    onApplyFilters() {
      this.activeFilters = this.lodash.cloneDeep(this.filter)
      this.activeSelectedSearch = this.lodash.cloneDeep(this.selectedSearch)
    },
    onDataNotAvailable() {
      this.dataAvailable = false;
    },
    scrollHandler(evt) {
      if (evt.target.attributes["views-wrapper"] && (window.innerWidth > this.$mobileBound)) {
        if (!this.isFixed) {
          let fixedbar = document.querySelector(".fixedbar")
          if (fixedbar !== null) {
            this.offsetTop = fixedbar.offsetTop
            this.styleObject["min-height"] = fixedbar.offsetHeight + fixedbar.style.marginTop
          }
        }
        if (this.offsetTop <= evt.target.scrollTop) {
          this.isFixed = true
        } else {
          this.isFixed = false
        }
      }
    },
    clearFilters() {
      this.$root.$emit("clearFilters")
    },
  },
  watch: {
    "activeFilters.time.interval": function () {
      if (this.activeFilters.time && this.activeFilters.time.interval) {
        this.activeFilters.time.interval.start = this.$options.filters.formatDate(this.activeFilters.time.interval.start)
        this.activeFilters.time.interval.end = this.$options.filters.formatDate(this.activeFilters.time.interval.end)
      }
    },
    "activeFilters.queues": function () {
      if (this.activeFilters.queues && this.lodash.isArray(this.activeFilters.queues) && this.activeFilters.queues.length > 0) {
        this.activeFilters.queues = this.activeFilters.queues.join(", ")
      }
    },
    "activeFilters.groups": function () {
      if (this.activeFilters.groups && this.lodash.isArray(this.activeFilters.groups) && this.activeFilters.groups.length > 0) {
        this.activeFilters.groups.forEach((element, key) => {
         let groupsValuesText = this.filterValues.ctiGroups.find(obj => obj.value === element).text
          this.activeFilters.groups[key] = groupsValuesText
        })
        this.activeFilters.groups = this.activeFilters.groups.join(", ")
      }
    },
    "activeFilters.agents": function () {
      if (this.activeFilters.agents && this.lodash.isArray(this.activeFilters.agents) && this.activeFilters.agents.length > 0) {
        this.activeFilters.agents = this.activeFilters.agents.join(", ")
      }
    },
    "activeFilters.reasons": function () {
      if (this.activeFilters.reasons && this.lodash.isArray(this.activeFilters.reasons) && this.activeFilters.reasons.length > 0) {
        this.activeFilters.reasons = this.activeFilters.reasons.join(", ")
      }
    },
    "activeFilters.results": function () {
      if (this.activeFilters.results && this.lodash.isArray(this.activeFilters.results) && this.activeFilters.results.length > 0) {
        this.activeFilters.results = this.activeFilters.results.join(", ")
      }
    },
    "activeFilters.ivrs": function () {
      if (this.activeFilters.ivrs && this.lodash.isArray(this.activeFilters.ivrs) && this.activeFilters.ivrs.length > 0) {
        this.activeFilters.ivrs = this.activeFilters.ivrs.join(", ")
      }
    },
    "activeFilters.choices": function () {
      if (this.activeFilters.choices && this.lodash.isArray(this.activeFilters.choices) && this.activeFilters.choices.length > 0) {
        this.activeFilters.choices = this.activeFilters.choices.join(", ")
      }
    },
    "activeFilters.origins": function () {
      if (this.activeFilters.origins && this.lodash.isArray(this.activeFilters.origins) && this.activeFilters.origins.length > 0) {
        this.activeFilters.origins = this.activeFilters.origins.join(", ")
      }
    },
    "activeFilters.destinations": function () {
      if (this.activeFilters.destinations && this.lodash.isArray(this.activeFilters.destinations) && this.activeFilters.destinations.length > 0) {
        this.activeFilters.destinations = this.activeFilters.destinations.join(", ")
      }
    },
    "activeFilters.sources": function () {
      if (this.activeFilters.sources && this.activeFilters.sources.title && this.activeFilters.sources.title != "") {
        if (this.activeFilters.sources.value) {
          let sourcesValues = this.filterValues.cdrCaller.find(obj => obj.value === this.activeFilters.sources.value)
          this.activeFilters.sources.title = sourcesValues.title
        }
      }
    },
    "activeFilters.caller_destinations": function () {
      if (this.activeFilters.caller_destinations && this.activeFilters.caller_destinations.title && this.activeFilters.caller_destinations.title != "") {
        if (this.activeFilters.caller_destinations.value) {
          let destinationsValues = this.filterValues.cdrCaller.find(obj => obj.value === this.activeFilters.caller_destinations.value)
          this.activeFilters.caller_destinations.title = destinationsValues.title
        }
      }
    },
    "activeFilters.call_type": function () {
      if (this.activeFilters.call_type && this.lodash.isArray(this.activeFilters.call_type) && this.activeFilters.call_type.length > 0) {
        this.activeFilters.call_type = this.activeFilters.call_type.map((element) => {
          return this.$t(`filter.${element}`)
        })
        this.activeFilters.call_type = this.activeFilters.call_type.join(", ")
      }
    },
    "activeFilters.dids": function () {
      if (this.activeFilters.dids && this.lodash.isArray(this.activeFilters.dids) && this.activeFilters.dids.length > 0) {
        this.activeFilters.dids = this.activeFilters.dids.join(", ")
      }
    },
    "activeFilters.trunks": function () {
      if (this.activeFilters.trunks && this.lodash.isArray(this.activeFilters.trunks) && this.activeFilters.trunks.length > 0) {
        this.activeFilters.trunks.forEach((trunk, key) => {
          let splittedTrunk = trunk.split(",")
          let text = `${splittedTrunk[0]} (${splittedTrunk[1]})`
          this.activeFilters.trunks[key] = text
        })
        this.activeFilters.trunks = this.activeFilters.trunks.join(", ")
      }
    },
    "activeFilters.users": function () {
      if (this.activeFilters.users && this.lodash.isArray(this.activeFilters.users) && this.activeFilters.users.length > 0) {
        this.activeFilters.users.forEach((element, key) => {
          let usersValuesText = this.filterValues.users.find(obj => obj.value === element).text
          this.activeFilters.users[key] = usersValuesText
        })
        this.activeFilters.users = this.activeFilters.users.join(", ")
      }
    },
    "activeFilters.callDestinations": function () {
      if (this.activeFilters.callDestinations && this.lodash.isArray(this.activeFilters.callDestinations) && this.activeFilters.callDestinations.length > 0) {
        this.activeFilters.callDestinations.forEach((element, key) => {
          let callDestinationsText = this.callDestinationsMap.find(obj => obj.value === element).text
          this.activeFilters.callDestinations[key] = callDestinationsText
        })
        this.activeFilters.callDestinations = this.activeFilters.callDestinations.join(", ")
      }
    },
    "activeFilters.patterns": function () {
      if (this.activeFilters.patterns && this.lodash.isArray(this.activeFilters.patterns) && this.activeFilters.patterns.length > 0) {
        this.activeFilters.patterns.forEach((element, key) => {
          let destinationValuesText = this.filterValues.cdrPatterns.find(obj => obj.value === element).text
          this.activeFilters.patterns[key] = destinationValuesText
        })
        this.activeFilters.patterns = this.activeFilters.patterns.join(", ")
      }
    }
  }
};
</script>

<style lang="scss">

@import "../styles/theming.scss";

.fixed {
  position: fixed;
  z-index: 50;
  top: 0px !important;
  margin-top: 0px !important;
  width: calc(100% - 270px)
}

.fixedbar {
  padding: 8px 0px 4px 0px !important;
  background: #ffffff;
  margin-top: 20px;
  min-height: 39px !important;
  margin-bottom: 0 !important;
  border-bottom: 1px solid rgba(34, 36, 38, 0.15);
  box-shadow: -2px 1px 2px 0 rgba(34, 36, 38, 0.15);

  .label{
    margin-bottom: 4px !important;

    .field {
      font-style: italic;
      font-size: 11px;
      font-weight: 300 !important;
    }

    .value {
      font-weight: 600;
    }
  }

  .ui.container {
    margin-right: 3em !important;
    margin-left: 3em !important;
    width: auto !important;
    text-align: left;

    .activeFilters {
      font-size: 13px;
    }
  }

  @media only screen and (max-width: $mobile-bound) {
    & {
      display: none;
    }
  }
}

.fixedbar-container {
  @media only screen and (max-width: $mobile-bound) {
    & {
      display: none;
    }
  }
}

.clear-filters {
  display: inline-block;
  margin: 0px 10px;
  cursor: pointer;
}
</style>
