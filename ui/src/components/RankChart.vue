<template>
  <sui-table selectable striped>
    <sui-table-body>
      <sui-table-row v-for="(entry, index) in entries" :key="index">
        <sui-table-cell :width="1">
          <sui-label color="blue">
            {{ index + 1 }}
          </sui-label>
        </sui-table-cell>
        <sui-table-cell>
          {{ entry[0] }}
        </sui-table-cell>
        <sui-table-cell>
          <strong>{{ formatValue(entry[1]) }}</strong>
        </sui-table-cell>
      </sui-table-row>
    </sui-table-body>
  </sui-table>
</template>

<script>
export default {
  name: "RankChart",
  props: {
    caption: {
      type: String,
    },
    data: {
      type: Array,
    },
  },
  data() {
    return {
      entries: [],
      format: "",
    };
  },
  watch: {
    data: function () {
      if (this.data && this.data.length > 1) {
        this.format = this.data[0][1].split("£")[1];
        this.entries = this.data.slice(1);
      } else {
        this.entries = [];
      }
    },
  },
  methods: {
    formatValue(value) {

      console.log("this.$parent.$data.adminSettings.currency", this.$parent.$data.adminSettings.currency); ////
      console.log("this.format", this.format); ////

      if (!this.format || this.format == "num") {
        return this.$options.filters.formatNumber(value);
      } else if (this.format && this.format == "twoDecimals") {
        return this.$options.filters.formatTwoDecimals(value);
      } else if (this.format && this.format == "seconds") {
        return this.$options.filters.formatTime(value);
      } else if (this.format && this.format == "currency") {
        return (
          this.$options.filters.formatCurrency(value) +
          " " +
          this.$parent.$data.adminSettings.currency
        );
      } else {
        return value;
      }
    },
  },
};
</script>
