"use strict";
(self["webpackChunkauction_center"] = self["webpackChunkauction_center"] || []).push([["wishlist_items"],{

/***/ "./app/packs/entrypoints/wishlist_items.js":
/*!*************************************************!*\
  !*** ./app/packs/entrypoints/wishlist_items.js ***!
  \*************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony import */ var punycode__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! punycode */ "./node_modules/punycode/punycode.es6.js");

function formHandler() {
  var domainNameField = document.getElementById('wishlist_item_domain_name');
  domainNameField.value = punycode__WEBPACK_IMPORTED_MODULE_0__.toUnicode(domainNameField.value);
}
function createListItem(string, document) {
  var listItem = document.createElement('li');
  listItem.innerHTML = string;
  return listItem;
}
;
function onlyUnique(value, index, self) {
  return self.indexOf(value) === index;
}
function clearErrors() {
  var container = document.getElementById('errors-list');
  while (container.firstChild) {
    container.removeChild(container.firstChild);
  }
}
document.body.addEventListener('ajax:error', function (event) {
  var xhr = event.detail[0];
  var errorsBlock = document.getElementById('errors');
  var errorsList = document.getElementById('errors-list');
  var uniqueMessages = xhr.filter(onlyUnique);
  uniqueMessages.forEach(function (message) {
    var listItem = createListItem(message, document);
    errorsList.appendChild(listItem);
  });
  errorsBlock.classList.remove('hidden');
});
document.addEventListener('ajax:beforeSend', function (event) {
  var errorsBlock = document.getElementById('errors');
  errorsBlock.classList.add('hidden');
  clearErrors();
});
document.addEventListener('turbo:load', function (event) {
  var form = document.getElementById('wishlist_item_form');
  var button = document.getElementById('wishlist_item_form_commit');
  if (form) {
    form.addEventListener('change', formHandler);
  }
  if (button) {
    button.addEventListener('click', formHandler);
  }
});

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ var __webpack_exec__ = function(moduleId) { return __webpack_require__(__webpack_require__.s = moduleId); }
/******/ __webpack_require__.O(0, ["vendors-node_modules_punycode_punycode_es6_js"], function() { return __webpack_exec__("./app/packs/entrypoints/wishlist_items.js"); });
/******/ var __webpack_exports__ = __webpack_require__.O();
/******/ }
]);
//# sourceMappingURL=wishlist_items.js.map