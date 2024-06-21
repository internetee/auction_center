// Entry point for the build script in your package.json
import "./turbo_streams"
import "@hotwired/turbo-rails"
import "./controllers"

import { StreamActions } from "@hotwired/turbo"
 
Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};

document.addEventListener('DOMContentLoaded', function() {
  // Find all elements with the class 'js-close-toast'
  var closeButtons = document.querySelectorAll('.js-close-toast');
  
  closeButtons.forEach(function(closeButton) {
    closeButton.addEventListener('click', function() {
      var toast = closeButton.closest('.c-toast');
      if (toast) {
        toast.style.transition = 'opacity 0.5s ease';
        toast.style.opacity = '0';
        toast.addEventListener('transitionend', function() {
          toast.remove();
        }, { once: true });
      }
    });
  });
});