<template>
  <div id="app">
    <div class="chat messages-container">
      <div class="d-flex justify-content-center">
        <div v-if="previousArchive">

          <Observer @intersect="intersected" v-model="previousArchive" :options="options"/>
          
        </div>
      </div>
      <div class="room_messages">
        <div v-for="message in messages" class="chat-message-container">
          <div class="row no-gutters">
            <div class="col d-flex">     
              <div class="message-content flex-grow-1 msg-element" @load="loadMessage(message)">
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
import Rails from "@rails/ujs";
import Observer from "./observer";

export default {
  props: ["room_id", "current_user"],
  components: {Observer},
  data: function () {
    return {
      messages: [],
      message: null,
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
    sendMessage(e) {
      e.preventDefault();

      let self = this;

      Rails.ajax({
        url: "/rooms/" + this.room_id + "/messages",
        type: "post",
        dataType: "json",
        contentType: "application/json",
        data: "message=" + this.message + "&message_id=" + this.message_id,
        success: function(data) {
          self.message = null;
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
