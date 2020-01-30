<template>
    <div>   
      <form class="input-group mb-3" @submit.prevent="onSubmit(msg)">
        <input placeholder="Write your message here" type="text" class='chat-input message-field col' v-model="msg.message"/>
        <div class="input-group-append">
          <button :disabled="!msg.message" type="submit" class='btn btn-primary col chat-input submit-message'>Send</button>
        </div>
      </form>
    </div>
</template>

<script>
export default {
  props: {
    onSubmit: {
      type: Function
    },
    message: {
      type: Object
    }
  },
  data: function () {
    return {
      msg: []
    }
  },
  watch: {
    message(){
      this.msg = this.message;
    }
  }
}
</script>