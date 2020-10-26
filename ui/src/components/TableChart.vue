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
                ? "[" + $t("collapse") + "]"
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
      let tableData = this.data;

      if (tableData && tableData.length) {
        // pre-process table data if it's a pivot table
        const isPivotTable = tableData[0].some((h) => {
          return h.includes("^pivot");
        });

        if (isPivotTable && tableData.length > 1) {
          tableData = this.processPivotTable();
        }

        // table has double header if at least one column header contains "$" character
        this.hasDoubleHeader = tableData[0].some((h) => {
          return h.includes("$");
        });
        let rawColumns = tableData[0];

        if (tableData.length > 1) {
          this.rows = tableData.slice(1);
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
        const colRegex = /^(([^$£#]*)(\$))?([^$£#]+)£?([^$£#]*)(#hide)?$/g;
        const match = colRegex.exec(rawColumn);

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
    processPivotTable() {
      //// test with data holes (missing hours for some records)

      let pivotColIndex = -1;
      let groupedColIndex = -1;
      let idColIndex = -1;
      let pivotMatch;
      let sumMatch;
      let idMatch;
      let pivotId; // e.g. queueName
      let pivotFormat;
      let superHeader;
      let totalSubHeader;
      let data = JSON.parse(JSON.stringify(this.data));
      const originalColumns = data[0];
      const originalRows = data.splice(1);

      // look for id, pivot and sum column indexes

      for (const [index, rawColumn] of originalColumns.entries()) {
        idMatch = /([^^]+)\^id/.exec(rawColumn); //// is ^id needed?
        if (idMatch) {
          idColIndex = index;
          pivotId = idMatch[1];
          continue;
        }

        pivotMatch = /[^£#]+(£[^#]+)?\^pivot/.exec(rawColumn);
        if (pivotMatch) {
          pivotColIndex = index;

          if (pivotMatch[1]) {
            pivotFormat = pivotMatch[1];
          } else {
            pivotFormat = "";
          }
          continue;
        }

        sumMatch = /([^^]+)\^sum_(.+)/.exec(rawColumn);
        if (sumMatch) {
          groupedColIndex = index;
          superHeader = sumMatch[1];
          totalSubHeader = sumMatch[2];
          continue;
        }
      }

      // read pivot data from rows

      let pivotColumnSet = new Set();

      //// todo remove pivotMap??
      let pivotMap = {}; // contains id -> column -> number (e.g. queueName -> hour -> numberOfCalls)

      //// needed?
      for (const row of originalRows) {
        const id = row[idColIndex]; // e.g. "4444" (queueName)
        const pivotColumn = row[pivotColIndex]; // e.g. "09:00"
        const value = row[groupedColIndex]; // e.g. 147
        pivotColumnSet.add(pivotColumn);

        if (!pivotMap[id]) {
          pivotMap[id] = {};

          // add non-pivot data
          for (const [colIndex, value] of row.entries()) {
            if (
              colIndex != idColIndex &&
              colIndex != pivotColIndex &&
              colIndex != groupedColIndex
            ) {
              const originalColumn = originalColumns[colIndex];
              pivotMap[id][originalColumn] = value;
            }
          }
        }
        pivotMap[id][pivotColumn] = value;
      }
      const pivotColumnsList = Array.from(pivotColumnSet).sort();

      console.log("pivotColumnsList", pivotColumnsList); ////

      // process column headers

      let processedColumns = [];
      originalColumns.forEach((rawColumn, index) => {
        if (index == pivotColIndex) {
          // add sum column
          processedColumns.push(superHeader + "$" + totalSubHeader);

          // add pivot columns
          for (let pivotColumn of pivotColumnsList) {
            processedColumns.push(
              superHeader + "$" + pivotColumn + pivotFormat + "#hide"
            );
          }
        } else if (index == idColIndex) {
          processedColumns.push(pivotId);
        } else if (index != groupedColIndex) {
          processedColumns.push(rawColumn);
        }
      });

      console.log("processedColumns", processedColumns); ////

      // process rows

      let processedRows = [];
      let currentPivotGroup;
      let currentProcessedRow = [];
      let groupedPivotValues = 0;

      for (const row of originalRows) {
        // detect when pivot group changes, i.e. when a non-pivot related column changes
        let pivotGroup = "";
        for (const [colIndex, value] of row.entries()) {
          if (colIndex >= pivotColIndex) {
            break;
          } else {
            pivotGroup += value;
          }
        }

        if (!currentPivotGroup || pivotGroup != currentPivotGroup) {
          // new pivot group

          if (currentPivotGroup) {
            currentProcessedRow[pivotColIndex] = groupedPivotValues;

            // console.log("currentProcessedRow", currentProcessedRow); ////

            processedRows.push(currentProcessedRow);
          }

          currentProcessedRow = [];
          groupedPivotValues = 0;
          currentPivotGroup = pivotGroup;

          for (let colIndex = 0; colIndex < pivotColIndex; colIndex++) {
            currentProcessedRow.push(row[colIndex]);
          }
          // temporary value for grouped pivot values
          currentProcessedRow.push(0);
        }

        // add data to current pivot group

        let pivotValue = parseInt(row[groupedColIndex]);
        groupedPivotValues += pivotValue;
        currentProcessedRow.push(pivotValue);
      }

      return [processedColumns].concat(processedRows);
    },
  },
};
</script>

<style lang="scss" scoped>
</style>
