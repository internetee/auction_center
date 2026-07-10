import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list"]

  add(event) {
    if (event.key !== "Enter") return

    event.preventDefault()

    const value = this.normalizedValue(this.inputTarget.value)
    if (!value) return
    if (this.existingValues().includes(value)) {
      this.inputTarget.value = ""
      return
    }

    this.listTarget.insertAdjacentHTML("beforeend", this.tagHtml(value))
    this.inputTarget.value = ""
  }

  remove(event) {
    event.preventDefault()
    const tag = event.currentTarget.closest("[data-custom-interest-value]")
    if (!tag) return

    tag.remove()
  }

  existingValues() {
    return Array.from(this.listTarget.querySelectorAll("[data-custom-interest-value]"))
      .map((node) => node.dataset.customInterestValue)
  }

  normalizedValue(value) {
    return value.toString().trim().toLowerCase()
  }

  tagHtml(value) {
    const escaped = this.escapeHtml(value)
    return `
      <span class="c-badge c-badge--blue c-badge--interest" data-custom-interest-value="${escaped}">
        <span>${escaped}</span>
        <button type="button" class="c-badge__remove" data-action="form--custom-interest-tags#remove">x</button>
        <input type="hidden" name="${this.hiddenInputName()}" value="${escaped}">
      </span>
    `
  }

  hiddenInputName() {
    return this.inputTarget.dataset.hiddenInputName
  }

  escapeHtml(value) {
    return value
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;")
  }
}
