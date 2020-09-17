<template lang="html">
  <div>
    <!-- start view content -->
    <div class="component-body">
      <StandardTable/>
    </div>
  </div>
</template>

<script>

import StandardTable from "../components/StandardTable.vue";

export default {
  name: "Home",
  components: {
    StandardTable: StandardTable
  },
  data () {
    return {

    }
  }
};
</script>

<style lang="css">
.docs-color-grid {
  margin: -1.5em;
  width: 400px;
}

.docs-color-grid .column {
  margin: 0.5em;
  width: 50px;
  height: 50px;
}
</style>
