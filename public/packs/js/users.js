"use strict";
(self["webpackChunkauction_center"] = self["webpackChunkauction_center"] || []).push([["users"],{

/***/ "./app/packs/entrypoints/users.js":
/*!****************************************!*\
  !*** ./app/packs/entrypoints/users.js ***!
  \****************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _src_mobile_phone__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../src/mobile_phone */ "./app/packs/src/mobile_phone.js");

function setMobilePhoneInvalid() {
  var mobilePhoneField = document.getElementById('user_mobile_phone').parentElement;
  mobilePhoneField.classList.add('error');
}
function disableSubmitButton() {
  var button = document.getElementById('user_form_commit');
  button.disabled = true;
}
function enableSubmitButton() {
  var button = document.getElementById('user_form_commit');
  button.disabled = false;
}
function resetFields() {
  var mobilePhoneField = document.getElementById('user_mobile_phone').parentElement;
  mobilePhoneField.classList.remove('error');
}
function formHandler() {
  var mobilePhoneField = document.getElementById('user_mobile_phone');
  var countryCodeField = document.getElementById('user_country_code');
  resetFields();
  enableSubmitButton();
  var mobilePhone = new _src_mobile_phone__WEBPACK_IMPORTED_MODULE_0__["default"](countryCodeField.value, mobilePhoneField.value);
  if (!mobilePhone.validate()) {
    setMobilePhoneInvalid();
  } else {
    mobilePhoneField.value = mobilePhone.format();
  }
  if (document.querySelector('.error')) {
    disableSubmitButton();
  }
}
document.addEventListener('turbo:load', function () {
  var form = document.getElementById('user_form');
  var button = document.getElementById('user_form_commit');
  if (form) {
    form.addEventListener('change', formHandler);
  }
  if (button) {
    button.addEventListener('click', formHandler);
  }
});

/***/ }),

/***/ "./app/packs/src/mobile_phone.js":
/*!***************************************!*\
  !*** ./app/packs/src/mobile_phone.js ***!
  \***************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony import */ var libphonenumber_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! libphonenumber-js */ "./node_modules/libphonenumber-js/index.es6.exports/parse.js");
/* harmony import */ var libphonenumber_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! libphonenumber-js */ "./node_modules/libphonenumber-js/index.es6.exports/format.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }

var MobilePhone = /*#__PURE__*/function () {
  function MobilePhone(countryCode, mobileNumber) {
    _classCallCheck(this, MobilePhone);
    this.countryCode = countryCode;
    this.mobileNumber = mobileNumber;
    this.parsedNumber = libphonenumber_js__WEBPACK_IMPORTED_MODULE_0__.parse(this.mobileNumber, {
      extended: true,
      defaultCountry: this.countryCode
    });
  }
  _createClass(MobilePhone, [{
    key: "validate",
    value: function validate() {
      return this.parsedNumber.valid;
    }
  }, {
    key: "format",
    value: function format() {
      var formatted = libphonenumber_js__WEBPACK_IMPORTED_MODULE_1__.format(this.parsedNumber, 'E.164');
      return formatted;
    }
  }]);
  return MobilePhone;
}();
/* harmony default export */ __webpack_exports__["default"] = (MobilePhone);

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ var __webpack_exec__ = function(moduleId) { return __webpack_require__(__webpack_require__.s = moduleId); }
/******/ __webpack_require__.O(0, ["vendors-node_modules_libphonenumber-js_index_es6_exports_format_js-node_modules_libphonenumbe-79e2c3"], function() { return __webpack_exec__("./app/packs/entrypoints/users.js"); });
/******/ var __webpack_exports__ = __webpack_require__.O();
/******/ }
]);
//# sourceMappingURL=users.js.map