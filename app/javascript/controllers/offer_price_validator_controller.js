import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priceInput", "submitButton"]
  static values = {
    minimumPrice: Number
  }

  connect() {
    console.log('Conntected price validation');
    
    this.validatePrice()
  }

  validatePrice() {
    const price = parseFloat(this.priceInputTarget.value)
    const minPrice = this.minimumPriceValue

    if (!this.priceInputTarget.value || isNaN(price) || price < minPrice) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.style.opacity = '0.5'
      this.submitButtonTarget.style.cursor = 'not-allowed'
    } else {
      this.submitButtonTarget.disabled = false
      this.submitButtonTarget.style.opacity = '1'
      this.submitButtonTarget.style.cursor = 'pointer'
    }
  }
}
