// app/javascript/controllers/check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkboxes"]

  checkAll() {
    this.checkboxesTargets.forEach((checkbox) => {
      checkbox.checked = !checkbox.checked;
    })
  }
}
