(() => {
  // app/javascript/google_analytics.js
  document.addEventListener("turbo:load", (event) => {
    const googleId = document.getElementById("google-tracking-id").getAttribute("data-value");
    if (googleId) {
      let gtag2 = function() {
        dataLayer.push(arguments);
      };
      var gtag = gtag2;
      window.dataLayer = window.dataLayer || [];
      ;
      gtag2("js", new Date());
      gtag2("config", googleId);
      gtag2("config", googleId, {
        "page_location": event.detail.url,
        "cookie_prefix": "AuctionTest",
        "cookie_domain": "auction.ee"
      });
    }
    ;
  });
})();
//# sourceMappingURL=assets/google_analytics.js.map
