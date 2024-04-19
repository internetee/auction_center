import { Controller } from "@hotwired/stimulus"
import Rails from 'rails-ujs';

export default class extends Controller {
  static targets = ['input', 'validationBox']

  static values = {
    url: String
  }

  domainCheck() {
    const url = this.urlValue + `?domain_name=${this.inputTarget.value}`;
    this.validationBoxTarget.style.display = "none";
    this.validationBoxTarget.innerHTML = ''

    if (this.inputTarget.value === '') return;

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
    let divElement = document.createElement("span");
    
    while (this.validationBoxTarget.firstChild) {
      this.validationBoxTarget.removeChild(this.validationBoxTarget.firstChild);
    }

    this.validationBoxTarget.style.display = "block";

    if (data.status == "wrong") {
      divElement.textContent = data.errors;
      this.validationBoxTarget.style.color = 'red'; 
      this.validationBoxTarget.style.borderColor = 'red'; 
    } else {
      divElement.textContent = data.message;
      this.validationBoxTarget.style.color = 'green'; 
      this.validationBoxTarget.style.borderColor = 'green'; 
    }

    this.validationBoxTarget.appendChild(divElement);
  }
}
