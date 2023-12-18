import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { startTime: String, endTime: String }
  static targets = ["endtime", "starttime"]

  connect() {
    this.updateTime()
  }

  updateTime() {
    if (this.hasEndtimeTarget) {
      const endTime = new Date(this.endTimeValue)
      const userLocalTime = endTime.toLocaleString(undefined, {timeZone: Intl.DateTimeFormat().resolvedOptions().timeZone})
  
      this.endtimeTarget.textContent = userLocalTime
    }

    if (this.hasStarttimeTarget) {
      const startTime = new Date(this.startTimeValue)
      const userLocalTime = startTime.toLocaleString(undefined, {timeZone: Intl.DateTimeFormat().resolvedOptions().timeZone})
  
      this.starttimeTarget.textContent = userLocalTime
    }
  }
}
