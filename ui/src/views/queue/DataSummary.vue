<template lang="html">
<div>
  Data summary
</div>
</template>

<script>
export default {
  name: 'DataSummary',
  mounted() {
    console.log("mounted DataSummary"); ////

    this.$root.$on('applyFilters', filter => {
      console.log("[DataSummary.vue] applyFilters event handler", filter); ////
    });
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$off("applyFilters");
    next();
  },
};
</script>
