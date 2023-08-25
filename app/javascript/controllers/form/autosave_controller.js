import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form", "select"]
    static values = { 
      select: String,
    }


    connect() {
      this.selectValue = this.selectTarget.value;
    }

    save() {
      if (confirm("Are you sure?") == true) {
        this.formTarget.requestSubmit()
      } else {
        this.selectTarget.value = this.selectValue;
      }
    }
}
