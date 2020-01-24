<template>
  <div id="app" v-if="room_id">
    <div class="chat msg-box" data-channel-subscribe='chat' :data-room-id="room_id">
      <div class="d-flex justify-content-center">
        <div v-if="messageArchive">

          <a href="#" :data-previous-archive="from_date">Load older messages</a>
          
        </div>
      </div>
      <div class="room_messages">
        <div v-for="message in messages" class="chat-message-container">
          <div class="row no-gutters">
            <div class="col d-flex">     
              <div class="message-content flex-grow-1 msg-element" v-on:load="loadMessage(message)">
                <p class="mb-1 content" :data-message-id="message.id">
                  {{ message.message }}
                </p>

                <div class="text-right">
                  <small v-if="current_user == message.user_id">
                    <i class="fa fa-edit pointer" @click="editMessage(message)" :data-message-content="message.message" :data-message-id="message.id"></i>
                  </small>
                  |
                  <small v-if="isEdited">
                    Edited
                  </small>
                  |
                  <small>
                    {{ message.created_at }}
                  </small>
                </div>
              </div>  
            </div>
          </div>
        </div>
      </div>
    </div>

    <form class="input-group mb-3" @submit="sendMessage">
      <textarea class='chat-input message-field' v-model="message"></textarea>
      <div class="input-group-append">
        <button type="submit" class='btn btn-primary chat-input submit-message'>Send</button>
      </div>
      <div v-if="message">
        <input type="hidden" v-model="message.id" class="message_id">
      </div>
    </form>
  </div>
</template>

<script>
import Rails from "@rails/ujs"
import consumer from "../channels/consumer"

document.addEventListener("turbolinks:load", function() {
  consumer.subscriptions.create(
    {
      channel: "ChatChannel",
      room: this.$el.querySelector("[data-channel-subscribe='chat']").getAttribute("data-room-id"),
    }
  )
});

export default {
  props: ["room_id", "current_user"],
  data: function () {
    return {
      messageArchive: [],
      messages: [],
      message: null,
      message_id: null,
      from_date: new Date(),
      isEdited: false,
    }
  },
  mounted() {
    this.getMessages();
  },
  methods: {
    sendMessage(e) {
      e.preventDefault();

      console.log();
      Rails.ajax({
        url: "/rooms/" + this.room_id + "/messages",
        type: "post",
        dataType: "json",
        contentType: "application/json",
        data: "message=" + this.message + "&message_id=" + this.message_id,
        success: function(data) {},
        error: function() {}
      })
    },
    getMessages() {
      let self = this;

      Rails.ajax({
        url: "/rooms/" + this.room_id,
        type: "get",
        data: "",
        success: function(data) {
          self.messages = data.messages;
          self.messageArchive = data.messageArchive;
        },
        error: function(data) {}
      })
    },
    editMessage(message) {
      this.message_id = message.id;
      this.message = message.message;
    },
    loadMessage(message) {
      let created_at = new Date(message.created_at); 
      let updated_at = new Date(message.updated_at); 

      this.isEdited = updated_at.getTime() > created_at.getTime();
    }
  }

}
</script>

<style lang="css">

</style>
