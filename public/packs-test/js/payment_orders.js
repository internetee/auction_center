(self["webpackChunkauction_center"] = self["webpackChunkauction_center"] || []).push([["payment_orders"],{

/***/ "./app/packs/entrypoints/payment_orders.js":
/*!*************************************************!*\
  !*** ./app/packs/entrypoints/payment_orders.js ***!
  \*************************************************/
/***/ (function() {

document.addEventListener('turbo:load', function () {
  setTimeout(function () {
    var form = document.getElementById('payment-order-form');
    if (form) {
      form.submit();
    }
  }, 1000);
});

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ var __webpack_exec__ = function(moduleId) { return __webpack_require__(__webpack_require__.s = moduleId); }
/******/ var __webpack_exports__ = (__webpack_exec__("./app/packs/entrypoints/payment_orders.js"));
/******/ }
]);
//# sourceMappingURL=payment_orders.js.map