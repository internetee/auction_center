// app/javascript/controllers/check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["enableDeposit", "disableDeposit"];

  connect() {
        this.enableDepositTarget.addEventListener('click', (source) => {
          this.disableDepositTarget.checked = false;
        });

        this.disableDepositTarget.addEventListener('click', (source) => {
          this.enableDepositTarget.checked = false;
        });
    }
}
