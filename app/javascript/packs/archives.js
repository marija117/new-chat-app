import Rails from "@rails/ujs"

document.querySelector("[data-channel-subscribe='chat']").addEventListener("load", (event) => {
    loadOlderMessages()
});


let msgBox = document.querySelector('.msg-box');
let msg = document.querySelector(".msg-element");

let options = {
    root: msgBox,
    rootMargin: '0px',
    threshold: 1.0
}

function handleIntersect(entries, observer) {
    entries.forEach((entry) => {
        if ( entry.isIntersecting ) {
            loadOlderMessages()
        }
    });
}

let observer = new IntersectionObserver(handleIntersect, options);

let target = document.querySelector('#old_messages');
if (target)
    observer.observe(target);

function loadOlderMessages() {
    let room_id = document.querySelector("[data-channel-subscribe='chat']").getAttribute("data-room-id");
    
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

function scrollToBottom() {
    msgBox.scrollTop = msgBox.scrollHeight;
}
  
scrollToBottom();

function editMessage() {
    let editIcons = document.querySelectorAll('.fa.fa-edit');
    editIcons.forEach(function(icon) {
        icon.addEventListener("click", (event) => {
            document.querySelector(".chat-input").value = icon.dataset.messageContent;
            document.querySelector(".message_id").value = icon.dataset.messageId;
        });
    });  
}

editMessage();