import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    date: String,
    refreshInterval: { type: Number, default: 1000 },
    messageTimer: String,
    defaultMessageTimer: String
  }

  static targets = [ "button" ]

  connect() {
    this.update = this.update.bind(this);

    if (this.dateValue) {
      this.endTime = new Date(this.dateValue).getTime();

      this.update();

      this.timer = setInterval(() => {
        this.update();
      }, this.refreshIntervalValue);
    } else {
      console.log("Missing data-timeleft-date-value attribute", this.element);
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
      this.stopTimer();
      this.buttonTarget.removeAttribute("disabled");
      this.buttonTarget.innerHTML = this.defaultMessageTimerValue;
    } else {
      this.buttonTarget.setAttribute("disabled", "disabled");
  
      let minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));
      let seconds = Math.floor((difference % (1000 * 60)) / 1000);
  
      let formattedSeconds = seconds < 10 ? `0${seconds}` : seconds;
  
      this.buttonTarget.innerHTML = `${this.messageTimerValue} ${minutes}:${formattedSeconds}`
    }
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