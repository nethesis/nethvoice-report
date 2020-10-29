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
            header &&
            (!header.superHeader ||
              header.superHeader.expanded ||
              !header.hidden)
          "
          v-for="(header, index) in subHeaders"
          v-bind:key="index"
          >{{ $t(header.name) }}</sui-table-header-cell
        >
      </sui-table-row>
    </sui-table-header>

    <sui-table-body>
      <sui-table-row
        v-for="(row, index) in pagination.pageRows"
        v-bind:key="index"
      >
        <sui-table-cell
          v-for="(element, index) in row"
          v-show="
            columns[index] &&
            (!columns[index].superHeader ||
              columns[index].superHeader.expanded ||
              !columns[index].hidden)
          "
          v-bind:key="index"
        >
          <span v-if="columns[index] && columns[index].format == 'num'">
            {{ element | formatNumber }}
          </span>
          <span
            v-else-if="columns[index] && columns[index].format == 'seconds'"
          >
            {{ element | formatTime }}
          </span>
          <span
            v-else-if="columns[index] && columns[index].format == 'percent'"
          >
            {{ element | formatPercentage }}
          </span>
          <span v-else-if="columns[index] && columns[index].format == 'label'">
            {{ $t(element) }}
          </span>
          <span
            v-else-if="columns[index] && columns[index].format == 'monthDate'"
          >
            {{ element | formatMonthDate($i18n) }}
          </span>
          <span
            v-else-if="columns[index] && columns[index].format == 'weekDate'"
          >
            {{ element | formatWeekDate($i18n) }}
          </span>
          <span v-else>
            {{ element }}
          </span>
        </sui-table-cell>
      </sui-table-row>
    </sui-table-body>
    <sui-table-footer>
      <sui-table-row>
        <sui-table-header-cell :colspan="columns.length">
          <sui-menu pagination class="no-border">
            <span is="sui-menu-item" class="small-pad"
              >{{ pagination.firstRowIndex + 1 }} -
              {{ Math.min(pagination.lastRowIndex, rows.length) }}
              {{ $t("pagination.of") }} {{ rows.length }}</span
            >
          </sui-menu>

          <sui-menu pagination class="mg-right-xl">
            <sui-dropdown class="item select-rows-per-page">
              <sui-dropdown-menu>
                <sui-dropdown-item
                  v-for="(value, index) in pagination.rowsPerPageOptions"
                  v-bind:key="index"
                  @click="setRowsPerPage(value)"
                >
                  <span class="mg-right-sm"
                    >{{ value }} {{ $t("pagination.per_page") }}</span
                  >
                  <sui-icon
                    v-if="pagination.rowsPerPage == value"
                    name="check"
                  />
                </sui-dropdown-item>
              </sui-dropdown-menu>
            </sui-dropdown>
          </sui-menu>

          <sui-menu pagination>
            <a is="sui-menu-item" icon @click="firstPage()">
              <sui-icon name="left double angle" />
            </a>
            <a is="sui-menu-item" icon @click="previousPage()">
              <sui-icon name="left angle" />
            </a>
          </sui-menu>
          <sui-menu pagination class="no-border">
            <span is="sui-menu-item" class="small-pad">{{
              $t("pagination.page")
            }}</span>
            <sui-input
              @blur="updatePagination()"
              @keyup.enter="updatePagination()"
              class="current-page"
              v-model="pagination.currentPage"
            />
            <span is="sui-menu-item" class="small-pad"
              >{{ $t("pagination.of") }} {{ pagination.totalPages }}</span
            >
          </sui-menu>
          <sui-menu pagination>
            <a is="sui-menu-item" icon @click="nextPage()">
              <sui-icon name="right angle" />
            </a>
            <a is="sui-menu-item" icon @click="lastPage()">
              <sui-icon name="right double angle" />
            </a>
          </sui-menu>
        </sui-table-header-cell>
      </sui-table-row>
    </sui-table-footer>
  </sui-table>
</template>

<script>
import UtilService from "../services/utils";
import StorageService from "../services/storage";

export default {
  name: "TableChart",
  props: ["caption", "data"],
  mixins: [UtilService, StorageService],
  data() {
    return {
      ROWS_PER_PAGE_KEY: "tableChartRowsPerPage",
      columns: [],
      rows: [],
      hasDoubleHeader: false,
      doubleHeader: [],
      pagination: {
        rowsPerPage: 10,
        rowsPerPageOptions: [10, 25, 50, 100],
        currentPage: 1,
        pageRows: [],
        totalPages: 0,
        firstRowIndex: 0,
        lastRowIndex: 0,
      },
    };
  },
  mounted() {
    // get number of rows per page from local storage
    const rowsPerPage = this.get(this.ROWS_PER_PAGE_KEY);

    if (rowsPerPage) {
      this.pagination.rowsPerPage = rowsPerPage;
    }
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
          this.updatePagination();
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
      let pivotColIndex = -1;
      let groupedColIndex = -1;
      let pivotMatch;
      let sumMatch;
      let pivotFormat;
      let superHeader;
      let totalSubHeader;
      let data = JSON.parse(JSON.stringify(this.data));
      const originalColumns = data[0];
      const originalRows = data.splice(1);

      // look for pivot and sum column indexes

      for (const [index, rawColumn] of originalColumns.entries()) {
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

      let pivotMap = {}; // contains pivotGroup -> pivotColumn -> number (e.g. 2019QueueNameQueueDescription -> hour -> numberOfCalls)

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

        const pivotColumn = row[pivotColIndex]; // e.g. "09:00"
        const value = row[groupedColIndex]; // e.g. 147
        pivotColumnSet.add(pivotColumn);

        if (!pivotMap[pivotGroup]) {
          pivotMap[pivotGroup] = {};
        }

        pivotMap[pivotGroup][pivotColumn] = value;
      }

      const pivotColumnsList = Array.from(pivotColumnSet).sort();

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
        } else if (index != groupedColIndex) {
          processedColumns.push(rawColumn);
        }
      });

      // process rows

      let processedRows = [];
      let currentPivotGroup;
      let currentProcessedRow = [];
      let groupedPivotValues = 0;
      let pivotColumnIndex = 0;

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

            while (pivotColumnIndex < pivotColumnsList.length) {
              // fill missing data
              currentProcessedRow.push(0);
              pivotColumnIndex++;
            }
            processedRows.push(currentProcessedRow);
          }
          currentProcessedRow = [];
          groupedPivotValues = 0;
          pivotColumnIndex = 0;
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

        // insert pivot value under the related pivot column (data may contain data holes)

        let pivotColumn = pivotColumnsList[pivotColumnIndex]; // e.g. 9:00

        while (!pivotMap[pivotGroup][pivotColumn]) {
          // fill missing data
          currentProcessedRow.push(0);
          pivotColumnIndex++;
          pivotColumn = pivotColumnsList[pivotColumnIndex];
        }
        currentProcessedRow.push(pivotValue);
        pivotColumnIndex++;
      }

      // add last processed row
      currentProcessedRow[pivotColIndex] = groupedPivotValues;

      while (pivotColumnIndex < pivotColumnsList.length) {
        // fill missing data
        currentProcessedRow.push(0);
        pivotColumnIndex++;
      }

      processedRows.push(currentProcessedRow);

      return [processedColumns].concat(processedRows);
    },
    setRowsPerPage(value) {
      this.pagination.rowsPerPage = value;
      this.updatePagination();

      // save number of rows per page to local storage
      this.set(this.ROWS_PER_PAGE_KEY, this.pagination.rowsPerPage);
    },
    previousPage() {
      if (this.pagination.currentPage > 1) {
        this.pagination.currentPage--;
        this.updatePagination();
      }
    },
    nextPage() {
      if (this.pagination.currentPage < this.pagination.totalPages) {
        this.pagination.currentPage++;
        this.updatePagination();
      }
    },
    firstPage() {
      this.pagination.currentPage = 1;
      this.updatePagination();
    },
    lastPage() {
      this.pagination.currentPage = this.pagination.totalPages;
      this.updatePagination();
    },
    updatePagination() {
      this.pagination.totalPages = Math.ceil(
        this.rows.length / this.pagination.rowsPerPage
      );

      // validate currentPage
      if (
        isNaN(this.pagination.currentPage) ||
        this.pagination.currentPage < 1
      ) {
        this.pagination.currentPage = 1;
      } else if (this.pagination.currentPage > this.pagination.totalPages) {
        this.pagination.currentPage = this.pagination.totalPages;
      }

      this.pagination.firstRowIndex =
        (this.pagination.currentPage - 1) * this.pagination.rowsPerPage;
      this.pagination.lastRowIndex =
        this.pagination.firstRowIndex + this.pagination.rowsPerPage;
      this.pagination.pageRows = this.rows.slice(
        this.pagination.firstRowIndex,
        this.pagination.lastRowIndex
      );
    },
  },
};
</script>

<style lang="scss" scoped>
</style>
