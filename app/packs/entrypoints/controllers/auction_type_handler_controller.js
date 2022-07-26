// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"
import { log } from "qunit";

export default class extends Controller {

    connect() {
        console.log('auction type handler connected');
    }

    add_dropdown() {
      let selectorWrapper = document.querySelector('#auction_type_filter_wrapper');
      let auctionWithOffers = document.querySelector('#auction_with_offers');
      let selector = document.querySelector('#type');

      var value = selector.value;
        // 1 - english auction index
        if(value === '1') {
          selectorWrapper.classList.add('two', 'fields')
          auctionWithOffers.style.display = 'block';
        } else {
          selectorWrapper.classList.remove('two', 'fields')
          auctionWithOffers.style.display = 'none';
        }
    }
}
