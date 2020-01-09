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
    this.appendLine(data)
  },

  appendLine(data) {
    // const html = this.createLine(data)
    // console.log(html)
    let element = document.getElementById("p11")
    console.log(element)
    element.innerHTML = data["new_messages"]
    // element.insertAdjacentHTML("beforeend", html)
  },
 
  // createLine(data) {
  //   return `
  //   <div>
  //     <p>${data["new_messages"]}</p>
  //   </div>
  //   `
  // }
});
});