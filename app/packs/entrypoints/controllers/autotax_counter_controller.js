import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["result"]
  static values = {
    tax: String,
    template: String,
    defaulttemplate: String
  }

  connect() {
    this.updateTax(); // обновляем значение tax при инициализации
  }

  count(event) {
    const value = parseFloat(event.target.value)
    const result = this.resultTarget
  
    if (!isNaN(value) && value > 0) {
      const tax = parseFloat(this.taxValue) || 0.0;
      const taxAmount = value * tax;
      const totalAmount = value + taxAmount;

      result.innerHTML = this.templateValue.replace('{price}', totalAmount.toFixed(2)).replace('{tax}', (tax * 100.0).toFixed(2));
    } else {
      result.innerHTML = this.defaulttemplateValue;
    }
  }

  updateTax(event) {
    let selectElement = this.element.querySelector('select');
    this.taxValue = selectElement.options[selectElement.selectedIndex].dataset.vatRate || 0.0;

    const priceElement = this.element.querySelector('[name="offer[price]"]');
    this.count({target: priceElement});
  }
}
