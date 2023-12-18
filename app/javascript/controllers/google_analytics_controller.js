// app/javascript/controllers/english_offers_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const googleId = document
        .getElementById('google-tracking-id')
        .getAttribute('data-value');

    if (googleId) {
        window.dataLayer = window.dataLayer || [];
        function gtag() {
            dataLayer.push(arguments);
        };
        gtag('js', new Date());
        gtag('config', googleId);

        gtag('config', googleId, {
            'page_location': event.detail.url,
            'cookie_prefix': 'AuctionTest',
            'cookie_domain': 'auction.ee',
        });
    };

    console.log('Google Analytics controller connected...');
  }
}
