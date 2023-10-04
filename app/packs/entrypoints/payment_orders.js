document.addEventListener('turbo:load', function() {
    setTimeout(function() {
        const form = document.getElementById('payment-order-form');
        if (form) {
            form.submit();
        }
    }, 1000);
});
