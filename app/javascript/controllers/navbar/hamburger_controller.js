import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  static classes = ["open"]

  connect() {}

  toggle() {
    this.menuTarget.classList.toggle(this.openClass);
    this.menuTarget.style.display = this.menuTarget.classList.contains(this.openClass) ? "block" : "none";
  }

}