import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]
  static classes = ["active"]

  initialize() {
    this.showTab = this.showTab.bind(this);
  }

  showTab(event) {
    const index = event.params.index;

    this.tabTargets.forEach((tab) => {
      tab.classList.remove(this.activeClass)
    })

    this.contentTargets.forEach((content) => {
      content.classList.remove(this.activeClass)
    })

    this.tabTargets[index].classList.add(this.activeClass)
    this.contentTargets[index].classList.add(this.activeClass)
  }
}
