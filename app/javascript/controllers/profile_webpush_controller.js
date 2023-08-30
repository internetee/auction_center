import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    vapidPublic: String,
  }

  static targets = ["checkbox"]
 
  connect() {

    console.log('webpush connected!');

    if ('serviceWorker' in navigator && 'PushManager' in window) {
      navigator.serviceWorker.ready.then(registration => {
        registration.pushManager.getSubscription().then(subscription => {
          if (subscription) {
            this.checkboxTarget.style.disabled = true;
            this.checkboxTarget.classList.add('disabled');
          }
        }
      )}
    )}
  }

  setupPushNotifications() {
    console.log('webpush action!');

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
        document.querySelector('.webpush-modal').style.display = 'none';
        this.checkboxTarget.style.disabled = true;
        this.checkboxTarget.classList.add('disabled');
      });
    });
  }

}