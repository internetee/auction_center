import { Controller } from "@hotwired/stimulus"
import Rails from 'rails-ujs';

export default class extends Controller {
  domainCheck() {
    let wishlistInputField = document.querySelector('#wishlist_item_domain_name');
    let url = `/wishlists/domain_validities?domain_name=${wishlistInputField.value}`;

    let validationBox = document.querySelector('#validation-box');
    validationBox.style.display = "none";
    validationBox.innerHTML = ''

    if (wishlistInputField.value === '') return;

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
        Rails.ajax({
          type: 'GET',
          url: url,
          dataType: 'json',
          success: (data) => {
            this.parseResponse(data);
          }
        })
      }, 1000)
  }

  parseResponse(data) {
    let validationBox = document.querySelector('#validation-box');
    let divElement = document.createElement("span");
    validationBox.style.display = "block";

    if (data.status == "wrong") {
      divElement.textContent = data.errors;
      validationBox.style.color = 'red'; 
      validationBox.style.borderColor = 'red'; 
    } else {
      divElement.textContent = data.message;
      validationBox.style.color = 'green'; 
      validationBox.style.borderColor = 'green'; 
    }

    validationBox.appendChild(divElement);
  }
}
