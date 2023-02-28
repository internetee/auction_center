// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["toggleBtn", "menu"]

    showMenu() {
      if (this.menuTarget.style.visibility === 'hidden') {
        this.menuTarget.style.visibility = 'visible';
      } else {
        this.menuTarget.style.visibility = 'hidden';
      }
    }
}
