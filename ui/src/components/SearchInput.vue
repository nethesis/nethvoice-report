<template>
  <div class="ui search">
    <sui-input
      :placeholder="placeholder"
      :value="value.title"
      @input="onInput"
      @focus="onFocus"
      @blur="onBlur"
    />
    <div
      v-show="results.length && showResults"
      :class="['results', 'transition', showResults ? 'visible' : 'hidden']"
    >
      <div
        v-for="(result, i) in results"
        :key="i"
        class="result"
        @click="selectResult(result)"
      >
        <div class="content">
          <div class="title">
            {{ result.title }}
            <span v-if="showOptionType">
              {{ result.type ? "(" + $t("search." + result.type) + ")" : "" }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    options: {
      type: Array,
      required: true,
    },
    value: {
      type: Object,
      required: false,
    },
    minCharacters: {
      type: Number,
      required: false,
      default: 1,
    },
    maxResults: {
      type: Number,
      required: false,
      default: 100,
    },
    searchFields: {
      type: Array,
      required: false,
      default: function () {
        return ["title"];
      },
    },
    showOptionType: {
      type: Boolean,
      required: false,
      default: true,
    },
    placeholder: {
      type: String,
      required: false,
      default: "",
    },
  },
  data() {
    return {
      results: [],
      showResults: false,
    };
  },
  methods: {
    search() {
      // clean query
      const cleanRegex = /[^a-zA-Z0-9]/g;
      const queryText = this.value.title.replace(cleanRegex, "");

      if (queryText.length < this.minCharacters) {
        this.results = [];
        this.showResults = false;
        return;
      }

      // search
      this.results = this.options.filter((option) => {
        // compare query text with all search fields of option
        return this.searchFields.some((searchField) => {
          if (option[searchField]) {
            return new RegExp(queryText, "i").test(
              option[searchField].replace(cleanRegex, "")
            );
          } else {
            return false;
          }
        });
      }, this);

      if (this.results.length) {
        // limit maximum number of results
        if (this.results.length > this.maxResults) {
          this.results = this.results.slice(0, this.maxResults);
        }
        this.showResults = true;
      } else {
        this.showResults = false;
      }
    },
    onInput(event) {
      // free input
      this.value.title = event;
      this.$emit("input", { title: event });
      this.search();
    },
    onFocus() {
      this.search();
    },
    onBlur() {
      this.$emit("blur");

      setTimeout(() => {
        this.showResults = false;
      }, 300);
    },
    selectResult(result) {
      this.value.title = result.title;
      this.$emit("input", result);
      this.showResults = false;
    },
  },
};
</script>

<style lang="scss" scoped>
.results {
  overflow: auto;
  max-height: 19rem;
}
</style>