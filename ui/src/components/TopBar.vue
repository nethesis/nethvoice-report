<template>
  <div class="masthead">
    <sui-container>

      <sui-menu floated="right">
        <sui-popup position="bottom center" content="Settings">
          <a
            slot="trigger"
            is="sui-menu-item"
            icon="github"
            :href="githubLink"
          />
        </sui-popup>
        <sui-popup position="bottom center" content="Logout">
          <a slot="trigger" is="sui-menu-item" icon="book" :href="suiLink" />
        </sui-popup>
      </sui-menu>

      <h1 is="sui-header" class="view-title">
        Home
      </h1>

      <!-- <sui-menu :widths="2" class="component-head-menu">
        <router-link
          is="sui-menu-item"
          :active="!tab"
          :to="`/${type}/${componentName}`"
        >
          Definitions
        </router-link>
        <router-link
          is="sui-menu-item"
          :active="tab === 'api'"
          :to="`/${type}/${componentName}/api`"
        >
          API
        </router-link>
      </sui-menu> -->
    </sui-container>
  </div>
</template>

<script>
// import capitalize from 'lodash/capitalize';

export default {
  name: 'TopBar',
//   props: {
//     type: String,
//     componentName: String,
//     tab: String,
//   },
  data() {
    return {
      // currentComponent: this.componentName
    }
  }
};
</script>

<style lang="scss">
.masthead {
  padding: 14px 0px 15px 0px !important;
  min-height: 65px;
  margin-bottom: 0 !important;
  border-bottom: 1px solid rgba(34,36,38,.15);
  box-shadow: 0 1px 2px 0 rgba(34,36,38,.15);

  .ui.container {
    margin-right: 3em !important;
    margin-left: 3em !important;
    width: auto !important;

    .ui.header {
      margin: 0px !important;
    }

    .ui.right.floated.menu {
      margin-top: -2px;
    }
  }
}

.view-title {
  text-align: left;
}

.component-head-menu {
  margin: 3rem 0rem 0rem !important;
}
</style>
