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
        }).catch(error => {
          console.error('Error checking subscription:', error);
        });
      });
    }
  }

  setupPushNotifications() {
    if ("Notification" in window) {
      Notification.requestPermission().then((permission) => {
        if (permission === "granted") {
          this.registerAndSubscribe();
        } else {
          console.warn("User rejected to allow notifications.");
        }
      });
    } else {
      console.warn("Push notifications not supported.");
    }
  }

  registerAndSubscribe() {
    const applicationServerKey = this.urlBase64ToUint8Array(this.vapidPublicValue);

    navigator.serviceWorker.register("/service-worker.js", {scope: "./" })
      .then((registration) => {
        console.log('Service Worker registered successfully:', registration);
        return navigator.serviceWorker.ready;
      })
      .then((serviceWorkerRegistration) => {
        return serviceWorkerRegistration.pushManager.getSubscription()
          .then((existingSubscription) => {
            if (!existingSubscription) {
              return serviceWorkerRegistration.pushManager.subscribe({
                userVisibleOnly: true,
                applicationServerKey: applicationServerKey
              });
            }
            return existingSubscription;
          });
      })
      .then((subscription) => {
        const endpoint = subscription.endpoint;
        const p256dh = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('p256dh'))));
        const auth = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('auth'))));

        return fetch('/push_subscriptions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({
            subscription: {
              endpoint: endpoint,
              p256dh: p256dh,
              auth: auth
            }
          })
        }).then(response => {
          if (response.ok) {
            console.log("Subscription successfully saved on the server.");
            localStorage.setItem('block-webpush-modal', 'true');
            const modal = document.querySelector('.webpush-modal');
            if (modal) {
              modal.style.display = 'none';
            }
            this.checkboxTarget.style.disabled = true;
            this.checkboxTarget.classList.add('disabled');
          } else {
            throw new Error(`Server responded with status: ${response.status}`);
          }
        });
      })
      .catch(error => {
        console.error('Service Worker registration or subscription failed:', error);
        alert('Failed to enable push notifications. Please try again later.');
      });
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