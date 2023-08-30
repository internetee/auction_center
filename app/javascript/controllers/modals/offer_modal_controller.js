import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    classNameAttr: String
  }

  connect() {
    const modal = document.querySelector(`.${this.classNameAttrValue}`);

    modal.classList.toggle('is-open');
    document.querySelector('.js-close-modal').addEventListener('click', function() {
      modal.classList.toggle('is-open');
    });         
  }
}
