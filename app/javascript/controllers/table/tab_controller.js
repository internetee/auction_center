import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content", "payablebtn"]
  static classes = ["active"]

  initialize() {
    this.showTab = this.showTab.bind(this);
  }

  connect() {
    console.log(this.payablebtnTargets);

    if (this.payablebtnTargets.length > 0) {
      this.payablebtnTargets[0].style.display = "block"
      this.payablebtnTargets[1].style.display = "none"
    }
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

    if (this.payablebtnTargets.length > 0) {
      if (index == 0) {
        this.payablebtnTargets[0].style.display = "block"
        this.payablebtnTargets[1].style.display = "none"
      } else if (index == 1) {
        this.payablebtnTargets[1].style.display = "block"
        this.payablebtnTargets[0].style.display = "none"
      } else {
        this.payablebtnTargets[0].style.display = "none"
        this.payablebtnTargets[1].style.display = "none"
      }
    }
  }
}
