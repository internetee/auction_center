import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form", "price"]

    connect() {
        console.log('autobider submit connectes');
    }

    submitAutobider() {
        clearTimeout(this.timeout)
        
        this.timeout = setTimeout(() => {
            this.formTarget.requestSubmit()
        }, 300)
    }

    validatePrice(event) {
        const char = event.key;
        const value = this.priceTarget.value;
        if (![".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "Backspace", "Delete", "Tab", "Enter", "ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown"].includes(char) || (char == '.' && value.includes('.'))) {
            event.preventDefault();
        }
    }
}