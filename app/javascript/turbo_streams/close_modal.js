import { StreamActions } from "@hotwired/turbo"

StreamActions.close_modal = function() {
  
  const modalClass = this.getAttribute("modal-class");
  const openClass = this.getAttribute("open-class");
  const formId = this.getAttribute("form-id");
  const modal = document.querySelector(`.${modalClass}`);
  const form = document.getElementById(formId);

  form.addEventListener('submit', (event) => {
    modal.classList.toggle(openClass);
  });
}
