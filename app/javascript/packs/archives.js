import {loadOlderMessages} from "./loader"

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


let msgBox = document.querySelector('.msg-box');
let msg = document.querySelector(".msg-element");


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