<template lang="html">
<div class="ui placeholder segment report-data-not-available">
  <div class="ui icon header">
    <i class="wrench icon mg-bottom-sm"></i>
    {{ $t("message.coming_soon") }}
  </div>
  <div class="inline">
    {{ $t("message.cdr_not_available") }}
  </div>
</div>
</template>

<script>
export default {
  name: 'CdrView',
};
</script>
