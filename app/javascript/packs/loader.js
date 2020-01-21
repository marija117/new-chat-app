import Rails from "@rails/ujs"

let msgBox = document.querySelector('.msg-box');
let msg = document.querySelector(".msg-element");
let messagesContainer = document.querySelector("[data-channel-subscribe='chat']");

export function loadOlderMessages() {
    let room_id = messagesContainer.getAttribute("data-room-id");
    
    Rails.ajax({
        url: "/rooms/" + room_id + "/old_messages",
        type: "get",
        data: "previous_archive=" + document.querySelector("#from_date").value,
        success: function(data) {
            if (data["messages"] == null) {
                document.querySelector("#old_messages").remove()
            }   
            else{   
                msgBox.scrollTop = msg.scrollHeight * 3;

                let old_messages = data["messages"]["old_messages"].reverse();
                var html
                document.querySelector("#from_date").value = data["from_date"]
                
                old_messages.forEach(function(msg) {
                    html = `
                    <div class="chat-message-container" id="ajax-messages">
                        <div class="row no-gutters">
                            <div class="col">
                                <div class="message-content msg-element">
                                    <p class="mb-1">` 
                                        + msg["message"] +
                                    `</p>
                                    <div class="text-right"> 
                                        <small>`
                                            + msg["created_at"] +
                                        `</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    `
                    document.querySelector('.room_messages').insertAdjacentHTML('afterbegin', html);
                })
            }
        },
        error: function(data) {}
    })
}