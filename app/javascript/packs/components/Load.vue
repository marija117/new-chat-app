<template>
  <div id="app" v-if="room_id">
    <div class="d-flex flex-column" v-if="archive && messages">
        <div class="chat msg-box" data-channel-subscribe='chat' :data-room-id="room_id">
          <div class="d-flex justify-content-center">
            <div v-if="archive">
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
                          <small v-if="user_id == message.user_id">
                            <i class="fa fa-edit pointer" @click="updateMessage(message)" :data-message-content="message.message" :data-message-id="message.id"></i> |
                          </small>
                          <small v-if="edit(message)">
                            Edited |
                          </small>
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
        <div  d-flex row>
          <div class="input-group mb-3">
            <textarea class='chat-input message-field col' v-model="message"></textarea>
            <div class="input-group-append">
              <button type="submit" class='btn btn-primary col chat-input submit-message' @click="postMessage">Send</button>
            </div>
            <div v-if="message">
              <input type="hidden" :value="message.id" class="message_id">
            </div>
          </div>
           </div>
    </div>
  </div>
</template>

<script>
import Rails from "@rails/ujs"
export default {
  props: ["room_id", "user_id"],
  data: function () {
    return {
      archive: [],
      messages: [],
      message: '',
      message_id: '',
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
          self.messages = data.messages;
          self.archive = data.archive;
        },
        error: function(data) {}
      })
    },
    postMessage(e) {
      e.preventDefault();
      let self = this;
      Rails.ajax({
        url: "/rooms/" + this.room_id + "/messages", 
        type: "post",
        dataType: "json",
        contentType: "application/json",
        data: "message=" + this.message + "&message_id=" + this.message_id,
        success: function(data) {
          self.message= null;
          self.message_id = null;
        },
        error: function(data) {
        }
      })
    },
    updateMessage(message){
      this.message_id = message.id;
      this.message = message.message;
    },
    loadMessage(message) {
      let created_at = new Date(); 
      let updated_at = new Date(); 
      
      this.isEdited = updated_at.getTime() > created_at.getTime();
    }, 
    edit(message) {
      return message.updated_at > message.created_at;
    }
  }
}
</script>

<style lang="css">
</style>