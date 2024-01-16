(self["webpackChunkauction_center"] = self["webpackChunkauction_center"] || []).push([["application"],{

/***/ "./app/packs/entrypoints/application.js":
/*!**********************************************!*\
  !*** ./app/packs/entrypoints/application.js ***!
  \**********************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var rails_ujs__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! rails-ujs */ "./node_modules/rails-ujs/lib/assets/compiled/rails-ujs.js");
/* harmony import */ var rails_ujs__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(rails_ujs__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var chartkick_chart_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! chartkick/chart.js */ "./node_modules/chartkick/chart.js/chart.esm.js");
/* harmony import */ var highcharts__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! highcharts */ "./node_modules/highcharts/highcharts.js");
/* harmony import */ var highcharts__WEBPACK_IMPORTED_MODULE_2___default = /*#__PURE__*/__webpack_require__.n(highcharts__WEBPACK_IMPORTED_MODULE_2__);
/* harmony import */ var _hotwired_turbo_rails__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! @hotwired/turbo-rails */ "./node_modules/@hotwired/turbo-rails/app/javascript/turbo/index.js");
/* harmony import */ var _controllers__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./controllers */ "./app/packs/entrypoints/controllers/index.js");
/* harmony import */ var _stylesheets_application_scss__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./stylesheets/application.scss */ "./app/packs/entrypoints/stylesheets/application.scss");
/* harmony import */ var _stylesheets_transition_css__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./stylesheets/transition.css */ "./app/packs/entrypoints/stylesheets/transition.css");
/* harmony import */ var _src_semantic_definitions_modules_transition_js__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ../src/semantic/definitions/modules/transition.js */ "./app/packs/src/semantic/definitions/modules/transition.js");
/* harmony import */ var _src_semantic_definitions_modules_transition_js__WEBPACK_IMPORTED_MODULE_7___default = /*#__PURE__*/__webpack_require__.n(_src_semantic_definitions_modules_transition_js__WEBPACK_IMPORTED_MODULE_7__);
/* harmony import */ var _src_semantic_definitions_modules_checkbox_js__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ../src/semantic/definitions/modules/checkbox.js */ "./app/packs/src/semantic/definitions/modules/checkbox.js");
/* harmony import */ var _src_semantic_definitions_modules_checkbox_js__WEBPACK_IMPORTED_MODULE_8___default = /*#__PURE__*/__webpack_require__.n(_src_semantic_definitions_modules_checkbox_js__WEBPACK_IMPORTED_MODULE_8__);
/* harmony import */ var _src_semantic_definitions_modules_dropdown_js__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ../src/semantic/definitions/modules/dropdown.js */ "./app/packs/src/semantic/definitions/modules/dropdown.js");
/* harmony import */ var _src_semantic_definitions_modules_dropdown_js__WEBPACK_IMPORTED_MODULE_9___default = /*#__PURE__*/__webpack_require__.n(_src_semantic_definitions_modules_dropdown_js__WEBPACK_IMPORTED_MODULE_9__);
/* harmony import */ var _src_semantic_definitions_modules_accordion_js__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ../src/semantic/definitions/modules/accordion.js */ "./app/packs/src/semantic/definitions/modules/accordion.js");
/* harmony import */ var _src_semantic_definitions_modules_accordion_js__WEBPACK_IMPORTED_MODULE_10___default = /*#__PURE__*/__webpack_require__.n(_src_semantic_definitions_modules_accordion_js__WEBPACK_IMPORTED_MODULE_10__);
/* harmony import */ var _src_semantic_definitions_modules_sidebar_js__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ../src/semantic/definitions/modules/sidebar.js */ "./app/packs/src/semantic/definitions/modules/sidebar.js");
/* harmony import */ var _src_semantic_definitions_modules_sidebar_js__WEBPACK_IMPORTED_MODULE_11___default = /*#__PURE__*/__webpack_require__.n(_src_semantic_definitions_modules_sidebar_js__WEBPACK_IMPORTED_MODULE_11__);
/* harmony import */ var _src_semantic_definitions_modules_popup_js__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! ../src/semantic/definitions/modules/popup.js */ "./app/packs/src/semantic/definitions/modules/popup.js");
/* harmony import */ var _src_semantic_definitions_modules_popup_js__WEBPACK_IMPORTED_MODULE_12___default = /*#__PURE__*/__webpack_require__.n(_src_semantic_definitions_modules_popup_js__WEBPACK_IMPORTED_MODULE_12__);
/* harmony import */ var _src_semantic_semantic_less__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! ../src/semantic/semantic.less */ "./app/packs/src/semantic/semantic.less");
/* harmony import */ var typeface_raleway__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! typeface-raleway */ "./node_modules/typeface-raleway/index.css");
/* harmony import */ var _entrypoints_users_js__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! ../entrypoints/users.js */ "./app/packs/entrypoints/users.js");
/* harmony import */ var _entrypoints_wishlist_items_js__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! ../entrypoints/wishlist_items.js */ "./app/packs/entrypoints/wishlist_items.js");
/* harmony import */ var _entrypoints_payment_orders_js__WEBPACK_IMPORTED_MODULE_17__ = __webpack_require__(/*! ../entrypoints/payment_orders.js */ "./app/packs/entrypoints/payment_orders.js");
/* harmony import */ var _entrypoints_payment_orders_js__WEBPACK_IMPORTED_MODULE_17___default = /*#__PURE__*/__webpack_require__.n(_entrypoints_payment_orders_js__WEBPACK_IMPORTED_MODULE_17__);
/* provided dependency */ var $ = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application
// logic in a relevant structure within app/javascript and only use these pack
// files to reference that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the
// appropriate layout file, like app/views/layouts/application.html.erb

// Default Rails javascript and turbolinks

rails_ujs__WEBPACK_IMPORTED_MODULE_0___default().start();




// import "controllers"


// UI modules








// Fonts




$(document).on('turbo:load', function () {
  $('.ui.dropdown').dropdown();
  $('.ui.accordion').accordion();
  $('.btn-menu').on('click', function (e) {
    $('.ui.sidebar').sidebar('toggle');
  });
  $(window).scroll(function () {
    if (window.matchMedia('(max-width: 1024px)').matches && $(document).scrollTop() > 0) {
      $('.main-header').addClass('u-fixed');
    } else {
      $('.main-header').removeClass('u-fixed');
    }
  });
});
$(document).ready(function () {
  $('.ui.accordion').accordion();
});

/***/ }),

/***/ "./app/packs/entrypoints/controllers/application.js":
/*!**********************************************************!*\
  !*** ./app/packs/entrypoints/controllers/application.js ***!
  \**********************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   application: function() { return /* binding */ application; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
/* harmony import */ var _hotwired_turbo_rails__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @hotwired/turbo-rails */ "./node_modules/@hotwired/turbo-rails/app/javascript/turbo/index.js");


_hotwired_turbo_rails__WEBPACK_IMPORTED_MODULE_1__.Turbo.session.drive = true;
var application = _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Application.start();

// Configure Stimulus development experience1
application.debug = false;
window.Stimulus = application;


/***/ }),

/***/ "./app/packs/entrypoints/controllers/auction_timezone_controller.js":
/*!**************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/auction_timezone_controller.js ***!
  \**************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      this.updateTime();
    }
  }, {
    key: "updateTime",
    value: function updateTime() {
      if (!this.hasDisplayTarget) {
        return;
      }
      var endTime = new Date(this.endTimeValue);
      var userLocalTime = endTime.toLocaleString(undefined, {
        timeZone: Intl.DateTimeFormat().resolvedOptions().timeZone
      });
      this.displayTarget.textContent = userLocalTime;
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.values = {
  endTime: String
};
_default.targets = ["display"];


/***/ }),

/***/ "./app/packs/entrypoints/controllers/auction_type_handler_controller.js":
/*!******************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/auction_type_handler_controller.js ***!
  \******************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/debounce_controller.js

// import { log } from "qunit";
var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {}
  }, {
    key: "add_dropdown",
    value: function add_dropdown() {
      var selectorWrapper = document.querySelector('#auction_type_filter_wrapper');
      var auctionWithOffers = document.querySelector('#auction_with_offers');
      var selector = document.querySelector('#type');
      var value = selector.value;
      // 1 - english auction index
      if (value === '1') {
        selectorWrapper.classList.add('two', 'fields');
        auctionWithOffers.style.display = 'block';
      } else {
        selectorWrapper.classList.remove('two', 'fields');
        auctionWithOffers.style.display = 'none';
      }
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);


/***/ }),

/***/ "./app/packs/entrypoints/controllers/autosave_controller.js":
/*!******************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/autosave_controller.js ***!
  \******************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      this.selectValue = this.selectTarget.value;
    }
  }, {
    key: "save",
    value: function save() {
      if (confirm("Are you sure?") == true) {
        this.formTarget.requestSubmit();
      } else {
        this.selectTarget.value = this.selectValue;
      }
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.targets = ["form", "select"];
_default.values = {
  select: String
};


/***/ }),

/***/ "./app/packs/entrypoints/controllers/autotax_counter_controller.js":
/*!*************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/autotax_counter_controller.js ***!
  \*************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      this.updateTax(); // обновляем значение tax при инициализации
    }
  }, {
    key: "count",
    value: function count(event) {
      var value = parseFloat(event.target.value);
      var result = this.resultTarget;
      if (!isNaN(value) && value > 0) {
        var tax = parseFloat(this.taxValue) || 0.0;
        var taxAmount = value * tax;
        var totalAmount = value + taxAmount;
        result.innerHTML = this.templateValue.replace('{price}', totalAmount.toFixed(2)).replace('{tax}', (tax * 100.0).toFixed(2));
      } else {
        result.innerHTML = this.defaulttemplateValue;
      }
    }
  }, {
    key: "updateTax",
    value: function updateTax(event) {
      var selectElement = this.element.querySelector('select');
      this.taxValue = selectElement.options[selectElement.selectedIndex].dataset.vatRate || 0.0;
      var priceElement = this.element.querySelector('[name="offer[price]"]');
      this.count({
        target: priceElement
      });
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.targets = ["result"];
_default.values = {
  tax: String,
  template: String,
  defaulttemplate: String
};


/***/ }),

/***/ "./app/packs/entrypoints/controllers/check_controller.js":
/*!***************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/check_controller.js ***!
  \***************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/check_controller.js

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "initialize",
    value: function initialize() {
      var checker = document.getElementById('check_all');
      checker.addEventListener('click', function (source) {
        var checkboxes = document.querySelectorAll('[id^="auction_elements_auction_ids"]');
        for (var i = 0; i < checkboxes.length; i++) {
          checkboxes[i].checked = !checkboxes[i].checked;
        }
      });
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);


/***/ }),

/***/ "./app/packs/entrypoints/controllers/checkbox_toggle_controller.js":
/*!*************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/checkbox_toggle_controller.js ***!
  \*************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/check_controller.js

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      var firstCheckbox = document.querySelector('[data-name="first_checkbox"]');
      var secondCheckbox = document.querySelector('[data-name="second_checkbox"]');
      firstCheckbox.addEventListener('click', function (source) {
        secondCheckbox.checked = false;
      });
      secondCheckbox.addEventListener('click', function (source) {
        firstCheckbox.checked = false;
      });
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);


/***/ }),

/***/ "./app/packs/entrypoints/controllers/checker_controller.js":
/*!*****************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/checker_controller.js ***!
  \*****************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/debounce_controller.js

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {}
  }, {
    key: "collect_ids",
    value: function collect_ids() {
      var r = /\d+/;
      var hiddenField = document.querySelector('#auction_elements_elements_id');
      var checkboxes = document.querySelectorAll("[id^=\"auction_elements_auction_ids_\"]:checked");
      hiddenField.value = '';
      checkboxes.forEach(function (el) {
        var element_id = el.id;
        hiddenField.value += " ".concat(element_id.match(r));
      });
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.targets = ["bulkactionform"];


/***/ }),

/***/ "./app/packs/entrypoints/controllers/cookie_controller.js":
/*!****************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/cookie_controller.js ***!
  \****************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "expandCustomOptions",
    value: function expandCustomOptions() {
      this.customOptionsTarget.style.display = this.customOptionsTarget.style.display === 'none' ? 'block' : 'none';
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.targets = ['customOptions'];


/***/ }),

/***/ "./app/packs/entrypoints/controllers/countdown_controller.js":
/*!*******************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/countdown_controller.js ***!
  \*******************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
/* provided dependency */ var $ = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      var _this = this;
      if (this.dateValue) {
        this.endTime = new Date(this.dateValue).getTime();

        // console.log(this.dateValue);

        this.update();
        this.timer = setInterval(function () {
          _this.update();
        }, this.refreshIntervalValue);
      } else {
        console.log("Missing data-countdown-date-value attribute", this.element);
      }
    }
  }, {
    key: "disconnect",
    value: function disconnect() {
      this.stopTimer();
    }
  }, {
    key: "stopTimer",
    value: function stopTimer() {
      if (this.timer) {
        clearInterval(this.timer);
      }
    }
  }, {
    key: "update",
    value: function update() {
      var difference = this.timeDifference();
      if (difference < 0) {
        var expiredMsg = $("#timer_message").data("expiredMessage");
        $("#timer_message").html(expiredMsg);
        this.stopTimer();
        return;
      }
      var days = Math.floor(difference / (1000 * 60 * 60 * 24));
      var hours = Math.floor(difference % (1000 * 60 * 60 * 24) / (1000 * 60 * 60));
      var minutes = Math.floor(difference % (1000 * 60 * 60) / (1000 * 60));
      var seconds = Math.floor(difference % (1000 * 60) / 1000);
      this.element.innerHTML = this.messageTimerValue.replace("${days}", days).replace("${hours}", hours).replace("${minutes}", minutes).replace("${seconds}", seconds);
    }
  }, {
    key: "timeDifference",
    value: function timeDifference() {
      var convertedToTimeZone = this.convertDateToTimeZone(new Date().getTime(), 'Europe/Tallinn');
      return this.endTime - new Date(convertedToTimeZone).getTime();
    }
  }, {
    key: "convertDateToTimeZone",
    value: function convertDateToTimeZone(date, timeZone) {
      return new Intl.DateTimeFormat('en-US', {
        timeZone: timeZone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      }).format(date);
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.values = {
  date: String,
  refreshInterval: {
    type: Number,
    "default": 1000
  },
  messageTimer: {
    type: String,
    "default": "<b>${days}d ${hours}h ${minutes}m ${seconds}s</b>"
  }
};


/***/ }),

/***/ "./app/packs/entrypoints/controllers/debounce_controller.js":
/*!******************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/debounce_controller.js ***!
  \******************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/debounce_controller.js

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {}
  }, {
    key: "search",
    value: function search() {
      var _this = this;
      clearTimeout(this.timeout);
      this.timeout = setTimeout(function () {
        _this.formTarget.requestSubmit();
      }, 300);
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.targets = ["form"];


/***/ }),

/***/ "./app/packs/entrypoints/controllers/dropdown_controller.js":
/*!******************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/dropdown_controller.js ***!
  \******************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/debounce_controller.js

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      var box = document.querySelector('.dropdown-custom');
      if (box === null || box === 'undefined') return;
      document.addEventListener("click", function (event) {
        if (!event.target.closest('.dropdown-custom') && !event.target.closest('.bell-broadcast')) {
          box.style.visibility = 'hidden';
        }
        if (!event.target.closest('.dropdown-custom-mobile') && !event.target.closest('.bell-broadcast')) {
          box.style.visibility = 'hidden';
        }
      });
    }
  }, {
    key: "showMenu",
    value: function showMenu() {
      // const mobileBox = document.querySelector('.dropdown-custom-mobile');

      if (this.menuTarget.style.visibility === 'hidden') {
        this.menuTarget.style.visibility = 'visible';
        this.menuTarget.style.zIndex = 999999;
      } else {
        this.menuTarget.style.visibility = 'hidden';
      }
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.targets = ["menu"];


/***/ }),

/***/ "./app/packs/entrypoints/controllers/english_offers_controller.js":
/*!************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/english_offers_controller.js ***!
  \************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
/* provided dependency */ var $ = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/english_offers_controller.js

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "beforeStreamRender",
    value: function beforeStreamRender(e) {
      var content = e.target.templateElement.content;
      var currentPrice = content.querySelector(".current_price");
      var auctionRow = content.querySelector(".auctions-table-row");
      if (currentPrice) {
        var offerUserId = currentPrice.dataset.userId;
        var you = currentPrice.dataset.you;
        if (this.userIdValue === offerUserId) {
          $(currentPrice).css("color", "green");
          $("#current_price_wrapper").css("color", "green");
          $("#current_price_wrapper").removeClass();
          $(currentPrice).find(".bidder").text("(" + you + ")");
        } else {
          $(currentPrice).css("color", "red");
          $("#current_price_wrapper").css("color", "red");
          $("#current_price_wrapper").removeClass();
        }
      }
      if (auctionRow) {
        var platform = auctionRow.dataset.platform;
        $(auctionRow).find(".bid_button").text(this.bidTextValue);
        $(auctionRow).find(".auction_platform").text(this[platform + 'TextValue']);
      }
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.values = {
  userId: String,
  decimalMark: String,
  bidText: String,
  participateText: String,
  englishText: String,
  blindText: String
};


/***/ }),

/***/ "./app/packs/entrypoints/controllers/hello_controller.js":
/*!***************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/hello_controller.js ***!
  \***************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "initialize",
    value: function initialize() {}
  }, {
    key: "connect",
    value: function connect() {
      this.element.textContent = "Hello World!";
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);


/***/ }),

/***/ "./app/packs/entrypoints/controllers/index.js":
/*!****************************************************!*\
  !*** ./app/packs/entrypoints/controllers/index.js ***!
  \****************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _application__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./application */ "./app/packs/entrypoints/controllers/application.js");
/* harmony import */ var _hello_controller__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./hello_controller */ "./app/packs/entrypoints/controllers/hello_controller.js");
/* harmony import */ var _debounce_controller__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./debounce_controller */ "./app/packs/entrypoints/controllers/debounce_controller.js");
/* harmony import */ var _check_controller__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./check_controller */ "./app/packs/entrypoints/controllers/check_controller.js");
/* harmony import */ var _submitter_controller__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./submitter_controller */ "./app/packs/entrypoints/controllers/submitter_controller.js");
/* harmony import */ var _checker_controller__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./checker_controller */ "./app/packs/entrypoints/controllers/checker_controller.js");
/* harmony import */ var _countdown_controller__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./countdown_controller */ "./app/packs/entrypoints/controllers/countdown_controller.js");
/* harmony import */ var _wishlist_controller__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./wishlist_controller */ "./app/packs/entrypoints/controllers/wishlist_controller.js");
/* harmony import */ var _auction_type_handler_controller__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./auction_type_handler_controller */ "./app/packs/entrypoints/controllers/auction_type_handler_controller.js");
/* harmony import */ var _checkbox_toggle_controller__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ./checkbox_toggle_controller */ "./app/packs/entrypoints/controllers/checkbox_toggle_controller.js");
/* harmony import */ var _autosave_controller__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ./autosave_controller */ "./app/packs/entrypoints/controllers/autosave_controller.js");
/* harmony import */ var _dropdown_controller__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ./dropdown_controller */ "./app/packs/entrypoints/controllers/dropdown_controller.js");
/* harmony import */ var _update_notifications_controller__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! ./update_notifications_controller */ "./app/packs/entrypoints/controllers/update_notifications_controller.js");
/* harmony import */ var _notificable_handler_controller__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! ./notificable_handler_controller */ "./app/packs/entrypoints/controllers/notificable_handler_controller.js");
/* harmony import */ var _push_notification_controller__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! ./push_notification_controller */ "./app/packs/entrypoints/controllers/push_notification_controller.js");
/* harmony import */ var _profile_webpush_controller__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! ./profile_webpush_controller */ "./app/packs/entrypoints/controllers/profile_webpush_controller.js");
/* harmony import */ var _english_offers_controller__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! ./english_offers_controller */ "./app/packs/entrypoints/controllers/english_offers_controller.js");
/* harmony import */ var _autotax_counter_controller__WEBPACK_IMPORTED_MODULE_17__ = __webpack_require__(/*! ./autotax_counter_controller */ "./app/packs/entrypoints/controllers/autotax_counter_controller.js");
/* harmony import */ var _cookie_controller__WEBPACK_IMPORTED_MODULE_18__ = __webpack_require__(/*! ./cookie_controller */ "./app/packs/entrypoints/controllers/cookie_controller.js");
/* harmony import */ var _auction_timezone_controller__WEBPACK_IMPORTED_MODULE_19__ = __webpack_require__(/*! ./auction_timezone_controller */ "./app/packs/entrypoints/controllers/auction_timezone_controller.js");
// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName


// import Rails from "@rails/ujs"


_application__WEBPACK_IMPORTED_MODULE_0__.application.register("hello", _hello_controller__WEBPACK_IMPORTED_MODULE_1__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("debounce", _debounce_controller__WEBPACK_IMPORTED_MODULE_2__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("check", _check_controller__WEBPACK_IMPORTED_MODULE_3__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("submitter", _submitter_controller__WEBPACK_IMPORTED_MODULE_4__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("checker", _checker_controller__WEBPACK_IMPORTED_MODULE_5__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("countdown", _countdown_controller__WEBPACK_IMPORTED_MODULE_6__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("wishlist", _wishlist_controller__WEBPACK_IMPORTED_MODULE_7__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("auction_type_handler", _auction_type_handler_controller__WEBPACK_IMPORTED_MODULE_8__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("checkbox_toggle", _checkbox_toggle_controller__WEBPACK_IMPORTED_MODULE_9__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("autosave", _autosave_controller__WEBPACK_IMPORTED_MODULE_10__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("dropdown", _dropdown_controller__WEBPACK_IMPORTED_MODULE_11__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("update_notifications", _update_notifications_controller__WEBPACK_IMPORTED_MODULE_12__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("notificable_handler", _notificable_handler_controller__WEBPACK_IMPORTED_MODULE_13__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("push-notification", _push_notification_controller__WEBPACK_IMPORTED_MODULE_14__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("profile-webpush", _profile_webpush_controller__WEBPACK_IMPORTED_MODULE_15__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("english-offers", _english_offers_controller__WEBPACK_IMPORTED_MODULE_16__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("autotax-counter", _autotax_counter_controller__WEBPACK_IMPORTED_MODULE_17__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("cookie", _cookie_controller__WEBPACK_IMPORTED_MODULE_18__["default"]);

_application__WEBPACK_IMPORTED_MODULE_0__.application.register("auction-timezone", _auction_timezone_controller__WEBPACK_IMPORTED_MODULE_19__["default"]);

/***/ }),

/***/ "./app/packs/entrypoints/controllers/notificable_handler_controller.js":
/*!*****************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/notificable_handler_controller.js ***!
  \*****************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/debounce_controller.js

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "notificationTargetConnected",
    value: function notificationTargetConnected(target) {
      var el = target.querySelector('#flash');
      var text = el.textContent;
      var textTemaplate = target.parentNode.dataset.outbidMessage;
      var parsedText = text.split(', ');
      if (parsedText[0] === 'websocket_domain_name') {
        el.textContent = textTemaplate.replace(/{domain_name}/g, parsedText[1]);
      }
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);


/***/ }),

/***/ "./app/packs/entrypoints/controllers/profile_webpush_controller.js":
/*!*************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/profile_webpush_controller.js ***!
  \*************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      var _this = this;
      if ('serviceWorker' in navigator && 'PushManager' in window) {
        navigator.serviceWorker.ready.then(function (registration) {
          registration.pushManager.getSubscription().then(function (subscription) {
            if (subscription) {
              _this.buttonTarget.style.disabled = true;
              _this.buttonTarget.classList.add('disabled');
            }
          });
        });
      }
    }
  }, {
    key: "setupPushNotifications",
    value: function setupPushNotifications() {
      var _this2 = this;
      var applicationServerKey = this.urlBase64ToUint8Array(this.vapidPublicValue);
      navigator.serviceWorker.register("/service-worker.js", {
        scope: "./"
      }).then(function (registration) {
        registration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: applicationServerKey
        }).then(function (subscription) {
          var endpoint = subscription.endpoint;
          var p256dh = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('p256dh'))));
          var auth = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('auth'))));
          fetch('/push_subscriptions', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({
              subscription: {
                endpoint: endpoint,
                p256dh: p256dh,
                auth: auth
              }
            })
          });
          localStorage.setItem('block-webpush-modal', 'true');
          document.querySelector('.webpush-modal').style.display = 'none';
          _this2.buttonTarget.style.disabled = true;
          _this2.buttonTarget.classList.add('disabled');
        });
      });
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.values = {
  vapidPublic: String
};
_default.targets = ["button"];


/***/ }),

/***/ "./app/packs/entrypoints/controllers/push_notification_controller.js":
/*!***************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/push_notification_controller.js ***!
  \***************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {
      var _this = this;
      if (!this.userLoginValue) return;
      var subscribed = localStorage.getItem('block-webpush-modal');
      if (subscribed === 'true') {
        document.querySelector('.webpush-modal').style.display = 'none';
      }
      if ('serviceWorker' in navigator && 'PushManager' in window) {
        navigator.serviceWorker.ready.then(function (registration) {
          registration.pushManager.getSubscription().then(function (subscription) {
            if (!subscription) {
              if (Notification.permission === 'granted') {
                _this.setupPushNotifications();
              } else {
                _this.requestPermission();
              }
            }
          });
        });
      }
    }
  }, {
    key: "requestPermission",
    value: function requestPermission() {
      var _this2 = this;
      window.addEventListener('load', function () {
        Notification.requestPermission().then(function (permission) {
          if (permission === 'granted') {
            _this2.setupPushNotifications(applicationServerKey);
          }
        });
      });
    }
  }, {
    key: "setupPushNotifications",
    value: function setupPushNotifications() {
      var applicationServerKey = this.urlBase64ToUint8Array(this.vapidPublicValue);
      console.log(this.vapidPublicValue);
      navigator.serviceWorker.register("/service-worker.js", {
        scope: "./"
      }).then(function (registration) {
        console.log('Service Worker registered successfully:', registration);
        registration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: applicationServerKey
        }).then(function (subscription) {
          var endpoint = subscription.endpoint;
          var p256dh = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('p256dh'))));
          var auth = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('auth'))));
          fetch('/push_subscriptions', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({
              subscription: {
                endpoint: endpoint,
                p256dh: p256dh,
                auth: auth
              }
            })
          });
          localStorage.setItem('block-webpush-modal', 'true');
          document.querySelector('.webpush-modal').style.display = 'none';
        });
      })["catch"](function (err) {
        console.log('Service Worker registration failed:', err);
      });
      ;
    }
  }, {
    key: "close",
    value: function close() {
      document.querySelector('.webpush-modal').style.display = 'none';
    }
  }, {
    key: "decline",
    value: function decline() {
      localStorage.setItem('block-webpush-modal', 'true');
      document.querySelector('.webpush-modal').style.display = 'none';
    }
  }, {
    key: "urlBase64ToUint8Array",
    value: function urlBase64ToUint8Array(base64String) {
      var padding = '='.repeat((4 - base64String.length % 4) % 4);
      var base64 = (base64String + padding).replace(/\-/g, '+').replace(/_/g, '/');
      var rawData = window.atob(base64);
      var outputArray = new Uint8Array(rawData.length);
      for (var i = 0; i < rawData.length; ++i) {
        outputArray[i] = rawData.charCodeAt(i);
      }
      return outputArray;
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.values = {
  vapidPublic: String,
  userLogin: Boolean
};


/***/ }),

/***/ "./app/packs/entrypoints/controllers/submitter_controller.js":
/*!*******************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/submitter_controller.js ***!
  \*******************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
/* harmony import */ var _rails_request_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @rails/request.js */ "./node_modules/@rails/request.js/src/index.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }


var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {}
  }, {
    key: "uploadFile",
    value: function uploadFile() {
      this.element.submit();
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);


/***/ }),

/***/ "./app/packs/entrypoints/controllers/update_notifications_controller.js":
/*!******************************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/update_notifications_controller.js ***!
  \******************************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
/* harmony import */ var _rails_request_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @rails/request.js */ "./node_modules/@rails/request.js/src/index.js");
function _regeneratorRuntime() { "use strict"; /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/facebook/regenerator/blob/main/LICENSE */ _regeneratorRuntime = function _regeneratorRuntime() { return exports; }; var exports = {}, Op = Object.prototype, hasOwn = Op.hasOwnProperty, defineProperty = Object.defineProperty || function (obj, key, desc) { obj[key] = desc.value; }, $Symbol = "function" == typeof Symbol ? Symbol : {}, iteratorSymbol = $Symbol.iterator || "@@iterator", asyncIteratorSymbol = $Symbol.asyncIterator || "@@asyncIterator", toStringTagSymbol = $Symbol.toStringTag || "@@toStringTag"; function define(obj, key, value) { return Object.defineProperty(obj, key, { value: value, enumerable: !0, configurable: !0, writable: !0 }), obj[key]; } try { define({}, ""); } catch (err) { define = function define(obj, key, value) { return obj[key] = value; }; } function wrap(innerFn, outerFn, self, tryLocsList) { var protoGenerator = outerFn && outerFn.prototype instanceof Generator ? outerFn : Generator, generator = Object.create(protoGenerator.prototype), context = new Context(tryLocsList || []); return defineProperty(generator, "_invoke", { value: makeInvokeMethod(innerFn, self, context) }), generator; } function tryCatch(fn, obj, arg) { try { return { type: "normal", arg: fn.call(obj, arg) }; } catch (err) { return { type: "throw", arg: err }; } } exports.wrap = wrap; var ContinueSentinel = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} var IteratorPrototype = {}; define(IteratorPrototype, iteratorSymbol, function () { return this; }); var getProto = Object.getPrototypeOf, NativeIteratorPrototype = getProto && getProto(getProto(values([]))); NativeIteratorPrototype && NativeIteratorPrototype !== Op && hasOwn.call(NativeIteratorPrototype, iteratorSymbol) && (IteratorPrototype = NativeIteratorPrototype); var Gp = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(IteratorPrototype); function defineIteratorMethods(prototype) { ["next", "throw", "return"].forEach(function (method) { define(prototype, method, function (arg) { return this._invoke(method, arg); }); }); } function AsyncIterator(generator, PromiseImpl) { function invoke(method, arg, resolve, reject) { var record = tryCatch(generator[method], generator, arg); if ("throw" !== record.type) { var result = record.arg, value = result.value; return value && "object" == typeof value && hasOwn.call(value, "__await") ? PromiseImpl.resolve(value.__await).then(function (value) { invoke("next", value, resolve, reject); }, function (err) { invoke("throw", err, resolve, reject); }) : PromiseImpl.resolve(value).then(function (unwrapped) { result.value = unwrapped, resolve(result); }, function (error) { return invoke("throw", error, resolve, reject); }); } reject(record.arg); } var previousPromise; defineProperty(this, "_invoke", { value: function value(method, arg) { function callInvokeWithMethodAndArg() { return new PromiseImpl(function (resolve, reject) { invoke(method, arg, resolve, reject); }); } return previousPromise = previousPromise ? previousPromise.then(callInvokeWithMethodAndArg, callInvokeWithMethodAndArg) : callInvokeWithMethodAndArg(); } }); } function makeInvokeMethod(innerFn, self, context) { var state = "suspendedStart"; return function (method, arg) { if ("executing" === state) throw new Error("Generator is already running"); if ("completed" === state) { if ("throw" === method) throw arg; return doneResult(); } for (context.method = method, context.arg = arg;;) { var delegate = context.delegate; if (delegate) { var delegateResult = maybeInvokeDelegate(delegate, context); if (delegateResult) { if (delegateResult === ContinueSentinel) continue; return delegateResult; } } if ("next" === context.method) context.sent = context._sent = context.arg;else if ("throw" === context.method) { if ("suspendedStart" === state) throw state = "completed", context.arg; context.dispatchException(context.arg); } else "return" === context.method && context.abrupt("return", context.arg); state = "executing"; var record = tryCatch(innerFn, self, context); if ("normal" === record.type) { if (state = context.done ? "completed" : "suspendedYield", record.arg === ContinueSentinel) continue; return { value: record.arg, done: context.done }; } "throw" === record.type && (state = "completed", context.method = "throw", context.arg = record.arg); } }; } function maybeInvokeDelegate(delegate, context) { var methodName = context.method, method = delegate.iterator[methodName]; if (undefined === method) return context.delegate = null, "throw" === methodName && delegate.iterator["return"] && (context.method = "return", context.arg = undefined, maybeInvokeDelegate(delegate, context), "throw" === context.method) || "return" !== methodName && (context.method = "throw", context.arg = new TypeError("The iterator does not provide a '" + methodName + "' method")), ContinueSentinel; var record = tryCatch(method, delegate.iterator, context.arg); if ("throw" === record.type) return context.method = "throw", context.arg = record.arg, context.delegate = null, ContinueSentinel; var info = record.arg; return info ? info.done ? (context[delegate.resultName] = info.value, context.next = delegate.nextLoc, "return" !== context.method && (context.method = "next", context.arg = undefined), context.delegate = null, ContinueSentinel) : info : (context.method = "throw", context.arg = new TypeError("iterator result is not an object"), context.delegate = null, ContinueSentinel); } function pushTryEntry(locs) { var entry = { tryLoc: locs[0] }; 1 in locs && (entry.catchLoc = locs[1]), 2 in locs && (entry.finallyLoc = locs[2], entry.afterLoc = locs[3]), this.tryEntries.push(entry); } function resetTryEntry(entry) { var record = entry.completion || {}; record.type = "normal", delete record.arg, entry.completion = record; } function Context(tryLocsList) { this.tryEntries = [{ tryLoc: "root" }], tryLocsList.forEach(pushTryEntry, this), this.reset(!0); } function values(iterable) { if (iterable) { var iteratorMethod = iterable[iteratorSymbol]; if (iteratorMethod) return iteratorMethod.call(iterable); if ("function" == typeof iterable.next) return iterable; if (!isNaN(iterable.length)) { var i = -1, next = function next() { for (; ++i < iterable.length;) if (hasOwn.call(iterable, i)) return next.value = iterable[i], next.done = !1, next; return next.value = undefined, next.done = !0, next; }; return next.next = next; } } return { next: doneResult }; } function doneResult() { return { value: undefined, done: !0 }; } return GeneratorFunction.prototype = GeneratorFunctionPrototype, defineProperty(Gp, "constructor", { value: GeneratorFunctionPrototype, configurable: !0 }), defineProperty(GeneratorFunctionPrototype, "constructor", { value: GeneratorFunction, configurable: !0 }), GeneratorFunction.displayName = define(GeneratorFunctionPrototype, toStringTagSymbol, "GeneratorFunction"), exports.isGeneratorFunction = function (genFun) { var ctor = "function" == typeof genFun && genFun.constructor; return !!ctor && (ctor === GeneratorFunction || "GeneratorFunction" === (ctor.displayName || ctor.name)); }, exports.mark = function (genFun) { return Object.setPrototypeOf ? Object.setPrototypeOf(genFun, GeneratorFunctionPrototype) : (genFun.__proto__ = GeneratorFunctionPrototype, define(genFun, toStringTagSymbol, "GeneratorFunction")), genFun.prototype = Object.create(Gp), genFun; }, exports.awrap = function (arg) { return { __await: arg }; }, defineIteratorMethods(AsyncIterator.prototype), define(AsyncIterator.prototype, asyncIteratorSymbol, function () { return this; }), exports.AsyncIterator = AsyncIterator, exports.async = function (innerFn, outerFn, self, tryLocsList, PromiseImpl) { void 0 === PromiseImpl && (PromiseImpl = Promise); var iter = new AsyncIterator(wrap(innerFn, outerFn, self, tryLocsList), PromiseImpl); return exports.isGeneratorFunction(outerFn) ? iter : iter.next().then(function (result) { return result.done ? result.value : iter.next(); }); }, defineIteratorMethods(Gp), define(Gp, toStringTagSymbol, "Generator"), define(Gp, iteratorSymbol, function () { return this; }), define(Gp, "toString", function () { return "[object Generator]"; }), exports.keys = function (val) { var object = Object(val), keys = []; for (var key in object) keys.push(key); return keys.reverse(), function next() { for (; keys.length;) { var key = keys.pop(); if (key in object) return next.value = key, next.done = !1, next; } return next.done = !0, next; }; }, exports.values = values, Context.prototype = { constructor: Context, reset: function reset(skipTempReset) { if (this.prev = 0, this.next = 0, this.sent = this._sent = undefined, this.done = !1, this.delegate = null, this.method = "next", this.arg = undefined, this.tryEntries.forEach(resetTryEntry), !skipTempReset) for (var name in this) "t" === name.charAt(0) && hasOwn.call(this, name) && !isNaN(+name.slice(1)) && (this[name] = undefined); }, stop: function stop() { this.done = !0; var rootRecord = this.tryEntries[0].completion; if ("throw" === rootRecord.type) throw rootRecord.arg; return this.rval; }, dispatchException: function dispatchException(exception) { if (this.done) throw exception; var context = this; function handle(loc, caught) { return record.type = "throw", record.arg = exception, context.next = loc, caught && (context.method = "next", context.arg = undefined), !!caught; } for (var i = this.tryEntries.length - 1; i >= 0; --i) { var entry = this.tryEntries[i], record = entry.completion; if ("root" === entry.tryLoc) return handle("end"); if (entry.tryLoc <= this.prev) { var hasCatch = hasOwn.call(entry, "catchLoc"), hasFinally = hasOwn.call(entry, "finallyLoc"); if (hasCatch && hasFinally) { if (this.prev < entry.catchLoc) return handle(entry.catchLoc, !0); if (this.prev < entry.finallyLoc) return handle(entry.finallyLoc); } else if (hasCatch) { if (this.prev < entry.catchLoc) return handle(entry.catchLoc, !0); } else { if (!hasFinally) throw new Error("try statement without catch or finally"); if (this.prev < entry.finallyLoc) return handle(entry.finallyLoc); } } } }, abrupt: function abrupt(type, arg) { for (var i = this.tryEntries.length - 1; i >= 0; --i) { var entry = this.tryEntries[i]; if (entry.tryLoc <= this.prev && hasOwn.call(entry, "finallyLoc") && this.prev < entry.finallyLoc) { var finallyEntry = entry; break; } } finallyEntry && ("break" === type || "continue" === type) && finallyEntry.tryLoc <= arg && arg <= finallyEntry.finallyLoc && (finallyEntry = null); var record = finallyEntry ? finallyEntry.completion : {}; return record.type = type, record.arg = arg, finallyEntry ? (this.method = "next", this.next = finallyEntry.finallyLoc, ContinueSentinel) : this.complete(record); }, complete: function complete(record, afterLoc) { if ("throw" === record.type) throw record.arg; return "break" === record.type || "continue" === record.type ? this.next = record.arg : "return" === record.type ? (this.rval = this.arg = record.arg, this.method = "return", this.next = "end") : "normal" === record.type && afterLoc && (this.next = afterLoc), ContinueSentinel; }, finish: function finish(finallyLoc) { for (var i = this.tryEntries.length - 1; i >= 0; --i) { var entry = this.tryEntries[i]; if (entry.finallyLoc === finallyLoc) return this.complete(entry.completion, entry.afterLoc), resetTryEntry(entry), ContinueSentinel; } }, "catch": function _catch(tryLoc) { for (var i = this.tryEntries.length - 1; i >= 0; --i) { var entry = this.tryEntries[i]; if (entry.tryLoc === tryLoc) { var record = entry.completion; if ("throw" === record.type) { var thrown = record.arg; resetTryEntry(entry); } return thrown; } } throw new Error("illegal catch attempt"); }, delegateYield: function delegateYield(iterable, resultName, nextLoc) { return this.delegate = { iterator: values(iterable), resultName: resultName, nextLoc: nextLoc }, "next" === this.method && (this.arg = undefined), ContinueSentinel; } }, exports; }
function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }
function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }
// app/javascript/controllers/debounce_controller.js


var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "update",
    value: function update(event) {
      var _this = this;
      event.preventDefault();
      setTimeout( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/_regeneratorRuntime().mark(function _callee() {
        return _regeneratorRuntime().wrap(function _callee$(_context) {
          while (1) switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return (0,_rails_request_js__WEBPACK_IMPORTED_MODULE_1__.patch)(_this.urlValue, {});
            case 2:
            case "end":
              return _context.stop();
          }
        }, _callee);
      })), 500);
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);
_default.values = {
  url: String
};


/***/ }),

/***/ "./app/packs/entrypoints/controllers/wishlist_controller.js":
/*!******************************************************************!*\
  !*** ./app/packs/entrypoints/controllers/wishlist_controller.js ***!
  \******************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ _default; }
/* harmony export */ });
/* harmony import */ var _hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @hotwired/stimulus */ "./node_modules/@hotwired/stimulus/dist/stimulus.js");
/* harmony import */ var rails_ujs__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! rails-ujs */ "./node_modules/rails-ujs/lib/assets/compiled/rails-ujs.js");
/* harmony import */ var rails_ujs__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(rails_ujs__WEBPACK_IMPORTED_MODULE_1__);
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); Object.defineProperty(subClass, "prototype", { writable: false }); if (superClass) _setPrototypeOf(subClass, superClass); }
function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf ? Object.setPrototypeOf.bind() : function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }
function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }
function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } else if (call !== void 0) { throw new TypeError("Derived constructors may only return object or undefined"); } return _assertThisInitialized(self); }
function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }
function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }
function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf.bind() : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }


var _default = /*#__PURE__*/function (_Controller) {
  _inherits(_default, _Controller);
  var _super = _createSuper(_default);
  function _default() {
    _classCallCheck(this, _default);
    return _super.apply(this, arguments);
  }
  _createClass(_default, [{
    key: "connect",
    value: function connect() {}
  }, {
    key: "domainCheck",
    value: function domainCheck() {
      var _this = this;
      var wishlistInputField = document.querySelector('#wishlist_item_domain_name');
      var url = "/domain_wishlist_availability?domain_name=".concat(wishlistInputField.value);
      var validationBox = document.querySelector('#validation-box');
      validationBox.style.display = "none";
      validationBox.innerHTML = '';
      if (wishlistInputField.value === '') return;
      clearTimeout(this.timeout);
      this.timeout = setTimeout(function () {
        rails_ujs__WEBPACK_IMPORTED_MODULE_1___default().ajax({
          type: 'GET',
          url: url,
          dataType: 'json',
          success: function success(data) {
            _this.parseResponse(data);
          }
        });
      }, 1000);
    }
  }, {
    key: "parseResponse",
    value: function parseResponse(data) {
      var validationBox = document.querySelector('#validation-box');
      var divElement = document.createElement("span");
      validationBox.style.display = "block";
      if (data.status == "wrong") {
        divElement.textContent = data.errors;
        validationBox.style.color = 'red';
        validationBox.style.borderColor = 'red';
      } else {
        divElement.textContent = "Suitable domain";
        validationBox.style.color = 'green';
        validationBox.style.borderColor = 'green';
      }
      validationBox.appendChild(divElement);
    }
  }]);
  return _default;
}(_hotwired_stimulus__WEBPACK_IMPORTED_MODULE_0__.Controller);


/***/ }),

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

/***/ }),

/***/ "./app/packs/entrypoints/users.js":
/*!****************************************!*\
  !*** ./app/packs/entrypoints/users.js ***!
  \****************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
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

/***/ "./app/packs/entrypoints/wishlist_items.js":
/*!*************************************************!*\
  !*** ./app/packs/entrypoints/wishlist_items.js ***!
  \*************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
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

/***/ }),

/***/ "./app/packs/src/mobile_phone.js":
/*!***************************************!*\
  !*** ./app/packs/src/mobile_phone.js ***!
  \***************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
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

/***/ }),

/***/ "./app/packs/src/semantic/definitions/modules/accordion.js":
/*!*****************************************************************!*\
  !*** ./app/packs/src/semantic/definitions/modules/accordion.js ***!
  \*****************************************************************/
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

/* provided dependency */ var jQuery = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
/*!
 * # Fomantic-UI - Accordion
 * http://github.com/fomantic/Fomantic-UI/
 *
 *
 * Released under the MIT license
 * http://opensource.org/licenses/MIT
 *
 */

;
(function ($, window, document, undefined) {
  'use strict';

  $.isFunction = $.isFunction || function (obj) {
    return typeof obj === "function" && typeof obj.nodeType !== "number";
  };
  window = typeof window != 'undefined' && window.Math == Math ? window : typeof self != 'undefined' && self.Math == Math ? self : Function('return this')();
  $.fn.accordion = function (parameters) {
    var $allModules = $(this),
      time = new Date().getTime(),
      performance = [],
      query = arguments[0],
      methodInvoked = typeof query == 'string',
      queryArguments = [].slice.call(arguments, 1),
      returnedValue;
    $allModules.each(function () {
      var settings = $.isPlainObject(parameters) ? $.extend(true, {}, $.fn.accordion.settings, parameters) : $.extend({}, $.fn.accordion.settings),
        className = settings.className,
        namespace = settings.namespace,
        selector = settings.selector,
        error = settings.error,
        eventNamespace = '.' + namespace,
        moduleNamespace = 'module-' + namespace,
        moduleSelector = $allModules.selector || '',
        $module = $(this),
        $title = $module.find(selector.title),
        $content = $module.find(selector.content),
        element = this,
        instance = $module.data(moduleNamespace),
        observer,
        module;
      module = {
        initialize: function initialize() {
          module.debug('Initializing', $module);
          module.bind.events();
          if (settings.observeChanges) {
            module.observeChanges();
          }
          module.instantiate();
        },
        instantiate: function instantiate() {
          instance = module;
          $module.data(moduleNamespace, module);
        },
        destroy: function destroy() {
          module.debug('Destroying previous instance', $module);
          $module.off(eventNamespace).removeData(moduleNamespace);
        },
        refresh: function refresh() {
          $title = $module.find(selector.title);
          $content = $module.find(selector.content);
        },
        observeChanges: function observeChanges() {
          if ('MutationObserver' in window) {
            observer = new MutationObserver(function (mutations) {
              module.debug('DOM tree modified, updating selector cache');
              module.refresh();
            });
            observer.observe(element, {
              childList: true,
              subtree: true
            });
            module.debug('Setting up mutation observer', observer);
          }
        },
        bind: {
          events: function events() {
            module.debug('Binding delegated events');
            $module.on(settings.on + eventNamespace, selector.trigger, module.event.click);
          }
        },
        event: {
          click: function click() {
            module.toggle.call(this);
          }
        },
        toggle: function toggle(query) {
          var $activeTitle = query !== undefined ? typeof query === 'number' ? $title.eq(query) : $(query).closest(selector.title) : $(this).closest(selector.title),
            $activeContent = $activeTitle.next($content),
            isAnimating = $activeContent.hasClass(className.animating),
            isActive = $activeContent.hasClass(className.active),
            isOpen = isActive && !isAnimating,
            isOpening = !isActive && isAnimating;
          module.debug('Toggling visibility of content', $activeTitle);
          if (isOpen || isOpening) {
            if (settings.collapsible) {
              module.close.call($activeTitle);
            } else {
              module.debug('Cannot close accordion content collapsing is disabled');
            }
          } else {
            module.open.call($activeTitle);
          }
        },
        open: function open(query) {
          var $activeTitle = query !== undefined ? typeof query === 'number' ? $title.eq(query) : $(query).closest(selector.title) : $(this).closest(selector.title),
            $activeContent = $activeTitle.next($content),
            isAnimating = $activeContent.hasClass(className.animating),
            isActive = $activeContent.hasClass(className.active),
            isOpen = isActive || isAnimating;
          if (isOpen) {
            module.debug('Accordion already open, skipping', $activeContent);
            return;
          }
          module.debug('Opening accordion content', $activeTitle);
          settings.onOpening.call($activeContent);
          settings.onChanging.call($activeContent);
          if (settings.exclusive) {
            module.closeOthers.call($activeTitle);
          }
          $activeTitle.addClass(className.active);
          $activeContent.stop(true, true).addClass(className.animating);
          if (settings.animateChildren) {
            if ($.fn.transition !== undefined && $module.transition('is supported')) {
              $activeContent.children().transition({
                animation: 'fade in',
                queue: false,
                useFailSafe: true,
                debug: settings.debug,
                verbose: settings.verbose,
                duration: settings.duration,
                skipInlineHidden: true,
                onComplete: function onComplete() {
                  $activeContent.children().removeClass(className.transition);
                }
              });
            } else {
              $activeContent.children().stop(true, true).animate({
                opacity: 1
              }, settings.duration, module.resetOpacity);
            }
          }
          $activeContent.slideDown(settings.duration, settings.easing, function () {
            $activeContent.removeClass(className.animating).addClass(className.active);
            module.reset.display.call(this);
            settings.onOpen.call(this);
            settings.onChange.call(this);
          });
        },
        close: function close(query) {
          var $activeTitle = query !== undefined ? typeof query === 'number' ? $title.eq(query) : $(query).closest(selector.title) : $(this).closest(selector.title),
            $activeContent = $activeTitle.next($content),
            isAnimating = $activeContent.hasClass(className.animating),
            isActive = $activeContent.hasClass(className.active),
            isOpening = !isActive && isAnimating,
            isClosing = isActive && isAnimating;
          if ((isActive || isOpening) && !isClosing) {
            module.debug('Closing accordion content', $activeContent);
            settings.onClosing.call($activeContent);
            settings.onChanging.call($activeContent);
            $activeTitle.removeClass(className.active);
            $activeContent.stop(true, true).addClass(className.animating);
            if (settings.animateChildren) {
              if ($.fn.transition !== undefined && $module.transition('is supported')) {
                $activeContent.children().transition({
                  animation: 'fade out',
                  queue: false,
                  useFailSafe: true,
                  debug: settings.debug,
                  verbose: settings.verbose,
                  duration: settings.duration,
                  skipInlineHidden: true
                });
              } else {
                $activeContent.children().stop(true, true).animate({
                  opacity: 0
                }, settings.duration, module.resetOpacity);
              }
            }
            $activeContent.slideUp(settings.duration, settings.easing, function () {
              $activeContent.removeClass(className.animating).removeClass(className.active);
              module.reset.display.call(this);
              settings.onClose.call(this);
              settings.onChange.call(this);
            });
          }
        },
        closeOthers: function closeOthers(index) {
          var $activeTitle = index !== undefined ? $title.eq(index) : $(this).closest(selector.title),
            $parentTitles = $activeTitle.parents(selector.content).prev(selector.title),
            $activeAccordion = $activeTitle.closest(selector.accordion),
            activeSelector = selector.title + '.' + className.active + ':visible',
            activeContent = selector.content + '.' + className.active + ':visible',
            $openTitles,
            $nestedTitles,
            $openContents;
          if (settings.closeNested) {
            $openTitles = $activeAccordion.find(activeSelector).not($parentTitles);
            $openContents = $openTitles.next($content);
          } else {
            $openTitles = $activeAccordion.find(activeSelector).not($parentTitles);
            $nestedTitles = $activeAccordion.find(activeContent).find(activeSelector).not($parentTitles);
            $openTitles = $openTitles.not($nestedTitles);
            $openContents = $openTitles.next($content);
          }
          if ($openTitles.length > 0) {
            module.debug('Exclusive enabled, closing other content', $openTitles);
            $openTitles.removeClass(className.active);
            $openContents.removeClass(className.animating).stop(true, true);
            if (settings.animateChildren) {
              if ($.fn.transition !== undefined && $module.transition('is supported')) {
                $openContents.children().transition({
                  animation: 'fade out',
                  useFailSafe: true,
                  debug: settings.debug,
                  verbose: settings.verbose,
                  duration: settings.duration,
                  skipInlineHidden: true
                });
              } else {
                $openContents.children().stop(true, true).animate({
                  opacity: 0
                }, settings.duration, module.resetOpacity);
              }
            }
            $openContents.slideUp(settings.duration, settings.easing, function () {
              $(this).removeClass(className.active);
              module.reset.display.call(this);
            });
          }
        },
        reset: {
          display: function display() {
            module.verbose('Removing inline display from element', this);
            $(this).css('display', '');
            if ($(this).attr('style') === '') {
              $(this).attr('style', '').removeAttr('style');
            }
          },
          opacity: function opacity() {
            module.verbose('Removing inline opacity from element', this);
            $(this).css('opacity', '');
            if ($(this).attr('style') === '') {
              $(this).attr('style', '').removeAttr('style');
            }
          }
        },
        setting: function setting(name, value) {
          module.debug('Changing setting', name, value);
          if ($.isPlainObject(name)) {
            $.extend(true, settings, name);
          } else if (value !== undefined) {
            if ($.isPlainObject(settings[name])) {
              $.extend(true, settings[name], value);
            } else {
              settings[name] = value;
            }
          } else {
            return settings[name];
          }
        },
        internal: function internal(name, value) {
          module.debug('Changing internal', name, value);
          if (value !== undefined) {
            if ($.isPlainObject(name)) {
              $.extend(true, module, name);
            } else {
              module[name] = value;
            }
          } else {
            return module[name];
          }
        },
        debug: function debug() {
          if (!settings.silent && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.debug = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.debug.apply(console, arguments);
            }
          }
        },
        verbose: function verbose() {
          if (!settings.silent && settings.verbose && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.verbose = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.verbose.apply(console, arguments);
            }
          }
        },
        error: function error() {
          if (!settings.silent) {
            module.error = Function.prototype.bind.call(console.error, console, settings.name + ':');
            module.error.apply(console, arguments);
          }
        },
        performance: {
          log: function log(message) {
            var currentTime, executionTime, previousTime;
            if (settings.performance) {
              currentTime = new Date().getTime();
              previousTime = time || currentTime;
              executionTime = currentTime - previousTime;
              time = currentTime;
              performance.push({
                'Name': message[0],
                'Arguments': [].slice.call(message, 1) || '',
                'Element': element,
                'Execution Time': executionTime
              });
            }
            clearTimeout(module.performance.timer);
            module.performance.timer = setTimeout(module.performance.display, 500);
          },
          display: function display() {
            var title = settings.name + ':',
              totalTime = 0;
            time = false;
            clearTimeout(module.performance.timer);
            $.each(performance, function (index, data) {
              totalTime += data['Execution Time'];
            });
            title += ' ' + totalTime + 'ms';
            if (moduleSelector) {
              title += ' \'' + moduleSelector + '\'';
            }
            if ((console.group !== undefined || console.table !== undefined) && performance.length > 0) {
              console.groupCollapsed(title);
              if (console.table) {
                console.table(performance);
              } else {
                $.each(performance, function (index, data) {
                  console.log(data['Name'] + ': ' + data['Execution Time'] + 'ms');
                });
              }
              console.groupEnd();
            }
            performance = [];
          }
        },
        invoke: function invoke(query, passedArguments, context) {
          var object = instance,
            maxDepth,
            found,
            response;
          passedArguments = passedArguments || queryArguments;
          context = element || context;
          if (typeof query == 'string' && object !== undefined) {
            query = query.split(/[\. ]/);
            maxDepth = query.length - 1;
            $.each(query, function (depth, value) {
              var camelCaseValue = depth != maxDepth ? value + query[depth + 1].charAt(0).toUpperCase() + query[depth + 1].slice(1) : query;
              if ($.isPlainObject(object[camelCaseValue]) && depth != maxDepth) {
                object = object[camelCaseValue];
              } else if (object[camelCaseValue] !== undefined) {
                found = object[camelCaseValue];
                return false;
              } else if ($.isPlainObject(object[value]) && depth != maxDepth) {
                object = object[value];
              } else if (object[value] !== undefined) {
                found = object[value];
                return false;
              } else {
                module.error(error.method, query);
                return false;
              }
            });
          }
          if ($.isFunction(found)) {
            response = found.apply(context, passedArguments);
          } else if (found !== undefined) {
            response = found;
          }
          if (Array.isArray(returnedValue)) {
            returnedValue.push(response);
          } else if (returnedValue !== undefined) {
            returnedValue = [returnedValue, response];
          } else if (response !== undefined) {
            returnedValue = response;
          }
          return found;
        }
      };
      if (methodInvoked) {
        if (instance === undefined) {
          module.initialize();
        }
        module.invoke(query);
      } else {
        if (instance !== undefined) {
          instance.invoke('destroy');
        }
        module.initialize();
      }
    });
    return returnedValue !== undefined ? returnedValue : this;
  };
  $.fn.accordion.settings = {
    name: 'Accordion',
    namespace: 'accordion',
    silent: false,
    debug: false,
    verbose: false,
    performance: true,
    on: 'click',
    // event on title that opens accordion

    observeChanges: true,
    // whether accordion should automatically refresh on DOM insertion

    exclusive: true,
    // whether a single accordion content panel should be open at once
    collapsible: true,
    // whether accordion content can be closed
    closeNested: false,
    // whether nested content should be closed when a panel is closed
    animateChildren: true,
    // whether children opacity should be animated

    duration: 350,
    // duration of animation
    easing: 'easeOutQuad',
    // easing equation for animation

    onOpening: function onOpening() {},
    // callback before open animation
    onClosing: function onClosing() {},
    // callback before closing animation
    onChanging: function onChanging() {},
    // callback before closing or opening animation

    onOpen: function onOpen() {},
    // callback after open animation
    onClose: function onClose() {},
    // callback after closing animation
    onChange: function onChange() {},
    // callback after closing or opening animation

    error: {
      method: 'The method you called is not defined'
    },
    className: {
      active: 'active',
      animating: 'animating',
      transition: 'transition'
    },
    selector: {
      accordion: '.accordion',
      title: '.title',
      trigger: '.title',
      content: '.content'
    }
  };

  // Adds easing
  $.extend($.easing, {
    easeOutQuad: function easeOutQuad(x, t, b, c, d) {
      return -c * (t /= d) * (t - 2) + b;
    }
  });
})(jQuery, window, document);

/***/ }),

/***/ "./app/packs/src/semantic/definitions/modules/checkbox.js":
/*!****************************************************************!*\
  !*** ./app/packs/src/semantic/definitions/modules/checkbox.js ***!
  \****************************************************************/
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

/* provided dependency */ var jQuery = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
/*!
 * # Fomantic-UI - Checkbox
 * http://github.com/fomantic/Fomantic-UI/
 *
 *
 * Released under the MIT license
 * http://opensource.org/licenses/MIT
 *
 */

;
(function ($, window, document, undefined) {
  'use strict';

  $.isFunction = $.isFunction || function (obj) {
    return typeof obj === "function" && typeof obj.nodeType !== "number";
  };
  window = typeof window != 'undefined' && window.Math == Math ? window : typeof self != 'undefined' && self.Math == Math ? self : Function('return this')();
  $.fn.checkbox = function (parameters) {
    var $allModules = $(this),
      moduleSelector = $allModules.selector || '',
      time = new Date().getTime(),
      performance = [],
      query = arguments[0],
      methodInvoked = typeof query == 'string',
      queryArguments = [].slice.call(arguments, 1),
      returnedValue;
    $allModules.each(function () {
      var settings = $.extend(true, {}, $.fn.checkbox.settings, parameters),
        className = settings.className,
        namespace = settings.namespace,
        selector = settings.selector,
        error = settings.error,
        eventNamespace = '.' + namespace,
        moduleNamespace = 'module-' + namespace,
        $module = $(this),
        $label = $(this).children(selector.label),
        $input = $(this).children(selector.input),
        input = $input[0],
        _initialLoad = false,
        shortcutPressed = false,
        instance = $module.data(moduleNamespace),
        observer,
        element = this,
        module;
      module = {
        initialize: function initialize() {
          module.verbose('Initializing checkbox', settings);
          module.create.label();
          module.bind.events();
          module.set.tabbable();
          module.hide.input();
          module.observeChanges();
          module.instantiate();
          module.setup();
        },
        instantiate: function instantiate() {
          module.verbose('Storing instance of module', module);
          instance = module;
          $module.data(moduleNamespace, module);
        },
        destroy: function destroy() {
          module.verbose('Destroying module');
          module.unbind.events();
          module.show.input();
          $module.removeData(moduleNamespace);
        },
        fix: {
          reference: function reference() {
            if ($module.is(selector.input)) {
              module.debug('Behavior called on <input> adjusting invoked element');
              $module = $module.closest(selector.checkbox);
              module.refresh();
            }
          }
        },
        setup: function setup() {
          module.set.initialLoad();
          if (module.is.indeterminate()) {
            module.debug('Initial value is indeterminate');
            module.indeterminate();
          } else if (module.is.checked()) {
            module.debug('Initial value is checked');
            module.check();
          } else {
            module.debug('Initial value is unchecked');
            module.uncheck();
          }
          module.remove.initialLoad();
        },
        refresh: function refresh() {
          $label = $module.children(selector.label);
          $input = $module.children(selector.input);
          input = $input[0];
        },
        hide: {
          input: function input() {
            module.verbose('Modifying <input> z-index to be unselectable');
            $input.addClass(className.hidden);
          }
        },
        show: {
          input: function input() {
            module.verbose('Modifying <input> z-index to be selectable');
            $input.removeClass(className.hidden);
          }
        },
        observeChanges: function observeChanges() {
          if ('MutationObserver' in window) {
            observer = new MutationObserver(function (mutations) {
              module.debug('DOM tree modified, updating selector cache');
              module.refresh();
            });
            observer.observe(element, {
              childList: true,
              subtree: true
            });
            module.debug('Setting up mutation observer', observer);
          }
        },
        attachEvents: function attachEvents(selector, event) {
          var $element = $(selector);
          event = $.isFunction(module[event]) ? module[event] : module.toggle;
          if ($element.length > 0) {
            module.debug('Attaching checkbox events to element', selector, event);
            $element.on('click' + eventNamespace, event);
          } else {
            module.error(error.notFound);
          }
        },
        preventDefaultOnInputTarget: function preventDefaultOnInputTarget() {
          if (typeof event !== 'undefined' && event !== null && $(event.target).is(selector.input)) {
            module.verbose('Preventing default check action after manual check action');
            event.preventDefault();
          }
        },
        event: {
          change: function change(event) {
            if (!module.should.ignoreCallbacks()) {
              settings.onChange.call(input);
            }
          },
          click: function click(event) {
            var $target = $(event.target);
            if ($target.is(selector.input)) {
              module.verbose('Using default check action on initialized checkbox');
              return;
            }
            if ($target.is(selector.link)) {
              module.debug('Clicking link inside checkbox, skipping toggle');
              return;
            }
            module.toggle();
            $input.focus();
            event.preventDefault();
          },
          keydown: function keydown(event) {
            var key = event.which,
              keyCode = {
                enter: 13,
                space: 32,
                escape: 27,
                left: 37,
                up: 38,
                right: 39,
                down: 40
              };
            var r = module.get.radios(),
              rIndex = r.index($module),
              rLen = r.length,
              checkIndex = false;
            if (key == keyCode.left || key == keyCode.up) {
              checkIndex = (rIndex === 0 ? rLen : rIndex) - 1;
            } else if (key == keyCode.right || key == keyCode.down) {
              checkIndex = rIndex === rLen - 1 ? 0 : rIndex + 1;
            }
            if (!module.should.ignoreCallbacks() && checkIndex !== false) {
              if (settings.beforeUnchecked.apply(input) === false) {
                module.verbose('Option not allowed to be unchecked, cancelling key navigation');
                return false;
              }
              if (settings.beforeChecked.apply($(r[checkIndex]).children(selector.input)[0]) === false) {
                module.verbose('Next option should not allow check, cancelling key navigation');
                return false;
              }
            }
            if (key == keyCode.escape) {
              module.verbose('Escape key pressed blurring field');
              $input.blur();
              shortcutPressed = true;
            } else if (!event.ctrlKey && (key == keyCode.space || key == keyCode.enter && settings.enableEnterKey)) {
              module.verbose('Enter/space key pressed, toggling checkbox');
              module.toggle();
              shortcutPressed = true;
            } else {
              shortcutPressed = false;
            }
          },
          keyup: function keyup(event) {
            if (shortcutPressed) {
              event.preventDefault();
            }
          }
        },
        check: function check() {
          if (!module.should.allowCheck()) {
            return;
          }
          module.debug('Checking checkbox', $input);
          module.set.checked();
          if (!module.should.ignoreCallbacks()) {
            settings.onChecked.call(input);
            module.trigger.change();
          }
          module.preventDefaultOnInputTarget();
        },
        uncheck: function uncheck() {
          if (!module.should.allowUncheck()) {
            return;
          }
          module.debug('Unchecking checkbox');
          module.set.unchecked();
          if (!module.should.ignoreCallbacks()) {
            settings.onUnchecked.call(input);
            module.trigger.change();
          }
          module.preventDefaultOnInputTarget();
        },
        indeterminate: function indeterminate() {
          if (module.should.allowIndeterminate()) {
            module.debug('Checkbox is already indeterminate');
            return;
          }
          module.debug('Making checkbox indeterminate');
          module.set.indeterminate();
          if (!module.should.ignoreCallbacks()) {
            settings.onIndeterminate.call(input);
            module.trigger.change();
          }
        },
        determinate: function determinate() {
          if (module.should.allowDeterminate()) {
            module.debug('Checkbox is already determinate');
            return;
          }
          module.debug('Making checkbox determinate');
          module.set.determinate();
          if (!module.should.ignoreCallbacks()) {
            settings.onDeterminate.call(input);
            module.trigger.change();
          }
        },
        enable: function enable() {
          if (module.is.enabled()) {
            module.debug('Checkbox is already enabled');
            return;
          }
          module.debug('Enabling checkbox');
          module.set.enabled();
          if (!module.should.ignoreCallbacks()) {
            settings.onEnable.call(input);
            // preserve legacy callbacks
            settings.onEnabled.call(input);
            module.trigger.change();
          }
        },
        disable: function disable() {
          if (module.is.disabled()) {
            module.debug('Checkbox is already disabled');
            return;
          }
          module.debug('Disabling checkbox');
          module.set.disabled();
          if (!module.should.ignoreCallbacks()) {
            settings.onDisable.call(input);
            // preserve legacy callbacks
            settings.onDisabled.call(input);
            module.trigger.change();
          }
        },
        get: {
          radios: function radios() {
            var name = module.get.name();
            return $('input[name="' + name + '"]').closest(selector.checkbox);
          },
          otherRadios: function otherRadios() {
            return module.get.radios().not($module);
          },
          name: function name() {
            return $input.attr('name');
          }
        },
        is: {
          initialLoad: function initialLoad() {
            return _initialLoad;
          },
          radio: function radio() {
            return $input.hasClass(className.radio) || $input.attr('type') == 'radio';
          },
          indeterminate: function indeterminate() {
            return $input.prop('indeterminate') !== undefined && $input.prop('indeterminate');
          },
          checked: function checked() {
            return $input.prop('checked') !== undefined && $input.prop('checked');
          },
          disabled: function disabled() {
            return $input.prop('disabled') !== undefined && $input.prop('disabled');
          },
          enabled: function enabled() {
            return !module.is.disabled();
          },
          determinate: function determinate() {
            return !module.is.indeterminate();
          },
          unchecked: function unchecked() {
            return !module.is.checked();
          }
        },
        should: {
          allowCheck: function allowCheck() {
            if (module.is.determinate() && module.is.checked() && !module.is.initialLoad()) {
              module.debug('Should not allow check, checkbox is already checked');
              return false;
            }
            if (!module.should.ignoreCallbacks() && settings.beforeChecked.apply(input) === false) {
              module.debug('Should not allow check, beforeChecked cancelled');
              return false;
            }
            return true;
          },
          allowUncheck: function allowUncheck() {
            if (module.is.determinate() && module.is.unchecked() && !module.is.initialLoad()) {
              module.debug('Should not allow uncheck, checkbox is already unchecked');
              return false;
            }
            if (!module.should.ignoreCallbacks() && settings.beforeUnchecked.apply(input) === false) {
              module.debug('Should not allow uncheck, beforeUnchecked cancelled');
              return false;
            }
            return true;
          },
          allowIndeterminate: function allowIndeterminate() {
            if (module.is.indeterminate() && !module.is.initialLoad()) {
              module.debug('Should not allow indeterminate, checkbox is already indeterminate');
              return false;
            }
            if (!module.should.ignoreCallbacks() && settings.beforeIndeterminate.apply(input) === false) {
              module.debug('Should not allow indeterminate, beforeIndeterminate cancelled');
              return false;
            }
            return true;
          },
          allowDeterminate: function allowDeterminate() {
            if (module.is.determinate() && !module.is.initialLoad()) {
              module.debug('Should not allow determinate, checkbox is already determinate');
              return false;
            }
            if (!module.should.ignoreCallbacks() && settings.beforeDeterminate.apply(input) === false) {
              module.debug('Should not allow determinate, beforeDeterminate cancelled');
              return false;
            }
            return true;
          },
          ignoreCallbacks: function ignoreCallbacks() {
            return _initialLoad && !settings.fireOnInit;
          }
        },
        can: {
          change: function change() {
            return !($module.hasClass(className.disabled) || $module.hasClass(className.readOnly) || $input.prop('disabled') || $input.prop('readonly'));
          },
          uncheck: function uncheck() {
            return typeof settings.uncheckable === 'boolean' ? settings.uncheckable : !module.is.radio();
          }
        },
        set: {
          initialLoad: function initialLoad() {
            _initialLoad = true;
          },
          checked: function checked() {
            module.verbose('Setting class to checked');
            $module.removeClass(className.indeterminate).addClass(className.checked);
            if (module.is.radio()) {
              module.uncheckOthers();
            }
            if (!module.is.indeterminate() && module.is.checked()) {
              module.debug('Input is already checked, skipping input property change');
              return;
            }
            module.verbose('Setting state to checked', input);
            $input.prop('indeterminate', false).prop('checked', true);
          },
          unchecked: function unchecked() {
            module.verbose('Removing checked class');
            $module.removeClass(className.indeterminate).removeClass(className.checked);
            if (!module.is.indeterminate() && module.is.unchecked()) {
              module.debug('Input is already unchecked');
              return;
            }
            module.debug('Setting state to unchecked');
            $input.prop('indeterminate', false).prop('checked', false);
          },
          indeterminate: function indeterminate() {
            module.verbose('Setting class to indeterminate');
            $module.addClass(className.indeterminate);
            if (module.is.indeterminate()) {
              module.debug('Input is already indeterminate, skipping input property change');
              return;
            }
            module.debug('Setting state to indeterminate');
            $input.prop('indeterminate', true);
          },
          determinate: function determinate() {
            module.verbose('Removing indeterminate class');
            $module.removeClass(className.indeterminate);
            if (module.is.determinate()) {
              module.debug('Input is already determinate, skipping input property change');
              return;
            }
            module.debug('Setting state to determinate');
            $input.prop('indeterminate', false);
          },
          disabled: function disabled() {
            module.verbose('Setting class to disabled');
            $module.addClass(className.disabled);
            if (module.is.disabled()) {
              module.debug('Input is already disabled, skipping input property change');
              return;
            }
            module.debug('Setting state to disabled');
            $input.prop('disabled', 'disabled');
          },
          enabled: function enabled() {
            module.verbose('Removing disabled class');
            $module.removeClass(className.disabled);
            if (module.is.enabled()) {
              module.debug('Input is already enabled, skipping input property change');
              return;
            }
            module.debug('Setting state to enabled');
            $input.prop('disabled', false);
          },
          tabbable: function tabbable() {
            module.verbose('Adding tabindex to checkbox');
            if ($input.attr('tabindex') === undefined) {
              $input.attr('tabindex', 0);
            }
          }
        },
        remove: {
          initialLoad: function initialLoad() {
            _initialLoad = false;
          }
        },
        trigger: {
          change: function change() {
            var inputElement = $input[0];
            if (inputElement) {
              var events = document.createEvent('HTMLEvents');
              module.verbose('Triggering native change event');
              events.initEvent('change', true, false);
              inputElement.dispatchEvent(events);
            }
          }
        },
        create: {
          label: function label() {
            if ($input.prevAll(selector.label).length > 0) {
              $input.prev(selector.label).detach().insertAfter($input);
              module.debug('Moving existing label', $label);
            } else if (!module.has.label()) {
              $label = $('<label>').insertAfter($input);
              module.debug('Creating label', $label);
            }
          }
        },
        has: {
          label: function label() {
            return $label.length > 0;
          }
        },
        bind: {
          events: function events() {
            module.verbose('Attaching checkbox events');
            $module.on('click' + eventNamespace, module.event.click).on('change' + eventNamespace, module.event.change).on('keydown' + eventNamespace, selector.input, module.event.keydown).on('keyup' + eventNamespace, selector.input, module.event.keyup);
          }
        },
        unbind: {
          events: function events() {
            module.debug('Removing events');
            $module.off(eventNamespace);
          }
        },
        uncheckOthers: function uncheckOthers() {
          var $radios = module.get.otherRadios();
          module.debug('Unchecking other radios', $radios);
          $radios.removeClass(className.checked);
        },
        toggle: function toggle() {
          if (!module.can.change()) {
            if (!module.is.radio()) {
              module.debug('Checkbox is read-only or disabled, ignoring toggle');
            }
            return;
          }
          if (module.is.indeterminate() || module.is.unchecked()) {
            module.debug('Currently unchecked');
            module.check();
          } else if (module.is.checked() && module.can.uncheck()) {
            module.debug('Currently checked');
            module.uncheck();
          }
        },
        setting: function setting(name, value) {
          module.debug('Changing setting', name, value);
          if ($.isPlainObject(name)) {
            $.extend(true, settings, name);
          } else if (value !== undefined) {
            if ($.isPlainObject(settings[name])) {
              $.extend(true, settings[name], value);
            } else {
              settings[name] = value;
            }
          } else {
            return settings[name];
          }
        },
        internal: function internal(name, value) {
          if ($.isPlainObject(name)) {
            $.extend(true, module, name);
          } else if (value !== undefined) {
            module[name] = value;
          } else {
            return module[name];
          }
        },
        debug: function debug() {
          if (!settings.silent && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.debug = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.debug.apply(console, arguments);
            }
          }
        },
        verbose: function verbose() {
          if (!settings.silent && settings.verbose && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.verbose = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.verbose.apply(console, arguments);
            }
          }
        },
        error: function error() {
          if (!settings.silent) {
            module.error = Function.prototype.bind.call(console.error, console, settings.name + ':');
            module.error.apply(console, arguments);
          }
        },
        performance: {
          log: function log(message) {
            var currentTime, executionTime, previousTime;
            if (settings.performance) {
              currentTime = new Date().getTime();
              previousTime = time || currentTime;
              executionTime = currentTime - previousTime;
              time = currentTime;
              performance.push({
                'Name': message[0],
                'Arguments': [].slice.call(message, 1) || '',
                'Element': element,
                'Execution Time': executionTime
              });
            }
            clearTimeout(module.performance.timer);
            module.performance.timer = setTimeout(module.performance.display, 500);
          },
          display: function display() {
            var title = settings.name + ':',
              totalTime = 0;
            time = false;
            clearTimeout(module.performance.timer);
            $.each(performance, function (index, data) {
              totalTime += data['Execution Time'];
            });
            title += ' ' + totalTime + 'ms';
            if (moduleSelector) {
              title += ' \'' + moduleSelector + '\'';
            }
            if ((console.group !== undefined || console.table !== undefined) && performance.length > 0) {
              console.groupCollapsed(title);
              if (console.table) {
                console.table(performance);
              } else {
                $.each(performance, function (index, data) {
                  console.log(data['Name'] + ': ' + data['Execution Time'] + 'ms');
                });
              }
              console.groupEnd();
            }
            performance = [];
          }
        },
        invoke: function invoke(query, passedArguments, context) {
          var object = instance,
            maxDepth,
            found,
            response;
          passedArguments = passedArguments || queryArguments;
          context = element || context;
          if (typeof query == 'string' && object !== undefined) {
            query = query.split(/[\. ]/);
            maxDepth = query.length - 1;
            $.each(query, function (depth, value) {
              var camelCaseValue = depth != maxDepth ? value + query[depth + 1].charAt(0).toUpperCase() + query[depth + 1].slice(1) : query;
              if ($.isPlainObject(object[camelCaseValue]) && depth != maxDepth) {
                object = object[camelCaseValue];
              } else if (object[camelCaseValue] !== undefined) {
                found = object[camelCaseValue];
                return false;
              } else if ($.isPlainObject(object[value]) && depth != maxDepth) {
                object = object[value];
              } else if (object[value] !== undefined) {
                found = object[value];
                return false;
              } else {
                module.error(error.method, query);
                return false;
              }
            });
          }
          if ($.isFunction(found)) {
            response = found.apply(context, passedArguments);
          } else if (found !== undefined) {
            response = found;
          }
          if (Array.isArray(returnedValue)) {
            returnedValue.push(response);
          } else if (returnedValue !== undefined) {
            returnedValue = [returnedValue, response];
          } else if (response !== undefined) {
            returnedValue = response;
          }
          return found;
        }
      };
      if (methodInvoked) {
        if (instance === undefined) {
          module.initialize();
        }
        module.invoke(query);
      } else {
        if (instance !== undefined) {
          instance.invoke('destroy');
        }
        module.initialize();
      }
    });
    return returnedValue !== undefined ? returnedValue : this;
  };
  $.fn.checkbox.settings = {
    name: 'Checkbox',
    namespace: 'checkbox',
    silent: false,
    debug: false,
    verbose: true,
    performance: true,
    // delegated event context
    uncheckable: 'auto',
    fireOnInit: false,
    enableEnterKey: true,
    onChange: function onChange() {},
    beforeChecked: function beforeChecked() {},
    beforeUnchecked: function beforeUnchecked() {},
    beforeDeterminate: function beforeDeterminate() {},
    beforeIndeterminate: function beforeIndeterminate() {},
    onChecked: function onChecked() {},
    onUnchecked: function onUnchecked() {},
    onDeterminate: function onDeterminate() {},
    onIndeterminate: function onIndeterminate() {},
    onEnable: function onEnable() {},
    onDisable: function onDisable() {},
    // preserve misspelled callbacks (will be removed in 3.0)
    onEnabled: function onEnabled() {},
    onDisabled: function onDisabled() {},
    className: {
      checked: 'checked',
      indeterminate: 'indeterminate',
      disabled: 'disabled',
      hidden: 'hidden',
      radio: 'radio',
      readOnly: 'read-only'
    },
    error: {
      method: 'The method you called is not defined'
    },
    selector: {
      checkbox: '.ui.checkbox',
      label: 'label, .box',
      input: 'input[type="checkbox"], input[type="radio"]',
      link: 'a[href]'
    }
  };
})(jQuery, window, document);

/***/ }),

/***/ "./app/packs/src/semantic/definitions/modules/dropdown.js":
/*!****************************************************************!*\
  !*** ./app/packs/src/semantic/definitions/modules/dropdown.js ***!
  \****************************************************************/
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

/* provided dependency */ var jQuery = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
/*!
 * # Fomantic-UI - Dropdown
 * http://github.com/fomantic/Fomantic-UI/
 *
 *
 * Released under the MIT license
 * http://opensource.org/licenses/MIT
 *
 */

;
(function ($, window, document, undefined) {
  'use strict';

  $.isFunction = $.isFunction || function (obj) {
    return typeof obj === "function" && typeof obj.nodeType !== "number";
  };
  window = typeof window != 'undefined' && window.Math == Math ? window : typeof self != 'undefined' && self.Math == Math ? self : Function('return this')();
  $.fn.dropdown = function (parameters) {
    var $allModules = $(this),
      $document = $(document),
      moduleSelector = $allModules.selector || '',
      hasTouch = ('ontouchstart' in document.documentElement),
      clickEvent = hasTouch ? 'touchstart' : 'click',
      time = new Date().getTime(),
      performance = [],
      query = arguments[0],
      methodInvoked = typeof query == 'string',
      queryArguments = [].slice.call(arguments, 1),
      returnedValue;
    $allModules.each(function (elementIndex) {
      var settings = $.isPlainObject(parameters) ? $.extend(true, {}, $.fn.dropdown.settings, parameters) : $.extend({}, $.fn.dropdown.settings),
        className = settings.className,
        message = settings.message,
        fields = settings.fields,
        keys = settings.keys,
        metadata = settings.metadata,
        namespace = settings.namespace,
        regExp = settings.regExp,
        selector = settings.selector,
        error = settings.error,
        templates = settings.templates,
        eventNamespace = '.' + namespace,
        moduleNamespace = 'module-' + namespace,
        $module = $(this),
        $context = $(settings.context),
        $text = $module.find(selector.text),
        $search = $module.find(selector.search),
        $sizer = $module.find(selector.sizer),
        $input = $module.find(selector.input),
        $icon = $module.find(selector.icon),
        $clear = $module.find(selector.clearIcon),
        $combo = $module.prev().find(selector.text).length > 0 ? $module.prev().find(selector.text) : $module.prev(),
        $menu = $module.children(selector.menu),
        $item = $menu.find(selector.item),
        $divider = settings.hideDividers ? $item.parent().children(selector.divider) : $(),
        activated = false,
        itemActivated = false,
        internalChange = false,
        iconClicked = false,
        element = this,
        focused = false,
        instance = $module.data(moduleNamespace),
        selectActionActive,
        _initialLoad,
        pageLostFocus,
        willRefocus,
        elementNamespace,
        _id,
        _selectObserver,
        _menuObserver,
        _classObserver,
        module;
      module = {
        initialize: function initialize() {
          module.debug('Initializing dropdown', settings);
          if (module.is.alreadySetup()) {
            module.setup.reference();
          } else {
            if (settings.ignoreDiacritics && !String.prototype.normalize) {
              settings.ignoreDiacritics = false;
              module.error(error.noNormalize, element);
            }
            module.setup.layout();
            if (settings.values) {
              module.set.initialLoad();
              module.change.values(settings.values);
              module.remove.initialLoad();
            }
            module.refreshData();
            module.save.defaults();
            module.restore.selected();
            module.create.id();
            module.bind.events();
            module.observeChanges();
            module.instantiate();
          }
        },
        instantiate: function instantiate() {
          module.verbose('Storing instance of dropdown', module);
          instance = module;
          $module.data(moduleNamespace, module);
        },
        destroy: function destroy() {
          module.verbose('Destroying previous dropdown', $module);
          module.remove.tabbable();
          module.remove.active();
          $menu.transition('stop all');
          $menu.removeClass(className.visible).addClass(className.hidden);
          $module.off(eventNamespace).removeData(moduleNamespace);
          $menu.off(eventNamespace);
          $document.off(elementNamespace);
          module.disconnect.menuObserver();
          module.disconnect.selectObserver();
          module.disconnect.classObserver();
        },
        observeChanges: function observeChanges() {
          if ('MutationObserver' in window) {
            _selectObserver = new MutationObserver(module.event.select.mutation);
            _menuObserver = new MutationObserver(module.event.menu.mutation);
            _classObserver = new MutationObserver(module.event["class"].mutation);
            module.debug('Setting up mutation observer', _selectObserver, _menuObserver, _classObserver);
            module.observe.select();
            module.observe.menu();
            module.observe["class"]();
          }
        },
        disconnect: {
          menuObserver: function menuObserver() {
            if (_menuObserver) {
              _menuObserver.disconnect();
            }
          },
          selectObserver: function selectObserver() {
            if (_selectObserver) {
              _selectObserver.disconnect();
            }
          },
          classObserver: function classObserver() {
            if (_classObserver) {
              _classObserver.disconnect();
            }
          }
        },
        observe: {
          select: function select() {
            if (module.has.input() && _selectObserver) {
              _selectObserver.observe($module[0], {
                childList: true,
                subtree: true
              });
            }
          },
          menu: function menu() {
            if (module.has.menu() && _menuObserver) {
              _menuObserver.observe($menu[0], {
                childList: true,
                subtree: true
              });
            }
          },
          "class": function _class() {
            if (module.has.search() && _classObserver) {
              _classObserver.observe($module[0], {
                attributes: true
              });
            }
          }
        },
        create: {
          id: function id() {
            _id = (Math.random().toString(16) + '000000000').substr(2, 8);
            elementNamespace = '.' + _id;
            module.verbose('Creating unique id for element', _id);
          },
          userChoice: function userChoice(values) {
            var $userChoices, $userChoice, isUserValue, html;
            values = values || module.get.userValues();
            if (!values) {
              return false;
            }
            values = Array.isArray(values) ? values : [values];
            $.each(values, function (index, value) {
              if (module.get.item(value) === false) {
                html = settings.templates.addition(module.add.variables(message.addResult, value));
                $userChoice = $('<div />').html(html).attr('data-' + metadata.value, value).attr('data-' + metadata.text, value).addClass(className.addition).addClass(className.item);
                if (settings.hideAdditions) {
                  $userChoice.addClass(className.hidden);
                }
                $userChoices = $userChoices === undefined ? $userChoice : $userChoices.add($userChoice);
                module.verbose('Creating user choices for value', value, $userChoice);
              }
            });
            return $userChoices;
          },
          userLabels: function userLabels(value) {
            var userValues = module.get.userValues();
            if (userValues) {
              module.debug('Adding user labels', userValues);
              $.each(userValues, function (index, value) {
                module.verbose('Adding custom user value');
                module.add.label(value, value);
              });
            }
          },
          menu: function menu() {
            $menu = $('<div />').addClass(className.menu).appendTo($module);
          },
          sizer: function sizer() {
            $sizer = $('<span />').addClass(className.sizer).insertAfter($search);
          }
        },
        search: function search(query) {
          query = query !== undefined ? query : module.get.query();
          module.verbose('Searching for query', query);
          if (settings.fireOnInit === false && module.is.initialLoad()) {
            module.verbose('Skipping callback on initial load', settings.onSearch);
          } else if (module.has.minCharacters(query) && settings.onSearch.call(element, query) !== false) {
            module.filter(query);
          } else {
            module.hide(null, true);
          }
        },
        select: {
          firstUnfiltered: function firstUnfiltered() {
            module.verbose('Selecting first non-filtered element');
            module.remove.selectedItem();
            $item.not(selector.unselectable).not(selector.addition + selector.hidden).eq(0).addClass(className.selected);
          },
          nextAvailable: function nextAvailable($selected) {
            $selected = $selected.eq(0);
            var $nextAvailable = $selected.nextAll(selector.item).not(selector.unselectable).eq(0),
              $prevAvailable = $selected.prevAll(selector.item).not(selector.unselectable).eq(0),
              hasNext = $nextAvailable.length > 0;
            if (hasNext) {
              module.verbose('Moving selection to', $nextAvailable);
              $nextAvailable.addClass(className.selected);
            } else {
              module.verbose('Moving selection to', $prevAvailable);
              $prevAvailable.addClass(className.selected);
            }
          }
        },
        setup: {
          api: function api() {
            var apiSettings = {
              debug: settings.debug,
              urlData: {
                value: module.get.value(),
                query: module.get.query()
              },
              on: false
            };
            module.verbose('First request, initializing API');
            $module.api(apiSettings);
          },
          layout: function layout() {
            if ($module.is('select')) {
              module.setup.select();
              module.setup.returnedObject();
            }
            if (!module.has.menu()) {
              module.create.menu();
            }
            if (module.is.clearable() && !module.has.clearItem()) {
              module.verbose('Adding clear icon');
              $clear = $('<i />').addClass('remove icon').insertBefore($text);
            }
            if (module.is.search() && !module.has.search()) {
              module.verbose('Adding search input');
              $search = $('<input />').addClass(className.search).prop('autocomplete', module.is.chrome() ? 'fomantic-search' : 'off').insertBefore($text);
            }
            if (module.is.multiple() && module.is.searchSelection() && !module.has.sizer()) {
              module.create.sizer();
            }
            if (settings.allowTab) {
              module.set.tabbable();
            }
          },
          select: function select() {
            var selectValues = module.get.selectValues();
            module.debug('Dropdown initialized on a select', selectValues);
            if ($module.is('select')) {
              $input = $module;
            }
            // see if select is placed correctly already
            if ($input.parent(selector.dropdown).length > 0) {
              module.debug('UI dropdown already exists. Creating dropdown menu only');
              $module = $input.closest(selector.dropdown);
              if (!module.has.menu()) {
                module.create.menu();
              }
              $menu = $module.children(selector.menu);
              module.setup.menu(selectValues);
            } else {
              module.debug('Creating entire dropdown from select');
              $module = $('<div />').attr('class', $input.attr('class')).addClass(className.selection).addClass(className.dropdown).html(templates.dropdown(selectValues, fields, settings.preserveHTML, settings.className)).insertBefore($input);
              if ($input.hasClass(className.multiple) && $input.prop('multiple') === false) {
                module.error(error.missingMultiple);
                $input.prop('multiple', true);
              }
              if ($input.is('[multiple]')) {
                module.set.multiple();
              }
              if ($input.prop('disabled')) {
                module.debug('Disabling dropdown');
                $module.addClass(className.disabled);
              }
              $input.removeAttr('required').removeAttr('class').detach().prependTo($module);
            }
            module.refresh();
          },
          menu: function menu(values) {
            $menu.html(templates.menu(values, fields, settings.preserveHTML, settings.className));
            $item = $menu.find(selector.item);
            $divider = settings.hideDividers ? $item.parent().children(selector.divider) : $();
          },
          reference: function reference() {
            module.debug('Dropdown behavior was called on select, replacing with closest dropdown');
            // replace module reference
            $module = $module.parent(selector.dropdown);
            instance = $module.data(moduleNamespace);
            element = $module.get(0);
            module.refresh();
            module.setup.returnedObject();
          },
          returnedObject: function returnedObject() {
            var $firstModules = $allModules.slice(0, elementIndex),
              $lastModules = $allModules.slice(elementIndex + 1);
            // adjust all modules to use correct reference
            $allModules = $firstModules.add($module).add($lastModules);
          }
        },
        refresh: function refresh() {
          module.refreshSelectors();
          module.refreshData();
        },
        refreshItems: function refreshItems() {
          $item = $menu.find(selector.item);
          $divider = settings.hideDividers ? $item.parent().children(selector.divider) : $();
        },
        refreshSelectors: function refreshSelectors() {
          module.verbose('Refreshing selector cache');
          $text = $module.find(selector.text);
          $search = $module.find(selector.search);
          $input = $module.find(selector.input);
          $icon = $module.find(selector.icon);
          $combo = $module.prev().find(selector.text).length > 0 ? $module.prev().find(selector.text) : $module.prev();
          $menu = $module.children(selector.menu);
          $item = $menu.find(selector.item);
          $divider = settings.hideDividers ? $item.parent().children(selector.divider) : $();
        },
        refreshData: function refreshData() {
          module.verbose('Refreshing cached metadata');
          $item.removeData(metadata.text).removeData(metadata.value);
        },
        clearData: function clearData() {
          module.verbose('Clearing metadata');
          $item.removeData(metadata.text).removeData(metadata.value);
          $module.removeData(metadata.defaultText).removeData(metadata.defaultValue).removeData(metadata.placeholderText);
        },
        clearItems: function clearItems() {
          $menu.empty();
          module.refreshItems();
        },
        toggle: function toggle() {
          module.verbose('Toggling menu visibility');
          if (!module.is.active()) {
            module.show();
          } else {
            module.hide();
          }
        },
        show: function show(callback, preventFocus) {
          callback = $.isFunction(callback) ? callback : function () {};
          if ((focused || iconClicked) && module.is.remote() && module.is.noApiCache()) {
            module.clearItems();
          }
          if (!module.can.show() && module.is.remote()) {
            module.debug('No API results retrieved, searching before show');
            module.queryRemote(module.get.query(), module.show, [callback, preventFocus]);
          }
          if (module.can.show() && !module.is.active()) {
            module.debug('Showing dropdown');
            if (module.has.message() && !(module.has.maxSelections() || module.has.allResultsFiltered())) {
              module.remove.message();
            }
            if (module.is.allFiltered()) {
              return true;
            }
            if (settings.onShow.call(element) !== false) {
              module.animate.show(function () {
                if (module.can.click()) {
                  module.bind.intent();
                }
                if (module.has.search() && !preventFocus) {
                  module.focusSearch();
                }
                module.set.visible();
                callback.call(element);
              });
            }
          }
        },
        hide: function hide(callback, preventBlur) {
          callback = $.isFunction(callback) ? callback : function () {};
          if (module.is.active() && !module.is.animatingOutward()) {
            module.debug('Hiding dropdown');
            if (settings.onHide.call(element) !== false) {
              module.animate.hide(function () {
                module.remove.visible();
                // hidding search focus
                if (module.is.focusedOnSearch() && preventBlur !== true) {
                  $search.blur();
                }
                callback.call(element);
              });
            }
          } else if (module.can.click()) {
            module.unbind.intent();
          }
          iconClicked = false;
          focused = false;
        },
        hideOthers: function hideOthers() {
          module.verbose('Finding other dropdowns to hide');
          $allModules.not($module).has(selector.menu + '.' + className.visible).dropdown('hide');
        },
        hideMenu: function hideMenu() {
          module.verbose('Hiding menu  instantaneously');
          module.remove.active();
          module.remove.visible();
          $menu.transition('hide');
        },
        hideSubMenus: function hideSubMenus() {
          var $subMenus = $menu.children(selector.item).find(selector.menu);
          module.verbose('Hiding sub menus', $subMenus);
          $subMenus.transition('hide');
        },
        bind: {
          events: function events() {
            module.bind.keyboardEvents();
            module.bind.inputEvents();
            module.bind.mouseEvents();
          },
          keyboardEvents: function keyboardEvents() {
            module.verbose('Binding keyboard events');
            $module.on('keydown' + eventNamespace, module.event.keydown);
            if (module.has.search()) {
              $module.on(module.get.inputEvent() + eventNamespace, selector.search, module.event.input);
            }
            if (module.is.multiple()) {
              $document.on('keydown' + elementNamespace, module.event.document.keydown);
            }
          },
          inputEvents: function inputEvents() {
            module.verbose('Binding input change events');
            $module.on('change' + eventNamespace, selector.input, module.event.change);
          },
          mouseEvents: function mouseEvents() {
            module.verbose('Binding mouse events');
            if (module.is.multiple()) {
              $module.on(clickEvent + eventNamespace, selector.label, module.event.label.click).on(clickEvent + eventNamespace, selector.remove, module.event.remove.click);
            }
            if (module.is.searchSelection()) {
              $module.on('mousedown' + eventNamespace, module.event.mousedown).on('mouseup' + eventNamespace, module.event.mouseup).on('mousedown' + eventNamespace, selector.menu, module.event.menu.mousedown).on('mouseup' + eventNamespace, selector.menu, module.event.menu.mouseup).on(clickEvent + eventNamespace, selector.icon, module.event.icon.click).on(clickEvent + eventNamespace, selector.clearIcon, module.event.clearIcon.click).on('focus' + eventNamespace, selector.search, module.event.search.focus).on(clickEvent + eventNamespace, selector.search, module.event.search.focus).on('blur' + eventNamespace, selector.search, module.event.search.blur).on(clickEvent + eventNamespace, selector.text, module.event.text.focus);
              if (module.is.multiple()) {
                $module.on(clickEvent + eventNamespace, module.event.click).on(clickEvent + eventNamespace, module.event.search.focus);
              }
            } else {
              if (settings.on == 'click') {
                $module.on(clickEvent + eventNamespace, selector.icon, module.event.icon.click).on(clickEvent + eventNamespace, module.event.test.toggle);
              } else if (settings.on == 'hover') {
                $module.on('mouseenter' + eventNamespace, module.delay.show).on('mouseleave' + eventNamespace, module.delay.hide);
              } else {
                $module.on(settings.on + eventNamespace, module.toggle);
              }
              $module.on('mousedown' + eventNamespace, module.event.mousedown).on('mouseup' + eventNamespace, module.event.mouseup).on('focus' + eventNamespace, module.event.focus).on(clickEvent + eventNamespace, selector.clearIcon, module.event.clearIcon.click);
              if (module.has.menuSearch()) {
                $module.on('blur' + eventNamespace, selector.search, module.event.search.blur);
              } else {
                $module.on('blur' + eventNamespace, module.event.blur);
              }
            }
            $menu.on((hasTouch ? 'touchstart' : 'mouseenter') + eventNamespace, selector.item, module.event.item.mouseenter).on('mouseleave' + eventNamespace, selector.item, module.event.item.mouseleave).on('click' + eventNamespace, selector.item, module.event.item.click);
          },
          intent: function intent() {
            module.verbose('Binding hide intent event to document');
            if (hasTouch) {
              $document.on('touchstart' + elementNamespace, module.event.test.touch).on('touchmove' + elementNamespace, module.event.test.touch);
            }
            $document.on(clickEvent + elementNamespace, module.event.test.hide);
          }
        },
        unbind: {
          intent: function intent() {
            module.verbose('Removing hide intent event from document');
            if (hasTouch) {
              $document.off('touchstart' + elementNamespace).off('touchmove' + elementNamespace);
            }
            $document.off(clickEvent + elementNamespace);
          }
        },
        filter: function filter(query) {
          var searchTerm = query !== undefined ? query : module.get.query(),
            afterFiltered = function afterFiltered() {
              if (module.is.multiple()) {
                module.filterActive();
              }
              if (query || !query && module.get.activeItem().length == 0) {
                module.select.firstUnfiltered();
              }
              if (module.has.allResultsFiltered()) {
                if (settings.onNoResults.call(element, searchTerm)) {
                  if (settings.allowAdditions) {
                    if (settings.hideAdditions) {
                      module.verbose('User addition with no menu, setting empty style');
                      module.set.empty();
                      module.hideMenu();
                    }
                  } else {
                    module.verbose('All items filtered, showing message', searchTerm);
                    module.add.message(message.noResults);
                  }
                } else {
                  module.verbose('All items filtered, hiding dropdown', searchTerm);
                  module.hideMenu();
                }
              } else {
                module.remove.empty();
                module.remove.message();
              }
              if (settings.allowAdditions) {
                module.add.userSuggestion(module.escape.htmlEntities(query));
              }
              if (module.is.searchSelection() && module.can.show() && module.is.focusedOnSearch()) {
                module.show();
              }
            };
          if (settings.useLabels && module.has.maxSelections()) {
            return;
          }
          if (settings.apiSettings) {
            if (module.can.useAPI()) {
              module.queryRemote(searchTerm, function () {
                if (settings.filterRemoteData) {
                  module.filterItems(searchTerm);
                }
                var preSelected = $input.val();
                if (!Array.isArray(preSelected)) {
                  preSelected = preSelected && preSelected !== "" ? preSelected.split(settings.delimiter) : [];
                }
                if (module.is.multiple()) {
                  $.each(preSelected, function (index, value) {
                    $item.filter('[data-value="' + value + '"]').addClass(className.filtered);
                  });
                }
                module.focusSearch(true);
                afterFiltered();
              });
            } else {
              module.error(error.noAPI);
            }
          } else {
            module.filterItems(searchTerm);
            afterFiltered();
          }
        },
        queryRemote: function queryRemote(query, callback, callbackParameters) {
          if (!Array.isArray(callbackParameters)) {
            callbackParameters = [callbackParameters];
          }
          var apiSettings = {
            errorDuration: false,
            cache: 'local',
            throttle: settings.throttle,
            urlData: {
              query: query
            },
            onError: function onError() {
              module.add.message(message.serverError);
              iconClicked = false;
              focused = false;
              callback.apply(null, callbackParameters);
            },
            onFailure: function onFailure() {
              module.add.message(message.serverError);
              iconClicked = false;
              focused = false;
              callback.apply(null, callbackParameters);
            },
            onSuccess: function onSuccess(response) {
              var values = response[fields.remoteValues];
              if (!Array.isArray(values)) {
                values = [];
              }
              module.remove.message();
              var menuConfig = {};
              menuConfig[fields.values] = values;
              module.setup.menu(menuConfig);
              if (values.length === 0 && !settings.allowAdditions) {
                module.add.message(message.noResults);
              } else {
                var value = module.is.multiple() ? module.get.values() : module.get.value();
                if (value !== '') {
                  module.verbose('Value(s) present after click icon, select value(s) in items');
                  module.set.selected(value, null, null, true);
                }
              }
              iconClicked = false;
              focused = false;
              callback.apply(null, callbackParameters);
            }
          };
          if (!$module.api('get request')) {
            module.setup.api();
          }
          apiSettings = $.extend(true, {}, apiSettings, settings.apiSettings);
          $module.api('setting', apiSettings).api('query');
        },
        filterItems: function filterItems(query) {
          var searchTerm = module.remove.diacritics(query !== undefined ? query : module.get.query()),
            results = null,
            escapedTerm = module.escape.string(searchTerm),
            regExpFlags = (settings.ignoreSearchCase ? 'i' : '') + 'gm',
            beginsWithRegExp = new RegExp('^' + escapedTerm, regExpFlags);
          // avoid loop if we're matching nothing
          if (module.has.query()) {
            results = [];
            module.verbose('Searching for matching values', searchTerm);
            $item.each(function () {
              var $choice = $(this),
                text,
                value;
              if ($choice.hasClass(className.unfilterable)) {
                results.push(this);
                return true;
              }
              if (settings.match === 'both' || settings.match === 'text') {
                text = module.remove.diacritics(String(module.get.choiceText($choice, false)));
                if (text.search(beginsWithRegExp) !== -1) {
                  results.push(this);
                  return true;
                } else if (settings.fullTextSearch === 'exact' && module.exactSearch(searchTerm, text)) {
                  results.push(this);
                  return true;
                } else if (settings.fullTextSearch === true && module.fuzzySearch(searchTerm, text)) {
                  results.push(this);
                  return true;
                }
              }
              if (settings.match === 'both' || settings.match === 'value') {
                value = module.remove.diacritics(String(module.get.choiceValue($choice, text)));
                if (value.search(beginsWithRegExp) !== -1) {
                  results.push(this);
                  return true;
                } else if (settings.fullTextSearch === 'exact' && module.exactSearch(searchTerm, value)) {
                  results.push(this);
                  return true;
                } else if (settings.fullTextSearch === true && module.fuzzySearch(searchTerm, value)) {
                  results.push(this);
                  return true;
                }
              }
            });
          }
          module.debug('Showing only matched items', searchTerm);
          module.remove.filteredItem();
          if (results) {
            $item.not(results).addClass(className.filtered);
          }
          if (!module.has.query()) {
            $divider.removeClass(className.hidden);
          } else if (settings.hideDividers === true) {
            $divider.addClass(className.hidden);
          } else if (settings.hideDividers === 'empty') {
            $divider.removeClass(className.hidden).filter(function () {
              // First find the last divider in this divider group
              // Dividers which are direct siblings are considered a group
              var lastDivider = $(this).nextUntil(selector.item);
              return (lastDivider.length ? lastDivider : $(this)
              // Count all non-filtered items until the next divider (or end of the dropdown)
              ).nextUntil(selector.divider).filter(selector.item + ":not(." + className.filtered + ")")
              // Hide divider if no items are found
              .length === 0;
            }).addClass(className.hidden);
          }
        },
        fuzzySearch: function fuzzySearch(query, term) {
          var termLength = term.length,
            queryLength = query.length;
          query = settings.ignoreSearchCase ? query.toLowerCase() : query;
          term = settings.ignoreSearchCase ? term.toLowerCase() : term;
          if (queryLength > termLength) {
            return false;
          }
          if (queryLength === termLength) {
            return query === term;
          }
          search: for (var characterIndex = 0, nextCharacterIndex = 0; characterIndex < queryLength; characterIndex++) {
            var queryCharacter = query.charCodeAt(characterIndex);
            while (nextCharacterIndex < termLength) {
              if (term.charCodeAt(nextCharacterIndex++) === queryCharacter) {
                continue search;
              }
            }
            return false;
          }
          return true;
        },
        exactSearch: function exactSearch(query, term) {
          query = settings.ignoreSearchCase ? query.toLowerCase() : query;
          term = settings.ignoreSearchCase ? term.toLowerCase() : term;
          return term.indexOf(query) > -1;
        },
        filterActive: function filterActive() {
          if (settings.useLabels) {
            $item.filter('.' + className.active).addClass(className.filtered);
          }
        },
        focusSearch: function focusSearch(skipHandler) {
          if (module.has.search() && !module.is.focusedOnSearch()) {
            if (skipHandler) {
              $module.off('focus' + eventNamespace, selector.search);
              $search.focus();
              $module.on('focus' + eventNamespace, selector.search, module.event.search.focus);
            } else {
              $search.focus();
            }
          }
        },
        blurSearch: function blurSearch() {
          if (module.has.search()) {
            $search.blur();
          }
        },
        forceSelection: function forceSelection() {
          var $currentlySelected = $item.not(className.filtered).filter('.' + className.selected).eq(0),
            $activeItem = $item.not(className.filtered).filter('.' + className.active).eq(0),
            $selectedItem = $currentlySelected.length > 0 ? $currentlySelected : $activeItem,
            hasSelected = $selectedItem.length > 0;
          if (settings.allowAdditions || hasSelected && !module.is.multiple()) {
            module.debug('Forcing partial selection to selected item', $selectedItem);
            module.event.item.click.call($selectedItem, {}, true);
          } else {
            module.remove.searchTerm();
          }
        },
        change: {
          values: function values(_values) {
            if (!settings.allowAdditions) {
              module.clear();
            }
            module.debug('Creating dropdown with specified values', _values);
            var menuConfig = {};
            menuConfig[fields.values] = _values;
            module.setup.menu(menuConfig);
            $.each(_values, function (index, item) {
              if (item.selected == true) {
                module.debug('Setting initial selection to', item[fields.value]);
                module.set.selected(item[fields.value]);
                if (!module.is.multiple()) {
                  return false;
                }
              }
            });
            if (module.has.selectInput()) {
              module.disconnect.selectObserver();
              $input.html('');
              $input.append('<option disabled selected value></option>');
              $.each(_values, function (index, item) {
                var value = settings.templates.deQuote(item[fields.value]),
                  name = settings.templates.escape(item[fields.name] || '', settings.preserveHTML);
                $input.append('<option value="' + value + '">' + name + '</option>');
              });
              module.observe.select();
            }
          }
        },
        event: {
          change: function change() {
            if (!internalChange) {
              module.debug('Input changed, updating selection');
              module.set.selected();
            }
          },
          focus: function focus() {
            if (settings.showOnFocus && !activated && module.is.hidden() && !pageLostFocus) {
              focused = true;
              module.show();
            }
          },
          blur: function blur(event) {
            pageLostFocus = document.activeElement === this;
            if (!activated && !pageLostFocus) {
              module.remove.activeLabel();
              module.hide();
            }
          },
          mousedown: function mousedown() {
            if (module.is.searchSelection()) {
              // prevent menu hiding on immediate re-focus
              willRefocus = true;
            } else {
              // prevents focus callback from occurring on mousedown
              activated = true;
            }
          },
          mouseup: function mouseup() {
            if (module.is.searchSelection()) {
              // prevent menu hiding on immediate re-focus
              willRefocus = false;
            } else {
              activated = false;
            }
          },
          click: function click(event) {
            var $target = $(event.target);
            // focus search
            if ($target.is($module)) {
              if (!module.is.focusedOnSearch()) {
                module.focusSearch();
              } else {
                module.show();
              }
            }
          },
          search: {
            focus: function focus(event) {
              activated = true;
              if (module.is.multiple()) {
                module.remove.activeLabel();
              }
              if (!focused && !module.is.active() && (settings.showOnFocus || event.type !== 'focus' && event.type !== 'focusin')) {
                focused = true;
                module.search();
              }
            },
            blur: function blur(event) {
              pageLostFocus = document.activeElement === this;
              if (module.is.searchSelection() && !willRefocus) {
                if (!itemActivated && !pageLostFocus) {
                  if (settings.forceSelection) {
                    module.forceSelection();
                  } else if (!settings.allowAdditions) {
                    module.remove.searchTerm();
                  }
                  module.hide();
                }
              }
              willRefocus = false;
            }
          },
          clearIcon: {
            click: function click(event) {
              module.clear();
              if (module.is.searchSelection()) {
                module.remove.searchTerm();
              }
              module.hide();
              event.stopPropagation();
            }
          },
          icon: {
            click: function click(event) {
              iconClicked = true;
              if (module.has.search()) {
                if (!module.is.active()) {
                  if (settings.showOnFocus) {
                    module.focusSearch();
                  } else {
                    module.toggle();
                  }
                } else {
                  module.blurSearch();
                }
              } else {
                module.toggle();
              }
              event.stopPropagation();
            }
          },
          text: {
            focus: function focus(event) {
              activated = true;
              module.focusSearch();
            }
          },
          input: function input(event) {
            if (module.is.multiple() || module.is.searchSelection()) {
              module.set.filtered();
            }
            clearTimeout(module.timer);
            module.timer = setTimeout(module.search, settings.delay.search);
          },
          label: {
            click: function click(event) {
              var $label = $(this),
                $labels = $module.find(selector.label),
                $activeLabels = $labels.filter('.' + className.active),
                $nextActive = $label.nextAll('.' + className.active),
                $prevActive = $label.prevAll('.' + className.active),
                $range = $nextActive.length > 0 ? $label.nextUntil($nextActive).add($activeLabels).add($label) : $label.prevUntil($prevActive).add($activeLabels).add($label);
              if (event.shiftKey) {
                $activeLabels.removeClass(className.active);
                $range.addClass(className.active);
              } else if (event.ctrlKey) {
                $label.toggleClass(className.active);
              } else {
                $activeLabels.removeClass(className.active);
                $label.addClass(className.active);
              }
              settings.onLabelSelect.apply(this, $labels.filter('.' + className.active));
              event.stopPropagation();
            }
          },
          remove: {
            click: function click(event) {
              var $label = $(this).parent();
              if ($label.hasClass(className.active)) {
                // remove all selected labels
                module.remove.activeLabels();
              } else {
                // remove this label only
                module.remove.activeLabels($label);
              }
              event.stopPropagation();
            }
          },
          test: {
            toggle: function toggle(event) {
              var toggleBehavior = module.is.multiple() ? module.show : module.toggle;
              if (module.is.bubbledLabelClick(event) || module.is.bubbledIconClick(event)) {
                return;
              }
              if (!module.is.multiple() || module.is.multiple() && !module.is.active()) {
                focused = true;
              }
              if (module.determine.eventOnElement(event, toggleBehavior)) {
                event.preventDefault();
              }
            },
            touch: function touch(event) {
              module.determine.eventOnElement(event, function () {
                if (event.type == 'touchstart') {
                  module.timer = setTimeout(function () {
                    module.hide();
                  }, settings.delay.touch);
                } else if (event.type == 'touchmove') {
                  clearTimeout(module.timer);
                }
              });
              event.stopPropagation();
            },
            hide: function hide(event) {
              if (module.determine.eventInModule(event, module.hide)) {
                if (element.id && $(event.target).attr('for') === element.id) {
                  event.preventDefault();
                }
              }
            }
          },
          "class": {
            mutation: function mutation(mutations) {
              mutations.forEach(function (mutation) {
                if (mutation.attributeName === "class") {
                  module.check.disabled();
                }
              });
            }
          },
          select: {
            mutation: function mutation(mutations) {
              module.debug('<select> modified, recreating menu');
              if (module.is.selectMutation(mutations)) {
                module.disconnect.selectObserver();
                module.refresh();
                module.setup.select();
                module.set.selected();
                module.observe.select();
              }
            }
          },
          menu: {
            mutation: function mutation(mutations) {
              var mutation = mutations[0],
                $addedNode = mutation.addedNodes ? $(mutation.addedNodes[0]) : $(false),
                $removedNode = mutation.removedNodes ? $(mutation.removedNodes[0]) : $(false),
                $changedNodes = $addedNode.add($removedNode),
                isUserAddition = $changedNodes.is(selector.addition) || $changedNodes.closest(selector.addition).length > 0,
                isMessage = $changedNodes.is(selector.message) || $changedNodes.closest(selector.message).length > 0;
              if (isUserAddition || isMessage) {
                module.debug('Updating item selector cache');
                module.refreshItems();
              } else {
                module.debug('Menu modified, updating selector cache');
                module.refresh();
              }
            },
            mousedown: function mousedown() {
              itemActivated = true;
            },
            mouseup: function mouseup() {
              itemActivated = false;
            }
          },
          item: {
            mouseenter: function mouseenter(event) {
              var $target = $(event.target),
                $item = $(this),
                $subMenu = $item.children(selector.menu),
                $otherMenus = $item.siblings(selector.item).children(selector.menu),
                hasSubMenu = $subMenu.length > 0,
                isBubbledEvent = $subMenu.find($target).length > 0;
              if (!isBubbledEvent && hasSubMenu) {
                clearTimeout(module.itemTimer);
                module.itemTimer = setTimeout(function () {
                  module.verbose('Showing sub-menu', $subMenu);
                  $.each($otherMenus, function () {
                    module.animate.hide(false, $(this));
                  });
                  module.animate.show(false, $subMenu);
                }, settings.delay.show);
                event.preventDefault();
              }
            },
            mouseleave: function mouseleave(event) {
              var $subMenu = $(this).children(selector.menu);
              if ($subMenu.length > 0) {
                clearTimeout(module.itemTimer);
                module.itemTimer = setTimeout(function () {
                  module.verbose('Hiding sub-menu', $subMenu);
                  module.animate.hide(false, $subMenu);
                }, settings.delay.hide);
              }
            },
            click: function click(event, skipRefocus) {
              var $choice = $(this),
                $target = event ? $(event.target) : $(''),
                $subMenu = $choice.find(selector.menu),
                text = module.get.choiceText($choice),
                value = module.get.choiceValue($choice, text),
                hasSubMenu = $subMenu.length > 0,
                isBubbledEvent = $subMenu.find($target).length > 0;
              // prevents IE11 bug where menu receives focus even though `tabindex=-1`
              if (document.activeElement.tagName.toLowerCase() !== 'input') {
                $(document.activeElement).blur();
              }
              if (!isBubbledEvent && (!hasSubMenu || settings.allowCategorySelection)) {
                if (module.is.searchSelection()) {
                  if (settings.allowAdditions) {
                    module.remove.userAddition();
                  }
                  module.remove.searchTerm();
                  if (!module.is.focusedOnSearch() && !(skipRefocus == true)) {
                    module.focusSearch(true);
                  }
                }
                if (!settings.useLabels) {
                  module.remove.filteredItem();
                  module.set.scrollPosition($choice);
                }
                module.determine.selectAction.call(this, text, value);
              }
            }
          },
          document: {
            // label selection should occur even when element has no focus
            keydown: function keydown(event) {
              var pressedKey = event.which,
                isShortcutKey = module.is.inObject(pressedKey, keys);
              if (isShortcutKey) {
                var $label = $module.find(selector.label),
                  $activeLabel = $label.filter('.' + className.active),
                  activeValue = $activeLabel.data(metadata.value),
                  labelIndex = $label.index($activeLabel),
                  labelCount = $label.length,
                  hasActiveLabel = $activeLabel.length > 0,
                  hasMultipleActive = $activeLabel.length > 1,
                  isFirstLabel = labelIndex === 0,
                  isLastLabel = labelIndex + 1 == labelCount,
                  isSearch = module.is.searchSelection(),
                  isFocusedOnSearch = module.is.focusedOnSearch(),
                  isFocused = module.is.focused(),
                  caretAtStart = isFocusedOnSearch && module.get.caretPosition(false) === 0,
                  isSelectedSearch = caretAtStart && module.get.caretPosition(true) !== 0,
                  $nextLabel;
                if (isSearch && !hasActiveLabel && !isFocusedOnSearch) {
                  return;
                }
                if (pressedKey == keys.leftArrow) {
                  // activate previous label
                  if ((isFocused || caretAtStart) && !hasActiveLabel) {
                    module.verbose('Selecting previous label');
                    $label.last().addClass(className.active);
                  } else if (hasActiveLabel) {
                    if (!event.shiftKey) {
                      module.verbose('Selecting previous label');
                      $label.removeClass(className.active);
                    } else {
                      module.verbose('Adding previous label to selection');
                    }
                    if (isFirstLabel && !hasMultipleActive) {
                      $activeLabel.addClass(className.active);
                    } else {
                      $activeLabel.prev(selector.siblingLabel).addClass(className.active).end();
                    }
                    event.preventDefault();
                  }
                } else if (pressedKey == keys.rightArrow) {
                  // activate first label
                  if (isFocused && !hasActiveLabel) {
                    $label.first().addClass(className.active);
                  }
                  // activate next label
                  if (hasActiveLabel) {
                    if (!event.shiftKey) {
                      module.verbose('Selecting next label');
                      $label.removeClass(className.active);
                    } else {
                      module.verbose('Adding next label to selection');
                    }
                    if (isLastLabel) {
                      if (isSearch) {
                        if (!isFocusedOnSearch) {
                          module.focusSearch();
                        } else {
                          $label.removeClass(className.active);
                        }
                      } else if (hasMultipleActive) {
                        $activeLabel.next(selector.siblingLabel).addClass(className.active);
                      } else {
                        $activeLabel.addClass(className.active);
                      }
                    } else {
                      $activeLabel.next(selector.siblingLabel).addClass(className.active);
                    }
                    event.preventDefault();
                  }
                } else if (pressedKey == keys.deleteKey || pressedKey == keys.backspace) {
                  if (hasActiveLabel) {
                    module.verbose('Removing active labels');
                    if (isLastLabel) {
                      if (isSearch && !isFocusedOnSearch) {
                        module.focusSearch();
                      }
                    }
                    $activeLabel.last().next(selector.siblingLabel).addClass(className.active);
                    module.remove.activeLabels($activeLabel);
                    event.preventDefault();
                  } else if (caretAtStart && !isSelectedSearch && !hasActiveLabel && pressedKey == keys.backspace) {
                    module.verbose('Removing last label on input backspace');
                    $activeLabel = $label.last().addClass(className.active);
                    module.remove.activeLabels($activeLabel);
                  }
                } else {
                  $activeLabel.removeClass(className.active);
                }
              }
            }
          },
          keydown: function keydown(event) {
            var pressedKey = event.which,
              isShortcutKey = module.is.inObject(pressedKey, keys);
            if (isShortcutKey) {
              var $currentlySelected = $item.not(selector.unselectable).filter('.' + className.selected).eq(0),
                $activeItem = $menu.children('.' + className.active).eq(0),
                $selectedItem = $currentlySelected.length > 0 ? $currentlySelected : $activeItem,
                $visibleItems = $selectedItem.length > 0 ? $selectedItem.siblings(':not(.' + className.filtered + ')').addBack() : $menu.children(':not(.' + className.filtered + ')'),
                $subMenu = $selectedItem.children(selector.menu),
                $parentMenu = $selectedItem.closest(selector.menu),
                inVisibleMenu = $parentMenu.hasClass(className.visible) || $parentMenu.hasClass(className.animating) || $parentMenu.parent(selector.menu).length > 0,
                hasSubMenu = $subMenu.length > 0,
                hasSelectedItem = $selectedItem.length > 0,
                selectedIsSelectable = $selectedItem.not(selector.unselectable).length > 0,
                delimiterPressed = pressedKey == keys.delimiter && settings.allowAdditions && module.is.multiple(),
                isAdditionWithoutMenu = settings.allowAdditions && settings.hideAdditions && (pressedKey == keys.enter || delimiterPressed) && selectedIsSelectable,
                $nextItem,
                isSubMenuItem,
                newIndex;
              // allow selection with menu closed
              if (isAdditionWithoutMenu) {
                module.verbose('Selecting item from keyboard shortcut', $selectedItem);
                module.event.item.click.call($selectedItem, event);
                if (module.is.searchSelection()) {
                  module.remove.searchTerm();
                }
                if (module.is.multiple()) {
                  event.preventDefault();
                }
              }

              // visible menu keyboard shortcuts
              if (module.is.visible()) {
                // enter (select or open sub-menu)
                if (pressedKey == keys.enter || delimiterPressed) {
                  if (pressedKey == keys.enter && hasSelectedItem && hasSubMenu && !settings.allowCategorySelection) {
                    module.verbose('Pressed enter on unselectable category, opening sub menu');
                    pressedKey = keys.rightArrow;
                  } else if (selectedIsSelectable) {
                    module.verbose('Selecting item from keyboard shortcut', $selectedItem);
                    module.event.item.click.call($selectedItem, event);
                    if (module.is.searchSelection()) {
                      module.remove.searchTerm();
                      if (module.is.multiple()) {
                        $search.focus();
                      }
                    }
                  }
                  event.preventDefault();
                }

                // sub-menu actions
                if (hasSelectedItem) {
                  if (pressedKey == keys.leftArrow) {
                    isSubMenuItem = $parentMenu[0] !== $menu[0];
                    if (isSubMenuItem) {
                      module.verbose('Left key pressed, closing sub-menu');
                      module.animate.hide(false, $parentMenu);
                      $selectedItem.removeClass(className.selected);
                      $parentMenu.closest(selector.item).addClass(className.selected);
                      event.preventDefault();
                    }
                  }

                  // right arrow (show sub-menu)
                  if (pressedKey == keys.rightArrow) {
                    if (hasSubMenu) {
                      module.verbose('Right key pressed, opening sub-menu');
                      module.animate.show(false, $subMenu);
                      $selectedItem.removeClass(className.selected);
                      $subMenu.find(selector.item).eq(0).addClass(className.selected);
                      event.preventDefault();
                    }
                  }
                }

                // up arrow (traverse menu up)
                if (pressedKey == keys.upArrow) {
                  $nextItem = hasSelectedItem && inVisibleMenu ? $selectedItem.prevAll(selector.item + ':not(' + selector.unselectable + ')').eq(0) : $item.eq(0);
                  if ($visibleItems.index($nextItem) < 0) {
                    module.verbose('Up key pressed but reached top of current menu');
                    event.preventDefault();
                    return;
                  } else {
                    module.verbose('Up key pressed, changing active item');
                    $selectedItem.removeClass(className.selected);
                    $nextItem.addClass(className.selected);
                    module.set.scrollPosition($nextItem);
                    if (settings.selectOnKeydown && module.is.single()) {
                      module.set.selectedItem($nextItem);
                    }
                  }
                  event.preventDefault();
                }

                // down arrow (traverse menu down)
                if (pressedKey == keys.downArrow) {
                  $nextItem = hasSelectedItem && inVisibleMenu ? $nextItem = $selectedItem.nextAll(selector.item + ':not(' + selector.unselectable + ')').eq(0) : $item.eq(0);
                  if ($nextItem.length === 0) {
                    module.verbose('Down key pressed but reached bottom of current menu');
                    event.preventDefault();
                    return;
                  } else {
                    module.verbose('Down key pressed, changing active item');
                    $item.removeClass(className.selected);
                    $nextItem.addClass(className.selected);
                    module.set.scrollPosition($nextItem);
                    if (settings.selectOnKeydown && module.is.single()) {
                      module.set.selectedItem($nextItem);
                    }
                  }
                  event.preventDefault();
                }

                // page down (show next page)
                if (pressedKey == keys.pageUp) {
                  module.scrollPage('up');
                  event.preventDefault();
                }
                if (pressedKey == keys.pageDown) {
                  module.scrollPage('down');
                  event.preventDefault();
                }

                // escape (close menu)
                if (pressedKey == keys.escape) {
                  module.verbose('Escape key pressed, closing dropdown');
                  module.hide();
                }
              } else {
                // delimiter key
                if (delimiterPressed) {
                  event.preventDefault();
                }
                // down arrow (open menu)
                if (pressedKey == keys.downArrow && !module.is.visible()) {
                  module.verbose('Down key pressed, showing dropdown');
                  module.show();
                  event.preventDefault();
                }
              }
            } else {
              if (!module.has.search()) {
                module.set.selectedLetter(String.fromCharCode(pressedKey));
              }
            }
          }
        },
        trigger: {
          change: function change() {
            var inputElement = $input[0];
            if (inputElement) {
              var events = document.createEvent('HTMLEvents');
              module.verbose('Triggering native change event');
              events.initEvent('change', true, false);
              inputElement.dispatchEvent(events);
            }
          }
        },
        determine: {
          selectAction: function selectAction(text, value) {
            selectActionActive = true;
            module.verbose('Determining action', settings.action);
            if ($.isFunction(module.action[settings.action])) {
              module.verbose('Triggering preset action', settings.action, text, value);
              module.action[settings.action].call(element, text, value, this);
            } else if ($.isFunction(settings.action)) {
              module.verbose('Triggering user action', settings.action, text, value);
              settings.action.call(element, text, value, this);
            } else {
              module.error(error.action, settings.action);
            }
            selectActionActive = false;
          },
          eventInModule: function eventInModule(event, callback) {
            var $target = $(event.target),
              inDocument = $target.closest(document.documentElement).length > 0,
              inModule = $target.closest($module).length > 0;
            callback = $.isFunction(callback) ? callback : function () {};
            if (inDocument && !inModule) {
              module.verbose('Triggering event', callback);
              callback();
              return true;
            } else {
              module.verbose('Event occurred in dropdown, canceling callback');
              return false;
            }
          },
          eventOnElement: function eventOnElement(event, callback) {
            var $target = $(event.target),
              $label = $target.closest(selector.siblingLabel),
              inVisibleDOM = document.body.contains(event.target),
              notOnLabel = $module.find($label).length === 0 || !(module.is.multiple() && settings.useLabels),
              notInMenu = $target.closest($menu).length === 0;
            callback = $.isFunction(callback) ? callback : function () {};
            if (inVisibleDOM && notOnLabel && notInMenu) {
              module.verbose('Triggering event', callback);
              callback();
              return true;
            } else {
              module.verbose('Event occurred in dropdown menu, canceling callback');
              return false;
            }
          }
        },
        action: {
          nothing: function nothing() {},
          activate: function activate(text, value, element) {
            value = value !== undefined ? value : text;
            if (module.can.activate($(element))) {
              module.set.selected(value, $(element));
              if (!module.is.multiple()) {
                module.hideAndClear();
              }
            }
          },
          select: function select(text, value, element) {
            value = value !== undefined ? value : text;
            if (module.can.activate($(element))) {
              module.set.value(value, text, $(element));
              if (!module.is.multiple()) {
                module.hideAndClear();
              }
            }
          },
          combo: function combo(text, value, element) {
            value = value !== undefined ? value : text;
            module.set.selected(value, $(element));
            module.hideAndClear();
          },
          hide: function hide(text, value, element) {
            module.set.value(value, text, $(element));
            module.hideAndClear();
          }
        },
        get: {
          id: function id() {
            return _id;
          },
          defaultText: function defaultText() {
            return $module.data(metadata.defaultText);
          },
          defaultValue: function defaultValue() {
            return $module.data(metadata.defaultValue);
          },
          placeholderText: function placeholderText() {
            if (settings.placeholder != 'auto' && typeof settings.placeholder == 'string') {
              return settings.placeholder;
            }
            return $module.data(metadata.placeholderText) || '';
          },
          text: function text() {
            return settings.preserveHTML ? $text.html() : $text.text();
          },
          query: function query() {
            return String($search.val()).trim();
          },
          searchWidth: function searchWidth(value) {
            value = value !== undefined ? value : $search.val();
            $sizer.text(value);
            // prevent rounding issues
            return Math.ceil($sizer.width() + 1);
          },
          selectionCount: function selectionCount() {
            var values = module.get.values(),
              count;
            count = module.is.multiple() ? Array.isArray(values) ? values.length : 0 : module.get.value() !== '' ? 1 : 0;
            return count;
          },
          transition: function transition($subMenu) {
            return settings.transition === 'auto' ? module.is.upward($subMenu) ? 'slide up' : 'slide down' : settings.transition;
          },
          userValues: function userValues() {
            var values = module.get.values();
            if (!values) {
              return false;
            }
            values = Array.isArray(values) ? values : [values];
            return $.grep(values, function (value) {
              return module.get.item(value) === false;
            });
          },
          uniqueArray: function uniqueArray(array) {
            return $.grep(array, function (value, index) {
              return $.inArray(value, array) === index;
            });
          },
          caretPosition: function caretPosition(returnEndPos) {
            var input = $search.get(0),
              range,
              rangeLength;
            if (returnEndPos && 'selectionEnd' in input) {
              return input.selectionEnd;
            } else if (!returnEndPos && 'selectionStart' in input) {
              return input.selectionStart;
            }
            if (document.selection) {
              input.focus();
              range = document.selection.createRange();
              rangeLength = range.text.length;
              if (returnEndPos) {
                return rangeLength;
              }
              range.moveStart('character', -input.value.length);
              return range.text.length - rangeLength;
            }
          },
          value: function value() {
            var value = $input.length > 0 ? $input.val() : $module.data(metadata.value),
              isEmptyMultiselect = Array.isArray(value) && value.length === 1 && value[0] === '';
            // prevents placeholder element from being selected when multiple
            return value === undefined || isEmptyMultiselect ? '' : value;
          },
          values: function values(raw) {
            var value = module.get.value();
            if (value === '') {
              return '';
            }
            return !module.has.selectInput() && module.is.multiple() ? typeof value == 'string' // delimited string
            ? (raw ? value : module.escape.htmlEntities(value)).split(settings.delimiter) : '' : value;
          },
          remoteValues: function remoteValues() {
            var values = module.get.values(),
              remoteValues = false;
            if (values) {
              if (typeof values == 'string') {
                values = [values];
              }
              $.each(values, function (index, value) {
                var name = module.read.remoteData(value);
                module.verbose('Restoring value from session data', name, value);
                if (name) {
                  if (!remoteValues) {
                    remoteValues = {};
                  }
                  remoteValues[value] = name;
                }
              });
            }
            return remoteValues;
          },
          choiceText: function choiceText($choice, preserveHTML) {
            preserveHTML = preserveHTML !== undefined ? preserveHTML : settings.preserveHTML;
            if ($choice) {
              if ($choice.find(selector.menu).length > 0) {
                module.verbose('Retrieving text of element with sub-menu');
                $choice = $choice.clone();
                $choice.find(selector.menu).remove();
                $choice.find(selector.menuIcon).remove();
              }
              return $choice.data(metadata.text) !== undefined ? $choice.data(metadata.text) : preserveHTML ? $choice.html() && $choice.html().trim() : $choice.text() && $choice.text().trim();
            }
          },
          choiceValue: function choiceValue($choice, choiceText) {
            choiceText = choiceText || module.get.choiceText($choice);
            if (!$choice) {
              return false;
            }
            return $choice.data(metadata.value) !== undefined ? String($choice.data(metadata.value)) : typeof choiceText === 'string' ? String(settings.ignoreSearchCase ? choiceText.toLowerCase() : choiceText).trim() : String(choiceText);
          },
          inputEvent: function inputEvent() {
            var input = $search[0];
            if (input) {
              return input.oninput !== undefined ? 'input' : input.onpropertychange !== undefined ? 'propertychange' : 'keyup';
            }
            return false;
          },
          selectValues: function selectValues() {
            var select = {},
              oldGroup = [],
              values = [];
            $module.find('option').each(function () {
              var $option = $(this),
                name = $option.html(),
                disabled = $option.attr('disabled'),
                value = $option.attr('value') !== undefined ? $option.attr('value') : name,
                text = $option.data(metadata.text) !== undefined ? $option.data(metadata.text) : name,
                group = $option.parent('optgroup');
              if (settings.placeholder === 'auto' && value === '') {
                select.placeholder = name;
              } else {
                if (group.length !== oldGroup.length || group[0] !== oldGroup[0]) {
                  values.push({
                    type: 'header',
                    divider: settings.headerDivider,
                    name: group.attr('label') || ''
                  });
                  oldGroup = group;
                }
                values.push({
                  name: name,
                  value: value,
                  text: text,
                  disabled: disabled
                });
              }
            });
            if (settings.placeholder && settings.placeholder !== 'auto') {
              module.debug('Setting placeholder value to', settings.placeholder);
              select.placeholder = settings.placeholder;
            }
            if (settings.sortSelect) {
              if (settings.sortSelect === true) {
                values.sort(function (a, b) {
                  return a.name.localeCompare(b.name);
                });
              } else if (settings.sortSelect === 'natural') {
                values.sort(function (a, b) {
                  return a.name.toLowerCase().localeCompare(b.name.toLowerCase());
                });
              } else if ($.isFunction(settings.sortSelect)) {
                values.sort(settings.sortSelect);
              }
              select[fields.values] = values;
              module.debug('Retrieved and sorted values from select', select);
            } else {
              select[fields.values] = values;
              module.debug('Retrieved values from select', select);
            }
            return select;
          },
          activeItem: function activeItem() {
            return $item.filter('.' + className.active);
          },
          selectedItem: function selectedItem() {
            var $selectedItem = $item.not(selector.unselectable).filter('.' + className.selected);
            return $selectedItem.length > 0 ? $selectedItem : $item.eq(0);
          },
          itemWithAdditions: function itemWithAdditions(value) {
            var $items = module.get.item(value),
              $userItems = module.create.userChoice(value),
              hasUserItems = $userItems && $userItems.length > 0;
            if (hasUserItems) {
              $items = $items.length > 0 ? $items.add($userItems) : $userItems;
            }
            return $items;
          },
          item: function item(value, strict) {
            var $selectedItem = false,
              shouldSearch,
              isMultiple;
            value = value !== undefined ? value : module.get.values() !== undefined ? module.get.values() : module.get.text();
            isMultiple = module.is.multiple() && Array.isArray(value);
            shouldSearch = isMultiple ? value.length > 0 : value !== undefined && value !== null;
            strict = value === '' || value === false || value === true ? true : strict || false;
            if (shouldSearch) {
              $item.each(function () {
                var $choice = $(this),
                  optionText = module.get.choiceText($choice),
                  optionValue = module.get.choiceValue($choice, optionText);
                // safe early exit
                if (optionValue === null || optionValue === undefined) {
                  return;
                }
                if (isMultiple) {
                  if ($.inArray(module.escape.htmlEntities(String(optionValue)), value.map(function (v) {
                    return String(v);
                  })) !== -1) {
                    $selectedItem = $selectedItem ? $selectedItem.add($choice) : $choice;
                  }
                } else if (strict) {
                  module.verbose('Ambiguous dropdown value using strict type check', $choice, value);
                  if (optionValue === value) {
                    $selectedItem = $choice;
                    return true;
                  }
                } else {
                  if (settings.ignoreCase) {
                    optionValue = optionValue.toLowerCase();
                    value = value.toLowerCase();
                  }
                  if (module.escape.htmlEntities(String(optionValue)) === module.escape.htmlEntities(String(value))) {
                    module.verbose('Found select item by value', optionValue, value);
                    $selectedItem = $choice;
                    return true;
                  }
                }
              });
            }
            return $selectedItem;
          },
          displayType: function displayType() {
            return $module.hasClass('column') ? 'flex' : settings.displayType;
          }
        },
        check: {
          maxSelections: function maxSelections(selectionCount) {
            if (settings.maxSelections) {
              selectionCount = selectionCount !== undefined ? selectionCount : module.get.selectionCount();
              if (selectionCount >= settings.maxSelections) {
                module.debug('Maximum selection count reached');
                if (settings.useLabels) {
                  $item.addClass(className.filtered);
                  module.add.message(message.maxSelections);
                }
                return true;
              } else {
                module.verbose('No longer at maximum selection count');
                module.remove.message();
                module.remove.filteredItem();
                if (module.is.searchSelection()) {
                  module.filterItems();
                }
                return false;
              }
            }
            return true;
          },
          disabled: function disabled() {
            $search.attr('tabindex', module.is.disabled() ? -1 : 0);
          }
        },
        restore: {
          defaults: function defaults(preventChangeTrigger) {
            module.clear(preventChangeTrigger);
            module.restore.defaultText();
            module.restore.defaultValue();
          },
          defaultText: function defaultText() {
            var defaultText = module.get.defaultText(),
              placeholderText = module.get.placeholderText;
            if (defaultText === placeholderText) {
              module.debug('Restoring default placeholder text', defaultText);
              module.set.placeholderText(defaultText);
            } else {
              module.debug('Restoring default text', defaultText);
              module.set.text(defaultText);
            }
          },
          placeholderText: function placeholderText() {
            module.set.placeholderText();
          },
          defaultValue: function defaultValue() {
            var defaultValue = module.get.defaultValue();
            if (defaultValue !== undefined) {
              module.debug('Restoring default value', defaultValue);
              if (defaultValue !== '') {
                module.set.value(defaultValue);
                module.set.selected();
              } else {
                module.remove.activeItem();
                module.remove.selectedItem();
              }
            }
          },
          labels: function labels() {
            if (settings.allowAdditions) {
              if (!settings.useLabels) {
                module.error(error.labels);
                settings.useLabels = true;
              }
              module.debug('Restoring selected values');
              module.create.userLabels();
            }
            module.check.maxSelections();
          },
          selected: function selected() {
            module.restore.values();
            if (module.is.multiple()) {
              module.debug('Restoring previously selected values and labels');
              module.restore.labels();
            } else {
              module.debug('Restoring previously selected values');
            }
          },
          values: function values() {
            // prevents callbacks from occurring on initial load
            module.set.initialLoad();
            if (settings.apiSettings && settings.saveRemoteData && module.get.remoteValues()) {
              module.restore.remoteValues();
            } else {
              module.set.selected();
            }
            var value = module.get.value();
            if (value && value !== '' && !(Array.isArray(value) && value.length === 0)) {
              $input.removeClass(className.noselection);
            } else {
              $input.addClass(className.noselection);
            }
            module.remove.initialLoad();
          },
          remoteValues: function remoteValues() {
            var values = module.get.remoteValues();
            module.debug('Recreating selected from session data', values);
            if (values) {
              if (module.is.single()) {
                $.each(values, function (value, name) {
                  module.set.text(name);
                });
              } else {
                $.each(values, function (value, name) {
                  module.add.label(value, name);
                });
              }
            }
          }
        },
        read: {
          remoteData: function remoteData(value) {
            var name;
            if (window.Storage === undefined) {
              module.error(error.noStorage);
              return;
            }
            name = sessionStorage.getItem(value);
            return name !== undefined ? name : false;
          }
        },
        save: {
          defaults: function defaults() {
            module.save.defaultText();
            module.save.placeholderText();
            module.save.defaultValue();
          },
          defaultValue: function defaultValue() {
            var value = module.get.value();
            module.verbose('Saving default value as', value);
            $module.data(metadata.defaultValue, value);
          },
          defaultText: function defaultText() {
            var text = module.get.text();
            module.verbose('Saving default text as', text);
            $module.data(metadata.defaultText, text);
          },
          placeholderText: function placeholderText() {
            var text;
            if (settings.placeholder !== false && $text.hasClass(className.placeholder)) {
              text = module.get.text();
              module.verbose('Saving placeholder text as', text);
              $module.data(metadata.placeholderText, text);
            }
          },
          remoteData: function remoteData(name, value) {
            if (window.Storage === undefined) {
              module.error(error.noStorage);
              return;
            }
            module.verbose('Saving remote data to session storage', value, name);
            sessionStorage.setItem(value, name);
          }
        },
        clear: function clear(preventChangeTrigger) {
          if (module.is.multiple() && settings.useLabels) {
            module.remove.labels($module.find(selector.label), preventChangeTrigger);
          } else {
            module.remove.activeItem();
            module.remove.selectedItem();
            module.remove.filteredItem();
          }
          module.set.placeholderText();
          module.clearValue(preventChangeTrigger);
        },
        clearValue: function clearValue(preventChangeTrigger) {
          module.set.value('', null, null, preventChangeTrigger);
        },
        scrollPage: function scrollPage(direction, $selectedItem) {
          var $currentItem = $selectedItem || module.get.selectedItem(),
            $menu = $currentItem.closest(selector.menu),
            menuHeight = $menu.outerHeight(),
            currentScroll = $menu.scrollTop(),
            itemHeight = $item.eq(0).outerHeight(),
            itemsPerPage = Math.floor(menuHeight / itemHeight),
            maxScroll = $menu.prop('scrollHeight'),
            newScroll = direction == 'up' ? currentScroll - itemHeight * itemsPerPage : currentScroll + itemHeight * itemsPerPage,
            $selectableItem = $item.not(selector.unselectable),
            isWithinRange,
            $nextSelectedItem,
            elementIndex;
          elementIndex = direction == 'up' ? $selectableItem.index($currentItem) - itemsPerPage : $selectableItem.index($currentItem) + itemsPerPage;
          isWithinRange = direction == 'up' ? elementIndex >= 0 : elementIndex < $selectableItem.length;
          $nextSelectedItem = isWithinRange ? $selectableItem.eq(elementIndex) : direction == 'up' ? $selectableItem.first() : $selectableItem.last();
          if ($nextSelectedItem.length > 0) {
            module.debug('Scrolling page', direction, $nextSelectedItem);
            $currentItem.removeClass(className.selected);
            $nextSelectedItem.addClass(className.selected);
            if (settings.selectOnKeydown && module.is.single()) {
              module.set.selectedItem($nextSelectedItem);
            }
            $menu.scrollTop(newScroll);
          }
        },
        set: {
          filtered: function filtered() {
            var isMultiple = module.is.multiple(),
              isSearch = module.is.searchSelection(),
              isSearchMultiple = isMultiple && isSearch,
              searchValue = isSearch ? module.get.query() : '',
              hasSearchValue = typeof searchValue === 'string' && searchValue.length > 0,
              searchWidth = module.get.searchWidth(),
              valueIsSet = searchValue !== '';
            if (isMultiple && hasSearchValue) {
              module.verbose('Adjusting input width', searchWidth, settings.glyphWidth);
              $search.css('width', searchWidth);
            }
            if (hasSearchValue || isSearchMultiple && valueIsSet) {
              module.verbose('Hiding placeholder text');
              $text.addClass(className.filtered);
            } else if (!isMultiple || isSearchMultiple && !valueIsSet) {
              module.verbose('Showing placeholder text');
              $text.removeClass(className.filtered);
            }
          },
          empty: function empty() {
            $module.addClass(className.empty);
          },
          loading: function loading() {
            $module.addClass(className.loading);
          },
          placeholderText: function placeholderText(text) {
            text = text || module.get.placeholderText();
            module.debug('Setting placeholder text', text);
            module.set.text(text);
            $text.addClass(className.placeholder);
          },
          tabbable: function tabbable() {
            if (module.is.searchSelection()) {
              module.debug('Added tabindex to searchable dropdown');
              $search.val('');
              module.check.disabled();
              $menu.attr('tabindex', -1);
            } else {
              module.debug('Added tabindex to dropdown');
              if ($module.attr('tabindex') === undefined) {
                $module.attr('tabindex', 0);
                $menu.attr('tabindex', -1);
              }
            }
          },
          initialLoad: function initialLoad() {
            module.verbose('Setting initial load');
            _initialLoad = true;
          },
          activeItem: function activeItem($item) {
            if (settings.allowAdditions && $item.filter(selector.addition).length > 0) {
              $item.addClass(className.filtered);
            } else {
              $item.addClass(className.active);
            }
          },
          partialSearch: function partialSearch(text) {
            var length = module.get.query().length;
            $search.val(text.substr(0, length));
          },
          scrollPosition: function scrollPosition($item, forceScroll) {
            var edgeTolerance = 5,
              $menu,
              hasActive,
              offset,
              itemHeight,
              itemOffset,
              menuOffset,
              menuScroll,
              menuHeight,
              abovePage,
              belowPage;
            $item = $item || module.get.selectedItem();
            $menu = $item.closest(selector.menu);
            hasActive = $item && $item.length > 0;
            forceScroll = forceScroll !== undefined ? forceScroll : false;
            if (module.get.activeItem().length === 0) {
              forceScroll = false;
            }
            if ($item && $menu.length > 0 && hasActive) {
              itemOffset = $item.position().top;
              $menu.addClass(className.loading);
              menuScroll = $menu.scrollTop();
              menuOffset = $menu.offset().top;
              itemOffset = $item.offset().top;
              offset = menuScroll - menuOffset + itemOffset;
              if (!forceScroll) {
                menuHeight = $menu.height();
                belowPage = menuScroll + menuHeight < offset + edgeTolerance;
                abovePage = offset - edgeTolerance < menuScroll;
              }
              module.debug('Scrolling to active item', offset);
              if (forceScroll || abovePage || belowPage) {
                $menu.scrollTop(offset);
              }
              $menu.removeClass(className.loading);
            }
          },
          text: function text(_text) {
            if (settings.action === 'combo') {
              module.debug('Changing combo button text', _text, $combo);
              if (settings.preserveHTML) {
                $combo.html(_text);
              } else {
                $combo.text(_text);
              }
            } else if (settings.action === 'activate') {
              if (_text !== module.get.placeholderText()) {
                $text.removeClass(className.placeholder);
              }
              module.debug('Changing text', _text, $text);
              $text.removeClass(className.filtered);
              if (settings.preserveHTML) {
                $text.html(_text);
              } else {
                $text.text(_text);
              }
            }
          },
          selectedItem: function selectedItem($item) {
            var value = module.get.choiceValue($item),
              searchText = module.get.choiceText($item, false),
              text = module.get.choiceText($item, true);
            module.debug('Setting user selection to item', $item);
            module.remove.activeItem();
            module.set.partialSearch(searchText);
            module.set.activeItem($item);
            module.set.selected(value, $item);
            module.set.text(text);
          },
          selectedLetter: function selectedLetter(letter) {
            var $selectedItem = $item.filter('.' + className.selected),
              alreadySelectedLetter = $selectedItem.length > 0 && module.has.firstLetter($selectedItem, letter),
              $nextValue = false,
              $nextItem;
            // check next of same letter
            if (alreadySelectedLetter) {
              $nextItem = $selectedItem.nextAll($item).eq(0);
              if (module.has.firstLetter($nextItem, letter)) {
                $nextValue = $nextItem;
              }
            }
            // check all values
            if (!$nextValue) {
              $item.each(function () {
                if (module.has.firstLetter($(this), letter)) {
                  $nextValue = $(this);
                  return false;
                }
              });
            }
            // set next value
            if ($nextValue) {
              module.verbose('Scrolling to next value with letter', letter);
              module.set.scrollPosition($nextValue);
              $selectedItem.removeClass(className.selected);
              $nextValue.addClass(className.selected);
              if (settings.selectOnKeydown && module.is.single()) {
                module.set.selectedItem($nextValue);
              }
            }
          },
          direction: function direction($menu) {
            if (settings.direction == 'auto') {
              // reset position, remove upward if it's base menu
              if (!$menu) {
                module.remove.upward();
              } else if (module.is.upward($menu)) {
                //we need make sure when make assertion openDownward for $menu, $menu does not have upward class
                module.remove.upward($menu);
              }
              if (module.can.openDownward($menu)) {
                module.remove.upward($menu);
              } else {
                module.set.upward($menu);
              }
              if (!module.is.leftward($menu) && !module.can.openRightward($menu)) {
                module.set.leftward($menu);
              }
            } else if (settings.direction == 'upward') {
              module.set.upward($menu);
            }
          },
          upward: function upward($currentMenu) {
            var $element = $currentMenu || $module;
            $element.addClass(className.upward);
          },
          leftward: function leftward($currentMenu) {
            var $element = $currentMenu || $menu;
            $element.addClass(className.leftward);
          },
          value: function value(_value, text, $selected, preventChangeTrigger) {
            if (_value !== undefined && _value !== '' && !(Array.isArray(_value) && _value.length === 0)) {
              $input.removeClass(className.noselection);
            } else {
              $input.addClass(className.noselection);
            }
            var escapedValue = module.escape.value(_value),
              hasInput = $input.length > 0,
              currentValue = module.get.values(),
              stringValue = _value !== undefined ? String(_value) : _value,
              newValue;
            if (hasInput) {
              if (!settings.allowReselection && stringValue == currentValue) {
                module.verbose('Skipping value update already same value', _value, currentValue);
                if (!module.is.initialLoad()) {
                  return;
                }
              }
              if (module.is.single() && module.has.selectInput() && module.can.extendSelect()) {
                module.debug('Adding user option', _value);
                module.add.optionValue(_value);
              }
              module.debug('Updating input value', escapedValue, currentValue);
              internalChange = true;
              $input.val(escapedValue);
              if (settings.fireOnInit === false && module.is.initialLoad()) {
                module.debug('Input native change event ignored on initial load');
              } else if (preventChangeTrigger !== true) {
                module.trigger.change();
              }
              internalChange = false;
            } else {
              module.verbose('Storing value in metadata', escapedValue, $input);
              if (escapedValue !== currentValue) {
                $module.data(metadata.value, stringValue);
              }
            }
            if (settings.fireOnInit === false && module.is.initialLoad()) {
              module.verbose('No callback on initial load', settings.onChange);
            } else if (preventChangeTrigger !== true) {
              settings.onChange.call(element, _value, text, $selected);
            }
          },
          active: function active() {
            $module.addClass(className.active);
          },
          multiple: function multiple() {
            $module.addClass(className.multiple);
          },
          visible: function visible() {
            $module.addClass(className.visible);
          },
          exactly: function exactly(value, $selectedItem) {
            module.debug('Setting selected to exact values');
            module.clear();
            module.set.selected(value, $selectedItem);
          },
          selected: function selected(value, $selectedItem, preventChangeTrigger, keepSearchTerm) {
            var isMultiple = module.is.multiple();
            $selectedItem = settings.allowAdditions ? $selectedItem || module.get.itemWithAdditions(value) : $selectedItem || module.get.item(value);
            if (!$selectedItem) {
              return;
            }
            module.debug('Setting selected menu item to', $selectedItem);
            if (module.is.multiple()) {
              module.remove.searchWidth();
            }
            if (module.is.single()) {
              module.remove.activeItem();
              module.remove.selectedItem();
            } else if (settings.useLabels) {
              module.remove.selectedItem();
            }
            // select each item
            $selectedItem.each(function () {
              var $selected = $(this),
                selectedText = module.get.choiceText($selected),
                selectedValue = module.get.choiceValue($selected, selectedText),
                isFiltered = $selected.hasClass(className.filtered),
                isActive = $selected.hasClass(className.active),
                isUserValue = $selected.hasClass(className.addition),
                shouldAnimate = isMultiple && $selectedItem.length == 1;
              if (isMultiple) {
                if (!isActive || isUserValue) {
                  if (settings.apiSettings && settings.saveRemoteData) {
                    module.save.remoteData(selectedText, selectedValue);
                  }
                  if (settings.useLabels) {
                    module.add.label(selectedValue, selectedText, shouldAnimate);
                    module.add.value(selectedValue, selectedText, $selected);
                    module.set.activeItem($selected);
                    module.filterActive();
                    module.select.nextAvailable($selectedItem);
                  } else {
                    module.add.value(selectedValue, selectedText, $selected);
                    module.set.text(module.add.variables(message.count));
                    module.set.activeItem($selected);
                  }
                } else if (!isFiltered && (settings.useLabels || selectActionActive)) {
                  module.debug('Selected active value, removing label');
                  module.remove.selected(selectedValue);
                }
              } else {
                if (settings.apiSettings && settings.saveRemoteData) {
                  module.save.remoteData(selectedText, selectedValue);
                }
                if (!keepSearchTerm) {
                  module.set.text(selectedText);
                }
                module.set.value(selectedValue, selectedText, $selected, preventChangeTrigger);
                $selected.addClass(className.active).addClass(className.selected);
              }
            });
            if (!keepSearchTerm) {
              module.remove.searchTerm();
            }
          }
        },
        add: {
          label: function label(value, text, shouldAnimate) {
            var $next = module.is.searchSelection() ? $search : $text,
              escapedValue = module.escape.value(value),
              $label;
            if (settings.ignoreCase) {
              escapedValue = escapedValue.toLowerCase();
            }
            $label = $('<a />').addClass(className.label).attr('data-' + metadata.value, escapedValue).html(templates.label(escapedValue, text, settings.preserveHTML, settings.className));
            $label = settings.onLabelCreate.call($label, escapedValue, text);
            if (module.has.label(value)) {
              module.debug('User selection already exists, skipping', escapedValue);
              return;
            }
            if (settings.label.variation) {
              $label.addClass(settings.label.variation);
            }
            if (shouldAnimate === true) {
              module.debug('Animating in label', $label);
              $label.addClass(className.hidden).insertBefore($next).transition({
                animation: settings.label.transition,
                debug: settings.debug,
                verbose: settings.verbose,
                duration: settings.label.duration
              });
            } else {
              module.debug('Adding selection label', $label);
              $label.insertBefore($next);
            }
          },
          message: function message(_message) {
            var $message = $menu.children(selector.message),
              html = settings.templates.message(module.add.variables(_message));
            if ($message.length > 0) {
              $message.html(html);
            } else {
              $message = $('<div/>').html(html).addClass(className.message).appendTo($menu);
            }
          },
          optionValue: function optionValue(value) {
            var escapedValue = module.escape.value(value),
              $option = $input.find('option[value="' + module.escape.string(escapedValue) + '"]'),
              hasOption = $option.length > 0;
            if (hasOption) {
              return;
            }
            // temporarily disconnect observer
            module.disconnect.selectObserver();
            if (module.is.single()) {
              module.verbose('Removing previous user addition');
              $input.find('option.' + className.addition).remove();
            }
            $('<option/>').prop('value', escapedValue).addClass(className.addition).html(value).appendTo($input);
            module.verbose('Adding user addition as an <option>', value);
            module.observe.select();
          },
          userSuggestion: function userSuggestion(value) {
            var $addition = $menu.children(selector.addition),
              $existingItem = module.get.item(value),
              alreadyHasValue = $existingItem && $existingItem.not(selector.addition).length,
              hasUserSuggestion = $addition.length > 0,
              html;
            if (settings.useLabels && module.has.maxSelections()) {
              return;
            }
            if (value === '' || alreadyHasValue) {
              $addition.remove();
              return;
            }
            if (hasUserSuggestion) {
              $addition.data(metadata.value, value).data(metadata.text, value).attr('data-' + metadata.value, value).attr('data-' + metadata.text, value).removeClass(className.filtered);
              if (!settings.hideAdditions) {
                html = settings.templates.addition(module.add.variables(message.addResult, value));
                $addition.html(html);
              }
              module.verbose('Replacing user suggestion with new value', $addition);
            } else {
              $addition = module.create.userChoice(value);
              $addition.prependTo($menu);
              module.verbose('Adding item choice to menu corresponding with user choice addition', $addition);
            }
            if (!settings.hideAdditions || module.is.allFiltered()) {
              $addition.addClass(className.selected).siblings().removeClass(className.selected);
            }
            module.refreshItems();
          },
          variables: function variables(message, term) {
            var hasCount = message.search('{count}') !== -1,
              hasMaxCount = message.search('{maxCount}') !== -1,
              hasTerm = message.search('{term}') !== -1,
              count,
              query;
            module.verbose('Adding templated variables to message', message);
            if (hasCount) {
              count = module.get.selectionCount();
              message = message.replace('{count}', count);
            }
            if (hasMaxCount) {
              count = module.get.selectionCount();
              message = message.replace('{maxCount}', settings.maxSelections);
            }
            if (hasTerm) {
              query = term || module.get.query();
              message = message.replace('{term}', query);
            }
            return message;
          },
          value: function value(addedValue, addedText, $selectedItem) {
            var currentValue = module.get.values(true),
              newValue;
            if (module.has.value(addedValue)) {
              module.debug('Value already selected');
              return;
            }
            if (addedValue === '') {
              module.debug('Cannot select blank values from multiselect');
              return;
            }
            // extend current array
            if (Array.isArray(currentValue)) {
              newValue = currentValue.concat([addedValue]);
              newValue = module.get.uniqueArray(newValue);
            } else {
              newValue = [addedValue];
            }
            // add values
            if (module.has.selectInput()) {
              if (module.can.extendSelect()) {
                module.debug('Adding value to select', addedValue, newValue, $input);
                module.add.optionValue(addedValue);
              }
            } else {
              newValue = newValue.join(settings.delimiter);
              module.debug('Setting hidden input to delimited value', newValue, $input);
            }
            if (settings.fireOnInit === false && module.is.initialLoad()) {
              module.verbose('Skipping onadd callback on initial load', settings.onAdd);
            } else {
              settings.onAdd.call(element, addedValue, addedText, $selectedItem);
            }
            module.set.value(newValue, addedText, $selectedItem);
            module.check.maxSelections();
          }
        },
        remove: {
          active: function active() {
            $module.removeClass(className.active);
          },
          activeLabel: function activeLabel() {
            $module.find(selector.label).removeClass(className.active);
          },
          empty: function empty() {
            $module.removeClass(className.empty);
          },
          loading: function loading() {
            $module.removeClass(className.loading);
          },
          initialLoad: function initialLoad() {
            _initialLoad = false;
          },
          upward: function upward($currentMenu) {
            var $element = $currentMenu || $module;
            $element.removeClass(className.upward);
          },
          leftward: function leftward($currentMenu) {
            var $element = $currentMenu || $menu;
            $element.removeClass(className.leftward);
          },
          visible: function visible() {
            $module.removeClass(className.visible);
          },
          activeItem: function activeItem() {
            $item.removeClass(className.active);
          },
          filteredItem: function filteredItem() {
            if (settings.useLabels && module.has.maxSelections()) {
              return;
            }
            if (settings.useLabels && module.is.multiple()) {
              $item.not('.' + className.active).removeClass(className.filtered);
            } else {
              $item.removeClass(className.filtered);
            }
            if (settings.hideDividers) {
              $divider.removeClass(className.hidden);
            }
            module.remove.empty();
          },
          optionValue: function optionValue(value) {
            var escapedValue = module.escape.value(value),
              $option = $input.find('option[value="' + module.escape.string(escapedValue) + '"]'),
              hasOption = $option.length > 0;
            if (!hasOption || !$option.hasClass(className.addition)) {
              return;
            }
            // temporarily disconnect observer
            if (_selectObserver) {
              _selectObserver.disconnect();
              module.verbose('Temporarily disconnecting mutation observer');
            }
            $option.remove();
            module.verbose('Removing user addition as an <option>', escapedValue);
            if (_selectObserver) {
              _selectObserver.observe($input[0], {
                childList: true,
                subtree: true
              });
            }
          },
          message: function message() {
            $menu.children(selector.message).remove();
          },
          searchWidth: function searchWidth() {
            $search.css('width', '');
          },
          searchTerm: function searchTerm() {
            module.verbose('Cleared search term');
            $search.val('');
            module.set.filtered();
          },
          userAddition: function userAddition() {
            $item.filter(selector.addition).remove();
          },
          selected: function selected(value, $selectedItem, preventChangeTrigger) {
            $selectedItem = settings.allowAdditions ? $selectedItem || module.get.itemWithAdditions(value) : $selectedItem || module.get.item(value);
            if (!$selectedItem) {
              return false;
            }
            $selectedItem.each(function () {
              var $selected = $(this),
                selectedText = module.get.choiceText($selected),
                selectedValue = module.get.choiceValue($selected, selectedText);
              if (module.is.multiple()) {
                if (settings.useLabels) {
                  module.remove.value(selectedValue, selectedText, $selected, preventChangeTrigger);
                  module.remove.label(selectedValue);
                } else {
                  module.remove.value(selectedValue, selectedText, $selected, preventChangeTrigger);
                  if (module.get.selectionCount() === 0) {
                    module.set.placeholderText();
                  } else {
                    module.set.text(module.add.variables(message.count));
                  }
                }
              } else {
                module.remove.value(selectedValue, selectedText, $selected, preventChangeTrigger);
              }
              $selected.removeClass(className.filtered).removeClass(className.active);
              if (settings.useLabels) {
                $selected.removeClass(className.selected);
              }
            });
          },
          selectedItem: function selectedItem() {
            $item.removeClass(className.selected);
          },
          value: function value(removedValue, removedText, $removedItem, preventChangeTrigger) {
            var values = module.get.values(),
              newValue;
            removedValue = module.escape.htmlEntities(removedValue);
            if (module.has.selectInput()) {
              module.verbose('Input is <select> removing selected option', removedValue);
              newValue = module.remove.arrayValue(removedValue, values);
              module.remove.optionValue(removedValue);
            } else {
              module.verbose('Removing from delimited values', removedValue);
              newValue = module.remove.arrayValue(removedValue, values);
              newValue = newValue.join(settings.delimiter);
            }
            if (settings.fireOnInit === false && module.is.initialLoad()) {
              module.verbose('No callback on initial load', settings.onRemove);
            } else {
              settings.onRemove.call(element, removedValue, removedText, $removedItem);
            }
            module.set.value(newValue, removedText, $removedItem, preventChangeTrigger);
            module.check.maxSelections();
          },
          arrayValue: function arrayValue(removedValue, values) {
            if (!Array.isArray(values)) {
              values = [values];
            }
            values = $.grep(values, function (value) {
              return removedValue != value;
            });
            module.verbose('Removed value from delimited string', removedValue, values);
            return values;
          },
          label: function label(value, shouldAnimate) {
            var escapedValue = module.escape.value(value),
              $labels = $module.find(selector.label),
              $removedLabel = $labels.filter('[data-' + metadata.value + '="' + module.escape.string(settings.ignoreCase ? escapedValue.toLowerCase() : escapedValue) + '"]');
            module.verbose('Removing label', $removedLabel);
            $removedLabel.remove();
          },
          activeLabels: function activeLabels($activeLabels) {
            $activeLabels = $activeLabels || $module.find(selector.label).filter('.' + className.active);
            module.verbose('Removing active label selections', $activeLabels);
            module.remove.labels($activeLabels);
          },
          labels: function labels($labels, preventChangeTrigger) {
            $labels = $labels || $module.find(selector.label);
            module.verbose('Removing labels', $labels);
            $labels.each(function () {
              var $label = $(this),
                value = $label.data(metadata.value),
                stringValue = value !== undefined ? String(value) : value,
                isUserValue = module.is.userValue(stringValue);
              if (settings.onLabelRemove.call($label, value) === false) {
                module.debug('Label remove callback cancelled removal');
                return;
              }
              module.remove.message();
              if (isUserValue) {
                module.remove.value(stringValue, stringValue, module.get.item(stringValue), preventChangeTrigger);
                module.remove.label(stringValue);
              } else {
                // selected will also remove label
                module.remove.selected(stringValue, false, preventChangeTrigger);
              }
            });
          },
          tabbable: function tabbable() {
            if (module.is.searchSelection()) {
              module.debug('Searchable dropdown initialized');
              $search.removeAttr('tabindex');
              $menu.removeAttr('tabindex');
            } else {
              module.debug('Simple selection dropdown initialized');
              $module.removeAttr('tabindex');
              $menu.removeAttr('tabindex');
            }
          },
          diacritics: function diacritics(text) {
            return settings.ignoreDiacritics ? text.normalize('NFD').replace(/[\u0300-\u036f]/g, '') : text;
          }
        },
        has: {
          menuSearch: function menuSearch() {
            return module.has.search() && $search.closest($menu).length > 0;
          },
          clearItem: function clearItem() {
            return $clear.length > 0;
          },
          search: function search() {
            return $search.length > 0;
          },
          sizer: function sizer() {
            return $sizer.length > 0;
          },
          selectInput: function selectInput() {
            return $input.is('select');
          },
          minCharacters: function minCharacters(searchTerm) {
            if (settings.minCharacters && !iconClicked) {
              searchTerm = searchTerm !== undefined ? String(searchTerm) : String(module.get.query());
              return searchTerm.length >= settings.minCharacters;
            }
            iconClicked = false;
            return true;
          },
          firstLetter: function firstLetter($item, letter) {
            var text, firstLetter;
            if (!$item || $item.length === 0 || typeof letter !== 'string') {
              return false;
            }
            text = module.get.choiceText($item, false);
            letter = letter.toLowerCase();
            firstLetter = String(text).charAt(0).toLowerCase();
            return letter == firstLetter;
          },
          input: function input() {
            return $input.length > 0;
          },
          items: function items() {
            return $item.length > 0;
          },
          menu: function menu() {
            return $menu.length > 0;
          },
          subMenu: function subMenu($currentMenu) {
            return ($currentMenu || $menu).find(selector.menu).length > 0;
          },
          message: function message() {
            return $menu.children(selector.message).length !== 0;
          },
          label: function label(value) {
            var escapedValue = module.escape.value(value),
              $labels = $module.find(selector.label);
            if (settings.ignoreCase) {
              escapedValue = escapedValue.toLowerCase();
            }
            return $labels.filter('[data-' + metadata.value + '="' + module.escape.string(escapedValue) + '"]').length > 0;
          },
          maxSelections: function maxSelections() {
            return settings.maxSelections && module.get.selectionCount() >= settings.maxSelections;
          },
          allResultsFiltered: function allResultsFiltered() {
            var $normalResults = $item.not(selector.addition);
            return $normalResults.filter(selector.unselectable).length === $normalResults.length;
          },
          userSuggestion: function userSuggestion() {
            return $menu.children(selector.addition).length > 0;
          },
          query: function query() {
            return module.get.query() !== '';
          },
          value: function value(_value2) {
            return settings.ignoreCase ? module.has.valueIgnoringCase(_value2) : module.has.valueMatchingCase(_value2);
          },
          valueMatchingCase: function valueMatchingCase(value) {
            var values = module.get.values(true),
              hasValue = Array.isArray(values) ? values && $.inArray(value, values) !== -1 : values == value;
            return hasValue ? true : false;
          },
          valueIgnoringCase: function valueIgnoringCase(value) {
            var values = module.get.values(true),
              hasValue = false;
            if (!Array.isArray(values)) {
              values = [values];
            }
            $.each(values, function (index, existingValue) {
              if (String(value).toLowerCase() == String(existingValue).toLowerCase()) {
                hasValue = true;
                return false;
              }
            });
            return hasValue;
          }
        },
        is: {
          active: function active() {
            return $module.hasClass(className.active);
          },
          animatingInward: function animatingInward() {
            return $menu.transition('is inward');
          },
          animatingOutward: function animatingOutward() {
            return $menu.transition('is outward');
          },
          bubbledLabelClick: function bubbledLabelClick(event) {
            return $(event.target).is('select, input') && $module.closest('label').length > 0;
          },
          bubbledIconClick: function bubbledIconClick(event) {
            return $(event.target).closest($icon).length > 0;
          },
          chrome: function chrome() {
            return !!window.chrome && (!!window.chrome.webstore || !!window.chrome.runtime);
          },
          alreadySetup: function alreadySetup() {
            return $module.is('select') && $module.parent(selector.dropdown).data(moduleNamespace) !== undefined && $module.prev().length === 0;
          },
          animating: function animating($subMenu) {
            return $subMenu ? $subMenu.transition && $subMenu.transition('is animating') : $menu.transition && $menu.transition('is animating');
          },
          leftward: function leftward($subMenu) {
            var $selectedMenu = $subMenu || $menu;
            return $selectedMenu.hasClass(className.leftward);
          },
          clearable: function clearable() {
            return $module.hasClass(className.clearable) || settings.clearable;
          },
          disabled: function disabled() {
            return $module.hasClass(className.disabled);
          },
          focused: function focused() {
            return document.activeElement === $module[0];
          },
          focusedOnSearch: function focusedOnSearch() {
            return document.activeElement === $search[0];
          },
          allFiltered: function allFiltered() {
            return (module.is.multiple() || module.has.search()) && !(settings.hideAdditions == false && module.has.userSuggestion()) && !module.has.message() && module.has.allResultsFiltered();
          },
          hidden: function hidden($subMenu) {
            return !module.is.visible($subMenu);
          },
          initialLoad: function initialLoad() {
            return _initialLoad;
          },
          inObject: function inObject(needle, object) {
            var found = false;
            $.each(object, function (index, property) {
              if (property == needle) {
                found = true;
                return true;
              }
            });
            return found;
          },
          multiple: function multiple() {
            return $module.hasClass(className.multiple);
          },
          remote: function remote() {
            return settings.apiSettings && module.can.useAPI();
          },
          noApiCache: function noApiCache() {
            return settings.apiSettings && !settings.apiSettings.cache;
          },
          single: function single() {
            return !module.is.multiple();
          },
          selectMutation: function selectMutation(mutations) {
            var selectChanged = false;
            $.each(mutations, function (index, mutation) {
              if ($(mutation.target).is('select') || $(mutation.addedNodes).is('select')) {
                selectChanged = true;
                return false;
              }
            });
            return selectChanged;
          },
          search: function search() {
            return $module.hasClass(className.search);
          },
          searchSelection: function searchSelection() {
            return module.has.search() && $search.parent(selector.dropdown).length === 1;
          },
          selection: function selection() {
            return $module.hasClass(className.selection);
          },
          userValue: function userValue(value) {
            return $.inArray(value, module.get.userValues()) !== -1;
          },
          upward: function upward($menu) {
            var $element = $menu || $module;
            return $element.hasClass(className.upward);
          },
          visible: function visible($subMenu) {
            return $subMenu ? $subMenu.hasClass(className.visible) : $menu.hasClass(className.visible);
          },
          verticallyScrollableContext: function verticallyScrollableContext() {
            var overflowY = $context.get(0) !== window ? $context.css('overflow-y') : false;
            return overflowY == 'auto' || overflowY == 'scroll';
          },
          horizontallyScrollableContext: function horizontallyScrollableContext() {
            var overflowX = $context.get(0) !== window ? $context.css('overflow-X') : false;
            return overflowX == 'auto' || overflowX == 'scroll';
          }
        },
        can: {
          activate: function activate($item) {
            if (settings.useLabels) {
              return true;
            }
            if (!module.has.maxSelections()) {
              return true;
            }
            if (module.has.maxSelections() && $item.hasClass(className.active)) {
              return true;
            }
            return false;
          },
          openDownward: function openDownward($subMenu) {
            var $currentMenu = $subMenu || $menu,
              canOpenDownward = true,
              onScreen = {},
              calculations;
            $currentMenu.addClass(className.loading);
            calculations = {
              context: {
                offset: $context.get(0) === window ? {
                  top: 0,
                  left: 0
                } : $context.offset(),
                scrollTop: $context.scrollTop(),
                height: $context.outerHeight()
              },
              menu: {
                offset: $currentMenu.offset(),
                height: $currentMenu.outerHeight()
              }
            };
            if (module.is.verticallyScrollableContext()) {
              calculations.menu.offset.top += calculations.context.scrollTop;
            }
            if (module.has.subMenu($currentMenu)) {
              calculations.menu.height += $currentMenu.find(selector.menu).first().outerHeight();
            }
            onScreen = {
              above: calculations.context.scrollTop <= calculations.menu.offset.top - calculations.context.offset.top - calculations.menu.height,
              below: calculations.context.scrollTop + calculations.context.height >= calculations.menu.offset.top - calculations.context.offset.top + calculations.menu.height
            };
            if (onScreen.below) {
              module.verbose('Dropdown can fit in context downward', onScreen);
              canOpenDownward = true;
            } else if (!onScreen.below && !onScreen.above) {
              module.verbose('Dropdown cannot fit in either direction, favoring downward', onScreen);
              canOpenDownward = true;
            } else {
              module.verbose('Dropdown cannot fit below, opening upward', onScreen);
              canOpenDownward = false;
            }
            $currentMenu.removeClass(className.loading);
            return canOpenDownward;
          },
          openRightward: function openRightward($subMenu) {
            var $currentMenu = $subMenu || $menu,
              canOpenRightward = true,
              isOffscreenRight = false,
              calculations;
            $currentMenu.addClass(className.loading);
            calculations = {
              context: {
                offset: $context.get(0) === window ? {
                  top: 0,
                  left: 0
                } : $context.offset(),
                scrollLeft: $context.scrollLeft(),
                width: $context.outerWidth()
              },
              menu: {
                offset: $currentMenu.offset(),
                width: $currentMenu.outerWidth()
              }
            };
            if (module.is.horizontallyScrollableContext()) {
              calculations.menu.offset.left += calculations.context.scrollLeft;
            }
            isOffscreenRight = calculations.menu.offset.left - calculations.context.offset.left + calculations.menu.width >= calculations.context.scrollLeft + calculations.context.width;
            if (isOffscreenRight) {
              module.verbose('Dropdown cannot fit in context rightward', isOffscreenRight);
              canOpenRightward = false;
            }
            $currentMenu.removeClass(className.loading);
            return canOpenRightward;
          },
          click: function click() {
            return hasTouch || settings.on == 'click';
          },
          extendSelect: function extendSelect() {
            return settings.allowAdditions || settings.apiSettings;
          },
          show: function show() {
            return !module.is.disabled() && (module.has.items() || module.has.message());
          },
          useAPI: function useAPI() {
            return $.fn.api !== undefined;
          }
        },
        animate: {
          show: function show(callback, $subMenu) {
            var $currentMenu = $subMenu || $menu,
              start = $subMenu ? function () {} : function () {
                module.hideSubMenus();
                module.hideOthers();
                module.set.active();
              },
              transition;
            callback = $.isFunction(callback) ? callback : function () {};
            module.verbose('Doing menu show animation', $currentMenu);
            module.set.direction($subMenu);
            transition = settings.transition.showMethod || module.get.transition($subMenu);
            if (module.is.selection()) {
              module.set.scrollPosition(module.get.selectedItem(), true);
            }
            if (module.is.hidden($currentMenu) || module.is.animating($currentMenu)) {
              if (transition === 'none') {
                start();
                $currentMenu.transition({
                  displayType: module.get.displayType()
                }).transition('show');
                callback.call(element);
              } else if ($.fn.transition !== undefined && $module.transition('is supported')) {
                $currentMenu.transition({
                  animation: transition + ' in',
                  debug: settings.debug,
                  verbose: settings.verbose,
                  duration: settings.transition.showDuration || settings.duration,
                  queue: true,
                  onStart: start,
                  displayType: module.get.displayType(),
                  onComplete: function onComplete() {
                    callback.call(element);
                  }
                });
              } else {
                module.error(error.noTransition, transition);
              }
            }
          },
          hide: function hide(callback, $subMenu) {
            var $currentMenu = $subMenu || $menu,
              start = $subMenu ? function () {} : function () {
                if (module.can.click()) {
                  module.unbind.intent();
                }
                module.remove.active();
              },
              transition = settings.transition.hideMethod || module.get.transition($subMenu);
            callback = $.isFunction(callback) ? callback : function () {};
            if (module.is.visible($currentMenu) || module.is.animating($currentMenu)) {
              module.verbose('Doing menu hide animation', $currentMenu);
              if (transition === 'none') {
                start();
                $currentMenu.transition({
                  displayType: module.get.displayType()
                }).transition('hide');
                callback.call(element);
              } else if ($.fn.transition !== undefined && $module.transition('is supported')) {
                $currentMenu.transition({
                  animation: transition + ' out',
                  duration: settings.transition.hideDuration || settings.duration,
                  debug: settings.debug,
                  verbose: settings.verbose,
                  queue: false,
                  onStart: start,
                  displayType: module.get.displayType(),
                  onComplete: function onComplete() {
                    callback.call(element);
                  }
                });
              } else {
                module.error(error.transition);
              }
            }
          }
        },
        hideAndClear: function hideAndClear() {
          module.remove.searchTerm();
          if (module.has.maxSelections()) {
            return;
          }
          if (module.has.search()) {
            module.hide(function () {
              module.remove.filteredItem();
            });
          } else {
            module.hide();
          }
        },
        delay: {
          show: function show() {
            module.verbose('Delaying show event to ensure user intent');
            clearTimeout(module.timer);
            module.timer = setTimeout(module.show, settings.delay.show);
          },
          hide: function hide() {
            module.verbose('Delaying hide event to ensure user intent');
            clearTimeout(module.timer);
            module.timer = setTimeout(module.hide, settings.delay.hide);
          }
        },
        escape: {
          value: function value(_value3) {
            var multipleValues = Array.isArray(_value3),
              stringValue = typeof _value3 === 'string',
              isUnparsable = !stringValue && !multipleValues,
              hasQuotes = stringValue && _value3.search(regExp.quote) !== -1,
              values = [];
            if (isUnparsable || !hasQuotes) {
              return _value3;
            }
            module.debug('Encoding quote values for use in select', _value3);
            if (multipleValues) {
              $.each(_value3, function (index, value) {
                values.push(value.replace(regExp.quote, '&quot;'));
              });
              return values;
            }
            return _value3.replace(regExp.quote, '&quot;');
          },
          string: function string(text) {
            text = String(text);
            return text.replace(regExp.escape, '\\$&');
          },
          htmlEntities: function htmlEntities(string) {
            var badChars = /[<>"'`]/g,
              shouldEscape = /[&<>"'`]/,
              escape = {
                "<": "&lt;",
                ">": "&gt;",
                '"': "&quot;",
                "'": "&#x27;",
                "`": "&#x60;"
              },
              escapedChar = function escapedChar(chr) {
                return escape[chr];
              };
            if (shouldEscape.test(string)) {
              string = string.replace(/&(?![a-z0-9#]{1,6};)/, "&amp;");
              return string.replace(badChars, escapedChar);
            }
            return string;
          }
        },
        setting: function setting(name, value) {
          module.debug('Changing setting', name, value);
          if ($.isPlainObject(name)) {
            $.extend(true, settings, name);
          } else if (value !== undefined) {
            if ($.isPlainObject(settings[name])) {
              $.extend(true, settings[name], value);
            } else {
              settings[name] = value;
            }
          } else {
            return settings[name];
          }
        },
        internal: function internal(name, value) {
          if ($.isPlainObject(name)) {
            $.extend(true, module, name);
          } else if (value !== undefined) {
            module[name] = value;
          } else {
            return module[name];
          }
        },
        debug: function debug() {
          if (!settings.silent && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.debug = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.debug.apply(console, arguments);
            }
          }
        },
        verbose: function verbose() {
          if (!settings.silent && settings.verbose && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.verbose = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.verbose.apply(console, arguments);
            }
          }
        },
        error: function error() {
          if (!settings.silent) {
            module.error = Function.prototype.bind.call(console.error, console, settings.name + ':');
            module.error.apply(console, arguments);
          }
        },
        performance: {
          log: function log(message) {
            var currentTime, executionTime, previousTime;
            if (settings.performance) {
              currentTime = new Date().getTime();
              previousTime = time || currentTime;
              executionTime = currentTime - previousTime;
              time = currentTime;
              performance.push({
                'Name': message[0],
                'Arguments': [].slice.call(message, 1) || '',
                'Element': element,
                'Execution Time': executionTime
              });
            }
            clearTimeout(module.performance.timer);
            module.performance.timer = setTimeout(module.performance.display, 500);
          },
          display: function display() {
            var title = settings.name + ':',
              totalTime = 0;
            time = false;
            clearTimeout(module.performance.timer);
            $.each(performance, function (index, data) {
              totalTime += data['Execution Time'];
            });
            title += ' ' + totalTime + 'ms';
            if (moduleSelector) {
              title += ' \'' + moduleSelector + '\'';
            }
            if ((console.group !== undefined || console.table !== undefined) && performance.length > 0) {
              console.groupCollapsed(title);
              if (console.table) {
                console.table(performance);
              } else {
                $.each(performance, function (index, data) {
                  console.log(data['Name'] + ': ' + data['Execution Time'] + 'ms');
                });
              }
              console.groupEnd();
            }
            performance = [];
          }
        },
        invoke: function invoke(query, passedArguments, context) {
          var object = instance,
            maxDepth,
            found,
            response;
          passedArguments = passedArguments || queryArguments;
          context = element || context;
          if (typeof query == 'string' && object !== undefined) {
            query = query.split(/[\. ]/);
            maxDepth = query.length - 1;
            $.each(query, function (depth, value) {
              var camelCaseValue = depth != maxDepth ? value + query[depth + 1].charAt(0).toUpperCase() + query[depth + 1].slice(1) : query;
              if ($.isPlainObject(object[camelCaseValue]) && depth != maxDepth) {
                object = object[camelCaseValue];
              } else if (object[camelCaseValue] !== undefined) {
                found = object[camelCaseValue];
                return false;
              } else if ($.isPlainObject(object[value]) && depth != maxDepth) {
                object = object[value];
              } else if (object[value] !== undefined) {
                found = object[value];
                return false;
              } else {
                module.error(error.method, query);
                return false;
              }
            });
          }
          if ($.isFunction(found)) {
            response = found.apply(context, passedArguments);
          } else if (found !== undefined) {
            response = found;
          }
          if (Array.isArray(returnedValue)) {
            returnedValue.push(response);
          } else if (returnedValue !== undefined) {
            returnedValue = [returnedValue, response];
          } else if (response !== undefined) {
            returnedValue = response;
          }
          return found;
        }
      };
      if (methodInvoked) {
        if (instance === undefined) {
          module.initialize();
        }
        module.invoke(query);
      } else {
        if (instance !== undefined) {
          instance.invoke('destroy');
        }
        module.initialize();
      }
    });
    return returnedValue !== undefined ? returnedValue : $allModules;
  };
  $.fn.dropdown.settings = {
    silent: false,
    debug: false,
    verbose: false,
    performance: true,
    on: 'click',
    // what event should show menu action on item selection
    action: 'activate',
    // action on item selection (nothing, activate, select, combo, hide, function(){})

    values: false,
    // specify values to use for dropdown

    clearable: false,
    // whether the value of the dropdown can be cleared

    apiSettings: false,
    selectOnKeydown: true,
    // Whether selection should occur automatically when keyboard shortcuts used
    minCharacters: 0,
    // Minimum characters required to trigger API call

    filterRemoteData: false,
    // Whether API results should be filtered after being returned for query term
    saveRemoteData: true,
    // Whether remote name/value pairs should be stored in sessionStorage to allow remote data to be restored on page refresh

    throttle: 200,
    // How long to wait after last user input to search remotely

    context: window,
    // Context to use when determining if on screen
    direction: 'auto',
    // Whether dropdown should always open in one direction
    keepOnScreen: true,
    // Whether dropdown should check whether it is on screen before showing

    match: 'both',
    // what to match against with search selection (both, text, or label)
    fullTextSearch: false,
    // search anywhere in value (set to 'exact' to require exact matches)
    ignoreDiacritics: false,
    // match results also if they contain diacritics of the same base character (for example searching for "a" will also match "á" or "â" or "à", etc...)
    hideDividers: false,
    // Whether to hide any divider elements (specified in selector.divider) that are sibling to any items when searched (set to true will hide all dividers, set to 'empty' will hide them when they are not followed by a visible item)

    placeholder: 'auto',
    // whether to convert blank <select> values to placeholder text
    preserveHTML: true,
    // preserve html when selecting value
    sortSelect: false,
    // sort selection on init

    forceSelection: true,
    // force a choice on blur with search selection

    allowAdditions: false,
    // whether multiple select should allow user added values
    ignoreCase: false,
    // whether to consider case sensitivity when creating labels
    ignoreSearchCase: true,
    // whether to consider case sensitivity when filtering items
    hideAdditions: true,
    // whether or not to hide special message prompting a user they can enter a value

    maxSelections: false,
    // When set to a number limits the number of selections to this count
    useLabels: true,
    // whether multiple select should filter currently active selections from choices
    delimiter: ',',
    // when multiselect uses normal <input> the values will be delimited with this character

    showOnFocus: true,
    // show menu on focus
    allowReselection: false,
    // whether current value should trigger callbacks when reselected
    allowTab: true,
    // add tabindex to element
    allowCategorySelection: false,
    // allow elements with sub-menus to be selected

    fireOnInit: false,
    // Whether callbacks should fire when initializing dropdown values

    transition: 'auto',
    // auto transition will slide down or up based on direction
    duration: 200,
    // duration of transition
    displayType: false,
    // displayType of transition

    glyphWidth: 1.037,
    // widest glyph width in em (W is 1.037 em) used to calculate multiselect input width

    headerDivider: true,
    // whether option headers should have an additional divider line underneath when converted from <select> <optgroup>

    // label settings on multi-select
    label: {
      transition: 'scale',
      duration: 200,
      variation: false
    },
    // delay before event
    delay: {
      hide: 300,
      show: 200,
      search: 20,
      touch: 50
    },
    /* Callbacks */
    onChange: function onChange(value, text, $selected) {},
    onAdd: function onAdd(value, text, $selected) {},
    onRemove: function onRemove(value, text, $selected) {},
    onSearch: function onSearch(searchTerm) {},
    onLabelSelect: function onLabelSelect($selectedLabels) {},
    onLabelCreate: function onLabelCreate(value, text) {
      return $(this);
    },
    onLabelRemove: function onLabelRemove(value) {
      return true;
    },
    onNoResults: function onNoResults(searchTerm) {
      return true;
    },
    onShow: function onShow() {},
    onHide: function onHide() {},
    /* Component */
    name: 'Dropdown',
    namespace: 'dropdown',
    message: {
      addResult: 'Add <b>{term}</b>',
      count: '{count} selected',
      maxSelections: 'Max {maxCount} selections',
      noResults: 'No results found.',
      serverError: 'There was an error contacting the server'
    },
    error: {
      action: 'You called a dropdown action that was not defined',
      alreadySetup: 'Once a select has been initialized behaviors must be called on the created ui dropdown',
      labels: 'Allowing user additions currently requires the use of labels.',
      missingMultiple: '<select> requires multiple property to be set to correctly preserve multiple values',
      method: 'The method you called is not defined.',
      noAPI: 'The API module is required to load resources remotely',
      noStorage: 'Saving remote data requires session storage',
      noTransition: 'This module requires ui transitions <https://github.com/Semantic-Org/UI-Transition>',
      noNormalize: '"ignoreDiacritics" setting will be ignored. Browser does not support String().normalize(). You may consider including <https://cdn.jsdelivr.net/npm/unorm@1.4.1/lib/unorm.min.js> as a polyfill.'
    },
    regExp: {
      escape: /[-[\]{}()*+?.,\\^$|#\s:=@]/g,
      quote: /"/g
    },
    metadata: {
      defaultText: 'defaultText',
      defaultValue: 'defaultValue',
      placeholderText: 'placeholder',
      text: 'text',
      value: 'value'
    },
    // property names for remote query
    fields: {
      remoteValues: 'results',
      // grouping for api results
      values: 'values',
      // grouping for all dropdown values
      disabled: 'disabled',
      // whether value should be disabled
      name: 'name',
      // displayed dropdown text
      description: 'description',
      // displayed dropdown description
      descriptionVertical: 'descriptionVertical',
      // whether description should be vertical
      value: 'value',
      // actual dropdown value
      text: 'text',
      // displayed text when selected
      type: 'type',
      // type of dropdown element
      image: 'image',
      // optional image path
      imageClass: 'imageClass',
      // optional individual class for image
      icon: 'icon',
      // optional icon name
      iconClass: 'iconClass',
      // optional individual class for icon (for example to use flag instead)
      "class": 'class',
      // optional individual class for item/header
      divider: 'divider' // optional divider append for group headers
    },

    keys: {
      backspace: 8,
      delimiter: 188,
      // comma
      deleteKey: 46,
      enter: 13,
      escape: 27,
      pageUp: 33,
      pageDown: 34,
      leftArrow: 37,
      upArrow: 38,
      rightArrow: 39,
      downArrow: 40
    },
    selector: {
      addition: '.addition',
      divider: '.divider, .header',
      dropdown: '.ui.dropdown',
      hidden: '.hidden',
      icon: '> .dropdown.icon',
      input: '> input[type="hidden"], > select',
      item: '.item',
      label: '> .label',
      remove: '> .label > .delete.icon',
      siblingLabel: '.label',
      menu: '.menu',
      message: '.message',
      menuIcon: '.dropdown.icon',
      search: 'input.search, .menu > .search > input, .menu input.search',
      sizer: '> span.sizer',
      text: '> .text:not(.icon)',
      unselectable: '.disabled, .filtered',
      clearIcon: '> .remove.icon'
    },
    className: {
      active: 'active',
      addition: 'addition',
      animating: 'animating',
      description: 'description',
      descriptionVertical: 'vertical',
      disabled: 'disabled',
      empty: 'empty',
      dropdown: 'ui dropdown',
      filtered: 'filtered',
      hidden: 'hidden transition',
      icon: 'icon',
      image: 'image',
      item: 'item',
      label: 'ui label',
      loading: 'loading',
      menu: 'menu',
      message: 'message',
      multiple: 'multiple',
      placeholder: 'default',
      sizer: 'sizer',
      search: 'search',
      selected: 'selected',
      selection: 'selection',
      text: 'text',
      upward: 'upward',
      leftward: 'left',
      visible: 'visible',
      clearable: 'clearable',
      noselection: 'noselection',
      "delete": 'delete',
      header: 'header',
      divider: 'divider',
      groupIcon: '',
      unfilterable: 'unfilterable'
    }
  };

  /* Templates */
  $.fn.dropdown.settings.templates = {
    deQuote: function deQuote(string, encode) {
      return String(string).replace(/"/g, encode ? "&quot;" : "");
    },
    escape: function escape(string, preserveHTML) {
      if (preserveHTML) {
        return string;
      }
      var badChars = /[<>"'`]/g,
        shouldEscape = /[&<>"'`]/,
        escape = {
          "<": "&lt;",
          ">": "&gt;",
          '"': "&quot;",
          "'": "&#x27;",
          "`": "&#x60;"
        },
        escapedChar = function escapedChar(chr) {
          return escape[chr];
        };
      if (shouldEscape.test(string)) {
        string = string.replace(/&(?![a-z0-9#]{1,6};)/, "&amp;");
        return string.replace(badChars, escapedChar);
      }
      return string;
    },
    // generates dropdown from select values
    dropdown: function dropdown(select, fields, preserveHTML, className) {
      var placeholder = select.placeholder || false,
        html = '',
        escape = $.fn.dropdown.settings.templates.escape;
      html += '<i class="dropdown icon"></i>';
      if (placeholder) {
        html += '<div class="default text">' + escape(placeholder, preserveHTML) + '</div>';
      } else {
        html += '<div class="text"></div>';
      }
      html += '<div class="' + className.menu + '">';
      html += $.fn.dropdown.settings.templates.menu(select, fields, preserveHTML, className);
      html += '</div>';
      return html;
    },
    // generates just menu from select
    menu: function menu(response, fields, preserveHTML, className) {
      var values = response[fields.values] || [],
        html = '',
        escape = $.fn.dropdown.settings.templates.escape,
        deQuote = $.fn.dropdown.settings.templates.deQuote;
      $.each(values, function (index, option) {
        var itemType = option[fields.type] ? option[fields.type] : 'item',
          isMenu = itemType.indexOf('menu') !== -1;
        if (itemType === 'item' || isMenu) {
          var maybeText = option[fields.text] ? ' data-text="' + deQuote(option[fields.text], true) + '"' : '',
            maybeDisabled = option[fields.disabled] ? className.disabled + ' ' : '',
            maybeDescriptionVertical = option[fields.descriptionVertical] ? className.descriptionVertical + ' ' : '',
            hasDescription = escape(option[fields.description] || '', preserveHTML) != '';
          html += '<div class="' + maybeDisabled + maybeDescriptionVertical + (option[fields["class"]] ? deQuote(option[fields["class"]]) : className.item) + '" data-value="' + deQuote(option[fields.value], true) + '"' + maybeText + '>';
          if (isMenu) {
            html += '<i class="' + (itemType.indexOf('left') !== -1 ? 'left' : '') + ' dropdown icon"></i>';
          }
          if (option[fields.image]) {
            html += '<img class="' + (option[fields.imageClass] ? deQuote(option[fields.imageClass]) : className.image) + '" src="' + deQuote(option[fields.image]) + '">';
          }
          if (option[fields.icon]) {
            html += '<i class="' + deQuote(option[fields.icon]) + ' ' + (option[fields.iconClass] ? deQuote(option[fields.iconClass]) : className.icon) + '"></i>';
          }
          if (hasDescription) {
            html += '<span class="' + className.description + '">' + escape(option[fields.description] || '', preserveHTML) + '</span>';
            html += !isMenu ? '<span class="' + className.text + '">' : '';
          }
          if (isMenu) {
            html += '<span class="' + className.text + '">';
          }
          html += escape(option[fields.name] || '', preserveHTML);
          if (isMenu) {
            html += '</span>';
            html += '<div class="' + itemType + '">';
            html += $.fn.dropdown.settings.templates.menu(option, fields, preserveHTML, className);
            html += '</div>';
          } else if (hasDescription) {
            html += '</span>';
          }
          html += '</div>';
        } else if (itemType === 'header') {
          var groupName = escape(option[fields.name] || '', preserveHTML),
            groupIcon = option[fields.icon] ? deQuote(option[fields.icon]) : className.groupIcon;
          if (groupName !== '' || groupIcon !== '') {
            html += '<div class="' + (option[fields["class"]] ? deQuote(option[fields["class"]]) : className.header) + '">';
            if (groupIcon !== '') {
              html += '<i class="' + groupIcon + ' ' + (option[fields.iconClass] ? deQuote(option[fields.iconClass]) : className.icon) + '"></i>';
            }
            html += groupName;
            html += '</div>';
          }
          if (option[fields.divider]) {
            html += '<div class="' + className.divider + '"></div>';
          }
        }
      });
      return html;
    },
    // generates label for multiselect
    label: function label(value, text, preserveHTML, className) {
      var escape = $.fn.dropdown.settings.templates.escape;
      return escape(text, preserveHTML) + '<i class="' + className["delete"] + ' icon"></i>';
    },
    // generates messages like "No results"
    message: function message(_message2) {
      return _message2;
    },
    // generates user addition to selection menu
    addition: function addition(choice) {
      return choice;
    }
  };
})(jQuery, window, document);

/***/ }),

/***/ "./app/packs/src/semantic/definitions/modules/popup.js":
/*!*************************************************************!*\
  !*** ./app/packs/src/semantic/definitions/modules/popup.js ***!
  \*************************************************************/
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

/* provided dependency */ var jQuery = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
/*!
 * # Fomantic-UI - Popup
 * http://github.com/fomantic/Fomantic-UI/
 *
 *
 * Released under the MIT license
 * http://opensource.org/licenses/MIT
 *
 */

;
(function ($, window, document, undefined) {
  'use strict';

  $.isFunction = $.isFunction || function (obj) {
    return typeof obj === "function" && typeof obj.nodeType !== "number";
  };
  window = typeof window != 'undefined' && window.Math == Math ? window : typeof self != 'undefined' && self.Math == Math ? self : Function('return this')();
  $.fn.popup = function (parameters) {
    var $allModules = $(this),
      $document = $(document),
      $window = $(window),
      $body = $('body'),
      moduleSelector = $allModules.selector || '',
      clickEvent = 'ontouchstart' in document.documentElement ? 'touchstart' : 'click',
      time = new Date().getTime(),
      performance = [],
      query = arguments[0],
      methodInvoked = typeof query == 'string',
      queryArguments = [].slice.call(arguments, 1),
      returnedValue;
    $allModules.each(function () {
      var settings = $.isPlainObject(parameters) ? $.extend(true, {}, $.fn.popup.settings, parameters) : $.extend({}, $.fn.popup.settings),
        selector = settings.selector,
        className = settings.className,
        error = settings.error,
        metadata = settings.metadata,
        namespace = settings.namespace,
        eventNamespace = '.' + settings.namespace,
        moduleNamespace = 'module-' + namespace,
        $module = $(this),
        $context = $(settings.context),
        $scrollContext = $(settings.scrollContext),
        $boundary = $(settings.boundary),
        $target = settings.target ? $(settings.target) : $module,
        $popup,
        $offsetParent,
        searchDepth = 0,
        triedPositions = false,
        openedWithTouch = false,
        element = this,
        instance = $module.data(moduleNamespace),
        documentObserver,
        elementNamespace,
        _id,
        module;
      module = {
        // binds events
        initialize: function initialize() {
          module.debug('Initializing', $module);
          module.createID();
          module.bind.events();
          if (!module.exists() && settings.preserve) {
            module.create();
          }
          if (settings.observeChanges) {
            module.observeChanges();
          }
          module.instantiate();
        },
        instantiate: function instantiate() {
          module.verbose('Storing instance', module);
          instance = module;
          $module.data(moduleNamespace, instance);
        },
        observeChanges: function observeChanges() {
          if ('MutationObserver' in window) {
            documentObserver = new MutationObserver(module.event.documentChanged);
            documentObserver.observe(document, {
              childList: true,
              subtree: true
            });
            module.debug('Setting up mutation observer', documentObserver);
          }
        },
        refresh: function refresh() {
          if (settings.popup) {
            $popup = $(settings.popup).eq(0);
          } else {
            if (settings.inline) {
              $popup = $target.nextAll(selector.popup).eq(0);
              settings.popup = $popup;
            }
          }
          if (settings.popup) {
            $popup.addClass(className.loading);
            $offsetParent = module.get.offsetParent();
            $popup.removeClass(className.loading);
            if (settings.movePopup && module.has.popup() && module.get.offsetParent($popup)[0] !== $offsetParent[0]) {
              module.debug('Moving popup to the same offset parent as target');
              $popup.detach().appendTo($offsetParent);
            }
          } else {
            $offsetParent = settings.inline ? module.get.offsetParent($target) : module.has.popup() ? module.get.offsetParent($popup) : $body;
          }
          if ($offsetParent.is('html') && $offsetParent[0] !== $body[0]) {
            module.debug('Setting page as offset parent');
            $offsetParent = $body;
          }
          if (module.get.variation()) {
            module.set.variation();
          }
        },
        reposition: function reposition() {
          module.refresh();
          module.set.position();
        },
        destroy: function destroy() {
          module.debug('Destroying previous module');
          if (documentObserver) {
            documentObserver.disconnect();
          }
          // remove element only if was created dynamically
          if ($popup && !settings.preserve) {
            module.removePopup();
          }
          // clear all timeouts
          clearTimeout(module.hideTimer);
          clearTimeout(module.showTimer);
          // remove events
          module.unbind.close();
          module.unbind.events();
          $module.removeData(moduleNamespace);
        },
        event: {
          start: function start(event) {
            var delay = $.isPlainObject(settings.delay) ? settings.delay.show : settings.delay;
            clearTimeout(module.hideTimer);
            if (!openedWithTouch || openedWithTouch && settings.addTouchEvents) {
              module.showTimer = setTimeout(module.show, delay);
            }
          },
          end: function end() {
            var delay = $.isPlainObject(settings.delay) ? settings.delay.hide : settings.delay;
            clearTimeout(module.showTimer);
            module.hideTimer = setTimeout(module.hide, delay);
          },
          touchstart: function touchstart(event) {
            openedWithTouch = true;
            if (settings.addTouchEvents) {
              module.show();
            }
          },
          resize: function resize() {
            if (module.is.visible()) {
              module.set.position();
            }
          },
          documentChanged: function documentChanged(mutations) {
            [].forEach.call(mutations, function (mutation) {
              if (mutation.removedNodes) {
                [].forEach.call(mutation.removedNodes, function (node) {
                  if (node == element || $(node).find(element).length > 0) {
                    module.debug('Element removed from DOM, tearing down events');
                    module.destroy();
                  }
                });
              }
            });
          },
          hideGracefully: function hideGracefully(event) {
            var $target = $(event.target),
              isInDOM = $.contains(document.documentElement, event.target),
              inPopup = $target.closest(selector.popup).length > 0;
            // don't close on clicks inside popup
            if (event && !inPopup && isInDOM) {
              module.debug('Click occurred outside popup hiding popup');
              module.hide();
            } else {
              module.debug('Click was inside popup, keeping popup open');
            }
          }
        },
        // generates popup html from metadata
        create: function create() {
          var html = module.get.html(),
            title = module.get.title(),
            content = module.get.content();
          if (html || content || title) {
            module.debug('Creating pop-up html');
            if (!html) {
              html = settings.templates.popup({
                title: title,
                content: content
              });
            }
            $popup = $('<div/>').addClass(className.popup).data(metadata.activator, $module).html(html);
            if (settings.inline) {
              module.verbose('Inserting popup element inline', $popup);
              $popup.insertAfter($module);
            } else {
              module.verbose('Appending popup element to body', $popup);
              $popup.appendTo($context);
            }
            module.refresh();
            module.set.variation();
            if (settings.hoverable) {
              module.bind.popup();
            }
            settings.onCreate.call($popup, element);
          } else if (settings.popup) {
            $(settings.popup).data(metadata.activator, $module);
            module.verbose('Used popup specified in settings');
            module.refresh();
            if (settings.hoverable) {
              module.bind.popup();
            }
          } else if ($target.next(selector.popup).length !== 0) {
            module.verbose('Pre-existing popup found');
            settings.inline = true;
            settings.popup = $target.next(selector.popup).data(metadata.activator, $module);
            module.refresh();
            if (settings.hoverable) {
              module.bind.popup();
            }
          } else {
            module.debug('No content specified skipping display', element);
          }
        },
        createID: function createID() {
          _id = (Math.random().toString(16) + '000000000').substr(2, 8);
          elementNamespace = '.' + _id;
          module.verbose('Creating unique id for element', _id);
        },
        // determines popup state
        toggle: function toggle() {
          module.debug('Toggling pop-up');
          if (module.is.hidden()) {
            module.debug('Popup is hidden, showing pop-up');
            module.unbind.close();
            module.show();
          } else {
            module.debug('Popup is visible, hiding pop-up');
            module.hide();
          }
        },
        show: function show(callback) {
          callback = callback || function () {};
          module.debug('Showing pop-up', settings.transition);
          if (module.is.hidden() && !(module.is.active() && module.is.dropdown())) {
            if (!module.exists()) {
              module.create();
            }
            if (settings.onShow.call($popup, element) === false) {
              module.debug('onShow callback returned false, cancelling popup animation');
              return;
            } else if (!settings.preserve && !settings.popup) {
              module.refresh();
            }
            if ($popup && module.set.position()) {
              module.save.conditions();
              if (settings.exclusive) {
                module.hideAll();
              }
              module.animate.show(callback);
            }
          }
        },
        hide: function hide(callback) {
          callback = callback || function () {};
          if (module.is.visible() || module.is.animating()) {
            if (settings.onHide.call($popup, element) === false) {
              module.debug('onHide callback returned false, cancelling popup animation');
              return;
            }
            module.remove.visible();
            module.unbind.close();
            module.restore.conditions();
            module.animate.hide(callback);
          }
        },
        hideAll: function hideAll() {
          $(selector.popup).filter('.' + className.popupVisible).each(function () {
            $(this).data(metadata.activator).popup('hide');
          });
        },
        exists: function exists() {
          if (!$popup) {
            return false;
          }
          if (settings.inline || settings.popup) {
            return module.has.popup();
          } else {
            return $popup.closest($context).length >= 1 ? true : false;
          }
        },
        removePopup: function removePopup() {
          if (module.has.popup() && !settings.popup) {
            module.debug('Removing popup', $popup);
            $popup.remove();
            $popup = undefined;
            settings.onRemove.call($popup, element);
          }
        },
        save: {
          conditions: function conditions() {
            module.cache = {
              title: $module.attr('title')
            };
            if (module.cache.title) {
              $module.removeAttr('title');
            }
            module.verbose('Saving original attributes', module.cache.title);
          }
        },
        restore: {
          conditions: function conditions() {
            if (module.cache && module.cache.title) {
              $module.attr('title', module.cache.title);
              module.verbose('Restoring original attributes', module.cache.title);
            }
            return true;
          }
        },
        supports: {
          svg: function svg() {
            return typeof SVGGraphicsElement !== 'undefined';
          }
        },
        animate: {
          show: function show(callback) {
            callback = $.isFunction(callback) ? callback : function () {};
            if (settings.transition && $.fn.transition !== undefined && $module.transition('is supported')) {
              module.set.visible();
              $popup.transition({
                animation: (settings.transition.showMethod || settings.transition) + ' in',
                queue: false,
                debug: settings.debug,
                verbose: settings.verbose,
                duration: settings.transition.showDuration || settings.duration,
                onComplete: function onComplete() {
                  module.bind.close();
                  callback.call($popup, element);
                  settings.onVisible.call($popup, element);
                }
              });
            } else {
              module.error(error.noTransition);
            }
          },
          hide: function hide(callback) {
            callback = $.isFunction(callback) ? callback : function () {};
            module.debug('Hiding pop-up');
            if (settings.transition && $.fn.transition !== undefined && $module.transition('is supported')) {
              $popup.transition({
                animation: (settings.transition.hideMethod || settings.transition) + ' out',
                queue: false,
                duration: settings.transition.hideDuration || settings.duration,
                debug: settings.debug,
                verbose: settings.verbose,
                onComplete: function onComplete() {
                  module.reset();
                  callback.call($popup, element);
                  settings.onHidden.call($popup, element);
                }
              });
            } else {
              module.error(error.noTransition);
            }
          }
        },
        change: {
          content: function content(html) {
            $popup.html(html);
          }
        },
        get: {
          html: function html() {
            $module.removeData(metadata.html);
            return $module.data(metadata.html) || settings.html;
          },
          title: function title() {
            $module.removeData(metadata.title);
            return $module.data(metadata.title) || settings.title;
          },
          content: function content() {
            $module.removeData(metadata.content);
            return $module.data(metadata.content) || settings.content || $module.attr('title');
          },
          variation: function variation() {
            $module.removeData(metadata.variation);
            return $module.data(metadata.variation) || settings.variation;
          },
          popup: function popup() {
            return $popup;
          },
          popupOffset: function popupOffset() {
            return $popup.offset();
          },
          calculations: function calculations() {
            var $popupOffsetParent = module.get.offsetParent($popup),
              targetElement = $target[0],
              isWindow = $boundary[0] == window,
              targetOffset = $target.offset(),
              parentOffset = settings.inline || settings.popup && settings.movePopup ? $target.offsetParent().offset() : {
                top: 0,
                left: 0
              },
              screenPosition = isWindow ? {
                top: 0,
                left: 0
              } : $boundary.offset(),
              calculations = {},
              scroll = isWindow ? {
                top: $window.scrollTop(),
                left: $window.scrollLeft()
              } : {
                top: 0,
                left: 0
              },
              screen;
            calculations = {
              // element which is launching popup
              target: {
                element: $target[0],
                width: $target.outerWidth(),
                height: $target.outerHeight(),
                top: targetOffset.top - parentOffset.top,
                left: targetOffset.left - parentOffset.left,
                margin: {}
              },
              // popup itself
              popup: {
                width: $popup.outerWidth(),
                height: $popup.outerHeight()
              },
              // offset container (or 3d context)
              parent: {
                width: $offsetParent.outerWidth(),
                height: $offsetParent.outerHeight()
              },
              // screen boundaries
              screen: {
                top: screenPosition.top,
                left: screenPosition.left,
                scroll: {
                  top: scroll.top,
                  left: scroll.left
                },
                width: $boundary.width(),
                height: $boundary.height()
              }
            };

            // if popup offset context is not same as target, then adjust calculations
            if ($popupOffsetParent.get(0) !== $offsetParent.get(0)) {
              var popupOffset = $popupOffsetParent.offset();
              calculations.target.top -= popupOffset.top;
              calculations.target.left -= popupOffset.left;
              calculations.parent.width = $popupOffsetParent.outerWidth();
              calculations.parent.height = $popupOffsetParent.outerHeight();
            }

            // add in container calcs if fluid
            if (settings.setFluidWidth && module.is.fluid()) {
              calculations.container = {
                width: $popup.parent().outerWidth()
              };
              calculations.popup.width = calculations.container.width;
            }

            // add in margins if inline
            calculations.target.margin.top = settings.inline ? parseInt(window.getComputedStyle(targetElement).getPropertyValue('margin-top'), 10) : 0;
            calculations.target.margin.left = settings.inline ? module.is.rtl() ? parseInt(window.getComputedStyle(targetElement).getPropertyValue('margin-right'), 10) : parseInt(window.getComputedStyle(targetElement).getPropertyValue('margin-left'), 10) : 0;
            // calculate screen boundaries
            screen = calculations.screen;
            calculations.boundary = {
              top: screen.top + screen.scroll.top,
              bottom: screen.top + screen.scroll.top + screen.height,
              left: screen.left + screen.scroll.left,
              right: screen.left + screen.scroll.left + screen.width
            };
            return calculations;
          },
          id: function id() {
            return _id;
          },
          startEvent: function startEvent() {
            if (settings.on == 'hover') {
              return 'mouseenter';
            } else if (settings.on == 'focus') {
              return 'focus';
            }
            return false;
          },
          scrollEvent: function scrollEvent() {
            return 'scroll';
          },
          endEvent: function endEvent() {
            if (settings.on == 'hover') {
              return 'mouseleave';
            } else if (settings.on == 'focus') {
              return 'blur';
            }
            return false;
          },
          distanceFromBoundary: function distanceFromBoundary(offset, calculations) {
            var distanceFromBoundary = {},
              popup,
              boundary;
            calculations = calculations || module.get.calculations();

            // shorthand
            popup = calculations.popup;
            boundary = calculations.boundary;
            if (offset) {
              distanceFromBoundary = {
                top: offset.top - boundary.top,
                left: offset.left - boundary.left,
                right: boundary.right - (offset.left + popup.width),
                bottom: boundary.bottom - (offset.top + popup.height)
              };
              module.verbose('Distance from boundaries determined', offset, distanceFromBoundary);
            }
            return distanceFromBoundary;
          },
          offsetParent: function offsetParent($element) {
            var element = $element !== undefined ? $element[0] : $target[0],
              parentNode = element.parentNode,
              $node = $(parentNode);
            if (parentNode) {
              var is2D = $node.css('transform') === 'none',
                isStatic = $node.css('position') === 'static',
                isBody = $node.is('body');
              while (parentNode && !isBody && isStatic && is2D) {
                parentNode = parentNode.parentNode;
                $node = $(parentNode);
                is2D = $node.css('transform') === 'none';
                isStatic = $node.css('position') === 'static';
                isBody = $node.is('body');
              }
            }
            return $node && $node.length > 0 ? $node : $();
          },
          positions: function positions() {
            return {
              'top left': false,
              'top center': false,
              'top right': false,
              'bottom left': false,
              'bottom center': false,
              'bottom right': false,
              'left center': false,
              'right center': false
            };
          },
          nextPosition: function nextPosition(position) {
            var positions = position.split(' '),
              verticalPosition = positions[0],
              horizontalPosition = positions[1],
              opposite = {
                top: 'bottom',
                bottom: 'top',
                left: 'right',
                right: 'left'
              },
              adjacent = {
                left: 'center',
                center: 'right',
                right: 'left'
              },
              backup = {
                'top left': 'top center',
                'top center': 'top right',
                'top right': 'right center',
                'right center': 'bottom right',
                'bottom right': 'bottom center',
                'bottom center': 'bottom left',
                'bottom left': 'left center',
                'left center': 'top left'
              },
              adjacentsAvailable = verticalPosition == 'top' || verticalPosition == 'bottom',
              oppositeTried = false,
              adjacentTried = false,
              nextPosition = false;
            if (!triedPositions) {
              module.verbose('All available positions available');
              triedPositions = module.get.positions();
            }
            module.debug('Recording last position tried', position);
            triedPositions[position] = true;
            if (settings.prefer === 'opposite') {
              nextPosition = [opposite[verticalPosition], horizontalPosition];
              nextPosition = nextPosition.join(' ');
              oppositeTried = triedPositions[nextPosition] === true;
              module.debug('Trying opposite strategy', nextPosition);
            }
            if (settings.prefer === 'adjacent' && adjacentsAvailable) {
              nextPosition = [verticalPosition, adjacent[horizontalPosition]];
              nextPosition = nextPosition.join(' ');
              adjacentTried = triedPositions[nextPosition] === true;
              module.debug('Trying adjacent strategy', nextPosition);
            }
            if (adjacentTried || oppositeTried) {
              module.debug('Using backup position', nextPosition);
              nextPosition = backup[position];
            }
            return nextPosition;
          }
        },
        set: {
          position: function position(_position, calculations) {
            // exit conditions
            if ($target.length === 0 || $popup.length === 0) {
              module.error(error.notFound);
              return;
            }
            var offset, distanceAway, target, popup, parent, positioning, popupOffset, distanceFromBoundary;
            calculations = calculations || module.get.calculations();
            _position = _position || $module.data(metadata.position) || settings.position;
            offset = $module.data(metadata.offset) || settings.offset;
            distanceAway = settings.distanceAway;

            // shorthand
            target = calculations.target;
            popup = calculations.popup;
            parent = calculations.parent;
            if (module.should.centerArrow(calculations)) {
              module.verbose('Adjusting offset to center arrow on small target element');
              if (_position == 'top left' || _position == 'bottom left') {
                offset += target.width / 2;
                offset -= settings.arrowPixelsFromEdge;
              }
              if (_position == 'top right' || _position == 'bottom right') {
                offset -= target.width / 2;
                offset += settings.arrowPixelsFromEdge;
              }
            }
            if (target.width === 0 && target.height === 0 && !module.is.svg(target.element)) {
              module.debug('Popup target is hidden, no action taken');
              return false;
            }
            if (settings.inline) {
              module.debug('Adding margin to calculation', target.margin);
              if (_position == 'left center' || _position == 'right center') {
                offset += target.margin.top;
                distanceAway += -target.margin.left;
              } else if (_position == 'top left' || _position == 'top center' || _position == 'top right') {
                offset += target.margin.left;
                distanceAway -= target.margin.top;
              } else {
                offset += target.margin.left;
                distanceAway += target.margin.top;
              }
            }
            module.debug('Determining popup position from calculations', _position, calculations);
            if (module.is.rtl()) {
              _position = _position.replace(/left|right/g, function (match) {
                return match == 'left' ? 'right' : 'left';
              });
              module.debug('RTL: Popup position updated', _position);
            }

            // if last attempt use specified last resort position
            if (searchDepth == settings.maxSearchDepth && typeof settings.lastResort === 'string') {
              _position = settings.lastResort;
            }
            switch (_position) {
              case 'top left':
                positioning = {
                  top: 'auto',
                  bottom: parent.height - target.top + distanceAway,
                  left: target.left + offset,
                  right: 'auto'
                };
                break;
              case 'top center':
                positioning = {
                  bottom: parent.height - target.top + distanceAway,
                  left: target.left + target.width / 2 - popup.width / 2 + offset,
                  top: 'auto',
                  right: 'auto'
                };
                break;
              case 'top right':
                positioning = {
                  bottom: parent.height - target.top + distanceAway,
                  right: parent.width - target.left - target.width - offset,
                  top: 'auto',
                  left: 'auto'
                };
                break;
              case 'left center':
                positioning = {
                  top: target.top + target.height / 2 - popup.height / 2 + offset,
                  right: parent.width - target.left + distanceAway,
                  left: 'auto',
                  bottom: 'auto'
                };
                break;
              case 'right center':
                positioning = {
                  top: target.top + target.height / 2 - popup.height / 2 + offset,
                  left: target.left + target.width + distanceAway,
                  bottom: 'auto',
                  right: 'auto'
                };
                break;
              case 'bottom left':
                positioning = {
                  top: target.top + target.height + distanceAway,
                  left: target.left + offset,
                  bottom: 'auto',
                  right: 'auto'
                };
                break;
              case 'bottom center':
                positioning = {
                  top: target.top + target.height + distanceAway,
                  left: target.left + target.width / 2 - popup.width / 2 + offset,
                  bottom: 'auto',
                  right: 'auto'
                };
                break;
              case 'bottom right':
                positioning = {
                  top: target.top + target.height + distanceAway,
                  right: parent.width - target.left - target.width - offset,
                  left: 'auto',
                  bottom: 'auto'
                };
                break;
            }
            if (positioning === undefined) {
              module.error(error.invalidPosition, _position);
            }
            module.debug('Calculated popup positioning values', positioning);

            // tentatively place on stage
            $popup.css(positioning).removeClass(className.position).addClass(_position).addClass(className.loading);
            popupOffset = module.get.popupOffset();

            // see if any boundaries are surpassed with this tentative position
            distanceFromBoundary = module.get.distanceFromBoundary(popupOffset, calculations);
            if (!settings.forcePosition && module.is.offstage(distanceFromBoundary, _position)) {
              module.debug('Position is outside viewport', _position);
              if (searchDepth < settings.maxSearchDepth) {
                searchDepth++;
                _position = module.get.nextPosition(_position);
                module.debug('Trying new position', _position);
                return $popup ? module.set.position(_position, calculations) : false;
              } else {
                if (settings.lastResort) {
                  module.debug('No position found, showing with last position');
                } else {
                  module.debug('Popup could not find a position to display', $popup);
                  module.error(error.cannotPlace, element);
                  module.remove.attempts();
                  module.remove.loading();
                  module.reset();
                  settings.onUnplaceable.call($popup, element);
                  return false;
                }
              }
            }
            module.debug('Position is on stage', _position);
            module.remove.attempts();
            module.remove.loading();
            if (settings.setFluidWidth && module.is.fluid()) {
              module.set.fluidWidth(calculations);
            }
            return true;
          },
          fluidWidth: function fluidWidth(calculations) {
            calculations = calculations || module.get.calculations();
            module.debug('Automatically setting element width to parent width', calculations.parent.width);
            $popup.css('width', calculations.container.width);
          },
          variation: function variation(_variation) {
            _variation = _variation || module.get.variation();
            if (_variation && module.has.popup()) {
              module.verbose('Adding variation to popup', _variation);
              $popup.addClass(_variation);
            }
          },
          visible: function visible() {
            $module.addClass(className.visible);
          }
        },
        remove: {
          loading: function loading() {
            $popup.removeClass(className.loading);
          },
          variation: function variation(_variation2) {
            _variation2 = _variation2 || module.get.variation();
            if (_variation2) {
              module.verbose('Removing variation', _variation2);
              $popup.removeClass(_variation2);
            }
          },
          visible: function visible() {
            $module.removeClass(className.visible);
          },
          attempts: function attempts() {
            module.verbose('Resetting all searched positions');
            searchDepth = 0;
            triedPositions = false;
          }
        },
        bind: {
          events: function events() {
            module.debug('Binding popup events to module');
            if (settings.on == 'click') {
              $module.on(clickEvent + eventNamespace, module.toggle);
            }
            if (settings.on == 'hover') {
              $module.on('touchstart' + eventNamespace, module.event.touchstart);
            }
            if (module.get.startEvent()) {
              $module.on(module.get.startEvent() + eventNamespace, module.event.start).on(module.get.endEvent() + eventNamespace, module.event.end);
            }
            if (settings.target) {
              module.debug('Target set to element', $target);
            }
            $window.on('resize' + elementNamespace, module.event.resize);
          },
          popup: function popup() {
            module.verbose('Allowing hover events on popup to prevent closing');
            if ($popup && module.has.popup()) {
              $popup.on('mouseenter' + eventNamespace, module.event.start).on('mouseleave' + eventNamespace, module.event.end);
            }
          },
          close: function close() {
            if (settings.hideOnScroll === true || settings.hideOnScroll == 'auto' && settings.on != 'click') {
              module.bind.closeOnScroll();
            }
            if (module.is.closable()) {
              module.bind.clickaway();
            } else if (settings.on == 'hover' && openedWithTouch) {
              module.bind.touchClose();
            }
          },
          closeOnScroll: function closeOnScroll() {
            module.verbose('Binding scroll close event to document');
            $scrollContext.one(module.get.scrollEvent() + elementNamespace, module.event.hideGracefully);
          },
          touchClose: function touchClose() {
            module.verbose('Binding popup touchclose event to document');
            $document.on('touchstart' + elementNamespace, function (event) {
              module.verbose('Touched away from popup');
              module.event.hideGracefully.call(element, event);
            });
          },
          clickaway: function clickaway() {
            module.verbose('Binding popup close event to document');
            $document.on(clickEvent + elementNamespace, function (event) {
              module.verbose('Clicked away from popup');
              module.event.hideGracefully.call(element, event);
            });
          }
        },
        unbind: {
          events: function events() {
            $window.off(elementNamespace);
            $module.off(eventNamespace);
          },
          close: function close() {
            $document.off(elementNamespace);
            $scrollContext.off(elementNamespace);
          }
        },
        has: {
          popup: function popup() {
            return $popup && $popup.length > 0;
          }
        },
        should: {
          centerArrow: function centerArrow(calculations) {
            return !module.is.basic() && calculations.target.width <= settings.arrowPixelsFromEdge * 2;
          }
        },
        is: {
          closable: function closable() {
            if (settings.closable == 'auto') {
              if (settings.on == 'hover') {
                return false;
              }
              return true;
            }
            return settings.closable;
          },
          offstage: function offstage(distanceFromBoundary, position) {
            var offstage = [];
            // return boundaries that have been surpassed
            $.each(distanceFromBoundary, function (direction, distance) {
              if (distance < -settings.jitter) {
                module.debug('Position exceeds allowable distance from edge', direction, distance, position);
                offstage.push(direction);
              }
            });
            if (offstage.length > 0) {
              return true;
            } else {
              return false;
            }
          },
          svg: function svg(element) {
            return module.supports.svg() && element instanceof SVGGraphicsElement;
          },
          basic: function basic() {
            return $module.hasClass(className.basic);
          },
          active: function active() {
            return $module.hasClass(className.active);
          },
          animating: function animating() {
            return $popup !== undefined && $popup.hasClass(className.animating);
          },
          fluid: function fluid() {
            return $popup !== undefined && $popup.hasClass(className.fluid);
          },
          visible: function visible() {
            return $popup !== undefined && $popup.hasClass(className.popupVisible);
          },
          dropdown: function dropdown() {
            return $module.hasClass(className.dropdown);
          },
          hidden: function hidden() {
            return !module.is.visible();
          },
          rtl: function rtl() {
            return $module.attr('dir') === 'rtl' || $module.css('direction') === 'rtl';
          }
        },
        reset: function reset() {
          module.remove.visible();
          if (settings.preserve) {
            if ($.fn.transition !== undefined) {
              $popup.transition('remove transition');
            }
          } else {
            module.removePopup();
          }
        },
        setting: function setting(name, value) {
          if ($.isPlainObject(name)) {
            $.extend(true, settings, name);
          } else if (value !== undefined) {
            settings[name] = value;
          } else {
            return settings[name];
          }
        },
        internal: function internal(name, value) {
          if ($.isPlainObject(name)) {
            $.extend(true, module, name);
          } else if (value !== undefined) {
            module[name] = value;
          } else {
            return module[name];
          }
        },
        debug: function debug() {
          if (!settings.silent && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.debug = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.debug.apply(console, arguments);
            }
          }
        },
        verbose: function verbose() {
          if (!settings.silent && settings.verbose && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.verbose = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.verbose.apply(console, arguments);
            }
          }
        },
        error: function error() {
          if (!settings.silent) {
            module.error = Function.prototype.bind.call(console.error, console, settings.name + ':');
            module.error.apply(console, arguments);
          }
        },
        performance: {
          log: function log(message) {
            var currentTime, executionTime, previousTime;
            if (settings.performance) {
              currentTime = new Date().getTime();
              previousTime = time || currentTime;
              executionTime = currentTime - previousTime;
              time = currentTime;
              performance.push({
                'Name': message[0],
                'Arguments': [].slice.call(message, 1) || '',
                'Element': element,
                'Execution Time': executionTime
              });
            }
            clearTimeout(module.performance.timer);
            module.performance.timer = setTimeout(module.performance.display, 500);
          },
          display: function display() {
            var title = settings.name + ':',
              totalTime = 0;
            time = false;
            clearTimeout(module.performance.timer);
            $.each(performance, function (index, data) {
              totalTime += data['Execution Time'];
            });
            title += ' ' + totalTime + 'ms';
            if (moduleSelector) {
              title += ' \'' + moduleSelector + '\'';
            }
            if ((console.group !== undefined || console.table !== undefined) && performance.length > 0) {
              console.groupCollapsed(title);
              if (console.table) {
                console.table(performance);
              } else {
                $.each(performance, function (index, data) {
                  console.log(data['Name'] + ': ' + data['Execution Time'] + 'ms');
                });
              }
              console.groupEnd();
            }
            performance = [];
          }
        },
        invoke: function invoke(query, passedArguments, context) {
          var object = instance,
            maxDepth,
            found,
            response;
          passedArguments = passedArguments || queryArguments;
          context = element || context;
          if (typeof query == 'string' && object !== undefined) {
            query = query.split(/[\. ]/);
            maxDepth = query.length - 1;
            $.each(query, function (depth, value) {
              var camelCaseValue = depth != maxDepth ? value + query[depth + 1].charAt(0).toUpperCase() + query[depth + 1].slice(1) : query;
              if ($.isPlainObject(object[camelCaseValue]) && depth != maxDepth) {
                object = object[camelCaseValue];
              } else if (object[camelCaseValue] !== undefined) {
                found = object[camelCaseValue];
                return false;
              } else if ($.isPlainObject(object[value]) && depth != maxDepth) {
                object = object[value];
              } else if (object[value] !== undefined) {
                found = object[value];
                return false;
              } else {
                return false;
              }
            });
          }
          if ($.isFunction(found)) {
            response = found.apply(context, passedArguments);
          } else if (found !== undefined) {
            response = found;
          }
          if (Array.isArray(returnedValue)) {
            returnedValue.push(response);
          } else if (returnedValue !== undefined) {
            returnedValue = [returnedValue, response];
          } else if (response !== undefined) {
            returnedValue = response;
          }
          return found;
        }
      };
      if (methodInvoked) {
        if (instance === undefined) {
          module.initialize();
        }
        module.invoke(query);
      } else {
        if (instance !== undefined) {
          instance.invoke('destroy');
        }
        module.initialize();
      }
    });
    return returnedValue !== undefined ? returnedValue : this;
  };
  $.fn.popup.settings = {
    name: 'Popup',
    // module settings
    silent: false,
    debug: false,
    verbose: false,
    performance: true,
    namespace: 'popup',
    // whether it should use dom mutation observers
    observeChanges: true,
    // callback only when element added to dom
    onCreate: function onCreate() {},
    // callback before element removed from dom
    onRemove: function onRemove() {},
    // callback before show animation
    onShow: function onShow() {},
    // callback after show animation
    onVisible: function onVisible() {},
    // callback before hide animation
    onHide: function onHide() {},
    // callback when popup cannot be positioned in visible screen
    onUnplaceable: function onUnplaceable() {},
    // callback after hide animation
    onHidden: function onHidden() {},
    // when to show popup
    on: 'hover',
    // element to use to determine if popup is out of boundary
    boundary: window,
    // whether to add touchstart events when using hover
    addTouchEvents: true,
    // default position relative to element
    position: 'top left',
    // if given position should be used regardless if popup fits
    forcePosition: false,
    // name of variation to use
    variation: '',
    // whether popup should be moved to context
    movePopup: true,
    // element which popup should be relative to
    target: false,
    // jq selector or element that should be used as popup
    popup: false,
    // popup should remain inline next to activator
    inline: false,
    // popup should be removed from page on hide
    preserve: false,
    // popup should not close when being hovered on
    hoverable: false,
    // explicitly set content
    content: false,
    // explicitly set html
    html: false,
    // explicitly set title
    title: false,
    // whether automatically close on clickaway when on click
    closable: true,
    // automatically hide on scroll
    hideOnScroll: 'auto',
    // hide other popups on show
    exclusive: false,
    // context to attach popups
    context: 'body',
    // context for binding scroll events
    scrollContext: window,
    // position to prefer when calculating new position
    prefer: 'opposite',
    // specify position to appear even if it doesn't fit
    lastResort: false,
    // number of pixels from edge of popup to pointing arrow center (used from centering)
    arrowPixelsFromEdge: 20,
    // delay used to prevent accidental refiring of animations due to user error
    delay: {
      show: 50,
      hide: 70
    },
    // whether fluid variation should assign width explicitly
    setFluidWidth: true,
    // transition settings
    duration: 200,
    transition: 'scale',
    // distance away from activating element in px
    distanceAway: 0,
    // number of pixels an element is allowed to be "offstage" for a position to be chosen (allows for rounding)
    jitter: 2,
    // offset on aligning axis from calculated position
    offset: 0,
    // maximum times to look for a position before failing (9 positions total)
    maxSearchDepth: 15,
    error: {
      invalidPosition: 'The position you specified is not a valid position',
      cannotPlace: 'Popup does not fit within the boundaries of the viewport',
      method: 'The method you called is not defined.',
      noTransition: 'This module requires ui transitions <https://github.com/Semantic-Org/UI-Transition>',
      notFound: 'The target or popup you specified does not exist on the page'
    },
    metadata: {
      activator: 'activator',
      content: 'content',
      html: 'html',
      offset: 'offset',
      position: 'position',
      title: 'title',
      variation: 'variation'
    },
    className: {
      active: 'active',
      basic: 'basic',
      animating: 'animating',
      dropdown: 'dropdown',
      fluid: 'fluid',
      loading: 'loading',
      popup: 'ui popup',
      position: 'top left center bottom right',
      visible: 'visible',
      popupVisible: 'visible'
    },
    selector: {
      popup: '.ui.popup'
    },
    templates: {
      escape: function escape(string) {
        var badChars = /[<>"'`]/g,
          shouldEscape = /[&<>"'`]/,
          escape = {
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#x27;",
            "`": "&#x60;"
          },
          escapedChar = function escapedChar(chr) {
            return escape[chr];
          };
        if (shouldEscape.test(string)) {
          string = string.replace(/&(?![a-z0-9#]{1,6};)/, "&amp;");
          return string.replace(badChars, escapedChar);
        }
        return string;
      },
      popup: function popup(text) {
        var html = '',
          escape = $.fn.popup.settings.templates.escape;
        if (typeof text !== undefined) {
          if (typeof text.title !== undefined && text.title) {
            text.title = escape(text.title);
            html += '<div class="header">' + text.title + '</div>';
          }
          if (typeof text.content !== undefined && text.content) {
            text.content = escape(text.content);
            html += '<div class="content">' + text.content + '</div>';
          }
        }
        return html;
      }
    }
  };
})(jQuery, window, document);

/***/ }),

/***/ "./app/packs/src/semantic/definitions/modules/sidebar.js":
/*!***************************************************************!*\
  !*** ./app/packs/src/semantic/definitions/modules/sidebar.js ***!
  \***************************************************************/
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

/* provided dependency */ var jQuery = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
/*!
 * # Fomantic-UI - Sidebar
 * http://github.com/fomantic/Fomantic-UI/
 *
 *
 * Released under the MIT license
 * http://opensource.org/licenses/MIT
 *
 */

;
(function ($, window, document, undefined) {
  'use strict';

  $.isFunction = $.isFunction || function (obj) {
    return typeof obj === "function" && typeof obj.nodeType !== "number";
  };
  window = typeof window != 'undefined' && window.Math == Math ? window : typeof self != 'undefined' && self.Math == Math ? self : Function('return this')();
  $.fn.sidebar = function (parameters) {
    var $allModules = $(this),
      $window = $(window),
      $document = $(document),
      $html = $('html'),
      $head = $('head'),
      moduleSelector = $allModules.selector || '',
      time = new Date().getTime(),
      performance = [],
      query = arguments[0],
      methodInvoked = typeof query == 'string',
      queryArguments = [].slice.call(arguments, 1),
      requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || function (callback) {
        setTimeout(callback, 0);
      },
      returnedValue;
    $allModules.each(function () {
      var settings = $.isPlainObject(parameters) ? $.extend(true, {}, $.fn.sidebar.settings, parameters) : $.extend({}, $.fn.sidebar.settings),
        selector = settings.selector,
        className = settings.className,
        namespace = settings.namespace,
        regExp = settings.regExp,
        error = settings.error,
        eventNamespace = '.' + namespace,
        moduleNamespace = 'module-' + namespace,
        $module = $(this),
        $context = $(settings.context),
        $sidebars = $module.children(selector.sidebar),
        $fixed = $context.children(selector.fixed),
        $pusher = $context.children(selector.pusher),
        $style,
        element = this,
        instance = $module.data(moduleNamespace),
        elementNamespace,
        _id,
        currentScroll,
        transitionEvent,
        module;
      module = {
        initialize: function initialize() {
          module.debug('Initializing sidebar', parameters);
          module.create.id();
          transitionEvent = module.get.transitionEvent();

          // avoids locking rendering if initialized in onReady
          if (settings.delaySetup) {
            requestAnimationFrame(module.setup.layout);
          } else {
            module.setup.layout();
          }
          requestAnimationFrame(function () {
            module.setup.cache();
          });
          module.instantiate();
        },
        instantiate: function instantiate() {
          module.verbose('Storing instance of module', module);
          instance = module;
          $module.data(moduleNamespace, module);
        },
        create: {
          id: function id() {
            _id = (Math.random().toString(16) + '000000000').substr(2, 8);
            elementNamespace = '.' + _id;
            module.verbose('Creating unique id for element', _id);
          }
        },
        destroy: function destroy() {
          module.verbose('Destroying previous module for', $module);
          $module.off(eventNamespace).removeData(moduleNamespace);
          if (module.is.ios()) {
            module.remove.ios();
          }
          // bound by uuid
          $context.off(elementNamespace);
          $window.off(elementNamespace);
          $document.off(elementNamespace);
        },
        event: {
          clickaway: function clickaway(event) {
            if (settings.closable) {
              var clickedInPusher = $pusher.find(event.target).length > 0 || $pusher.is(event.target),
                clickedContext = $context.is(event.target);
              if (clickedInPusher) {
                module.verbose('User clicked on dimmed page');
                module.hide();
              }
              if (clickedContext) {
                module.verbose('User clicked on dimmable context (scaled out page)');
                module.hide();
              }
            }
          },
          touch: function touch(event) {
            //event.stopPropagation();
          },
          containScroll: function containScroll(event) {
            if (element.scrollTop <= 0) {
              element.scrollTop = 1;
            }
            if (element.scrollTop + element.offsetHeight >= element.scrollHeight) {
              element.scrollTop = element.scrollHeight - element.offsetHeight - 1;
            }
          },
          scroll: function scroll(event) {
            if ($(event.target).closest(selector.sidebar).length === 0) {
              event.preventDefault();
            }
          }
        },
        bind: {
          clickaway: function clickaway() {
            module.verbose('Adding clickaway events to context', $context);
            $context.on('click' + elementNamespace, module.event.clickaway).on('touchend' + elementNamespace, module.event.clickaway);
          },
          scrollLock: function scrollLock() {
            if (settings.scrollLock) {
              module.debug('Disabling page scroll');
              $window.on('DOMMouseScroll' + elementNamespace, module.event.scroll);
            }
            module.verbose('Adding events to contain sidebar scroll');
            $document.on('touchmove' + elementNamespace, module.event.touch);
            $module.on('scroll' + eventNamespace, module.event.containScroll);
          }
        },
        unbind: {
          clickaway: function clickaway() {
            module.verbose('Removing clickaway events from context', $context);
            $context.off(elementNamespace);
          },
          scrollLock: function scrollLock() {
            module.verbose('Removing scroll lock from page');
            $document.off(elementNamespace);
            $window.off(elementNamespace);
            $module.off('scroll' + eventNamespace);
          }
        },
        add: {
          inlineCSS: function inlineCSS() {
            var width = module.cache.width || $module.outerWidth(),
              height = module.cache.height || $module.outerHeight(),
              isRTL = module.is.rtl(),
              direction = module.get.direction(),
              distance = {
                left: width,
                right: -width,
                top: height,
                bottom: -height
              },
              style;
            if (isRTL) {
              module.verbose('RTL detected, flipping widths');
              distance.left = -width;
              distance.right = width;
            }
            style = '<style>';
            if (direction === 'left' || direction === 'right') {
              module.debug('Adding CSS rules for animation distance', width);
              style += '' + ' .ui.visible.' + direction + '.sidebar ~ .fixed,' + ' .ui.visible.' + direction + '.sidebar ~ .pusher {' + '   -webkit-transform: translate3d(' + distance[direction] + 'px, 0, 0);' + '           transform: translate3d(' + distance[direction] + 'px, 0, 0);' + ' }';
            } else if (direction === 'top' || direction == 'bottom') {
              style += '' + ' .ui.visible.' + direction + '.sidebar ~ .fixed,' + ' .ui.visible.' + direction + '.sidebar ~ .pusher {' + '   -webkit-transform: translate3d(0, ' + distance[direction] + 'px, 0);' + '           transform: translate3d(0, ' + distance[direction] + 'px, 0);' + ' }';
            }

            /* IE is only browser not to create context with transforms */
            /* https://www.w3.org/Bugs/Public/show_bug.cgi?id=16328 */
            if (module.is.ie()) {
              if (direction === 'left' || direction === 'right') {
                module.debug('Adding CSS rules for animation distance', width);
                style += '' + ' body.pushable > .ui.visible.' + direction + '.sidebar ~ .pusher:after {' + '   -webkit-transform: translate3d(' + distance[direction] + 'px, 0, 0);' + '           transform: translate3d(' + distance[direction] + 'px, 0, 0);' + ' }';
              } else if (direction === 'top' || direction == 'bottom') {
                style += '' + ' body.pushable > .ui.visible.' + direction + '.sidebar ~ .pusher:after {' + '   -webkit-transform: translate3d(0, ' + distance[direction] + 'px, 0);' + '           transform: translate3d(0, ' + distance[direction] + 'px, 0);' + ' }';
              }
              /* opposite sides visible forces content overlay */
              style += '' + ' body.pushable > .ui.visible.left.sidebar ~ .ui.visible.right.sidebar ~ .pusher:after,' + ' body.pushable > .ui.visible.right.sidebar ~ .ui.visible.left.sidebar ~ .pusher:after {' + '   -webkit-transform: translate3d(0, 0, 0);' + '           transform: translate3d(0, 0, 0);' + ' }';
            }
            style += '</style>';
            $style = $(style).appendTo($head);
            module.debug('Adding sizing css to head', $style);
          }
        },
        refresh: function refresh() {
          module.verbose('Refreshing selector cache');
          $context = $(settings.context);
          $sidebars = $context.children(selector.sidebar);
          $pusher = $context.children(selector.pusher);
          $fixed = $context.children(selector.fixed);
          module.clear.cache();
        },
        refreshSidebars: function refreshSidebars() {
          module.verbose('Refreshing other sidebars');
          $sidebars = $context.children(selector.sidebar);
        },
        repaint: function repaint() {
          module.verbose('Forcing repaint event');
          element.style.display = 'none';
          var ignored = element.offsetHeight;
          element.scrollTop = element.scrollTop;
          element.style.display = '';
        },
        setup: {
          cache: function cache() {
            module.cache = {
              width: $module.outerWidth(),
              height: $module.outerHeight()
            };
          },
          layout: function layout() {
            if ($context.children(selector.pusher).length === 0) {
              module.debug('Adding wrapper element for sidebar');
              module.error(error.pusher);
              $pusher = $('<div class="pusher" />');
              $context.children().not(selector.omitted).not($sidebars).wrapAll($pusher);
              module.refresh();
            }
            if ($module.nextAll(selector.pusher).length === 0 || $module.nextAll(selector.pusher)[0] !== $pusher[0]) {
              module.debug('Moved sidebar to correct parent element');
              module.error(error.movedSidebar, element);
              $module.detach().prependTo($context);
              module.refresh();
            }
            module.clear.cache();
            module.set.pushable();
            module.set.direction();
          }
        },
        attachEvents: function attachEvents(selector, event) {
          var $toggle = $(selector);
          event = $.isFunction(module[event]) ? module[event] : module.toggle;
          if ($toggle.length > 0) {
            module.debug('Attaching sidebar events to element', selector, event);
            $toggle.on('click' + eventNamespace, event);
          } else {
            module.error(error.notFound, selector);
          }
        },
        show: function show(callback) {
          callback = $.isFunction(callback) ? callback : function () {};
          if (module.is.hidden()) {
            module.refreshSidebars();
            if (settings.overlay) {
              module.error(error.overlay);
              settings.transition = 'overlay';
            }
            module.refresh();
            if (module.othersActive()) {
              module.debug('Other sidebars currently visible');
              if (settings.exclusive) {
                // if not overlay queue animation after hide
                if (settings.transition != 'overlay') {
                  module.hideOthers(module.show);
                  return;
                } else {
                  module.hideOthers();
                }
              } else {
                settings.transition = 'overlay';
              }
            }
            module.pushPage(function () {
              callback.call(element);
              settings.onShow.call(element);
            });
            settings.onChange.call(element);
            settings.onVisible.call(element);
          } else {
            module.debug('Sidebar is already visible');
          }
        },
        hide: function hide(callback) {
          callback = $.isFunction(callback) ? callback : function () {};
          if (module.is.visible() || module.is.animating()) {
            module.debug('Hiding sidebar', callback);
            module.refreshSidebars();
            module.pullPage(function () {
              callback.call(element);
              settings.onHidden.call(element);
            });
            settings.onChange.call(element);
            settings.onHide.call(element);
          }
        },
        othersAnimating: function othersAnimating() {
          return $sidebars.not($module).filter('.' + className.animating).length > 0;
        },
        othersVisible: function othersVisible() {
          return $sidebars.not($module).filter('.' + className.visible).length > 0;
        },
        othersActive: function othersActive() {
          return module.othersVisible() || module.othersAnimating();
        },
        hideOthers: function hideOthers(callback) {
          var $otherSidebars = $sidebars.not($module).filter('.' + className.visible),
            sidebarCount = $otherSidebars.length,
            callbackCount = 0;
          callback = callback || function () {};
          $otherSidebars.sidebar('hide', function () {
            callbackCount++;
            if (callbackCount == sidebarCount) {
              callback();
            }
          });
        },
        toggle: function toggle() {
          module.verbose('Determining toggled direction');
          if (module.is.hidden()) {
            module.show();
          } else {
            module.hide();
          }
        },
        pushPage: function pushPage(callback) {
          var transition = module.get.transition(),
            $transition = transition === 'overlay' || module.othersActive() ? $module : $pusher,
            animate,
            dim,
            _transitionEnd;
          callback = $.isFunction(callback) ? callback : function () {};
          if (settings.transition == 'scale down') {
            module.scrollToTop();
          }
          module.set.transition(transition);
          module.repaint();
          animate = function animate() {
            module.bind.clickaway();
            module.add.inlineCSS();
            module.set.animating();
            module.set.visible();
          };
          dim = function dim() {
            module.set.dimmed();
          };
          _transitionEnd = function transitionEnd(event) {
            if (event.target == $transition[0]) {
              $transition.off(transitionEvent + elementNamespace, _transitionEnd);
              module.remove.animating();
              module.bind.scrollLock();
              callback.call(element);
            }
          };
          $transition.off(transitionEvent + elementNamespace);
          $transition.on(transitionEvent + elementNamespace, _transitionEnd);
          requestAnimationFrame(animate);
          if (settings.dimPage && !module.othersVisible()) {
            requestAnimationFrame(dim);
          }
        },
        pullPage: function pullPage(callback) {
          var transition = module.get.transition(),
            $transition = transition == 'overlay' || module.othersActive() ? $module : $pusher,
            animate,
            _transitionEnd2;
          callback = $.isFunction(callback) ? callback : function () {};
          module.verbose('Removing context push state', module.get.direction());
          module.unbind.clickaway();
          module.unbind.scrollLock();
          animate = function animate() {
            module.set.transition(transition);
            module.set.animating();
            module.remove.visible();
            if (settings.dimPage && !module.othersVisible()) {
              $pusher.removeClass(className.dimmed);
            }
          };
          _transitionEnd2 = function transitionEnd(event) {
            if (event.target == $transition[0]) {
              $transition.off(transitionEvent + elementNamespace, _transitionEnd2);
              module.remove.animating();
              module.remove.transition();
              module.remove.inlineCSS();
              if (transition == 'scale down' || settings.returnScroll && module.is.mobile()) {
                module.scrollBack();
              }
              callback.call(element);
            }
          };
          $transition.off(transitionEvent + elementNamespace);
          $transition.on(transitionEvent + elementNamespace, _transitionEnd2);
          requestAnimationFrame(animate);
        },
        scrollToTop: function scrollToTop() {
          module.verbose('Scrolling to top of page to avoid animation issues');
          currentScroll = $(window).scrollTop();
          $module.scrollTop(0);
          window.scrollTo(0, 0);
        },
        scrollBack: function scrollBack() {
          module.verbose('Scrolling back to original page position');
          window.scrollTo(0, currentScroll);
        },
        clear: {
          cache: function cache() {
            module.verbose('Clearing cached dimensions');
            module.cache = {};
          }
        },
        set: {
          // ios only (scroll on html not document). This prevent auto-resize canvas/scroll in ios
          // (This is no longer necessary in latest iOS)
          ios: function ios() {
            $html.addClass(className.ios);
          },
          // container
          pushed: function pushed() {
            $context.addClass(className.pushed);
          },
          pushable: function pushable() {
            $context.addClass(className.pushable);
          },
          // pusher
          dimmed: function dimmed() {
            $pusher.addClass(className.dimmed);
          },
          // sidebar
          active: function active() {
            $module.addClass(className.active);
          },
          animating: function animating() {
            $module.addClass(className.animating);
          },
          transition: function transition(_transition) {
            _transition = _transition || module.get.transition();
            $module.addClass(_transition);
          },
          direction: function direction(_direction) {
            _direction = _direction || module.get.direction();
            $module.addClass(className[_direction]);
          },
          visible: function visible() {
            $module.addClass(className.visible);
          },
          overlay: function overlay() {
            $module.addClass(className.overlay);
          }
        },
        remove: {
          inlineCSS: function inlineCSS() {
            module.debug('Removing inline css styles', $style);
            if ($style && $style.length > 0) {
              $style.remove();
            }
          },
          // ios scroll on html not document
          ios: function ios() {
            $html.removeClass(className.ios);
          },
          // context
          pushed: function pushed() {
            $context.removeClass(className.pushed);
          },
          pushable: function pushable() {
            $context.removeClass(className.pushable);
          },
          // sidebar
          active: function active() {
            $module.removeClass(className.active);
          },
          animating: function animating() {
            $module.removeClass(className.animating);
          },
          transition: function transition(_transition2) {
            _transition2 = _transition2 || module.get.transition();
            $module.removeClass(_transition2);
          },
          direction: function direction(_direction2) {
            _direction2 = _direction2 || module.get.direction();
            $module.removeClass(className[_direction2]);
          },
          visible: function visible() {
            $module.removeClass(className.visible);
          },
          overlay: function overlay() {
            $module.removeClass(className.overlay);
          }
        },
        get: {
          direction: function direction() {
            if ($module.hasClass(className.top)) {
              return className.top;
            } else if ($module.hasClass(className.right)) {
              return className.right;
            } else if ($module.hasClass(className.bottom)) {
              return className.bottom;
            }
            return className.left;
          },
          transition: function transition() {
            var direction = module.get.direction(),
              transition;
            transition = module.is.mobile() ? settings.mobileTransition == 'auto' ? settings.defaultTransition.mobile[direction] : settings.mobileTransition : settings.transition == 'auto' ? settings.defaultTransition.computer[direction] : settings.transition;
            module.verbose('Determined transition', transition);
            return transition;
          },
          transitionEvent: function transitionEvent() {
            var element = document.createElement('element'),
              transitions = {
                'transition': 'transitionend',
                'OTransition': 'oTransitionEnd',
                'MozTransition': 'transitionend',
                'WebkitTransition': 'webkitTransitionEnd'
              },
              transition;
            for (transition in transitions) {
              if (element.style[transition] !== undefined) {
                return transitions[transition];
              }
            }
          }
        },
        is: {
          ie: function ie() {
            var isIE11 = !window.ActiveXObject && 'ActiveXObject' in window,
              isIE = ('ActiveXObject' in window);
            return isIE11 || isIE;
          },
          ios: function ios() {
            var userAgent = navigator.userAgent,
              isIOS = userAgent.match(regExp.ios),
              isMobileChrome = userAgent.match(regExp.mobileChrome);
            if (isIOS && !isMobileChrome) {
              module.verbose('Browser was found to be iOS', userAgent);
              return true;
            } else {
              return false;
            }
          },
          mobile: function mobile() {
            var userAgent = navigator.userAgent,
              isMobile = userAgent.match(regExp.mobile);
            if (isMobile) {
              module.verbose('Browser was found to be mobile', userAgent);
              return true;
            } else {
              module.verbose('Browser is not mobile, using regular transition', userAgent);
              return false;
            }
          },
          hidden: function hidden() {
            return !module.is.visible();
          },
          visible: function visible() {
            return $module.hasClass(className.visible);
          },
          // alias
          open: function open() {
            return module.is.visible();
          },
          closed: function closed() {
            return module.is.hidden();
          },
          vertical: function vertical() {
            return $module.hasClass(className.top);
          },
          animating: function animating() {
            return $context.hasClass(className.animating);
          },
          rtl: function rtl() {
            if (module.cache.rtl === undefined) {
              module.cache.rtl = $module.attr('dir') === 'rtl' || $module.css('direction') === 'rtl';
            }
            return module.cache.rtl;
          }
        },
        setting: function setting(name, value) {
          module.debug('Changing setting', name, value);
          if ($.isPlainObject(name)) {
            $.extend(true, settings, name);
          } else if (value !== undefined) {
            if ($.isPlainObject(settings[name])) {
              $.extend(true, settings[name], value);
            } else {
              settings[name] = value;
            }
          } else {
            return settings[name];
          }
        },
        internal: function internal(name, value) {
          if ($.isPlainObject(name)) {
            $.extend(true, module, name);
          } else if (value !== undefined) {
            module[name] = value;
          } else {
            return module[name];
          }
        },
        debug: function debug() {
          if (!settings.silent && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.debug = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.debug.apply(console, arguments);
            }
          }
        },
        verbose: function verbose() {
          if (!settings.silent && settings.verbose && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.verbose = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.verbose.apply(console, arguments);
            }
          }
        },
        error: function error() {
          if (!settings.silent) {
            module.error = Function.prototype.bind.call(console.error, console, settings.name + ':');
            module.error.apply(console, arguments);
          }
        },
        performance: {
          log: function log(message) {
            var currentTime, executionTime, previousTime;
            if (settings.performance) {
              currentTime = new Date().getTime();
              previousTime = time || currentTime;
              executionTime = currentTime - previousTime;
              time = currentTime;
              performance.push({
                'Name': message[0],
                'Arguments': [].slice.call(message, 1) || '',
                'Element': element,
                'Execution Time': executionTime
              });
            }
            clearTimeout(module.performance.timer);
            module.performance.timer = setTimeout(module.performance.display, 500);
          },
          display: function display() {
            var title = settings.name + ':',
              totalTime = 0;
            time = false;
            clearTimeout(module.performance.timer);
            $.each(performance, function (index, data) {
              totalTime += data['Execution Time'];
            });
            title += ' ' + totalTime + 'ms';
            if (moduleSelector) {
              title += ' \'' + moduleSelector + '\'';
            }
            if ((console.group !== undefined || console.table !== undefined) && performance.length > 0) {
              console.groupCollapsed(title);
              if (console.table) {
                console.table(performance);
              } else {
                $.each(performance, function (index, data) {
                  console.log(data['Name'] + ': ' + data['Execution Time'] + 'ms');
                });
              }
              console.groupEnd();
            }
            performance = [];
          }
        },
        invoke: function invoke(query, passedArguments, context) {
          var object = instance,
            maxDepth,
            found,
            response;
          passedArguments = passedArguments || queryArguments;
          context = element || context;
          if (typeof query == 'string' && object !== undefined) {
            query = query.split(/[\. ]/);
            maxDepth = query.length - 1;
            $.each(query, function (depth, value) {
              var camelCaseValue = depth != maxDepth ? value + query[depth + 1].charAt(0).toUpperCase() + query[depth + 1].slice(1) : query;
              if ($.isPlainObject(object[camelCaseValue]) && depth != maxDepth) {
                object = object[camelCaseValue];
              } else if (object[camelCaseValue] !== undefined) {
                found = object[camelCaseValue];
                return false;
              } else if ($.isPlainObject(object[value]) && depth != maxDepth) {
                object = object[value];
              } else if (object[value] !== undefined) {
                found = object[value];
                return false;
              } else {
                module.error(error.method, query);
                return false;
              }
            });
          }
          if ($.isFunction(found)) {
            response = found.apply(context, passedArguments);
          } else if (found !== undefined) {
            response = found;
          }
          if (Array.isArray(returnedValue)) {
            returnedValue.push(response);
          } else if (returnedValue !== undefined) {
            returnedValue = [returnedValue, response];
          } else if (response !== undefined) {
            returnedValue = response;
          }
          return found;
        }
      };
      if (methodInvoked) {
        if (instance === undefined) {
          module.initialize();
        }
        module.invoke(query);
      } else {
        if (instance !== undefined) {
          module.invoke('destroy');
        }
        module.initialize();
      }
    });
    return returnedValue !== undefined ? returnedValue : this;
  };
  $.fn.sidebar.settings = {
    name: 'Sidebar',
    namespace: 'sidebar',
    silent: false,
    debug: false,
    verbose: false,
    performance: true,
    transition: 'auto',
    mobileTransition: 'auto',
    defaultTransition: {
      computer: {
        left: 'uncover',
        right: 'uncover',
        top: 'overlay',
        bottom: 'overlay'
      },
      mobile: {
        left: 'uncover',
        right: 'uncover',
        top: 'overlay',
        bottom: 'overlay'
      }
    },
    context: 'body',
    exclusive: false,
    closable: true,
    dimPage: true,
    scrollLock: false,
    returnScroll: false,
    delaySetup: false,
    duration: 500,
    onChange: function onChange() {},
    onShow: function onShow() {},
    onHide: function onHide() {},
    onHidden: function onHidden() {},
    onVisible: function onVisible() {},
    className: {
      active: 'active',
      animating: 'animating',
      dimmed: 'dimmed',
      ios: 'ios',
      pushable: 'pushable',
      pushed: 'pushed',
      right: 'right',
      top: 'top',
      left: 'left',
      bottom: 'bottom',
      visible: 'visible'
    },
    selector: {
      fixed: '.fixed',
      omitted: 'script, link, style, .ui.modal, .ui.dimmer, .ui.nag, .ui.fixed',
      pusher: '.pusher',
      sidebar: '.ui.sidebar'
    },
    regExp: {
      ios: /(iPad|iPhone|iPod)/g,
      mobileChrome: /(CriOS)/g,
      mobile: /Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/g
    },
    error: {
      method: 'The method you called is not defined.',
      pusher: 'Had to add pusher element. For optimal performance make sure body content is inside a pusher element',
      movedSidebar: 'Had to move sidebar. For optimal performance make sure sidebar and pusher are direct children of your body tag',
      overlay: 'The overlay setting is no longer supported, use animation: overlay',
      notFound: 'There were no elements that matched the specified selector'
    }
  };
})(jQuery, window, document);

/***/ }),

/***/ "./app/packs/src/semantic/definitions/modules/transition.js":
/*!******************************************************************!*\
  !*** ./app/packs/src/semantic/definitions/modules/transition.js ***!
  \******************************************************************/
/***/ (function(__unused_webpack_module, __unused_webpack_exports, __webpack_require__) {

/* provided dependency */ var jQuery = __webpack_require__(/*! jquery */ "./node_modules/jquery/dist/jquery.js");
/*!
 * # Fomantic-UI - Transition
 * http://github.com/fomantic/Fomantic-UI/
 *
 *
 * Released under the MIT license
 * http://opensource.org/licenses/MIT
 *
 */

;
(function ($, window, document, undefined) {
  'use strict';

  $.isFunction = $.isFunction || function (obj) {
    return typeof obj === "function" && typeof obj.nodeType !== "number";
  };
  window = typeof window != 'undefined' && window.Math == Math ? window : typeof self != 'undefined' && self.Math == Math ? self : Function('return this')();
  $.fn.transition = function () {
    var $allModules = $(this),
      moduleSelector = $allModules.selector || '',
      time = new Date().getTime(),
      performance = [],
      moduleArguments = arguments,
      query = moduleArguments[0],
      queryArguments = [].slice.call(arguments, 1),
      methodInvoked = typeof query === 'string',
      returnedValue;
    $allModules.each(function (index) {
      var $module = $(this),
        element = this,
        // set at run time
        settings,
        instance,
        error,
        className,
        metadata,
        animationEnd,
        moduleNamespace,
        eventNamespace,
        module;
      module = {
        initialize: function initialize() {
          // get full settings
          settings = module.get.settings.apply(element, moduleArguments);

          // shorthand
          className = settings.className;
          error = settings.error;
          metadata = settings.metadata;

          // define namespace
          eventNamespace = '.' + settings.namespace;
          moduleNamespace = 'module-' + settings.namespace;
          instance = $module.data(moduleNamespace) || module;

          // get vendor specific events
          animationEnd = module.get.animationEndEvent();
          if (methodInvoked) {
            methodInvoked = module.invoke(query);
          }

          // method not invoked, lets run an animation
          if (methodInvoked === false) {
            module.verbose('Converted arguments into settings object', settings);
            if (settings.interval) {
              module.delay(settings.animate);
            } else {
              module.animate();
            }
            module.instantiate();
          }
        },
        instantiate: function instantiate() {
          module.verbose('Storing instance of module', module);
          instance = module;
          $module.data(moduleNamespace, instance);
        },
        destroy: function destroy() {
          module.verbose('Destroying previous module for', element);
          $module.removeData(moduleNamespace);
        },
        refresh: function refresh() {
          module.verbose('Refreshing display type on next animation');
          delete module.displayType;
        },
        forceRepaint: function forceRepaint() {
          module.verbose('Forcing element repaint');
          var $parentElement = $module.parent(),
            $nextElement = $module.next();
          if ($nextElement.length === 0) {
            $module.detach().appendTo($parentElement);
          } else {
            $module.detach().insertBefore($nextElement);
          }
        },
        repaint: function repaint() {
          module.verbose('Repainting element');
          var fakeAssignment = element.offsetWidth;
        },
        delay: function delay(interval) {
          var direction = module.get.animationDirection(),
            shouldReverse,
            delay;
          if (!direction) {
            direction = module.can.transition() ? module.get.direction() : 'static';
          }
          interval = interval !== undefined ? interval : settings.interval;
          shouldReverse = settings.reverse == 'auto' && direction == className.outward;
          delay = shouldReverse || settings.reverse == true ? ($allModules.length - index) * settings.interval : index * settings.interval;
          module.debug('Delaying animation by', delay);
          setTimeout(module.animate, delay);
        },
        animate: function animate(overrideSettings) {
          settings = overrideSettings || settings;
          if (!module.is.supported()) {
            module.error(error.support);
            return false;
          }
          module.debug('Preparing animation', settings.animation);
          if (module.is.animating()) {
            if (settings.queue) {
              if (!settings.allowRepeats && module.has.direction() && module.is.occurring() && module.queuing !== true) {
                module.debug('Animation is currently occurring, preventing queueing same animation', settings.animation);
              } else {
                module.queue(settings.animation);
              }
              return false;
            } else if (!settings.allowRepeats && module.is.occurring()) {
              module.debug('Animation is already occurring, will not execute repeated animation', settings.animation);
              return false;
            } else {
              module.debug('New animation started, completing previous early', settings.animation);
              instance.complete();
            }
          }
          if (module.can.animate()) {
            module.set.animating(settings.animation);
          } else {
            module.error(error.noAnimation, settings.animation, element);
          }
        },
        reset: function reset() {
          module.debug('Resetting animation to beginning conditions');
          module.remove.animationCallbacks();
          module.restore.conditions();
          module.remove.animating();
        },
        queue: function queue(animation) {
          module.debug('Queueing animation of', animation);
          module.queuing = true;
          $module.one(animationEnd + '.queue' + eventNamespace, function () {
            module.queuing = false;
            module.repaint();
            module.animate.apply(this, settings);
          });
        },
        complete: function complete(event) {
          if (event && event.target === element) {
            event.stopPropagation();
          }
          module.debug('Animation complete', settings.animation);
          module.remove.completeCallback();
          module.remove.failSafe();
          if (!module.is.looping()) {
            if (module.is.outward()) {
              module.verbose('Animation is outward, hiding element');
              module.restore.conditions();
              module.hide();
            } else if (module.is.inward()) {
              module.verbose('Animation is outward, showing element');
              module.restore.conditions();
              module.show();
            } else {
              module.verbose('Static animation completed');
              module.restore.conditions();
              settings.onComplete.call(element);
            }
          }
        },
        force: {
          visible: function visible() {
            var style = $module.attr('style'),
              userStyle = module.get.userStyle(style),
              displayType = module.get.displayType(),
              overrideStyle = userStyle + 'display: ' + displayType + ' !important;',
              inlineDisplay = $module[0].style.display,
              mustStayHidden = !displayType || inlineDisplay === 'none' && settings.skipInlineHidden || $module[0].tagName.match(/(script|link|style)/i);
            if (mustStayHidden) {
              module.remove.transition();
              return false;
            }
            module.verbose('Overriding default display to show element', displayType);
            $module.attr('style', overrideStyle);
            return true;
          },
          hidden: function hidden() {
            var style = $module.attr('style'),
              currentDisplay = $module.css('display'),
              emptyStyle = style === undefined || style === '';
            if (currentDisplay !== 'none' && !module.is.hidden()) {
              module.verbose('Overriding default display to hide element');
              $module.css('display', 'none');
            } else if (emptyStyle) {
              $module.removeAttr('style');
            }
          }
        },
        has: {
          direction: function direction(animation) {
            var hasDirection = false;
            animation = animation || settings.animation;
            if (typeof animation === 'string') {
              animation = animation.split(' ');
              $.each(animation, function (index, word) {
                if (word === className.inward || word === className.outward) {
                  hasDirection = true;
                }
              });
            }
            return hasDirection;
          },
          inlineDisplay: function inlineDisplay() {
            var style = $module.attr('style') || '';
            return Array.isArray(style.match(/display.*?;/, ''));
          }
        },
        set: {
          animating: function animating(animation) {
            // remove previous callbacks
            module.remove.completeCallback();

            // determine exact animation
            animation = animation || settings.animation;
            var animationClass = module.get.animationClass(animation);

            // save animation class in cache to restore class names
            module.save.animation(animationClass);
            if (module.force.visible()) {
              module.remove.hidden();
              module.remove.direction();
              module.start.animation(animationClass);
            }
          },
          duration: function duration(animationName, _duration) {
            _duration = _duration || settings.duration;
            _duration = typeof _duration == 'number' ? _duration + 'ms' : _duration;
            if (_duration || _duration === 0) {
              module.verbose('Setting animation duration', _duration);
              $module.css({
                'animation-duration': _duration
              });
            }
          },
          direction: function direction(_direction) {
            _direction = _direction || module.get.direction();
            if (_direction == className.inward) {
              module.set.inward();
            } else {
              module.set.outward();
            }
          },
          looping: function looping() {
            module.debug('Transition set to loop');
            $module.addClass(className.looping);
          },
          hidden: function hidden() {
            $module.addClass(className.transition).addClass(className.hidden);
          },
          inward: function inward() {
            module.debug('Setting direction to inward');
            $module.removeClass(className.outward).addClass(className.inward);
          },
          outward: function outward() {
            module.debug('Setting direction to outward');
            $module.removeClass(className.inward).addClass(className.outward);
          },
          visible: function visible() {
            $module.addClass(className.transition).addClass(className.visible);
          }
        },
        start: {
          animation: function animation(animationClass) {
            animationClass = animationClass || module.get.animationClass();
            module.debug('Starting tween', animationClass);
            $module.addClass(animationClass).one(animationEnd + '.complete' + eventNamespace, module.complete);
            if (settings.useFailSafe) {
              module.add.failSafe();
            }
            module.set.duration(settings.duration);
            settings.onStart.call(element);
          }
        },
        save: {
          animation: function animation(_animation) {
            if (!module.cache) {
              module.cache = {};
            }
            module.cache.animation = _animation;
          },
          displayType: function displayType(_displayType) {
            if (_displayType !== 'none') {
              $module.data(metadata.displayType, _displayType);
            }
          },
          transitionExists: function transitionExists(animation, exists) {
            $.fn.transition.exists[animation] = exists;
            module.verbose('Saving existence of transition', animation, exists);
          }
        },
        restore: {
          conditions: function conditions() {
            var animation = module.get.currentAnimation();
            if (animation) {
              $module.removeClass(animation);
              module.verbose('Removing animation class', module.cache);
            }
            module.remove.duration();
          }
        },
        add: {
          failSafe: function failSafe() {
            var duration = module.get.duration();
            module.timer = setTimeout(function () {
              $module.triggerHandler(animationEnd);
            }, duration + settings.failSafeDelay);
            module.verbose('Adding fail safe timer', module.timer);
          }
        },
        remove: {
          animating: function animating() {
            $module.removeClass(className.animating);
          },
          animationCallbacks: function animationCallbacks() {
            module.remove.queueCallback();
            module.remove.completeCallback();
          },
          queueCallback: function queueCallback() {
            $module.off('.queue' + eventNamespace);
          },
          completeCallback: function completeCallback() {
            $module.off('.complete' + eventNamespace);
          },
          display: function display() {
            $module.css('display', '');
          },
          direction: function direction() {
            $module.removeClass(className.inward).removeClass(className.outward);
          },
          duration: function duration() {
            $module.css('animation-duration', '');
          },
          failSafe: function failSafe() {
            module.verbose('Removing fail safe timer', module.timer);
            if (module.timer) {
              clearTimeout(module.timer);
            }
          },
          hidden: function hidden() {
            $module.removeClass(className.hidden);
          },
          visible: function visible() {
            $module.removeClass(className.visible);
          },
          looping: function looping() {
            module.debug('Transitions are no longer looping');
            if (module.is.looping()) {
              module.reset();
              $module.removeClass(className.looping);
            }
          },
          transition: function transition() {
            $module.removeClass(className.transition).removeClass(className.visible).removeClass(className.hidden);
          }
        },
        get: {
          settings: function settings(animation, duration, onComplete) {
            // single settings object
            if (typeof animation == 'object') {
              return $.extend(true, {}, $.fn.transition.settings, animation);
            }
            // all arguments provided
            else if (typeof onComplete == 'function') {
              return $.extend({}, $.fn.transition.settings, {
                animation: animation,
                onComplete: onComplete,
                duration: duration
              });
            }
            // only duration provided
            else if (typeof duration == 'string' || typeof duration == 'number') {
              return $.extend({}, $.fn.transition.settings, {
                animation: animation,
                duration: duration
              });
            }
            // duration is actually settings object
            else if (typeof duration == 'object') {
              return $.extend({}, $.fn.transition.settings, duration, {
                animation: animation
              });
            }
            // duration is actually callback
            else if (typeof duration == 'function') {
              return $.extend({}, $.fn.transition.settings, {
                animation: animation,
                onComplete: duration
              });
            }
            // only animation provided
            else {
              return $.extend({}, $.fn.transition.settings, {
                animation: animation
              });
            }
          },
          animationClass: function animationClass(animation) {
            var animationClass = animation || settings.animation,
              directionClass = module.can.transition() && !module.has.direction() ? module.get.direction() + ' ' : '';
            return className.animating + ' ' + className.transition + ' ' + directionClass + animationClass;
          },
          currentAnimation: function currentAnimation() {
            return module.cache && module.cache.animation !== undefined ? module.cache.animation : false;
          },
          currentDirection: function currentDirection() {
            return module.is.inward() ? className.inward : className.outward;
          },
          direction: function direction() {
            return module.is.hidden() || !module.is.visible() ? className.inward : className.outward;
          },
          animationDirection: function animationDirection(animation) {
            var direction;
            animation = animation || settings.animation;
            if (typeof animation === 'string') {
              animation = animation.split(' ');
              // search animation name for out/in class
              $.each(animation, function (index, word) {
                if (word === className.inward) {
                  direction = className.inward;
                } else if (word === className.outward) {
                  direction = className.outward;
                }
              });
            }
            // return found direction
            if (direction) {
              return direction;
            }
            return false;
          },
          duration: function duration(_duration2) {
            _duration2 = _duration2 || settings.duration;
            if (_duration2 === false) {
              _duration2 = $module.css('animation-duration') || 0;
            }
            return typeof _duration2 === 'string' ? _duration2.indexOf('ms') > -1 ? parseFloat(_duration2) : parseFloat(_duration2) * 1000 : _duration2;
          },
          displayType: function displayType(shouldDetermine) {
            shouldDetermine = shouldDetermine !== undefined ? shouldDetermine : true;
            if (settings.displayType) {
              return settings.displayType;
            }
            if (shouldDetermine && $module.data(metadata.displayType) === undefined) {
              var currentDisplay = $module.css('display');
              if (currentDisplay === '' || currentDisplay === 'none') {
                // create fake element to determine display state
                module.can.transition(true);
              } else {
                module.save.displayType(currentDisplay);
              }
            }
            return $module.data(metadata.displayType);
          },
          userStyle: function userStyle(style) {
            style = style || $module.attr('style') || '';
            return style.replace(/display.*?;/, '');
          },
          transitionExists: function transitionExists(animation) {
            return $.fn.transition.exists[animation];
          },
          animationStartEvent: function animationStartEvent() {
            var element = document.createElement('div'),
              animations = {
                'animation': 'animationstart',
                'OAnimation': 'oAnimationStart',
                'MozAnimation': 'mozAnimationStart',
                'WebkitAnimation': 'webkitAnimationStart'
              },
              animation;
            for (animation in animations) {
              if (element.style[animation] !== undefined) {
                return animations[animation];
              }
            }
            return false;
          },
          animationEndEvent: function animationEndEvent() {
            var element = document.createElement('div'),
              animations = {
                'animation': 'animationend',
                'OAnimation': 'oAnimationEnd',
                'MozAnimation': 'mozAnimationEnd',
                'WebkitAnimation': 'webkitAnimationEnd'
              },
              animation;
            for (animation in animations) {
              if (element.style[animation] !== undefined) {
                return animations[animation];
              }
            }
            return false;
          }
        },
        can: {
          transition: function transition(forced) {
            var animation = settings.animation,
              transitionExists = module.get.transitionExists(animation),
              displayType = module.get.displayType(false),
              elementClass,
              tagName,
              $clone,
              currentAnimation,
              inAnimation,
              directionExists;
            if (transitionExists === undefined || forced) {
              module.verbose('Determining whether animation exists');
              elementClass = $module.attr('class');
              tagName = $module.prop('tagName');
              $clone = $('<' + tagName + ' />').addClass(elementClass).insertAfter($module);
              currentAnimation = $clone.addClass(animation).removeClass(className.inward).removeClass(className.outward).addClass(className.animating).addClass(className.transition).css('animationName');
              inAnimation = $clone.addClass(className.inward).css('animationName');
              if (!displayType) {
                displayType = $clone.attr('class', elementClass).removeAttr('style').removeClass(className.hidden).removeClass(className.visible).show().css('display');
                module.verbose('Determining final display state', displayType);
                module.save.displayType(displayType);
              }
              $clone.remove();
              if (currentAnimation != inAnimation) {
                module.debug('Direction exists for animation', animation);
                directionExists = true;
              } else if (currentAnimation == 'none' || !currentAnimation) {
                module.debug('No animation defined in css', animation);
                return;
              } else {
                module.debug('Static animation found', animation, displayType);
                directionExists = false;
              }
              module.save.transitionExists(animation, directionExists);
            }
            return transitionExists !== undefined ? transitionExists : directionExists;
          },
          animate: function animate() {
            // can transition does not return a value if animation does not exist
            return module.can.transition() !== undefined;
          }
        },
        is: {
          animating: function animating() {
            return $module.hasClass(className.animating);
          },
          inward: function inward() {
            return $module.hasClass(className.inward);
          },
          outward: function outward() {
            return $module.hasClass(className.outward);
          },
          looping: function looping() {
            return $module.hasClass(className.looping);
          },
          occurring: function occurring(animation) {
            animation = animation || settings.animation;
            animation = '.' + animation.replace(' ', '.');
            return $module.filter(animation).length > 0;
          },
          visible: function visible() {
            return $module.is(':visible');
          },
          hidden: function hidden() {
            return $module.css('visibility') === 'hidden';
          },
          supported: function supported() {
            return animationEnd !== false;
          }
        },
        hide: function hide() {
          module.verbose('Hiding element');
          if (module.is.animating()) {
            module.reset();
          }
          element.blur(); // IE will trigger focus change if element is not blurred before hiding
          module.remove.display();
          module.remove.visible();
          if ($.isFunction(settings.onBeforeHide)) {
            settings.onBeforeHide.call(element, function () {
              module.hideNow();
            });
          } else {
            module.hideNow();
          }
        },
        hideNow: function hideNow() {
          module.set.hidden();
          module.force.hidden();
          settings.onHide.call(element);
          settings.onComplete.call(element);
          // module.repaint();
        },

        show: function show(display) {
          module.verbose('Showing element', display);
          if (module.force.visible()) {
            module.remove.hidden();
            module.set.visible();
            settings.onShow.call(element);
            settings.onComplete.call(element);
            // module.repaint();
          }
        },

        toggle: function toggle() {
          if (module.is.visible()) {
            module.hide();
          } else {
            module.show();
          }
        },
        stop: function stop() {
          module.debug('Stopping current animation');
          $module.triggerHandler(animationEnd);
        },
        stopAll: function stopAll() {
          module.debug('Stopping all animation');
          module.remove.queueCallback();
          $module.triggerHandler(animationEnd);
        },
        clear: {
          queue: function queue() {
            module.debug('Clearing animation queue');
            module.remove.queueCallback();
          }
        },
        enable: function enable() {
          module.verbose('Starting animation');
          $module.removeClass(className.disabled);
        },
        disable: function disable() {
          module.debug('Stopping animation');
          $module.addClass(className.disabled);
        },
        setting: function setting(name, value) {
          module.debug('Changing setting', name, value);
          if ($.isPlainObject(name)) {
            $.extend(true, settings, name);
          } else if (value !== undefined) {
            if ($.isPlainObject(settings[name])) {
              $.extend(true, settings[name], value);
            } else {
              settings[name] = value;
            }
          } else {
            return settings[name];
          }
        },
        internal: function internal(name, value) {
          if ($.isPlainObject(name)) {
            $.extend(true, module, name);
          } else if (value !== undefined) {
            module[name] = value;
          } else {
            return module[name];
          }
        },
        debug: function debug() {
          if (!settings.silent && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.debug = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.debug.apply(console, arguments);
            }
          }
        },
        verbose: function verbose() {
          if (!settings.silent && settings.verbose && settings.debug) {
            if (settings.performance) {
              module.performance.log(arguments);
            } else {
              module.verbose = Function.prototype.bind.call(console.info, console, settings.name + ':');
              module.verbose.apply(console, arguments);
            }
          }
        },
        error: function error() {
          if (!settings.silent) {
            module.error = Function.prototype.bind.call(console.error, console, settings.name + ':');
            module.error.apply(console, arguments);
          }
        },
        performance: {
          log: function log(message) {
            var currentTime, executionTime, previousTime;
            if (settings.performance) {
              currentTime = new Date().getTime();
              previousTime = time || currentTime;
              executionTime = currentTime - previousTime;
              time = currentTime;
              performance.push({
                'Name': message[0],
                'Arguments': [].slice.call(message, 1) || '',
                'Element': element,
                'Execution Time': executionTime
              });
            }
            clearTimeout(module.performance.timer);
            module.performance.timer = setTimeout(module.performance.display, 500);
          },
          display: function display() {
            var title = settings.name + ':',
              totalTime = 0;
            time = false;
            clearTimeout(module.performance.timer);
            $.each(performance, function (index, data) {
              totalTime += data['Execution Time'];
            });
            title += ' ' + totalTime + 'ms';
            if (moduleSelector) {
              title += ' \'' + moduleSelector + '\'';
            }
            if ($allModules.length > 1) {
              title += ' ' + '(' + $allModules.length + ')';
            }
            if ((console.group !== undefined || console.table !== undefined) && performance.length > 0) {
              console.groupCollapsed(title);
              if (console.table) {
                console.table(performance);
              } else {
                $.each(performance, function (index, data) {
                  console.log(data['Name'] + ': ' + data['Execution Time'] + 'ms');
                });
              }
              console.groupEnd();
            }
            performance = [];
          }
        },
        // modified for transition to return invoke success
        invoke: function invoke(query, passedArguments, context) {
          var object = instance,
            maxDepth,
            found,
            response;
          passedArguments = passedArguments || queryArguments;
          context = element || context;
          if (typeof query == 'string' && object !== undefined) {
            query = query.split(/[\. ]/);
            maxDepth = query.length - 1;
            $.each(query, function (depth, value) {
              var camelCaseValue = depth != maxDepth ? value + query[depth + 1].charAt(0).toUpperCase() + query[depth + 1].slice(1) : query;
              if ($.isPlainObject(object[camelCaseValue]) && depth != maxDepth) {
                object = object[camelCaseValue];
              } else if (object[camelCaseValue] !== undefined) {
                found = object[camelCaseValue];
                return false;
              } else if ($.isPlainObject(object[value]) && depth != maxDepth) {
                object = object[value];
              } else if (object[value] !== undefined) {
                found = object[value];
                return false;
              } else {
                return false;
              }
            });
          }
          if ($.isFunction(found)) {
            response = found.apply(context, passedArguments);
          } else if (found !== undefined) {
            response = found;
          }
          if (Array.isArray(returnedValue)) {
            returnedValue.push(response);
          } else if (returnedValue !== undefined) {
            returnedValue = [returnedValue, response];
          } else if (response !== undefined) {
            returnedValue = response;
          }
          return found !== undefined ? found : false;
        }
      };
      module.initialize();
    });
    return returnedValue !== undefined ? returnedValue : this;
  };

  // Records if CSS transition is available
  $.fn.transition.exists = {};
  $.fn.transition.settings = {
    // module info
    name: 'Transition',
    // hide all output from this component regardless of other settings
    silent: false,
    // debug content outputted to console
    debug: false,
    // verbose debug output
    verbose: false,
    // performance data output
    performance: true,
    // event namespace
    namespace: 'transition',
    // delay between animations in group
    interval: 0,
    // whether group animations should be reversed
    reverse: 'auto',
    // animation callback event
    onStart: function onStart() {},
    onComplete: function onComplete() {},
    onShow: function onShow() {},
    onHide: function onHide() {},
    // whether timeout should be used to ensure callback fires in cases animationend does not
    useFailSafe: true,
    // delay in ms for fail safe
    failSafeDelay: 100,
    // whether EXACT animation can occur twice in a row
    allowRepeats: false,
    // Override final display type on visible
    displayType: false,
    // animation duration
    animation: 'fade',
    duration: false,
    // new animations will occur after previous ones
    queue: true,
    // whether initially inline hidden objects should be skipped for transition
    skipInlineHidden: false,
    metadata: {
      displayType: 'display'
    },
    className: {
      animating: 'animating',
      disabled: 'disabled',
      hidden: 'hidden',
      inward: 'in',
      loading: 'loading',
      looping: 'looping',
      outward: 'out',
      transition: 'transition',
      visible: 'visible'
    },
    // possible errors
    error: {
      noAnimation: 'Element is no longer attached to DOM. Unable to animate.  Use silent setting to surpress this warning in production.',
      repeated: 'That animation is already occurring, cancelling repeated animation',
      method: 'The method you called is not defined',
      support: 'This browser does not support CSS animations'
    }
  };
})(jQuery, window, document);

/***/ }),

/***/ "./app/packs/entrypoints/stylesheets/transition.css":
/*!**********************************************************!*\
  !*** ./app/packs/entrypoints/stylesheets/transition.css ***!
  \**********************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
// extracted by mini-css-extract-plugin


/***/ }),

/***/ "./app/packs/entrypoints/stylesheets/application.scss":
/*!************************************************************!*\
  !*** ./app/packs/entrypoints/stylesheets/application.scss ***!
  \************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
// extracted by mini-css-extract-plugin


/***/ }),

/***/ "./app/packs/src/semantic/semantic.less":
/*!**********************************************!*\
  !*** ./app/packs/src/semantic/semantic.less ***!
  \**********************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
// extracted by mini-css-extract-plugin


/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ var __webpack_exec__ = function(moduleId) { return __webpack_require__(__webpack_require__.s = moduleId); }
/******/ __webpack_require__.O(0, ["vendors-node_modules_libphonenumber-js_index_es6_exports_format_js-node_modules_libphonenumbe-79e2c3","vendors-node_modules_punycode_punycode_es6_js","vendors-node_modules_hotwired_stimulus_dist_stimulus_js-node_modules_hotwired_turbo-rails_app-89e855"], function() { return __webpack_exec__("./app/packs/entrypoints/application.js"); });
/******/ var __webpack_exports__ = __webpack_require__.O();
/******/ }
]);
//# sourceMappingURL=application.js.map