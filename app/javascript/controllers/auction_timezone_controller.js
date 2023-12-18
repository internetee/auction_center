import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { endTime: String }
  static targets = ["display"]

  connect() {
    this.updateTime()
  }

  updateTime() {
    if (!this.hasDisplayTarget) {
      return;
    }

    const endTime = new Date(this.endTimeValue)
    const userLocalTime = endTime.toLocaleString(undefined, {timeZone: Intl.DateTimeFormat().resolvedOptions().timeZone})

    this.displayTarget.textContent = userLocalTime
  }
}
