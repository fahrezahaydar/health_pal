# Technical Design Document — Bagian 9: Push Notification

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Service** | Firebase Cloud Messaging (FCM) + Supabase |
| **Status** | 🔧 Proposed (belum ada Firebase package) |

---

## Daftar Isi

1. [Architecture](#1-architecture)
2. [FCM Token Lifecycle](#2-fcm-token-lifecycle)
3. [Notification Types](#3-notification-types)
4. [Notification Routing](#4-notification-routing)
5. [Foreground vs Background](#5-foreground-vs-background)
6. [Setup Checklist](#6-setup-checklist)

---

## 1. Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Supabase    │────▶│  FCM Server  │────▶│  Device      │
│  Edge Fn     │     │  (Firebase)  │     │  (App)       │
│              │     │              │     │              │
│  Trigger:    │     │  Send push   │     │  onMessage   │
│  booking     │     │  to token    │     │  onResume    │
│  reminder    │     │              │     │  onLaunch    │
└──────────────┘     └──────────────┘     └──────┬───────┘
                                                  │
                                          ┌───────▼───────┐
                                          │  Handle tap   │
                                          │  → route ke   │
                                          │  halaman sesuai│
                                          └───────────────┘
```

---

## 2. FCM Token Lifecycle

```dart
// lib/core/services/fcm_service.dart
@lazySingleton
class FcmService {
  final SupabaseClient _supabase;

  Future<void> init() async {
    // 1. Minta izin notifikasi (iOS)
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    // 2. Dapatkan token
    final token = await messaging.getToken();

    // 3. Kirim ke server
    if (token != null) await _upsertToken(token);

    // 4. Listen refresh token
    messaging.onTokenRefresh.listen(_upsertToken);
  }

  Future<void> _upsertToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.functions.invoke('upsert-fcm-token', body: {
      'fcm_token': token,
      'platform': Platform.isAndroid ? 'android' : 'ios',
    });
  }
}
```

---

## 3. Notification Types

| Type | Trigger | Waktu | Title | Body |
|---|---|---|---|---|
| `booking_success` | Booking dibuat | Segera | Booking Berhasil | "Booking kamu dengan Dr. {nama} berhasil! Menunggu konfirmasi." |
| `booking_confirmed` | Status → upcoming | Saat konfirmasi | Booking Dikonfirmasi | "Appointment kamu dengan Dr. {nama} sudah dikonfirmasi." |
| `reminder_h1` | H-1 | 24 jam sebelum | Reminder Besok | "Jangan lupa! Besok kamu ada jadwal dengan Dr. {nama} pukul {waktu}." |
| `reminder_h0` | H-0 | 2 jam sebelum | Reminder Hari Ini | "Appointment kamu dengan Dr. {nama} 2 jam lagi." |
| `booking_cancelled` | User batal | Segera | Booking Dibatalkan | "Appointment dengan Dr. {nama} pada {tanggal} telah dibatalkan." |

---

## 4. Notification Routing

```dart
// lib/core/services/fcm_service.dart

// ── Foreground message ──
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  final data = message.data;
  _showInAppNotification(data);
});

// ── App in background → user tap ──
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  _navigateToScreen(message.data);
});

// ── App killed → user tap ──
final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
if (initialMessage != null) {
  _navigateToScreen(initialMessage.data);
}

void _navigateToScreen(Map<String, dynamic> data) {
  final type = data['type'] as String?;
  final appointmentId = data['appointment_id'] as String?;
  final doctorId = data['doctor_id'] as String?;

  switch (type) {
    case 'booking_success':
    case 'booking_confirmed':
    case 'reminder_h1':
    case 'reminder_h0':
      router.push('/booking-history/$appointmentId');
    case 'booking_cancelled':
      router.push('/booking-history/$appointmentId');
    default:
      router.go('/home');
  }
}
```

---

## 5. Foreground vs Background

| State | Handler | Behavior |
|---|---|---|
| Foreground | `FirebaseMessaging.onMessage` | Tampilkan in-app banner / snackbar (TIDAK system notification) |
| Background | `onMessageOpenedApp` | System notification → tap → route ke halaman |
| Terminated | `getInitialMessage` | System notification → tap → app launch → route |

---

## 6. Setup Checklist

```
🔥 Setup Firebase:
[ ] Buat project Firebase
[ ] Download google-services.json → android/app/
[ ] Download GoogleService-Info.plist → ios/Runner/
[ ] flutter pub add firebase_messaging
[ ] flutter pub add firebase_core
[ ] flutterfire configure

📱 FCM:
[ ] Panggil FcmService.init() di main.dart setelah Supabase.initialize()
[ ] Register token ke Edge Function 'upsert-fcm-token'
[ ] Handle onMessage (foreground)
[ ] Handle onMessageOpenedApp (background tap)
[ ] Handle getInitialMessage (terminated tap)
[ ] Test kirim notifikasi via Firebase Console

🧪 Testing:
[ ] Test kirim notifikasi manual via Firebase Console
[ ] Test tap notifikasi → route ke halaman benar
[ ] Test foreground message → in-app banner
[ ] Test background → system notification
```
