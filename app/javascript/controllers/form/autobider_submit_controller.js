import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "price", "checkbox"]

  connect() {
    this.validatingInputPrice();
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  submitAutobider() {
    clearTimeout(this.timeout)

    if (parseFloat(this.priceTarget.value) <= 5.0) {
      return
    }

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 300)
  }

  validatePrice(event) {
    const char = event.key;
    const value = this.priceTarget.value;

    if (![".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Backspace", "Delete", "Tab", "Enter", "ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown"].includes(char) || (char == '.' && value.includes('.'))) {
      event.preventDefault();
    }
  }

  validatingInputPrice() {
    if (parseFloat(this.priceTarget.value) <= 5.0) {
      this.checkboxTarget.disabled = true;
    } else {
      this.checkboxTarget.disabled = false;
    }
  }
}