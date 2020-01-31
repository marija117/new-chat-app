<template>
  <div>
    <div class="mb-3">
      <a href="http://localhost:3000/rooms/new" class="btn btn-primary">Create a room</a>
    </div>

    <div v-if="rooms">
      <nav class="nav ">
        <div class="d-flex flex-column flex-grow-1">
          <div v-for="room in rooms" class="justify-content-between mb-2">
            <a class="nav-link room-nav-link" :href="`http://localhost:3000/rooms/${room.id}`" tooltip.hover :title="room.name">
              {{ room.name | truncate(10) }}
            </a>
            <span v-if="room.new_messages > 0" id="notification">{{ room.new_messages }}</span>
          </div>
        </div>
      </nav>
    </div>
    <div v-else>
      <div class="text-muted">
        The are no rooms
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    props: {
      rooms: {
        type: Array
      },
      currentUser: {
        type: Number
      }
    }
  }
</script>