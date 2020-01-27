<template>
  <div id="app">
    <div class="chat messages-container" data-channel-subscribe='chat' :data-room-id="room_id">
      <div class="d-flex justify-content-center">
        <observer v-if="previousArchive" @intersect="intersected" v-model="previousArchive" :options="options"/>
      </div>
      <div class="room_messages">
        <div v-for="message in messages" class="chat-message-container">
          <div class="row no-gutters">
            <div class="col d-flex">     
              <div class="message-content flex-grow-1 msg-element">
                <p class="mb-1 content">
                  {{ message.message }}
                </p>
                <div class="text-right">
                  <small v-if="current_user == message.user_id && message.updated_at">
                    <i class="fa fa-edit pointer" @click="editMessage(message)"></i> |
                  </small>
                  <small v-if="edited(message)">
                    Edited  |
                  </small>
                  <small>
                    {{ message.created_at | formatDate }}
                  </small>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

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
import Observer from "./observer";

export default {
  props: ["room_id", "current_user"],
  components: {Observer},
  data: function () {
    return {
      messages: [],
      message: [],
      message_id: '',
      previousArchive: new Date(),
      isEdited: false,
      options: {
        root: null,
        rootMargin: '0px',
        threshold: 1.0
      },
    }
  },
  mounted() {
    this.getMessages();
    this.options.root = this.$el.querySelector(".messages-container");
  },
  methods: {
    intersected() {
      let self = this;
      
      Rails.ajax({
        url: "/rooms/" + this.room_id + "/old_messages",
        type: "get",
        data: "previous_archive=" + this.previousArchive,
        success: function(data) {
          if (data.messages) {
            self.previousArchive = data.messages.from_date
            this.data = data.messages.from_date;
            self.messages = data.messages.old_messages.concat(self.messages);
          } else {
            self.previousArchive = null
          }
        },
        error: function(data) {}
      })
    },
    sendMessage() {
      let self = this;

      Rails.ajax({
        url: "/rooms/" + this.room_id + "/messages",
        type: "post",
        dataType: "json",
        contentType: "application/json",
        data: "message=" + this.message.message + "&message_id=" + this.message_id,
        success: function(data) {
          self.message = [];
          self.message_id = '';
        },
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
          self.messages = data.messages
        },
        error: function(data) {}
      })
    },
    editMessage(message) {
      this.message_id = message.id;
      this.message = message;
    },
    edited(message) {
      return message.updated_at > message.created_at;
    }
  }
}
</script>

<style lang="css">

</style>
