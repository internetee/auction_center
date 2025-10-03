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
      const element = document.querySelector('.webpush-modal');
      if (element) {
        element.style.display = 'none';
      }
    }

    // Check if the browser supports notifications
    if ("Notification" in window) {
      // Request permission from the user to send notifications
      Notification.requestPermission().then((permission) => {
        if (permission === "granted") {
          // If permission is granted, register the service worker
          this.registerServiceWorker();
        } else if (permission === "denied") {
          console.warn("User rejected to allow notifications.");
        } else {
          console.warn("User still didn't give an answer about notifications.");
        }
      });
    } else {
      console.warn("Push notifications not supported.");
    }
  }

  setupPushNotifications(registration) {
    // Wait for the service worker to be ready
    navigator.serviceWorker.ready
      .then((serviceWorkerRegistration) => {
        // Check if a subscription to push notifications already exists
        serviceWorkerRegistration.pushManager
          .getSubscription()
          .then((existingSubscription) => {
            if (!existingSubscription) {
              // If no subscription exists, subscribe to push notifications
              serviceWorkerRegistration.pushManager
                .subscribe({
                  userVisibleOnly: true,
                  applicationServerKey: this.urlBase64ToUint8Array(this.vapidPublicValue),
                })
                .then((subscription) => {
                  // Save the subscription on the server
                  this.saveSubscription(subscription);
                })
                .catch((error) => {
                  console.error("Error subscribing to push notifications:", error);
                });
            }
          });

        localStorage.setItem('block-webpush-modal', 'true');
        const modal = document.querySelector('.webpush-modal');
        if (modal) {
          modal.style.display = 'none';
        }
      })
      .catch((error) => {
        console.error("Error waiting for Service Worker to be ready:", error);
      });
  }

  registerServiceWorker() {
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/service-worker.js', { scope: '/' })
        .then(registration => {
          console.log('Service Worker registered successfully:', registration);
          this.setupPushNotifications(registration);
        })
        .catch(error => {
          console.error('Service Worker registration failed:', error);
        });
    } else {
      console.warn('Service Workers are not supported in this browser.');
    }
  }

  saveSubscription(subscription) {
    // Extract necessary subscription data
    const endpoint = subscription.endpoint;
    const p256dh = btoa(
      String.fromCharCode.apply(
        null,
        new Uint8Array(subscription.getKey("p256dh"))
      )
    );
    const auth = btoa(
      String.fromCharCode.apply(
        null,
        new Uint8Array(subscription.getKey("auth"))
      )
    );

    // Send the subscription data to the server
    fetch("/push_subscriptions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: JSON.stringify({ endpoint, p256dh, auth }),
    })
      .then((response) => {
        if (response.ok) {
          console.log("Subscription successfully saved on the server.");
        } else {
          console.error("Error saving subscription on the server.");
        }
      })
      .catch((error) => {
        console.error("Error sending subscription to the server:", error);
      });
  }

  close() {
    document.querySelector('.webpush-modal').style.display = 'none'
  }

  decline() {
    localStorage.setItem('block-webpush-modal', 'true');
    document.querySelector('.webpush-modal').style.display = 'none'
  }

  // ----

  // connect() {
  //   if(!this.userLoginValue) return;

  //   let subscribed = localStorage.getItem('block-webpush-modal');
  //   if (subscribed === 'true') {
  //     const element = document.querySelector('.webpush-modal');
  //     if (element) {
  //       element.style.display = 'none';
  //     }
  //   }

  //   if ('serviceWorker' in navigator && 'PushManager' in window) {
  //     navigator.serviceWorker.ready.then(registration => {
  //       registration.pushManager.getSubscription().then(subscription => {
  //         if (!subscription) {
  //           if (Notification.permission === 'granted') {
  //             this.setupPushNotifications();
  //           } else {
  //             this.requestPermission();
  //           }
  //         }
  //       }
  //     )}
  //   )}
  // }

  // requestPermission() {
  //   window.addEventListener('load', () => {
  //     Notification.requestPermission().then((permission) => {
  //       if (permission === 'granted') {
  //         this.setupPushNotifications(applicationServerKey);
  //       }
  //     });
  //   });
  // }

  // setupPushNotifications() {
  //   const applicationServerKey = this.urlBase64ToUint8Array(this.vapidPublicValue);

  //   navigator.serviceWorker.register("/service-worker.js", {scope: "./" }).then((registration) => {
  //     console.log('Service Worker registered successfully:', registration);

  //     registration.pushManager.subscribe({
  //       userVisibleOnly: true,
  //       applicationServerKey: applicationServerKey
  //     }).then((subscription) => {

  //       const endpoint = subscription.endpoint;
  //       const p256dh = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('p256dh'))));
  //       const auth = btoa(String.fromCharCode.apply(null, new Uint8Array(subscription.getKey('auth'))));

  //       fetch('/push_subscriptions', {
  //         method: 'POST',
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  //         },
  //         body: JSON.stringify({
  //           subscription: {
  //             endpoint: endpoint,
  //             p256dh: p256dh,
  //             auth: auth
  //           }
  //         })
  //       });

  //       localStorage.setItem('block-webpush-modal', 'true');
  //       document.querySelector('.webpush-modal').style.display = 'none'
  //     });
  //   }).catch(err => {
  //     console.log('Service Worker registration failed:', err);
  //   });;
  // }

  // close() {
  //   document.querySelector('.webpush-modal').style.display = 'none'
  // }

  // decline() {
  //   localStorage.setItem('block-webpush-modal', 'true');
  //   document.querySelector('.webpush-modal').style.display = 'none'
  // }

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
