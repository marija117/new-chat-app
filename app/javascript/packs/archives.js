import Rails from "@rails/ujs"

document.querySelector("#old_messages").onclick = function(event) {
    event.preventDefault()
    let room_id = document.querySelector("[data-channel-subscribe='chat']").getAttribute("data-room-id");
    console.log(room_id)
    
    Rails.ajax({
        url: "/rooms/" + room_id + "/old_messages",
        type: "get",
        data: "previous_archive=" + document.querySelector("#from_date").value,
        success: function(data) {
            if (data["messages"] == null) {
                document.querySelector("#old_messages").remove()
            }   
            else{
                let old_messages = data["messages"]["old_messages"]
                var html
                document.querySelector("#from_date").value = data["from_date"]

                console.log(data["from_date"])
                
                old_messages.forEach(function(msg) {
                    html = `
                    <div class="chat-message-container" id="ajax-messages">
                        <div class="row no-gutters">
                        <div class="col">
                            <div class="message-content" id="msg-element">
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
                    document.querySelector('#room_messages').insertAdjacentHTML('afterbegin', html);
                })
            }
        },
        error: function(data) {}
    })
}