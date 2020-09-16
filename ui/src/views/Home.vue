<template lang="html">
  <div>
    <!-- start topbar -->
    <TopBar/>
    <!-- end topbar -->
    <!-- start view content -->
    <div class="component-body">
      <StandardTable/>
    </div>
  </div>
</template>

<script>

import TopBar from "../components/TopBar.vue";
import StandardTable from "../components/StandardTable.vue";

export default {
  name: "Home",
  components: {
    TopBar: TopBar,
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
