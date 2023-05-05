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
        if (currentPrice){
            let offerUserId = currentPrice.dataset.userId;
            let you = currentPrice.dataset.you;
            if (this.userIdValue === offerUserId){
                $(currentPrice).css("color", "green");
                $("#current_price_wrapper").css("color", "green");
                $("#current_price_wrapper").removeClass();
                $(currentPrice).find(".bidder").text("(" + you + ")");
            } else {
                $(currentPrice).css("color", "red");
                $("#current_price_wrapper").css("color", "red");
                $("#current_price_wrapper").removeClass();
            }
        }
        if (auctionRow){
            let platform = auctionRow.dataset.platform;
            $(auctionRow).find(".bid_button").text(this.bidTextValue);
            $(auctionRow).find(".auction_platform").text(this[platform + 'TextValue']);
        }
    }
}
