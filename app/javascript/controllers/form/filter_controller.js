import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "label"]

  click(event) {
    const label = event.currentTarget

    this.resetAll()
    label.classList.add('is-active')
  }

  resetAll() {
    this.buttonTargets.forEach(r => r.checked = false)
    this.labelTargets.forEach(l => l.classList.remove('is-active'))
  }
}
