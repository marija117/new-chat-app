<template>
  <div class="row">
    <div class="col-12 col-md-3">
      <rooms 
        :rooms="rooms"
        :current-user="currentUser"/>
    </div>
    <chat-room 
      :on-submit="sendMessage" 
      :edit-message="editMessage" 
      :load-old-messages="loadOldMessages"
      :delete-room="deleteRoom"
      :from-date="fromDate" 
      :current-user="currentUser" 
      :messages="messages" 
      :message="message" 
      :room="room"
      :room_id="room_id"/>
  </div>
</template>

<script>
import Rails from "@rails/ujs";
import consumer from "./channels/consumer";
import chatRoom from "./components/chat-room";
import rooms from "./components/rooms";

export default {
  props: {
    room_id: {
      type: Number
    },
    currentUser: {
      type: Number
    }
  },
  components: {chatRoom, rooms},
   data: function () {
    return {
      rooms: [],
      room: null,
      messages: [],
      message: null,
      fromDate: new Date().toString()
    }
  },
  mounted() {
    let self = this;
    this.getRooms();
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
          self.messages.find(edit).updated_at = data.updated_at;
        }
        else {
          self.messages.push(data)
        }
      }
    });
  },
  methods: {
    getRooms() {
      Rails.ajax({
        url: "/rooms",
        type: "get",
        data: "",
        success: (data) => {
          this.rooms = data.rooms
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
          this.messages = data.messages;
          this.room = data.room;
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
    deleteRoom() {
      Rails.ajax({
        url: "/rooms/" + this.room_id,
        type: "delete",
        data: "",
        success: (data) => {
          this.room = null;
        },
        error: (data) => {}
      })
    }
  }
}
</script>
<style scoped>

</style>
