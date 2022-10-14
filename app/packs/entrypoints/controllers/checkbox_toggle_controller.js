// app/javascript/controllers/check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
        const firstCheckbox = document.querySelector('[data-name="first_checkbox"]');
        const secondCheckbox = document.querySelector('[data-name="second_checkbox"]');

        firstCheckbox.addEventListener('click', (source) => {
          secondCheckbox.checked = false;
        });

        secondCheckbox.addEventListener('click', (source) => {
          firstCheckbox.checked = false;
        });
    }
}
