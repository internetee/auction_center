import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["result", "dropdown", "totalprice", "tax", "taxDescription"]
  static values = {
    template: String,
    taxTemplate: String,
    dirtyprice: Number,
    invoiceUpdateUrl: String
  }

  connect() {
    this.updateTax();
  }

  count(taxValue) {
    const tax = parseFloat(taxValue);

    // .replace('{tax}', (tax * 100.0).toFixed(2))

    let dirtypriceValue = parseFloat(this.dirtypriceValue);
    let taxAmount = dirtypriceValue * tax;

    this.taxDescriptionTarget.innerHTML = this.taxTemplateValue.replace('{tax}', (tax * 100).toFixed(2));
    this.taxTarget.innerHTML = taxAmount.toFixed(2);
    this.totalpriceTarget.innerHTML = this.templateValue.replace('{price}', (dirtypriceValue + taxAmount).toFixed(2));

    // const value = parseFloat(event.target.value)
    // const result = this.resultTarget
  
    // if (!isNaN(value) && value > 0) {
    //   const tax = parseFloat(this.taxValue) || 0.0;
    //   const taxAmount = value * tax;
    //   const totalAmount = value + taxAmount;

    //   result.innerHTML = this.templateValue.replace('{price}', totalAmount.toFixed(2)).replace('{tax}', (tax * 100.0).toFixed(2));
    // } else {
    //   result.innerHTML = this.defaulttemplateValue;
    // }
  }

  updateTax(event) {
    // let selectElement = this.element.querySelector('select');
    // this.taxValue = selectElement.options[selectElement.selectedIndex].dataset.vatRate || 0.0;
    // const priceElement = this.element.querySelector(this.priceElementValue);

    // this.count({target: priceElement});
    let taxValue = this.dropdownTarget.options[this.dropdownTarget.selectedIndex].dataset.vatRate || 0.0;
    this.count(taxValue);
  }
}
