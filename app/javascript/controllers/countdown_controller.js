import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    date: String
  }

  connect() {
    console.log('TTTTTTTEEE');
    this.endTime = new Date(this.dateValue).getTime();
    console.log(this.endTime);
  }
}