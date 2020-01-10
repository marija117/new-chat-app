import consumer from "./consumer"

document.addEventListener("turbolinks:load", function() {
  consumer.subscriptions.create(
    {
      channel: "UserChannel",
      user: document.querySelector("[data-channel-subscribe='user']").getAttribute("data-user-id"),
    } ,{
    connected() {
      console.log("Connected to the notifications!");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log("bilo sta")
      this.appendLine(data)
    },

    appendLine(data) {
      let elements = document.querySelectorAll("#notification")
      let room
      elements.forEach(element => getElement(element));

      function getElement(element) {
        if(element.getAttribute("data-room-id") == data["room_id"]) {
          room = element
          console.log(room)
        }
        
        // if (element.innerHTML == 0) { 
        //   console.log(element.innerHTML)
        //   element.classList.add("hidden");
        // }
      }

      const html = this.createLine(data)
      room.insertAdjacentHTML("afterend", html)
      room.remove()
    },

    createLine(data) {
      return `
        <p id="notification" data-room-id="${data["room_id"]}">${data["new_messages"]}</p>

      `
    }
  });
});