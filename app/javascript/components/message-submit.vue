<template>
    <div>   
      <form class="input-group mb-3" @submit.prevent="onSubmit(msg)">
        <input type="text" class='chat-input message-field col' v-model="msg.message"/>
        <div class="input-group-append">
          <button :disabled="!msg" type="submit" class='btn btn-primary col chat-input submit-message'>Send</button>
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
      msg: null
    }
  },
  watch: {
    message(){
      if(message){
        this.msg = this.message;
      }
    }
  }
}
</script>