<template>
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
</template>


<script>
import Rails from "@rails/ujs";
import Observer from "./observer";
import { serverBus } from '../packs/application';

export default {
  props: ["room_id", "current_user"],
  components: {Observer},
  data: function () {
    return {
      messages: [],
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
    serverBus.$on('sendMessage', data => {
      this.messages.push(data)
    })
  },
  methods: {
    intersected() {      
      Rails.ajax({
        url: "/rooms/" + this.room_id + "/old_messages",
        type: "get",
        data: "previous_archive=" + this.previousArchive,
        success: (data) => {
          if (data.messages) {
            this.previousArchive = data.messages.from_date
            this.messages = data.messages.old_messages.concat(this.messages);
          } else {
            this.previousArchive = null
          }
        },
        error: (data) => {}
      })
    },
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