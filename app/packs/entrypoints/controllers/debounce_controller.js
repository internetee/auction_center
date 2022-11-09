// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form"]

    connect() {
        console.log('debounces');
    }

    search() {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            this.formTarget.requestSubmit()
        }, 300)
    }
}
