// app/javascript/controllers/english_offers_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { 
      userId: String,
      decimalMark: String,
      bidText: String,
      participateText: String
    }

    beforeStreamRender(e){
        var content = e.target.templateElement.content;
        var currentPrice = content.querySelector(".current_price");
        var bidButton = content.querySelector(".bid_button");
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
        if (bidButton){
          $(bidButton).text(this.bidTextValue);
        }
    }
}
