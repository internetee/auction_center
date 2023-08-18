// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["hiddenField", "checkboxes"];

    collect_ids() {
        if(this.hasCheckboxesTarget == false) return;

        const regx = /\d+/;
        this.hiddenFieldTarget.value = '';

        this.checkboxesTargets.forEach((el) => {
            if (el.checked == false) return;

            const element_id = el.id;
            this.hiddenFieldTarget.value += ` ${element_id.match(regx)}`
        });
    }
}
