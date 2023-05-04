// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menu"]

    connect() {
      const box = document.querySelector('.dropdown-custom');

      if (box === null || box === 'undefined') return;

      document.addEventListener("click", function(event) {
        if (!event.target.closest('.dropdown-custom') && !event.target.closest('.bell-broadcast')) {
          box.style.visibility = 'hidden';
        }

        if (!event.target.closest('.dropdown-custom-mobile') && !event.target.closest('.bell-broadcast')) {
          box.style.visibility = 'hidden';
        }
      });
    }

    showMenu() {
      // const mobileBox = document.querySelector('.dropdown-custom-mobile');

      if (this.menuTarget.style.visibility === 'hidden') {
        this.menuTarget.style.visibility = 'visible';
        this.menuTarget.style.zIndex = 999999;
      } else {
        this.menuTarget.style.visibility = 'hidden';
      }
    }
}
