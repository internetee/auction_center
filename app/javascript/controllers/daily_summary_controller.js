import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js'

export default class extends Controller {
  updateDailtSummary(_event) {
    clearTimeout(this.timeout)
    
    this.timeout = setTimeout(() => {
      get('/profile/toggle_subscription')
    }, 500)
  }
}
