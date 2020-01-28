<template>
    <div>   
      <form class="input-group mb-3" @submit.prevent="sendMessage">
        <input type="text" class='chat-input message-field col' v-model="message"/>
        <div class="input-group-append">
          <button :disabled="!message" type="submit" class='btn btn-primary col chat-input submit-message'>Send</button>
        </div>
        <div v-if="message">
          <input type="hidden" :value="message_id" class="message_id">
        </div>
      </form>
    </div>
</template>

<script>
import Rails from "@rails/ujs";
import consumer from "../channels/consumer"
import { serverBus } from '../packs/application';

export default {
  props: ['room_id'],
  data: function () {
    return {
      message: '',
      message_id: '',
    }
  },
  mounted() {

    consumer.subscriptions.create(
      {
        channel: "ChatChannel",
        room: this.room_id,
      } ,{
      connected() {
        console.log("Connected to the chat!");
      },
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      received(data) {
        serverBus.$emit("sendMessage", data)
      }
    });
    serverBus.$on('editMessage', message => {
      console.log(message);
      this.message = message.message;
      this.message_id = message.id;
    })
  },
  methods: {
    sendMessage() {
      Rails.ajax({
        url: "/rooms/" + this.room_id + "/messages",
        type: "post",
        dataType: "json",
        contentType: "application/json",
        data: "message=" + this.message + "&message_id=" + this.message_id,
        success: (data) => {
          this.message = '';
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