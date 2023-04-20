self.addEventListener('push', event => {
  const data = event.data.json();

  self.registration.showNotification(data.title, {
    body: data.body,
    icon: data.icon,
    data: { url: data.url }
  });
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window' }).then(clientsArr => {
      const client = clientsArr.find(c => {
        return c.visibilityState === 'visible';
      });
      if (client !== undefined) {
        client.navigate(event.notification.data.url);
        client.focus();
      } else {
        clients.openWindow(event.notification.data.url);
      }
    })
  );
});
