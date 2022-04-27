import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    console.log('HEEEEEEEEEEEEEEEE');
  }
  connect() {
    this.element.textContent = "Hello World!"
  }
}
