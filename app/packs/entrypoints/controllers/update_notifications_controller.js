// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = {
    url: String,
  }

    update(event) {
      event.preventDefault();

      setTimeout(async () => {
        await patch(this.urlValue, {});
      }, 500)
    }
}
