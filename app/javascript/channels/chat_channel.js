import consumer from "./consumer"
import app from "../components/app.vue"

document.addEventListener("turbolinks:load", function() {
  let chatChannel = consumer.subscriptions.create(
  {
    channel: "ChatChannel",
    room: document.querySelector("#room").getAttribute(":room_id"),
  } ,{
  connected() {
    console.log("Connected to the chat!");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data["updated_at"] === data["created_at"]) {
      this.appendLine(data)
    } else {
      this.editMessage(data)
    }
  },

  appendLine(data) {
    const html = this.createLine(data)
    const element = document.querySelector("[data-channel-subscribe='chat']")

    if (data["room_id"] == element.getAttribute("data-room-id")) {
      element.insertAdjacentHTML("beforeend", html)
      let msgBox = document.querySelector('.messages-container');
      document.querySelector(".message-field").value = "";
      msgBox.scrollTop = msgBox.scrollHeight;
    }
  },

  editMessage(data) {
    let messages = document.querySelectorAll(".content");
    messages.forEach(function (msg) {
      if (msg.dataset.messageId == data["id"]) {
        msg.innerHTML = data["message"]
        let msgBox = document.querySelector('.messages-container');
        document.querySelector(".message-field").value = "";
        msgBox.scrollTop = msgBox.scrollHeight;
      }
    })
  },
 
  createLine(data) {
    return `
    <div class="chat-message-container">
      <div class="row no-gutters">
        <div class="col">
          <div class="message-content">
            <p class="mb-1">
              ${data["message"]}
            </p>
            <div class="text-right">
              <small v-if="user_id == message.user_id">
                <i class="fa fa-edit pointer" :data-message-content="message.message" :data-message-id="message.id"></i> |
              </small>
              <small>
                ${data["created_at"]}
              </small>
            </div>
          </div>
        </div>
      </div>
    </div>
    `
  }
});
});