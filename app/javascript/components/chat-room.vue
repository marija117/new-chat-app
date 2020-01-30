<template>
  <div class="col">
    <room-header 
      :room="room"
      :current-user="currentUser"
      :delete-room="deleteRoom"/>
    <message-view 
      :messages="messages" 
      :current-user="currentUser" 
      :load-old-messages="loadOldMessages" 
      :from-date="fromDate" 
      :edit-message="editMessage"/>
    <message-submit 
      :on-submit="onSubmit"  
      :message="message"/>
  </div>
</template>

<script>
import messageSubmit from "./message-submit";
import messageView from "./message-view";
import roomHeader from "./room-header";

export default {
  props: {
    onSubmit: {
      type: Function
    },
    loadOldMessages: {
      type: Function
    },
    editMessage: {
      type: Function
    },
    deleteRoom: {
      type: Function
    },
    fromDate: {
      type: String
    },
    messages: {
      type: Array
    },
    message: {
      type: Object
    },
    room: {
      type: Object
    },
    currentUser: {
      type: Number
    },
    room_id:{
      type: Number
    }
  },
  data() {
    return {
    }
  },
  methods: {   
    
  },
  components: {messageSubmit, messageView, roomHeader},
}
</script>

<style lang="css">

</style>
