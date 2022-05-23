import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    date: String,
    refreshInterval: { type: Number, default: 1000 },
    expiredMessage: { type: String, default: 'Auction has been ended.' },
    message: { type: String, default: "Auction will finish in <b>${days}d ${hours}h ${minutes}m ${seconds}s</b>" }
  }

  connect() {
    if (this.dateValue) {
    this.endTime = new Date(this.dateValue).getTime();

    this.update();
    this.timer = setInterval(() => {
      this.update();
    }, this.refreshIntervalValue);
  } else {
    console.log("Missing data-countdown-date-value attribute", this.element);
  }
  }

  disconnect() {
    this.stopTimer();
  }

  stopTimer() {
    if(this.timer) {
      clearInterval(this.timer);
    }
  }

  update() {
    let difference = this.timeDifference();

    if (difference < 0) {
      this.element.textContent = this.expiredMessageValue;
      this.stopTimer();
      return;
    }

    let days = Math.floor(difference / (1000 * 60 * 60 * 24));
    let hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    let minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));
    let seconds = Math.floor((difference % (1000 * 60)) / 1000);

    this.element.innerHTML = this.messageValue
                                   .replace("${days}", days)
                                   .replace("${hours}", hours)
                                   .replace("${minutes}", minutes)
                                   .replace("${seconds}", seconds)
  }

  timeDifference() {
    return this.endTime - new Date().getTime();
  }
}