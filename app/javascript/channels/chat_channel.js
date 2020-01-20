import consumer from "./consumer"

// need to send room as param to server (subscribed method in chat_channel.rb)
document.addEventListener("turbolinks:load", function() {
  consumer.subscriptions.create(
  {
    channel: "ChatChannel",
    room: document.querySelector("[data-channel-subscribe='chat']").getAttribute("data-room-id"),
  } ,{
  connected() {
    console.log("Connected to the chat!");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // console.log(data);

    this.appendLine(data)
  },

  appendLine(data) {
    const html = this.createLine(data)
    const element = document.querySelector("[data-channel-subscribe='chat']")
    if (data["room_id"] == document.querySelector("[data-channel-subscribe='chat']").getAttribute("data-room-id")) {
      element.insertAdjacentHTML("beforeend", html)
      let msgBox = document.querySelector('.msg-box');

      msgBox.scrollTop = msgBox.scrollHeight;
    }
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