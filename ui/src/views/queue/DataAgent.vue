<template lang="html">
<div>
  Data agent
</div>
</template>

<script>
export default {
  name: 'DataAgent',
  mounted() {
    console.log("mounted DataAgent"); ////

    this.$root.$on('applyFilters', filter => {
      console.log("[DataAgent.vue] applyFilters event handler", filter); ////
    });
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$off("applyFilters");
    next();
  },
};
</script>
