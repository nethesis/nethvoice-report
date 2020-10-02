<template>
<sui-form>
  <sui-table celled selectable class="mg-bottom-md">
    <sui-table-header>
      <sui-table-row>
        <sui-table-header-cell v-for="(column, index) in columns" v-bind:key="index">{{column}}</sui-table-header-cell>
      </sui-table-row>
    </sui-table-header>

    <sui-table-body>
      <sui-table-row v-for="(row, index) in rows" v-bind:key="index">
        <sui-table-cell v-for="(element, index) in row" v-bind:key="index">{{ element }}</sui-table-cell>
      </sui-table-row>
    </sui-table-body>
  </sui-table>
</sui-form>
</template>

<script>
export default {
  name: "GraphTable",
  props: ['data'],
  data() {
    return {
      columns: [],
      rows: [],
    };
  },
  mounted() {
    if (this.data) {
      if (this.data.length) {
        this.columns = this.data[0];
      }

      if (this.data.length > 1) {
        this.rows = this.data.slice(1);
      }
    }
  },
  methods: {
  },
};
</script>

<style lang="scss">
.mg-bottom-md {
  margin-bottom: 2rem !important;
}
</style>
