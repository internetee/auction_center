import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ['open']
  static targets = ['modal']

  connect() {
    this.modalTarget.classList.toggle(this.openClass);    
  }

  close() {
    this.modalTarget.classList.toggle(this.openClass);
  }
}
