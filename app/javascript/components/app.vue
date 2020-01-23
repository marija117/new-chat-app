<template>
  <div id="app" v-if="room_id">
    <div v-if="messageArchive">
      <div v-if="messages">
        <div class="chat msg-box" data-channel-subscribe='chat' :data-room-id="room_id">
          <div class="d-flex justify-content-center">
            <div v-if="messageArchive">

              <a href="#" :data-previous-archive="from_date">Load older messages</a>
              
            </div>
          </div>
          <div class="room_messages">
            <div v-for="message in messages">
              <div class="chat-message-container">
                <div class="row no-gutters">
                  <div class="col d-flex">     
                    <div class="message-content flex-grow-1 msg-element" v-on:load="loadMessage(message)">
                      <p class="mb-1 content" :data-message-id="message.id">
                        {{ message.message }}
                      </p>

                      <div class="text-right">
                        <div v-if="current_user == message.user_id">
                          <small>
                            <i class="fa fa-edit pointer" :data-message-content="message.message" :data-message-id="message.id"></i>
                          </small>
                          |
                        </div>
                        <div v-if="isEdited">
                          <small>
                            Edited
                          </small>
                          |
                        </div>
                        <small class="edited">
                          {{ message.created_at }}
                        </small>
                      </div>
                    </div>  
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div>
          <div class="input-group mb-3">
            <textarea class='chat-input message-field' v-model="message"></textarea>
            <div class="input-group-append">
              <button class='btn btn-primary chat-input submit-message'>Send</button>
            </div>
            <div v-if="message">
              <input type="hidden" :value="message.id" class="message_id" %>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Rails from "@rails/ujs"

export default {
  props: ["room_id", "current_user"],
  data: function () {
    return {
      messageArchive: [],
      messages: [],
      message: null,
      from_date: new Date(),
      isEdited: false,
    }
  },
  mounted() {
    this.getMessages();
  },
  computed: {
    idEdited(message) {
      let created_at = new Date(); 
      let updated_at = new Date(); 
      
      console.log("@@@@@@");
      return updated_at.getTime() > created_at.getTime();
    }
  },
  methods: {
    getMessages() {
      let self = this;

      Rails.ajax({
        url: "/rooms/" + this.room_id,
        type: "get",
        data: "",
        success: function(data) {
          console.log(self.messages)
          self.messages = data.messages;
          self.messageArchive = data.messageArchive;
          console.log(self.messages)
        },
        error: function(data) {}
      })
    },
    loadMessage(message) {
      let created_at = new Date(); 
      let updated_at = new Date(); 
      
      console.log("@@@@@@");
      this.isEdited = updated_at.getTime() > created_at.getTime();
    }
  }

}
</script>

<style lang="css">

</style>
