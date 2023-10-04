/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application
// logic in a relevant structure within app/javascript and only use these pack
// files to reference that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the
// appropriate layout file, like app/views/layouts/application.html.erb

// Default Rails javascript and turbolinks
import Rails from 'rails-ujs';
Rails.start();

require("chartkick").use(require("highcharts"))
import "@hotwired/turbo-rails"
import "./controllers"
// import "controllers"
import './stylesheets/application.scss'
import './stylesheets/transition.css'
// UI modules
import '../src/semantic/definitions/modules/transition.js';
import '../src/semantic/definitions/modules/checkbox.js';
import '../src/semantic/definitions/modules/dropdown.js';
import '../src/semantic/definitions/modules/accordion.js';
import '../src/semantic/definitions/modules/sidebar.js';
import '../src/semantic/definitions/modules/popup.js';
import '../src/semantic/semantic.less';

// Fonts
import 'typeface-raleway';

import '../entrypoints/users.js';
import '../entrypoints/wishlist_items.js'
import '../entrypoints/payment_orders.js'

$(document).on('turbo:load', function() {
    $('.ui.dropdown').dropdown();
    $('.ui.accordion').accordion();

    $('.btn-menu').on('click', function(e) {
        $('.ui.sidebar')
            .sidebar('toggle');
    });

    $(window).scroll(function() {
        if (window.matchMedia('(max-width: 1024px)').matches
            && $(document).scrollTop() > 0) {
            $('.main-header').addClass('u-fixed');
        } else {
            $('.main-header').removeClass('u-fixed');
        }
    });
});

$(document).ready(function(){
    $('.ui.accordion').accordion()});
