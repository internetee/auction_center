import { Controller } from "@hotwired/stimulus"
import { patch } from '@rails/request.js'

export default class extends Controller {
  connect() {
  }

  uploadFile() {
    this.element.submit();
  }
}
