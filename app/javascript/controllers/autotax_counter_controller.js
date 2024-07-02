import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["result"]
  static values = {
    tax: String,
    template: String,
    defaulttemplate: String,
    priceElement: { default: 'input[name="offer[price]"]', type: String },
  }

  connect() {
    this.updateTax();
  }

  count(event) {
    const value = parseFloat(event.target.value)
    const result = this.resultTarget
  
    if (!isNaN(value) && value > 0) {
      const tax = parseFloat(this.taxValue) || 0.0;
      const taxAmount = value * tax;
      const totalAmount = value + taxAmount;

      let tem = this.templateValue.replace('{price}', totalAmount.toFixed(2)).replace('{tax}', (tax * 100.0).toFixed(2));
      tem = tem.replace('.', ',').replace('.', ',');
      result.innerHTML = tem
    } else {
      result.innerHTML = this.defaulttemplateValue;
    }
  }

  updateTax(event) {
    let selectElement = this.element.querySelector('select');
    this.taxValue = selectElement.options[selectElement.selectedIndex].dataset.vatRate || 0.0;
    const priceElement = this.element.querySelector(this.priceElementValue);

    this.count({target: priceElement});
  }
}
