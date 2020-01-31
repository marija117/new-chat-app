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
    <chatChannel/>
  </div>
</template>

<script>
import chatChannel from "./components/chat-channel";
import Rails from "@rails/ujs";
import consumer from "./channels/consumer";
import chatRoom from "./components/chat-room";
import rooms from "./components/rooms";
import { eventBus } from './packs/application';

export default {
  props: {
    room_id: {
      type: Number
    },
    currentUser: {
      type: Number
    }
  },
  components: {chatRoom, rooms, chatChannel},
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

    eventBus.$on('sendMessage', messages => {
      this.messages = messages;
    });

    consumer.subscriptions.create(
      {
        channel: "UserChannel"
      } ,{
      connected() {
        console.log("Connected to the notifications!");
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        const edit = (room) => room.id == data.room_id;
        self.rooms.find(edit).new_messages = data.new_messages;
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
    },
    getMessages() {
      Rails.ajax({
        url: "/rooms/" + this.room_id,
        type: "get",
        data: "",
        success: (data) => {
          this.messages = data.messages;
          this.room = data.room;
          eventBus.$emit("connectToChat", this.room.id, this.messages);
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
    }
  }
}
</script>
<style scoped>

</style>
