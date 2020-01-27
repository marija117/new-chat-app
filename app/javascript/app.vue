import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import moment from 'moment'
import App from '../components/app.vue'
import Observer from '../components/observer.vue'

Vue.use(TurbolinksAdapter)

Vue.filter('formatDate', function(value) {
  if (value) {
    return moment(String(value)).format('MM/DD/YYYY hh:mm')
  }
});

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '[data-behavior="vue"]',
    data: () => {
      return {
        message: "Can you say hello?"
      }
    },
    components: { 
        App,
        Observer
    }
  })
})