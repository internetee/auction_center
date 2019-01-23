// Semantic UI
import '../src/semantic-ui//dist/semantic.js';
import '../src/semantic-ui/src/semantic.less';

$(document).on('turbolinks:load', function() {
    $('.ui.dropdown').dropdown();

    $(window).scroll(function () {
        if (window.matchMedia("(max-width: 1024px)").matches && $(document).scrollTop() > 0) {
            $('.main-header').addClass('u-fixed');
        } else {
            $('.main-header').removeClass('u-fixed');
        }
    });
});
