import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['element']

  expand() {
    if (this.elementTarget.style.display === "block") {
      this.elementTarget.style.display = "none";
    } else {
      this.elementTarget.style.display = "block";
    }
  }
}