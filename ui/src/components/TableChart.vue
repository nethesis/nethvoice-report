<template>
  <sui-table celled selectable striped :class="{ structured: hasDoubleHeader }">
    <!-- single header -->
    <sui-table-header v-if="!hasDoubleHeader">
      <sui-table-row>
        <sui-table-header-cell
          v-for="(column, index) in columns"
          v-bind:key="index"
          >{{ $t(column.name) }}</sui-table-header-cell
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
          :colspan="
            header.subHeaders && (header.expanded || !header.expandible)
              ? header.subHeaders.length
              : '1'
          "
        >
          {{ $t(header.name) }}
          <a
            href="#"
            v-show="header.subHeaders && header.expandible"
            @click="toggleExpandHeader(header)"
          >
            {{
              header.expanded
                ? "[" + $t("compress") + "]"
                : "[" + $t("expand") + "]"
            }}
          </a>
        </sui-table-header-cell>
      </sui-table-row>
      <!-- sub-header -->
      <sui-table-row>
        <sui-table-header-cell
          v-show="
            !header.superHeader || header.superHeader.expanded || !header.hidden
          "
          v-for="(header, index) in subHeaders"
          v-bind:key="index"
          >{{ $t(header.name) }}</sui-table-header-cell
        >
      </sui-table-row>
    </sui-table-header>

    <sui-table-body>
      <sui-table-row v-for="(row, index) in rows" v-bind:key="index">
        <sui-table-cell
          v-for="(element, index) in row"
          v-show="
            !columns[index].superHeader ||
            columns[index].superHeader.expanded ||
            !columns[index].hidden
          "
          v-bind:key="index"
        >
          <span v-if="columns[index].format == 'num'">
            {{ element | formatNumber }}
          </span>
          <span v-else-if="columns[index].format == 'seconds'">
            {{ element | formatTime }}
          </span>
          <span v-else-if="columns[index].format == 'percent'">
            {{ element | formatPercentage }}
          </span>
          <span v-else-if="columns[index].format == 'label'">
            {{ $t(element) }}
          </span>
          <span v-else-if="columns[index].format == 'monthDate'">
            {{ element | formatMonthDate($i18n) }}
          </span>
          <span v-else-if="columns[index].format == 'weekDate'">
            {{ element | formatWeekDate($i18n) }}
          </span>
          <span v-else>
            {{ element }}
          </span>
        </sui-table-cell>
      </sui-table-row>
    </sui-table-body>
  </sui-table>
</template>

<script>
import UtilService from "../services/utils";

export default {
  name: "TableChart",
  props: ["caption", "data"],
  mixins: [UtilService],
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
      if (this.data && this.data.length) {
        // table has double header if at least one column header contains "$" character
        this.hasDoubleHeader = this.data[0].some((h) => {
          return h.includes("$");
        });
        let rawColumns = this.data[0];

        if (this.data.length > 1) {
          this.rows = this.data.slice(1);
        } else {
          this.rows = [];
        }
        this.parseColumns(rawColumns);
      } else {
        this.columns = [];
        this.rows = [];
        this.doubleHeader = [];
      }
    },
  },
  computed: {
    subHeaders: function () {
      const subHeaders = this.columns.filter((column) => {
        return column.superHeader;
      });
      return subHeaders;
    },
  },
  methods: {
    parseColumns(rawColumns) {
      this.doubleHeader = [];
      let columns = [];

      rawColumns.forEach((rawColumn) => {
        let column = {};

        // e.g. notProcessed$joinempty£num#hide
        var colRegex = /^(([^$£#]*)(\$))?([^$£#]+)£?([^$£#]*)(#hide)?$/g;
        var match = colRegex.exec(rawColumn);

        const superHeaderName = match[2];
        column.name = match[4];
        column.format = match[5];
        column.hidden = match[6] == "#hide";
        columns.push(column);

        if (this.hasDoubleHeader) {
          if (superHeaderName) {
            const subHeader = {
              name: column.name,
              hidden: column.hidden,
            };

            const headerFound = this.doubleHeader.find((h) => {
              return h.name == superHeaderName;
            });

            if (!headerFound) {
              // add primary header and its sub-header
              const superHeader = {
                name: superHeaderName,
                subHeaders: [subHeader],
                expanded: false,
                expandible: column.hidden,
              };
              column.superHeader = superHeader;

              this.doubleHeader.push(superHeader);
            } else {
              // add sub-header to existing primary header
              headerFound.subHeaders.push(subHeader);
              column.superHeader = headerFound;

              if (column.hidden) {
                headerFound.expandible = true;
              }
            }
          } else {
            // add single header
            this.doubleHeader.push({ name: column.name });
          }
        }
      });
      this.columns = columns;
    },
    toggleExpandHeader(header) {
      header.expanded = !header.expanded;
    },
  },
};
</script>

<style lang="scss" scoped>
</style>
