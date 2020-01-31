<template>
  <div>
  </div>
</template>
<script>
import { eventBus } from '../packs/application';
import consumer from "../channels/consumer";

export default {
  data() {
    return {
      rooms: [],
    }
  },
  mounted() {
    eventBus.$on('connectToRoom', (room) => {
      this.subscription(room);
    });
  },
  methods: {
    subscription(room) {
      let self = this;
      self.rooms.push(room)
      if (self.rooms.length == 1) {
        consumer.subscriptions.create(
          {
            channel: "RoomChannel",
            room: room,
          } ,{
          connected() {
            console.log("Connected to the room!" + room);
          },
          disconnected() {
            // Called when the subscription has been terminated by the server
          },
          received(data) {
            eventBus.$emit("sendMessage", data);
          }
        });
      }
    }
  }  
}
</script>