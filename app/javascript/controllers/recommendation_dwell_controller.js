import { Controller } from "@hotwired/stimulus"

// Fires a `recommendation_event` when the attached element has been
// visible in the viewport for at least `dwellMs` and the page is active.
// Idempotent per session via Set tracking.
//
// Usage on an auction card:
//   data-controller="recommendation-dwell"
//   data-recommendation-dwell-auction-uuid-value="..."
//   data-recommendation-dwell-source-value="auctions#index"
//   data-recommendation-dwell-event-type-value="auction_detail_view"
//   data-recommendation-dwell-dwell-ms-value="1500"
export default class extends Controller {
  static values = {
    auctionUuid: String,
    source: { type: String, default: "card" },
    eventType: { type: String, default: "auction_detail_view" },
    dwellMs: { type: Number, default: 1500 }
  }

  connect() {
    if (!this.hasAuctionUuidValue) return
    if (typeof IntersectionObserver === "undefined") return

    this.fired = false
    this.observer = new IntersectionObserver(
      (entries) => this.handle(entries),
      { threshold: 0.5 }
    )
    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
    if (this.timerId) clearTimeout(this.timerId)
  }

  handle(entries) {
    for (const entry of entries) {
      if (entry.isIntersecting) this.startTimer()
      else this.cancelTimer()
    }
  }

  startTimer() {
    if (this.fired || this.timerId) return
    this.timerId = setTimeout(() => this.fire(), this.dwellMsValue)
  }

  cancelTimer() {
    if (this.timerId) {
      clearTimeout(this.timerId)
      this.timerId = null
    }
  }

  fire() {
    this.timerId = null
    if (this.fired || document.visibilityState !== "visible") return
    this.fired = true

    const payload = {
      recommendation_event: {
        auction_uuid: this.auctionUuidValue,
        source: this.sourceValue,
        event_type: this.eventTypeValue
      }
    }

    const data = JSON.stringify(payload)
    if (navigator.sendBeacon) {
      const blob = new Blob([data], { type: "application/json" })
      navigator.sendBeacon("/recommendation_events", blob)
      return
    }

    fetch("/recommendation_events", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": this.csrfToken()
      },
      credentials: "same-origin",
      keepalive: true,
      body: data
    }).catch(() => null)
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
  }
}
