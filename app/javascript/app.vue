<template>
  <div>
    <chat-room :room_id="room_id" :current_user="current_user"/>
  </div>
</template>

<script>
import Rails from "@rails/ujs";
import chatRoom from "./components/chat-room";

export default {
  props: ["room_id", "current_user"],
  components: {chatRoom},
}
</script>

<style lang="css">

</style>
