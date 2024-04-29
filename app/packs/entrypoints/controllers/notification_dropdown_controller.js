import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menu"]
    static classes = ["dropdown", "bell"]

    connect() {
      document.addEventListener("click", function(event) {
        if (!event.target.closest(this.dropdownClass) && !event.target.closest(this.bellClass) && this.hasMenuTarget) {
          this.menuTarget.style.visibility = 'hidden';
        }
      });
    }

    showNotificationMenu(_event) {
      this.menuTarget.style.visibility = (this.menuTarget.style.visibility === 'hidden' ? 'visible' : 'hidden');
      this.menuTarget.style.zIndex = (this.menuTarget.style.visibility === 'visible' ? 999999 : 0);
    }
}
