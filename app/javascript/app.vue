<template>
  <div>
    <chat-room 
      :onSubmit="sendMessage" 
      :editMessage="editMessage" 
      :loadOldMessages="loadOldMessages" 
      :fromDate="fromDate" 
      :current_user="current_user" 
      :messages="messages" 
      :message="message" 
      :room_id="room_id"/>
  </div>
</template>

<script>
import Rails from "@rails/ujs";
import consumer from "./channels/consumer";
import chatRoom from "./components/chat-room";

export default {
  props: ["room_id", "current_user"],
  components: {chatRoom},
   data: function () {
    return {
      messages: [],
      message: null,
      fromDate: new Date().toString(),
    }
  },
  mounted() {
    let self = this;
    this.getMessages();
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
        if (data.updated_at > data.created_at) {
          const edit = (msg) => msg.id == data.id;
          self.messages.find(edit).message = data.message;
        }
        else {
          self.messages.push(data)
        }
      }
    });
  },
  methods: {
    getMessages() {
      Rails.ajax({
        url: "/rooms/" + this.room_id,
        type: "get",
        data: "",
        success: (data) => {
          this.messages = data.messages
        },
        error: (data) => {}
      })
    },
   sendMessage(message) {
      let message_id = message.id || '';

      Rails.ajax({
        url: "/rooms/" + this.room_id + "/messages",
        type: "post",
        dataType: "json",
        contentType: "application/json",
        data: "message=" + message.message + "&message_id=" + message_id,
        success: (data) => {
          this.message = {}
        },
        error: (data) => {}
      })
    }, 
    editMessage(message) {
      this.message = message;
    },
    loadOldMessages() {      
      Rails.ajax({
        url: "/rooms/" + this.room_id + "/old_messages",
        type: "get",
        data: "previous_archive=" + this.fromDate,
        success: (data) => {
          if (data.messages) {
            this.fromDate = data.messages.from_date;
            this.messages = data.messages.old_messages.concat(this.messages);
          } else {
            this.fromDate = null;
          }
        },
        error: (data) => {}
      })
    },
    edited(message) {
      return message.updated_at > message.created_at;
    }
  },
}
</script>

<style lang="css">

</style>
