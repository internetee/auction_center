import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "../helpers/csrf"

export default class extends Controller {
  static values = {
    auctionUuid: String,
    source: String,
    eventType: String
  }

  track() {
    if (!this.hasAuctionUuidValue) return

    fetch("/recommendation_events", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfToken()
      },
      credentials: "same-origin",
      keepalive: true,
      body: JSON.stringify({
        recommendation_event: {
          auction_uuid: this.auctionUuidValue,
          source: this.sourceValue || "ui",
          event_type: this.eventTypeValue || "auction_click"
        }
      })
    }).catch(() => null)
  }
}
