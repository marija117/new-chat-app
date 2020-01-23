<template>
  <div id="app">
    <div class="chat msg-box" data-channel-subscribe='chat' data-room-id="@{{room_id}}">
      <div class="d-flex justify-content-center">
        <div v-if="messageArchive">
          <a href="#" data-previous-archive="@{{from_date}}"></a>
          
        </div>
      </div>
      <div class="room_messages">
        <div v-for="message in messages">
          <div class="chat-message-container">
            <div class="row no-gutters">
              <div class="col d-flex">     
                <div class="message-content flex-grow-1 msg-element">
                  <p class="mb-1 content" data-message-id="@{{message.id}}">
                    {{ message }}
                  </p>

                  <div class="text-right">
                    <div v-if="current_user == message.user_id">
                      <small>
                        <i class="fa fa-edit pointer" data-message-content="@{{message.message}}" data-message-id="@{{message.id}}"></i>
                      </small>
                      |
                    </div>
                    <div v-if="isEdited(message)" %>
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
        <textarea class: 'chat-input message-field' v-model="message"></textarea>
        <div class="input-group-append">
          <button class='btn btn-primary chat-input submit-message'>Send</button>
        </div>
        <input type="hidden" value="@{{ message.id }}" class="message_id" %>
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
    }
  },
  mounted() {
    this.getMessages();
  },
  methods: {
    getMessages() {
      let self = this;

      Rails.ajax({
        url: "/rooms/" + this.room_id,
        type: "get",
        data: "",
        success: function(data) {
          self.messageArchive = data.messageArchive;
          self.archive = data.archive;
        },
        error: function(data) {}
      })
    },
    idEdited(message) {
      let created_at = new Date(); 
      let updated_at = new Date(); 
      
      return updated_at.getTime() > created_at.getTime();
    }
  }

}
</script>

<style scoped>
.chat-message-container {
  padding: 5px;

  .message-content {
    padding: 5px;
    border: 1px solid rgb(18, 99, 131), 10%;
    border-radius: 5px;
    background: lighten(rgb(18, 99, 131), 10%);
    color: white;
  }
}

.hidden {
  display: none;
}

.avatar {
  max-width: 40px;
  max-height: 40px;
  border-radius: 50%;
}

.pointer {
  cursor: pointer;
}

.chat {
  background: lighten(grey, 50%);
  height: 50vh;
  border-radius: 5px 5px 0 0;
  overflow-y: auto;
}

.chat-input {
  border-top: 0 none;
  border-radius: 0 0 5px 5px;
}

.room-nav-link {
  border: 1px solid lighten(rgb(121, 204, 236), 40%);
  background: lighten(rgb(53, 116, 141), 45%);

  & + .room-nav-link {
    border-top: 0 none;
  }
}
</style>
