importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyBkS2PK5YGoTqVsOphaqQOxYVfJDC1AC6s',
  appId: '1:298918535780:web:4f4d0b5a9477ad80f47571',
  messagingSenderId: '298918535780',
  projectId: 'healthpal-ej',
  authDomain: 'healthpal-ej.firebaseapp.com',
  storageBucket: 'healthpal-ej.firebasestorage.app',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Received background message: ', payload);
  const notificationTitle = payload.notification?.title || 'Health Pal';
  const notificationOptions = {
    body: payload.notification?.body || '',
    icon: '/favicon.png',
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
