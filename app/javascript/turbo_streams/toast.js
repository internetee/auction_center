import { StreamActions } from "@hotwired/turbo"
import Toastify from 'toastify-js'

StreamActions.toast = function() {
  const message = this.getAttribute("message")
  const position = this.getAttribute("position")
  const background = this.getAttribute("background")

  Toastify({
    text: message,
    duration: 5000,
    destination: '',
    close: true,
    gravity: 'top',
    position: position,
    stopOnFocus: true,
    offset: {
      y: '9em' // vertical axis - can be a number or a string indicating unity. eg: '2em'
    },
    style: {
      background: background,
    }
  }).showToast()
}
