// app/javascript/controllers/check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
        console.log('Connected?');
        const enable_deposit = document.getElementById('auction_elements_enable_deposit');
        const disable_deposit = document.getElementById('auction_elements_disable_deposit');

        enable_deposit.addEventListener('click', (source) => {
          disable_deposit.checked = false;
        });

        disable_deposit.addEventListener('click', (source) => {
          enable_deposit.checked = false;
        });
    }
}
