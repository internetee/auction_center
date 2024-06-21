// app/javascript/controllers/check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const checker = document.getElementById('check_all');

      console.log('check_controller.js');

        checker.addEventListener('click', (source) => {
          var checkboxes = document.querySelectorAll('[id^="auction_elements_auction_ids"]');
    
          console.log(checkboxes);

          for (var i = 0; i < checkboxes.length; i++) {
                  checkboxes[i].checked = !checkboxes[i].checked;
          }
      }); 
    }
}
