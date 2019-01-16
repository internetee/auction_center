/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Default Rails javascript and turbolinks
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
Rails.start();
Turbolinks.start();

// Semantic UI
import '../src/semantic-ui/semantic';

document.addEventListener("DOMContentLoaded", function() {
    $('.ui.dropdown').dropdown();

    $(window).scroll(function () {
        if (window.matchMedia("(max-width: 1024px)").matches && $(document).scrollTop() > 0) {
            $('.main-header').addClass('u-fixed');
        } else {
            $('.main-header').removeClass('u-fixed');
        }
    });
});
