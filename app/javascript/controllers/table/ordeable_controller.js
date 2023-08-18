import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { direction: String, column: String, frameName: String }
  static targets = ['th']
  static classes = ['asc', 'desc']

  initialize() {
    this.classHandle = this.classHandle.bind(this);
  }

  resortTable(_event) {
    Turbo.visit('?sort=' + this.columnValue + '&direction=' + this.directionValue, { frame: this.frameNameValue });
  }

  directionValueChanged() {
    this.classHandle();
  }

  columnValueChanged() {
    this.classHandle();
  }

  classHandle() {
    if (this.directionValue == 'asc') {
      this.thTarget.classList.remove(this.ascClass);
      this.thTarget.classList.add(this.descClass);
    } else if (this.directionValue == 'desc') {
      this.thTarget.classList.add(this.ascClass);
      this.thTarget.classList.remove(this.descClass);
    } else {
      this.thTarget.classList.remove(this.ascClass);
      this.thTarget.classList.remove(this.descClass);
    }
  }
}
