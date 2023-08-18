var trackingId = document.body.getAttribute('data-google-tracking-id');
if (trackingId) {
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}

    gtag('js', new Date());
    gtag('config', trackingId);

    document.addEventListener("turbo:load", (event) => {
        gtag('config', trackingId, {
            page_location: event.detail.url,
        });
    });
}
