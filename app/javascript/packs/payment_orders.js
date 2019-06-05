document.addEventListener('turbolinks:load', function() {
    setTimeout(function() {
        const form = document.getElementById('payment-order-form');
        form.submit();
    }, 1000);
});
