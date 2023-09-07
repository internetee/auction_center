import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    console.log('Modal connected');
  }

  open(event) {
    event.preventDefault();

    this.modalTarget.showModal();
    this.modalTarget.addEventListener('click', (e) =>  this.backdropClick(e));

    console.log('Modal opened');
  }

  close(event) {
    event.preventDefault();

    this.modalTarget.close();
    console.log('Modal close');

  }

  backdropClick(event) {
    event.target === this.modalTarget && this.close(event);
    console.log('Modal close');

  }
}
