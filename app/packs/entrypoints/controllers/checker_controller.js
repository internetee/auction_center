// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["bulkactionform"]

    connect() {
        console.log(this.bulkactionformTarget);
    }

    collect_ids() {
        const r = /\d+/;
        const hiddenField = document.querySelector('#auction_elements_elements_id');
        const checkboxes = document.querySelectorAll(`[id^="auction_elements_auction_ids_"]:checked`);

        hiddenField.value = '';

        checkboxes.forEach((el) => {
            const element_id = el.id;
    
            hiddenField.value += ` ${element_id.match(r)}`
        });
    }
}
