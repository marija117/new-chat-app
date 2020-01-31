<template>
  <div>
  </div>
</template>
<script>
import { eventBus } from '../packs/application';
import consumer from "../channels/consumer";

export default {
  mounted() {
    eventBus.$on('connectNotification', () => {
      this.subscription();
    });
  },
  methods: {
    subscription() {
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
          eventBus.$emit("sendNotification", data);
        }
      });
    }
  }  
}
</script>