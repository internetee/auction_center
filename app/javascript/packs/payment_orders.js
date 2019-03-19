document.addEventListener("turbolinks:load", function() {
    setTimeout(function() {
        let form = document.getElementById("payment-order-form");
        form.submit();
    }, 1000);
});
