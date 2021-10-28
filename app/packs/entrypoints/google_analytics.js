document.addEventListener('turbolinks:load', (event) => {
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
            'page_location': event.data.url,
            'cookie_prefix': 'AuctionTest',
            'cookie_domain': 'auction.ee',
        });
    };
});
