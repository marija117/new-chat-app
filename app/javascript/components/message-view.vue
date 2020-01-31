<template>
  <div class="chat messages-container" ref="messagesContainer">
    <div class="d-flex justify-content-center">
      <observer v-if="fromDate" @intersect="loadOldMessages()" :options="options"/>
    </div>
    <div class="room_messages">
      <div v-for="(message, index) in messages" class="chat-message-container">
        <div class="row no-gutters" @change="getElement(index)">
          <div class="col d-flex">     
            <div class="message-content flex-grow-1 msg-element" :class="{ otherUser: currentUser !== message.user_id }">
              <p class="mb-1 content" :class="{ 'text-right': currentUser !== message.user_id }">
                {{ message.message }}
              </p>
              <div :class="{ 'text-right': currentUser == message.user_id }">
                <small v-if="currentUser == message.user_id && !message.archived">
                  <i class="fa fa-edit pointer" @click="editMessage(message)"></i> |
                </small>
                <small v-if="message.updated_at > message.created_at">
                  Edited |
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
import Observer from "./observer";

export default {
  props: {
    loadOldMessages: {
      type: Function
    },
    fromDate: {
      type: String
    },
    editMessage: {
      type: Function
    },
    messages: {
      type: Array
    },
    currentUser: {
      type: Number
    },
  },
  components: {Observer},
  data: function () {
    return {
      options: {
        root: null,
        rootMargin: '0px',
        threshold: 1.0
      },
    }
  },
  mounted() {
    this.options.root = this.$refs.messagesContainer;
  },
  updated() {
    let container = this.$refs.messagesContainer;
    container.scrollTop = container.scrollHeight + container.clientHeight;
  },
  methods: {
    getElement(index) {
      console.log(index);
    }
  }
}
</script>