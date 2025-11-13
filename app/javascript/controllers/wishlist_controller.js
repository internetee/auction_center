import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wishlist"
export default class extends Controller {
  static targets = ["input", "submit"]

  connect() {
    // Check initial state on connect
    this.toggleSubmitButton()
  }

  domainCheck() {
    this.toggleSubmitButton()
  }

  toggleSubmitButton() {
    const inputValue = this.inputTarget.value.trim()

    if (inputValue.length > 0) {
      this.submitTarget.disabled = false
      this.submitTarget.classList.remove('c-btn--disabled')
    } else {
      this.submitTarget.disabled = true
      this.submitTarget.classList.add('c-btn--disabled')
    }
  }
}
