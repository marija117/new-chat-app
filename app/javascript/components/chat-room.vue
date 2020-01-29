<template>
  <div>
    <header/>
    <message-view 
      :messages="messages" 
      :current_user="current_user" 
      :loadOldMessages="loadOldMessages" 
      :fromDate="fromDate" 
      :editMessage="editMessage"/>
    <message-submit 
      :onSubmit="onSubmit"  
      :message="message"/>
  </div>
</template>

<script>
import messageSubmit from "./message-submit";
import messageView from "./message-view";

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
    fromDate: {
      type: String
    },
    messages: {
      type: Array
    },
    message: {
      type: Object
    },
    current_user: {
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
  components: {messageSubmit, messageView},
}
</script>

<style lang="css">

</style>
