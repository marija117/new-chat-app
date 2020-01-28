<template>
  <div class="chat messages-container">
    <div class="d-flex justify-content-center">
      <observer v-if="fromDate" @intersect="loadOldMessages()" :options="options"/>
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
                <small>
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
    current_user: {
      type: Number
    },
  },
  components: {Observer},
  data: function () {
    return {
      isEdited: false,
      options: {
        root: null,
        rootMargin: '0px',
        threshold: 1.0
      },
    }
  },
  mounted() {
    this.options.root = this.$el.querySelector(".messages-container");
  }
}
</script>