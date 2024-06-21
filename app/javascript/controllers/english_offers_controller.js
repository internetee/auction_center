// app/javascript/controllers/english_offers_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { 
      userId: String,
      decimalMark: String,
      bidText: String,
      participateText: String,
      englishText: String,
      blindText: String
    }

    beforeStreamRender(e){
        var content = e.target.templateElement.content;
        var currentPrice = content.querySelector(".current_price");
        var auctionRow = content.querySelector(".auctions-table-row");
        if (currentPrice) {
            let offerUserId = currentPrice.dataset.userId;
            let you = currentPrice.dataset.you;
            if (this.values.userId === offerUserId) {
                currentPrice.style.color = "green";
                var currentPriceWrapper = document.getElementById("current_price_wrapper");
                currentPriceWrapper.style.color = "green";
                currentPriceWrapper.className = "";
                currentPrice.querySelector(".bidder").textContent = "(" + you + ")";
            } else {
                currentPrice.style.color = "red";
                var currentPriceWrapper = document.getElementById("current_price_wrapper");
                currentPriceWrapper.style.color = "red";
                currentPriceWrapper.className = "";
            }
        }
        if (auctionRow) {
            let platform = auctionRow.dataset.platform;
            auctionRow.querySelector(".bid_button").textContent = this.values.bidText;
            auctionRow.querySelector(".auction_platform").textContent = this.values[platform + 'Text'];
        }
    }
}
