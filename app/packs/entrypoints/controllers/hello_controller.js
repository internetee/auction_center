import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
  }
  connect() {
    this.element.textContent = "Hello World!"
  }
}
