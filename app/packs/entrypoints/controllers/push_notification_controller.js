import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    vapidPublic: String,
    userLogin: Boolean
  };

  connect() {
    if(!this.userLoginValue) return;

    let subscribed = localStorage.getItem('block-webpush-modal');
    if (subscribed === 'true') {
      document.querySelector('.webpush-modal').style.display = 'none';
    }

    if ('serviceWorker' in navigator && 'PushManager' in window) {
      navigator.serviceWorker.ready.then(registration => {
        registration.pushManager.getSubscription().then(subscription => {
          if (!subscription) {
            if (Notification.permission === 'granted') {
              this.setupPushNotifications();
            } else {
              this.requestPermission();
            }
          }
        }
      )}
    )}
  }

  requestPermission() {
    window.addEventListener('load', () => {
      Notification.requestPermission().then((permission) => {
        if (permission === 'granted') {
          this.setupPushNotifications(applicationServerKey);
        }
      });
    });
  }

  setupPushNotifications() {
    const applicationServerKey = this.urlBase64ToUint8Array(this.vapidPublicValue);

    navigator.serviceWorker.register("/service-worker.js", {scope: "./" }).then((registration) => {
      registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: applicationServerKey
      }).then((subscription) => {

        const endpoint = subscription.endpoint;
        const p256dh = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('p256dh'))));
        const auth = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('auth'))));

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
        document.querySelector('.webpush-modal').style.display = 'none'
      });
    });
  }

  close() {
    document.querySelector('.webpush-modal').style.display = 'none'
  }

  decline() {
    localStorage.setItem('block-webpush-modal', 'true');
    document.querySelector('.webpush-modal').style.display = 'none'
  }

  urlBase64ToUint8Array(base64String) {
    var padding = '='.repeat((4 - base64String.length % 4) % 4);
    var base64 = (base64String + padding)
        .replace(/\-/g, '+')
        .replace(/_/g, '/');

    var rawData = window.atob(base64);
    var outputArray = new Uint8Array(rawData.length);

    for (var i = 0; i < rawData.length; ++i) {
        outputArray[i] = rawData.charCodeAt(i);
    }

    return outputArray;
  }
}
