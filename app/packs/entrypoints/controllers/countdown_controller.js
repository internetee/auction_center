import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    date: String,
    refreshInterval: { type: Number, default: 1000 },
    messageTimer: { type: String, default: "<b>${days}d ${hours}h ${minutes}m ${seconds}s</b>" }
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
      var expiredMsg = $("#timer_message").data("expiredMessage");
      $("#timer_message").html(expiredMsg);
      this.stopTimer();
      return;
    }

    let days = Math.floor(difference / (1000 * 60 * 60 * 24));
    let hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    let minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));
    let seconds = Math.floor((difference % (1000 * 60)) / 1000);

    this.element.innerHTML = this.messageTimerValue
                                .replace("${days}", days)
                                .replace("${hours}", hours)
                                .replace("${minutes}", minutes)
                                .replace("${seconds}", seconds)
  }

  timeDifference() {
    const convertedToTimeZone = this.convertDateToTimeZone(new Date().getTime(), 'Europe/Tallinn');
    return this.endTime - new Date(convertedToTimeZone).getTime();
  }

  convertDateToTimeZone(date, timeZone) {
    return new Intl.DateTimeFormat('en-US', {
      timeZone: timeZone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    }).format(date);
  }
}