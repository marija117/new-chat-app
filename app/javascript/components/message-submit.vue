<template>
    <div>   
      <form class="input-group mb-3" @submit.prevent="sendMessage">
        <input type="text" class='chat-input message-field col' v-model="message.message"/>
        <div class="input-group-append">
          <button :disabled="!message.message" type="submit" class='btn btn-primary col chat-input submit-message'>Send</button>
        </div>
        <div v-if="message">
          <input type="hidden" :value="message.id" class="message_id">
        </div>
      </form>
    </div>
</template>

<script>
import Rails from "@rails/ujs";

export default {
  props: ['room_id'],
  data: function () {
    return {
      message: [],
      message_id: '',
    }
  },
  methods: {
    sendMessage() {
      Rails.ajax({
        url: "/rooms/" + this.room_id + "/messages",
        type: "post",
        dataType: "json",
        contentType: "application/json",
        data: "message=" + this.message.message + "&message_id=" + this.message_id,
        success: (data) => {
          this.message = [];
          this.message_id = '';
        },
        error: (data) => {
          console.log(this.message)
        }
      })
    }
  }
}
</script>