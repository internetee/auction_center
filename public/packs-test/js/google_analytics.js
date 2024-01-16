(self["webpackChunkauction_center"] = self["webpackChunkauction_center"] || []).push([["google_analytics"],{

/***/ "./app/packs/entrypoints/google_analytics.js":
/*!***************************************************!*\
  !*** ./app/packs/entrypoints/google_analytics.js ***!
  \***************************************************/
/***/ (function() {

document.addEventListener('turbo:load', function (event) {
  var googleId = document.getElementById('google-tracking-id').getAttribute('data-value');
  if (googleId) {
    var gtag = function gtag() {
      dataLayer.push(arguments);
    };
    window.dataLayer = window.dataLayer || [];
    ;
    gtag('js', new Date());
    gtag('config', googleId);
    gtag('config', googleId, {
      'page_location': event.detail.url,
      'cookie_prefix': 'AuctionTest',
      'cookie_domain': 'auction.ee'
    });
  }
  ;
});

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ var __webpack_exec__ = function(moduleId) { return __webpack_require__(__webpack_require__.s = moduleId); }
/******/ var __webpack_exports__ = (__webpack_exec__("./app/packs/entrypoints/google_analytics.js"));
/******/ }
]);
//# sourceMappingURL=google_analytics.js.map