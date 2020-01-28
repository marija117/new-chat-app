<template>
  <div>
    <header :room_id="room_id"/>
    <message-view :room_id="room_id" :current_user="current_user"/>
    <message-submit :room_id="room_id"/>
  </div>
</template>

<script>
import Rails from "@rails/ujs";
import Observer from "./observer";
import messageSubmit from "./message-submit";
import messageView from "./message-view";

export default {
  props: ["room_id", "current_user"],
  components: {Observer, messageSubmit, messageView},
}
</script>

<style lang="css">

</style>
