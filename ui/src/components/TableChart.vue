<template>
  <sui-table celled selectable striped :class="{ structured: hasDoubleHeader }">
    <!-- single header -->
    <sui-table-header v-if="!hasDoubleHeader">
      <sui-table-row>
        <sui-table-header-cell
          v-for="(column, index) in columns"
          v-bind:key="index"
          >{{ column }}</sui-table-header-cell
        >
      </sui-table-row>
    </sui-table-header>

    <!-- double header table -->
    <sui-table-header v-else>
      <!-- primary header -->
      <sui-table-row>
        <sui-table-header-cell
          v-for="(header, index) in doubleHeader"
          v-bind:key="index"
          :rowspan="header.subHeaders == null ? '2' : '1'"
          :colspan="header.subHeaders ? header.subHeaders.length : '1'"
          >{{ header.name }}</sui-table-header-cell
        >
      </sui-table-row>
      <!-- sub-header -->
      <sui-table-row>
        <sui-table-header-cell
          v-for="(header, index) in subHeaders"
          v-bind:key="index"
          >{{ header }}</sui-table-header-cell
        >
      </sui-table-row>
    </sui-table-header>

    <sui-table-body>
      <sui-table-row v-for="(row, index) in rows" v-bind:key="index">
        <sui-table-cell v-for="(element, index) in row" v-bind:key="index">{{
          element
        }}</sui-table-cell>
      </sui-table-row>
    </sui-table-body>
  </sui-table>
</template>

<script>
export default {
  name: "TableChart",
  props: ["caption", "data"],
  data() {
    return {
      columns: [],
      rows: [],
      hasDoubleHeader: false,
      doubleHeader: [],
    };
  },
  watch: {
    data: function () {
      if (this.data) {
        if (this.data.length) {
          // table has double header if at least one column header contains "$" character
          this.hasDoubleHeader = this.data[0].some((h) => {
            return h.includes("$");
          });
          this.columns = this.data[0];

          if (this.hasDoubleHeader) {
            this.parseDoubleHeader();
          }
        }

        if (this.data.length > 1) {
          this.rows = this.data.slice(1);
        }
      }
    },
  },
  computed: {
    subHeaders: function () {
      let allSubHeaders = [];
      this.doubleHeader.forEach((header) => {
        if (header.subHeaders && header.subHeaders.length) {
          allSubHeaders = allSubHeaders.concat(header.subHeaders);
        }
      });
      return allSubHeaders;
    },
  },
  methods: {
    parseDoubleHeader() {
      this.doubleHeader = [];

      this.columns.forEach((column) => {
        if (column.includes("$")) {
          const headers = column.split("$");
          const primaryHeader = headers[0];
          const subHeader = headers[1];

          const headerFound = this.doubleHeader.find((h) => {
            return h.name == primaryHeader;
          });

          if (!headerFound) {
            // add primary header and its sub-header
            this.doubleHeader.push({
              name: primaryHeader,
              subHeaders: [subHeader],
            });
          } else {
            // add sub-header to existing primary header
            headerFound.subHeaders.push(subHeader);
          }
        } else {
          // add single header
          this.doubleHeader.push({ name: column, subHeaders: null });
        }
      });
    },
  },
};
</script>

<style lang="scss" scoped>
</style>
