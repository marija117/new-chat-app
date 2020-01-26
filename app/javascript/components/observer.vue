<template>
  <div class="observer">
    <a href="#">Load older messages</a>
  </div>
</template>

<script>
export default {
  props: ['options'],
  data() {
    return {
      observer: null,
    }
  },
  mounted() {
    const options = this.options || {};
    this.observer = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) {
        console.log("*******************intersection:ture*******************");
        this.$emit("intersect");
      }
    }, options);

    this.observer.observe(this.$el);
  },
  destroyed() {
    this.observer.disconnect();
  },
};
</script>