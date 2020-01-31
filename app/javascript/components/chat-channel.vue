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
      messages: []
    }
  },
  mounted() {
    eventBus.$on('connectToChat', (room, messages) => {
      this.subscription(room);
      this.messages = messages;
    });
  },
  methods: {
    subscription(room) {
      let self = this;
      consumer.subscriptions.create(
        {
          channel: "ChatChannel",
          room: room,
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
          eventBus.$emit("sendMessage", self.messages);
        }
      });
    }
  }  
}
</script>