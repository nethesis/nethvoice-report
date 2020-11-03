<template>
  <div v-show="mustShow">
    <div v-show="showLeftScroller" @click="scrollTo('left')" class="scroller left-scroller">
      <sui-icon name="chevron left" />
    </div>
    <div v-show="showRightScroller" @click="scrollTo('right')" class="scroller right-scroller">
      <sui-icon name="chevron right" />
    </div>
  </div>
</template>

<script>

import UtilService from "../services/utils";

export default {
  name: "HorizontalScrollers",
  mixins: [UtilService],
  props: [
    "visible",
    "containerId",
    "chartData",
    "scroll"
  ],
  data: function() {
    return {
      mustShow: true,
      showLeftScroller: true,
      showRightScroller: true,
      scrollValue: this.scroll || 50,
      container: "",
      rightScroller: "",
      leftScroller: "",
      table: ""
    }
  },
  mounted () {
    this.$nextTick(() => {
      this.container = document.querySelector(this.containerId)
      this.table = this.container.querySelector("table")
      this.rightScroller = this.container.querySelector(".right-scroller")
      this.leftScroller = this.container.querySelector(".left-scroller")
      // add listner to container
      this.container.addEventListener('scroll', this.updateScrollers, true)
      // init scrollers
      this.updateVisibility()
    })
  },
  destroyed() {
    // remove event listner
    this.container.removeEventListener('scroll', this.updateScrollers);
  },
  methods: {
    scrollTo(direction) {
      direction == "right" ? (
        this.container.scrollLeft += this.scrollValue
      ) : (
        this.container.scrollLeft -= this.scrollValue
      )
      this.updateScrollers()
    },
    updateVisibility() {
      // check if scrollers are nedded
      this.table.offsetWidth > this.container.clientWidth ? this.mustShow = true : this.mustShow = false
      this.updateScrollers()
    },
    updateScrollers() {
      // update scrollers positions
      this.rightScroller.style.right = `-${this.container.scrollLeft}px`
      this.leftScroller.style.left = `${this.container.scrollLeft}px`
      // check scrolling availability
      this.showLeftScroller = this.container.scrollLeft == 0 ? false : true
      this.showRightScroller = this.table.offsetWidth <= (this.container.clientWidth + this.container.scrollLeft) ? false : true
    }
  },
  watch: {
    "chartData": function () {
      this.updateVisibility()
    }
  },
}

</script>

<style lang="scss" scoped>
.scroller {
  display: flex;
  cursor: pointer;
  position: absolute;
  top: 0;
  background: rgba(229,229,229,.70);
  border: none;
  width: 30px;
  font-size: 20px;
  color: rgba(0,0,0,.87);
  height: calc(100% - 2px);
  margin: 0px;
  margin-top: 1px;
  i {
    margin: auto;
  }
}
.right-scroller {
  right: 0;
}
.left-scroller {
  left: 0;
}
.scroller:hover {
  background: rgba(229,229,229,.85);
}
</style>