import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.wrapZeros()
  }

  wrapZeros() {
    const text = this.element.textContent
    const wrappedText = text.replace(/0/g, '<span class="slashed-zero">0</span>')
    this.element.innerHTML = wrappedText
  }
}
