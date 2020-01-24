import Vue from 'vue/dist/vue.esm'
import Load from './components/Load.vue'
import TurbolinksAdapter from 'vue-turbolinks'
Vue.use(TurbolinksAdapter)
Vue.component('load', Load)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#loader'
  })
})
