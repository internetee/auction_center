import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
  static targets = ["checkbox"];
  static values = { url: String }

  submit() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.performRequest()
    }, 300)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  performRequest() {
    const originalState = this.checkboxTarget.checked;

    const request = new FetchRequest("PATCH", this.urlValue, {
      headers: { responseKind: "turbo-stream", accept: "text/vnd.turbo-stream.html" },
      body: new FormData(this.checkboxTarget.form)
    });

    const response = request.perform();

    if (!response.ok) {
      this.checkboxTarget.checked = !originalState;
      console.error("Failed to update user profile", response)
    }
  }
}