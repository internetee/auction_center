import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    'customOptions'
  ]

  expandCustomOptions() {
    this.customOptionsTarget.style.display = this.customOptionsTarget.style.display === 'none' ? 'block' : 'none';
  }
}
