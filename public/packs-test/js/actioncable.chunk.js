"use strict";
(self["webpackChunkauction_center"] = self["webpackChunkauction_center"] || []).push([["actioncable"],{

/***/ "./node_modules/@rails/actioncable/src/adapters.js":
/*!*********************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/adapters.js ***!
  \*********************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony default export */ __webpack_exports__["default"] = ({
  logger: self.console,
  WebSocket: self.WebSocket
});


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/connection.js":
/*!***********************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/connection.js ***!
  \***********************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _adapters__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./adapters */ "./node_modules/@rails/actioncable/src/adapters.js");
/* harmony import */ var _connection_monitor__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./connection_monitor */ "./node_modules/@rails/actioncable/src/connection_monitor.js");
/* harmony import */ var _internal__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./internal */ "./node_modules/@rails/actioncable/src/internal.js");
/* harmony import */ var _logger__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./logger */ "./node_modules/@rails/actioncable/src/logger.js");





// Encapsulate the cable connection held by the consumer. This is an internal class not intended for direct user manipulation.

const {message_types, protocols} = _internal__WEBPACK_IMPORTED_MODULE_2__["default"]
const supportedProtocols = protocols.slice(0, protocols.length - 1)

const indexOf = [].indexOf

class Connection {
  constructor(consumer) {
    this.open = this.open.bind(this)
    this.consumer = consumer
    this.subscriptions = this.consumer.subscriptions
    this.monitor = new _connection_monitor__WEBPACK_IMPORTED_MODULE_1__["default"](this)
    this.disconnected = true
  }

  send(data) {
    if (this.isOpen()) {
      this.webSocket.send(JSON.stringify(data))
      return true
    } else {
      return false
    }
  }

  open() {
    if (this.isActive()) {
      _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log(`Attempted to open WebSocket, but existing socket is ${this.getState()}`)
      return false
    } else {
      _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log(`Opening WebSocket, current state is ${this.getState()}, subprotocols: ${protocols}`)
      if (this.webSocket) { this.uninstallEventHandlers() }
      this.webSocket = new _adapters__WEBPACK_IMPORTED_MODULE_0__["default"].WebSocket(this.consumer.url, protocols)
      this.installEventHandlers()
      this.monitor.start()
      return true
    }
  }

  close({allowReconnect} = {allowReconnect: true}) {
    if (!allowReconnect) { this.monitor.stop() }
    // Avoid closing websockets in a "connecting" state due to Safari 15.1+ bug. See: https://github.com/rails/rails/issues/43835#issuecomment-1002288478
    if (this.isOpen()) {
      return this.webSocket.close()
    }
  }

  reopen() {
    _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log(`Reopening WebSocket, current state is ${this.getState()}`)
    if (this.isActive()) {
      try {
        return this.close()
      } catch (error) {
        _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log("Failed to reopen WebSocket", error)
      }
      finally {
        _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log(`Reopening WebSocket in ${this.constructor.reopenDelay}ms`)
        setTimeout(this.open, this.constructor.reopenDelay)
      }
    } else {
      return this.open()
    }
  }

  getProtocol() {
    if (this.webSocket) {
      return this.webSocket.protocol
    }
  }

  isOpen() {
    return this.isState("open")
  }

  isActive() {
    return this.isState("open", "connecting")
  }

  // Private

  isProtocolSupported() {
    return indexOf.call(supportedProtocols, this.getProtocol()) >= 0
  }

  isState(...states) {
    return indexOf.call(states, this.getState()) >= 0
  }

  getState() {
    if (this.webSocket) {
      for (let state in _adapters__WEBPACK_IMPORTED_MODULE_0__["default"].WebSocket) {
        if (_adapters__WEBPACK_IMPORTED_MODULE_0__["default"].WebSocket[state] === this.webSocket.readyState) {
          return state.toLowerCase()
        }
      }
    }
    return null
  }

  installEventHandlers() {
    for (let eventName in this.events) {
      const handler = this.events[eventName].bind(this)
      this.webSocket[`on${eventName}`] = handler
    }
  }

  uninstallEventHandlers() {
    for (let eventName in this.events) {
      this.webSocket[`on${eventName}`] = function() {}
    }
  }

}

Connection.reopenDelay = 500

Connection.prototype.events = {
  message(event) {
    if (!this.isProtocolSupported()) { return }
    const {identifier, message, reason, reconnect, type} = JSON.parse(event.data)
    switch (type) {
      case message_types.welcome:
        this.monitor.recordConnect()
        return this.subscriptions.reload()
      case message_types.disconnect:
        _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log(`Disconnecting. Reason: ${reason}`)
        return this.close({allowReconnect: reconnect})
      case message_types.ping:
        return this.monitor.recordPing()
      case message_types.confirmation:
        this.subscriptions.confirmSubscription(identifier)
        return this.subscriptions.notify(identifier, "connected")
      case message_types.rejection:
        return this.subscriptions.reject(identifier)
      default:
        return this.subscriptions.notify(identifier, "received", message)
    }
  },

  open() {
    _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log(`WebSocket onopen event, using '${this.getProtocol()}' subprotocol`)
    this.disconnected = false
    if (!this.isProtocolSupported()) {
      _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log("Protocol is unsupported. Stopping monitor and disconnecting.")
      return this.close({allowReconnect: false})
    }
  },

  close(event) {
    _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log("WebSocket onclose event")
    if (this.disconnected) { return }
    this.disconnected = true
    this.monitor.recordDisconnect()
    return this.subscriptions.notifyAll("disconnected", {willAttemptReconnect: this.monitor.isRunning()})
  },

  error() {
    _logger__WEBPACK_IMPORTED_MODULE_3__["default"].log("WebSocket onerror event")
  }
}

/* harmony default export */ __webpack_exports__["default"] = (Connection);


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/connection_monitor.js":
/*!*******************************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/connection_monitor.js ***!
  \*******************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _logger__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./logger */ "./node_modules/@rails/actioncable/src/logger.js");


// Responsible for ensuring the cable connection is in good health by validating the heartbeat pings sent from the server, and attempting
// revival reconnections if things go astray. Internal class, not intended for direct user manipulation.

const now = () => new Date().getTime()

const secondsSince = time => (now() - time) / 1000

class ConnectionMonitor {
  constructor(connection) {
    this.visibilityDidChange = this.visibilityDidChange.bind(this)
    this.connection = connection
    this.reconnectAttempts = 0
  }

  start() {
    if (!this.isRunning()) {
      this.startedAt = now()
      delete this.stoppedAt
      this.startPolling()
      addEventListener("visibilitychange", this.visibilityDidChange)
      _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`ConnectionMonitor started. stale threshold = ${this.constructor.staleThreshold} s`)
    }
  }

  stop() {
    if (this.isRunning()) {
      this.stoppedAt = now()
      this.stopPolling()
      removeEventListener("visibilitychange", this.visibilityDidChange)
      _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log("ConnectionMonitor stopped")
    }
  }

  isRunning() {
    return this.startedAt && !this.stoppedAt
  }

  recordPing() {
    this.pingedAt = now()
  }

  recordConnect() {
    this.reconnectAttempts = 0
    this.recordPing()
    delete this.disconnectedAt
    _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log("ConnectionMonitor recorded connect")
  }

  recordDisconnect() {
    this.disconnectedAt = now()
    _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log("ConnectionMonitor recorded disconnect")
  }

  // Private

  startPolling() {
    this.stopPolling()
    this.poll()
  }

  stopPolling() {
    clearTimeout(this.pollTimeout)
  }

  poll() {
    this.pollTimeout = setTimeout(() => {
      this.reconnectIfStale()
      this.poll()
    }
    , this.getPollInterval())
  }

  getPollInterval() {
    const { staleThreshold, reconnectionBackoffRate } = this.constructor
    const backoff = Math.pow(1 + reconnectionBackoffRate, Math.min(this.reconnectAttempts, 10))
    const jitterMax = this.reconnectAttempts === 0 ? 1.0 : reconnectionBackoffRate
    const jitter = jitterMax * Math.random()
    return staleThreshold * 1000 * backoff * (1 + jitter)
  }

  reconnectIfStale() {
    if (this.connectionIsStale()) {
      _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`ConnectionMonitor detected stale connection. reconnectAttempts = ${this.reconnectAttempts}, time stale = ${secondsSince(this.refreshedAt)} s, stale threshold = ${this.constructor.staleThreshold} s`)
      this.reconnectAttempts++
      if (this.disconnectedRecently()) {
        _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`ConnectionMonitor skipping reopening recent disconnect. time disconnected = ${secondsSince(this.disconnectedAt)} s`)
      } else {
        _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log("ConnectionMonitor reopening")
        this.connection.reopen()
      }
    }
  }

  get refreshedAt() {
    return this.pingedAt ? this.pingedAt : this.startedAt
  }

  connectionIsStale() {
    return secondsSince(this.refreshedAt) > this.constructor.staleThreshold
  }

  disconnectedRecently() {
    return this.disconnectedAt && (secondsSince(this.disconnectedAt) < this.constructor.staleThreshold)
  }

  visibilityDidChange() {
    if (document.visibilityState === "visible") {
      setTimeout(() => {
        if (this.connectionIsStale() || !this.connection.isOpen()) {
          _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`ConnectionMonitor reopening stale connection on visibilitychange. visibilityState = ${document.visibilityState}`)
          this.connection.reopen()
        }
      }
      , 200)
    }
  }

}

ConnectionMonitor.staleThreshold = 6 // Server::Connections::BEAT_INTERVAL * 2 (missed two pings)
ConnectionMonitor.reconnectionBackoffRate = 0.15

/* harmony default export */ __webpack_exports__["default"] = (ConnectionMonitor);


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/consumer.js":
/*!*********************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/consumer.js ***!
  \*********************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   createWebSocketURL: function() { return /* binding */ createWebSocketURL; },
/* harmony export */   "default": function() { return /* binding */ Consumer; }
/* harmony export */ });
/* harmony import */ var _connection__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./connection */ "./node_modules/@rails/actioncable/src/connection.js");
/* harmony import */ var _subscriptions__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./subscriptions */ "./node_modules/@rails/actioncable/src/subscriptions.js");



// The ActionCable.Consumer establishes the connection to a server-side Ruby Connection object. Once established,
// the ActionCable.ConnectionMonitor will ensure that its properly maintained through heartbeats and checking for stale updates.
// The Consumer instance is also the gateway to establishing subscriptions to desired channels through the #createSubscription
// method.
//
// The following example shows how this can be set up:
//
//   App = {}
//   App.cable = ActionCable.createConsumer("ws://example.com/accounts/1")
//   App.appearance = App.cable.subscriptions.create("AppearanceChannel")
//
// For more details on how you'd configure an actual channel subscription, see ActionCable.Subscription.
//
// When a consumer is created, it automatically connects with the server.
//
// To disconnect from the server, call
//
//   App.cable.disconnect()
//
// and to restart the connection:
//
//   App.cable.connect()
//
// Any channel subscriptions which existed prior to disconnecting will
// automatically resubscribe.

class Consumer {
  constructor(url) {
    this._url = url
    this.subscriptions = new _subscriptions__WEBPACK_IMPORTED_MODULE_1__["default"](this)
    this.connection = new _connection__WEBPACK_IMPORTED_MODULE_0__["default"](this)
  }

  get url() {
    return createWebSocketURL(this._url)
  }

  send(data) {
    return this.connection.send(data)
  }

  connect() {
    return this.connection.open()
  }

  disconnect() {
    return this.connection.close({allowReconnect: false})
  }

  ensureActiveConnection() {
    if (!this.connection.isActive()) {
      return this.connection.open()
    }
  }
}

function createWebSocketURL(url) {
  if (typeof url === "function") {
    url = url()
  }

  if (url && !/^wss?:/i.test(url)) {
    const a = document.createElement("a")
    a.href = url
    // Fix populating Location properties in IE. Otherwise, protocol will be blank.
    a.href = a.href
    a.protocol = a.protocol.replace("http", "ws")
    return a.href
  } else {
    return url
  }
}


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/index.js":
/*!******************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/index.js ***!
  \******************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   Connection: function() { return /* reexport safe */ _connection__WEBPACK_IMPORTED_MODULE_0__["default"]; },
/* harmony export */   ConnectionMonitor: function() { return /* reexport safe */ _connection_monitor__WEBPACK_IMPORTED_MODULE_1__["default"]; },
/* harmony export */   Consumer: function() { return /* reexport safe */ _consumer__WEBPACK_IMPORTED_MODULE_2__["default"]; },
/* harmony export */   INTERNAL: function() { return /* reexport safe */ _internal__WEBPACK_IMPORTED_MODULE_3__["default"]; },
/* harmony export */   Subscription: function() { return /* reexport safe */ _subscription__WEBPACK_IMPORTED_MODULE_4__["default"]; },
/* harmony export */   SubscriptionGuarantor: function() { return /* reexport safe */ _subscription_guarantor__WEBPACK_IMPORTED_MODULE_6__["default"]; },
/* harmony export */   Subscriptions: function() { return /* reexport safe */ _subscriptions__WEBPACK_IMPORTED_MODULE_5__["default"]; },
/* harmony export */   adapters: function() { return /* reexport safe */ _adapters__WEBPACK_IMPORTED_MODULE_7__["default"]; },
/* harmony export */   createConsumer: function() { return /* binding */ createConsumer; },
/* harmony export */   createWebSocketURL: function() { return /* reexport safe */ _consumer__WEBPACK_IMPORTED_MODULE_2__.createWebSocketURL; },
/* harmony export */   getConfig: function() { return /* binding */ getConfig; },
/* harmony export */   logger: function() { return /* reexport safe */ _logger__WEBPACK_IMPORTED_MODULE_8__["default"]; }
/* harmony export */ });
/* harmony import */ var _connection__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./connection */ "./node_modules/@rails/actioncable/src/connection.js");
/* harmony import */ var _connection_monitor__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./connection_monitor */ "./node_modules/@rails/actioncable/src/connection_monitor.js");
/* harmony import */ var _consumer__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./consumer */ "./node_modules/@rails/actioncable/src/consumer.js");
/* harmony import */ var _internal__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./internal */ "./node_modules/@rails/actioncable/src/internal.js");
/* harmony import */ var _subscription__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ./subscription */ "./node_modules/@rails/actioncable/src/subscription.js");
/* harmony import */ var _subscriptions__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ./subscriptions */ "./node_modules/@rails/actioncable/src/subscriptions.js");
/* harmony import */ var _subscription_guarantor__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./subscription_guarantor */ "./node_modules/@rails/actioncable/src/subscription_guarantor.js");
/* harmony import */ var _adapters__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./adapters */ "./node_modules/@rails/actioncable/src/adapters.js");
/* harmony import */ var _logger__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./logger */ "./node_modules/@rails/actioncable/src/logger.js");












function createConsumer(url = getConfig("url") || _internal__WEBPACK_IMPORTED_MODULE_3__["default"].default_mount_path) {
  return new _consumer__WEBPACK_IMPORTED_MODULE_2__["default"](url)
}

function getConfig(name) {
  const element = document.head.querySelector(`meta[name='action-cable-${name}']`)
  if (element) {
    return element.getAttribute("content")
  }
}


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/internal.js":
/*!*********************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/internal.js ***!
  \*********************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony default export */ __webpack_exports__["default"] = ({
  "message_types": {
    "welcome": "welcome",
    "disconnect": "disconnect",
    "ping": "ping",
    "confirmation": "confirm_subscription",
    "rejection": "reject_subscription"
  },
  "disconnect_reasons": {
    "unauthorized": "unauthorized",
    "invalid_request": "invalid_request",
    "server_restart": "server_restart"
  },
  "default_mount_path": "/cable",
  "protocols": [
    "actioncable-v1-json",
    "actioncable-unsupported"
  ]
});


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/logger.js":
/*!*******************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/logger.js ***!
  \*******************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _adapters__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./adapters */ "./node_modules/@rails/actioncable/src/adapters.js");


// The logger is disabled by default. You can enable it with:
//
//   ActionCable.logger.enabled = true
//
//   Example:
//
//   import * as ActionCable from '@rails/actioncable'
//
//   ActionCable.logger.enabled = true
//   ActionCable.logger.log('Connection Established.')
//

/* harmony default export */ __webpack_exports__["default"] = ({
  log(...messages) {
    if (this.enabled) {
      messages.push(Date.now())
      _adapters__WEBPACK_IMPORTED_MODULE_0__["default"].logger.log("[ActionCable]", ...messages)
    }
  },
});


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/subscription.js":
/*!*************************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/subscription.js ***!
  \*************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ Subscription; }
/* harmony export */ });
// A new subscription is created through the ActionCable.Subscriptions instance available on the consumer.
// It provides a number of callbacks and a method for calling remote procedure calls on the corresponding
// Channel instance on the server side.
//
// An example demonstrates the basic functionality:
//
//   App.appearance = App.cable.subscriptions.create("AppearanceChannel", {
//     connected() {
//       // Called once the subscription has been successfully completed
//     },
//
//     disconnected({ willAttemptReconnect: boolean }) {
//       // Called when the client has disconnected with the server.
//       // The object will have an `willAttemptReconnect` property which
//       // says whether the client has the intention of attempting
//       // to reconnect.
//     },
//
//     appear() {
//       this.perform('appear', {appearing_on: this.appearingOn()})
//     },
//
//     away() {
//       this.perform('away')
//     },
//
//     appearingOn() {
//       $('main').data('appearing-on')
//     }
//   })
//
// The methods #appear and #away forward their intent to the remote AppearanceChannel instance on the server
// by calling the `perform` method with the first parameter being the action (which maps to AppearanceChannel#appear/away).
// The second parameter is a hash that'll get JSON encoded and made available on the server in the data parameter.
//
// This is how the server component would look:
//
//   class AppearanceChannel < ApplicationActionCable::Channel
//     def subscribed
//       current_user.appear
//     end
//
//     def unsubscribed
//       current_user.disappear
//     end
//
//     def appear(data)
//       current_user.appear on: data['appearing_on']
//     end
//
//     def away
//       current_user.away
//     end
//   end
//
// The "AppearanceChannel" name is automatically mapped between the client-side subscription creation and the server-side Ruby class name.
// The AppearanceChannel#appear/away public methods are exposed automatically to client-side invocation through the perform method.

const extend = function(object, properties) {
  if (properties != null) {
    for (let key in properties) {
      const value = properties[key]
      object[key] = value
    }
  }
  return object
}

class Subscription {
  constructor(consumer, params = {}, mixin) {
    this.consumer = consumer
    this.identifier = JSON.stringify(params)
    extend(this, mixin)
  }

  // Perform a channel action with the optional data passed as an attribute
  perform(action, data = {}) {
    data.action = action
    return this.send(data)
  }

  send(data) {
    return this.consumer.send({command: "message", identifier: this.identifier, data: JSON.stringify(data)})
  }

  unsubscribe() {
    return this.consumer.subscriptions.remove(this)
  }
}


/***/ }),

/***/ "./node_modules/@rails/actioncable/src/subscription_guarantor.js":
/*!***********************************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/subscription_guarantor.js ***!
  \***********************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _logger__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./logger */ "./node_modules/@rails/actioncable/src/logger.js");


// Responsible for ensuring channel subscribe command is confirmed, retrying until confirmation is received.
// Internal class, not intended for direct user manipulation.

class SubscriptionGuarantor {
  constructor(subscriptions) {
    this.subscriptions = subscriptions
    this.pendingSubscriptions = []
  }

  guarantee(subscription) {
    if(this.pendingSubscriptions.indexOf(subscription) == -1){ 
      _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`SubscriptionGuarantor guaranteeing ${subscription.identifier}`)
      this.pendingSubscriptions.push(subscription) 
    }
    else {
      _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`SubscriptionGuarantor already guaranteeing ${subscription.identifier}`)
    }
    this.startGuaranteeing()
  }

  forget(subscription) {
    _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`SubscriptionGuarantor forgetting ${subscription.identifier}`)
    this.pendingSubscriptions = (this.pendingSubscriptions.filter((s) => s !== subscription))
  }

  startGuaranteeing() {
    this.stopGuaranteeing()
    this.retrySubscribing()
  }
  
  stopGuaranteeing() {
    clearTimeout(this.retryTimeout)
  }

  retrySubscribing() {
    this.retryTimeout = setTimeout(() => {
      if (this.subscriptions && typeof(this.subscriptions.subscribe) === "function") {
        this.pendingSubscriptions.map((subscription) => {
          _logger__WEBPACK_IMPORTED_MODULE_0__["default"].log(`SubscriptionGuarantor resubscribing ${subscription.identifier}`)
          this.subscriptions.subscribe(subscription)
        })
      }
    }
    , 500)
  }
}

/* harmony default export */ __webpack_exports__["default"] = (SubscriptionGuarantor);

/***/ }),

/***/ "./node_modules/@rails/actioncable/src/subscriptions.js":
/*!**************************************************************!*\
  !*** ./node_modules/@rails/actioncable/src/subscriptions.js ***!
  \**************************************************************/
/***/ (function(__unused_webpack_module, __webpack_exports__, __webpack_require__) {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   "default": function() { return /* binding */ Subscriptions; }
/* harmony export */ });
/* harmony import */ var _subscription__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./subscription */ "./node_modules/@rails/actioncable/src/subscription.js");
/* harmony import */ var _subscription_guarantor__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./subscription_guarantor */ "./node_modules/@rails/actioncable/src/subscription_guarantor.js");
/* harmony import */ var _logger__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./logger */ "./node_modules/@rails/actioncable/src/logger.js");




// Collection class for creating (and internally managing) channel subscriptions.
// The only method intended to be triggered by the user is ActionCable.Subscriptions#create,
// and it should be called through the consumer like so:
//
//   App = {}
//   App.cable = ActionCable.createConsumer("ws://example.com/accounts/1")
//   App.appearance = App.cable.subscriptions.create("AppearanceChannel")
//
// For more details on how you'd configure an actual channel subscription, see ActionCable.Subscription.

class Subscriptions {
  constructor(consumer) {
    this.consumer = consumer
    this.guarantor = new _subscription_guarantor__WEBPACK_IMPORTED_MODULE_1__["default"](this)
    this.subscriptions = []
  }

  create(channelName, mixin) {
    const channel = channelName
    const params = typeof channel === "object" ? channel : {channel}
    const subscription = new _subscription__WEBPACK_IMPORTED_MODULE_0__["default"](this.consumer, params, mixin)
    return this.add(subscription)
  }

  // Private

  add(subscription) {
    this.subscriptions.push(subscription)
    this.consumer.ensureActiveConnection()
    this.notify(subscription, "initialized")
    this.subscribe(subscription)
    return subscription
  }

  remove(subscription) {
    this.forget(subscription)
    if (!this.findAll(subscription.identifier).length) {
      this.sendCommand(subscription, "unsubscribe")
    }
    return subscription
  }

  reject(identifier) {
    return this.findAll(identifier).map((subscription) => {
      this.forget(subscription)
      this.notify(subscription, "rejected")
      return subscription
    })
  }

  forget(subscription) {
    this.guarantor.forget(subscription)
    this.subscriptions = (this.subscriptions.filter((s) => s !== subscription))
    return subscription
  }

  findAll(identifier) {
    return this.subscriptions.filter((s) => s.identifier === identifier)
  }

  reload() {
    return this.subscriptions.map((subscription) =>
      this.subscribe(subscription))
  }

  notifyAll(callbackName, ...args) {
    return this.subscriptions.map((subscription) =>
      this.notify(subscription, callbackName, ...args))
  }

  notify(subscription, callbackName, ...args) {
    let subscriptions
    if (typeof subscription === "string") {
      subscriptions = this.findAll(subscription)
    } else {
      subscriptions = [subscription]
    }

    return subscriptions.map((subscription) =>
      (typeof subscription[callbackName] === "function" ? subscription[callbackName](...args) : undefined))
  }

  subscribe(subscription) {
    if (this.sendCommand(subscription, "subscribe")) {
      this.guarantor.guarantee(subscription)
    }
  }

  confirmSubscription(identifier) {
    _logger__WEBPACK_IMPORTED_MODULE_2__["default"].log(`Subscription confirmed ${identifier}`)
    this.findAll(identifier).map((subscription) =>
      this.guarantor.forget(subscription))
  }

  sendCommand(subscription, command) {
    const {identifier} = subscription
    return this.consumer.send({command, identifier})
  }
}


/***/ })

}]);
//# sourceMappingURL=actioncable.chunk.js.map