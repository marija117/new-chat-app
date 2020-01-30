<template>
  <div v-if="room" class="d-flex row justify-content-between px-3">
    <h1>
      {{ room.name }}
    </h1>
    <div v-if="room.owner_id == currentUser">
      <a :href="`http://localhost:3000/rooms/${room.id}/edit`" class="btn btn-primary">Edit a room</a>
      <a @click="deleteRoom()" href="" class="btn btn-danger">Delete a room</a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    room: {
      type: Object
    },
    currentUser: {
      type: Number
    },
    deleteRoom: {
      type: Function
    }
  }
}
</script>