import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list", "otherToggle", "field"]

  connect() {
    this.syncVisibility()
  }

  add(event) {
    if (event.key !== "Enter") return

    event.preventDefault()

    const value = this.normalizedValue(this.inputTarget.value)
    if (!value) return
    if (this.existingValues().includes(value)) {
      this.inputTarget.value = ""
      this.syncVisibility()
      return
    }

    this.listTarget.insertAdjacentHTML("beforeend", this.tagHtml(value))
    this.inputTarget.value = ""

    if (this.hasOtherToggleTarget) {
      this.otherToggleTarget.checked = true
    }

    this.syncVisibility()
  }

  remove(event) {
    event.preventDefault()
    const tag = event.currentTarget.closest("[data-custom-interest-value]")
    if (!tag) return

    tag.remove()
    this.syncVisibility()
  }

  toggle() {
    this.syncVisibility()
  }

  syncVisibility() {
    if (!this.hasFieldTarget) return

    const shouldShow = this.hasExistingTags() || (this.hasOtherToggleTarget && this.otherToggleTarget.checked)
    this.fieldTarget.style.display = shouldShow ? "block" : "none"
  }

  hasExistingTags() {
    return this.listTarget.querySelectorAll("[data-custom-interest-value]").length > 0
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
      <span class="c-badge c-badge--blue" data-custom-interest-value="${escaped}" style="display:inline-flex; align-items:center; gap:8px; margin:4px 8px 4px 0;">
        <span>${escaped}</span>
        <button type="button" data-action="form--custom-interest-tags#remove" style="border:none; background:transparent; cursor:pointer; padding:0; line-height:1;">x</button>
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
