import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ['toggle']
  static targets = ['element']

  toggle() {
    this.elementTarget.classList.toggle(this.toggleClass);
  }
}
