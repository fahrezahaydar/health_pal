# Technical Design Document — Bagian 3: Routing Design

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Acuan** | USER_FLOW v2.0, TDD Bagian 1 & 2 |

---

## Daftar Isi

1. [Route Tree & Klasifikasi](#1-route-tree--klasifikasi)
2. [StatefulShellRoute — Bottom Navigation](#2-statefulshellroute--bottom-navigation)
3. [Redirect Guard Logic](#3-redirect-guard-logic)
4. [Navigation Flow Diagram](#4-navigation-flow-diagram)
5. [Deep Link Handling](#5-deep-link-handling)
6. [Transition & Animation](#6-transition--animation)
7. [Error Routing](#7-error-routing)
8. [Kode GoRouter Lengkap](#8-kode-gorouter-lengkap)

---

## 1. Route Tree & Klasifikasi

Seluruh route diklasifikasikan ke dalam 3 kategori berdasarkan cara navigasinya:

```
PRE-AUTH ROUTES (di luar shell)
├── /onboarding
├── /sign-in
│   └── /sign-in/forgot-password
└── /sign-up
    └── /sign-up/create-profile

SHELL ROUTES (StatefulShellRoute — bottom nav)
├── /home                  tab 0
├── /loc                   tab 1
├── /booking-history       tab 2
└── /profile               tab 3

STACK ROUTES (push di atas shell, bottom nav hidden)
├── /doctor/search
├── /doctor/:doctorId
├── /booking/:doctorId
├── /booking/success
├── /booking-history/:appointmentId
├── /profile/edit
├── /profile/favorite
├── /profile/notification
├── /profile/settings
├── /profile/help
├── /profile/tnc
└── /no-internet
```

| Kategori | Navigasi | Bottom Nav | Back Button |
|---|---|---|---|
| Pre-auth | `context.go()` | Tidak ada | Tidak ada |
| Shell | `context.go()` | ✅ Visible | Pindah tab |
| Stack | `context.push()` | ❌ Hidden | ✅ `context.pop()` |

---

## 2. StatefulShellRoute — Bottom Navigation

### 2.1 Arsitektur Shell

```
MaterialApp.router
  └── GoRouter
       └── StatefulShellRoute.indexedStack
            ├── Branch 0: /home              → HomePage
            ├── Branch 1: /loc               → LocPage
            ├── Branch 2: /booking-history   → BookingHistoryPage
            └── Branch 3: /profile           → ProfilePage
```

### 2.2 AppShell Widget

```dart
// lib/widgets/app_shell.dart
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,  // ← StatefulShellRoute child
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.location), label: 'Loc'),
          BottomNavigationBarItem(icon: Icon(Iconsax.calendar), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}
```

### 2.3 Branch Switching Rules

| Aksi | Method | Efek |
|---|---|---|
| Tap bottom nav tab | `navigationShell.goBranch(index)` | Switch branch, **state tiap branch tetap terjaga** |
| `context.go('/loc')` | GoRouter | Switch branch, tapi **reset state branch** (re-initialize) |
| `context.push('/doctor/:id')` | Push | Stack di atas shell, bottom nav hidden |

> **Important:** Untuk navigasi antar tab, selalu panggil `navigationShell.goBranch()` — jangan `context.go()`. `goBranch()` mempertahankan scroll position dan state tiap tab.

---

## 3. Redirect Guard Logic

### 3.1 Status-Based Redirect

```mermaid
graph TD
    A([User buka app]) --> B{AppServices.status}
    B -->|loading| C[Tampilkan native splash]
    C --> D{AppServices.init() selesai}
    D -->|onboardingDone = false| E[/onboarding]
    D -->|onboardingDone = true| F{isLoggedIn}
    F -->|false| G[/sign-in]
    F -->|true| H{Token valid?}
    H -->|Ya| I[/home]
    H -->|Tidak| J[Refresh token]
    J -->|Sukses| I
    J -->|Gagal| G

    E -->|completeOnboarding| G
    G -->|login success| I

    I -->|logout| G

    style I fill:#4CAF50,color:#fff
    style G fill:#FFA726,color:#fff
```

### 3.2 Kode Redirect

```dart
// lib/core/router/app_router.dart — redirect
redirect: (context, state) {
  final status = _appServices.status;
  final loc = state.uri.path;

  // Daftar route yang TIDAK perlu auth
  final publicRoutes = <String>{
    '/onboarding',
    '/sign-in',
    '/no-internet',
  };
  final isPublicRoute = publicRoutes.any((r) => loc.startsWith(r));
  final isAuthRoute = loc.startsWith('/sign-in') || loc.startsWith('/sign-up');

  switch (status) {
    case AppStatus.loading:
      // Selama init, jangan redirect apa pun
      return null;

    case AppStatus.onboarding:
      return loc == '/onboarding' ? null : '/onboarding';

    case AppStatus.unauthenticated:
      if (isAuthRoute || loc == '/onboarding') return null;
      return '/sign-in';

    case AppStatus.authenticated:
      if (isAuthRoute || loc == '/onboarding') return '/home';
      return null;
  }
}
```

### 3.3 Edge Cases

| Skenario | Perilaku | Kode |
|---|---|---|
| User buka `/home` tanpa login | Redirect ke `/sign-in` | `unauthenticated` |
| User sudah login buka `/sign-in` | Redirect ke `/home` | `authenticated` + authRoute |
| User selesai onboarding | `AppServices.completeOnboarding()` → `unauthenticated` → otomatis redirect ke `/sign-in` | `completeOnboarding()` |
| User tap logout | `AppServices.logout()` → `unauthenticated` → redirect `/sign-in` | `logout()` |
| Token expired di tengah session | ApiException(401) → global handler → `AppServices.logout()` → redirect `/sign-in` | Error handler |
| User buka deep link tanpa login | Simpan intended route di state → setelah login → redirect ke intended route | Pending redirect |
| Koneksi offline saat launch | `/no-internet` (include di publicRoutes) | `publicRoutes` |

---

## 4. Navigation Flow Diagram

### 4.1 Complete Navigation Map

```mermaid
graph TD
    %% PRE-AUTH
    APP([App Launch]) --> ONB[/onboarding]

    %% AUTH FORK
    ONB --> SIGNIN[/sign-in]
    ONB --> SIGNUP[/sign-up]

    SIGNIN -->|forgot password| FP[/sign-in/forgot-password]
    FP -->|reset sukses| SIGNIN

    SIGNUP --> CP[/sign-up/create-profile]
    CP -->|profil selesai| SHELL

    SIGNIN -->|login sukses| SHELL

    %% SHELL
    subgraph SHELL [StatefulShellRoute]
        direction TB
        NAV[BottomNavigationBar]
        H[/home] --> |search bar| DS[/doctor/search]
        L[/loc] --> |tap card| DD
        BH[/booking-history] --> BD[/booking-history/:id]
        P[/profile] --> PE[/profile/edit]
        P --> PF[/profile/favorite]
        P --> PN[/profile/notification]
        P --> PS[/profile/settings]
        P --> PH[/profile/help]
        P --> PT[/profile/tnc]
    end

    %% STACK
    DS -->|tap card| DD[/doctor/:doctorId]
    DD -->|book| BA[/booking/:doctorId]
    BA -->|sukses| BS[/booking/success]
    BS --> H

    DD -->|cancel| BH

    BD -->|cancel| BD

    %% LOGOUT
    P -->|logout| SIGNIN

    %% NO INTERNET
    ONB -.->|offline| NI[/no-internet]
    SIGNIN -.->|offline| NI
    H -.->|offline| NI
    DS -.->|offline| NI
```

### 4.2 Navigasi Horizontal (Tab Switching)

```
User di /loc (tab 1)
  → tap tab "Home" → navigationShell.goBranch(0) → /home
  → tap tab "History" → navigationShell.goBranch(2) → /booking-history
  → tap tab "Profile" → navigationShell.goBranch(3) → /profile
```

### 4.3 Navigasi Stack (Push)

```
User di /home (tab 0)
  → tap search bar → context.push('/doctor/search') → AppShell.body = DoctorSearchPage
  → tap doctor card → context.push('/doctor/:doctorId') → AppShell.body = DoctorDetailPage
  → tap "Book" → context.push('/booking/:doctorId') → AppShell.body = BookAppointmentPage
  → booking success → context.push('/booking/success') → AppShell.body = BookingSuccessPage
  → tap "Kembali" → context.go('/home') → AppShell.body = HomePage (shell restore)

Stack visual:
  /home → /doctor/search → /doctor/:id → /booking/:id → /booking/success
  ↓ pop all                                        ↓ go('/home') = clear stack
```

---

## 5. Deep Link Handling

### 5.1 Supported Deep Links (v1.0)

| Deep Link | Tujuan | Skenario |
|---|---|---|
| `healthpal://doctor/:doctorId` | DoctorDetailPage | Tap link dari notifikasi |
| `healthpal://booking-history/:appointmentId` | BookingDetailPage | Tap reminder notifikasi |
| `healthpal://home` | HomePage | Universal link |

### 5.2 Konfigurasi GoRouter

```dart
GoRouter(
  initialLocation: '/onboarding',
  refreshListenable: _appServices,
  redirect: ...,
  routes: ...,

  // Deep link config
  initialExtra: null,

  // Handler untuk deep link
  debugLogDiagnostics: true,
);
```

### 5.3 Konfigurasi Platform

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="healthpal" />
</intent-filter>
```

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>healthpal</string>
    </array>
  </dict>
</array>
```

### 5.4 Notification Tap → Navigasi

FCM notification → Flutter `onMessageOpenedApp` → navigasi:

```dart
// lib/core/services/notification_service.dart
class NotificationService {
  void handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final appointmentId = data['appointment_id'] as String?;
    final doctorId = data['doctor_id'] as String?;

    switch (type) {
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
}
```

---

## 6. Transition & Animation

### 6.1 Default Transition per Route Category

| Kategori | Transition | Durasi | Curve |
|---|---|---|---|
| Pre-auth routes | `FadeTransition` | 250ms | `easeInOut` |
| Shell tab switch | Tidak ada (instant) | 0ms | — |
| Stack push | `SlideTransition` (right → left) | 300ms | `fastOutSlowIn` |
| Stack pop | `SlideTransition` (left → right) | 300ms | `fastOutSlowIn` |
| Modal bottom sheet | `VerticalSlide` | 300ms | `easeOut` |

### 6.2 Custom Transition Builder

```dart
GoRouter(
  routes: [
    GoRoute(
      path: '/doctor/:doctorId',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: DoctorDetailPage(doctorId: state.pathParameters['doctorId']!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            )),
            child: child,
          );
        },
      ),
    ),
  ],
);
```

> **Catatan:** Untuk MVP, semua stack route bisa pakai default Material fade transition. Custom slide transition bisa ditambahkan di fase polish.

---

## 7. Error Routing

### 7.1 Not Found (404)

```dart
GoRouter(
  routes: [...],
  errorBuilder: (context, state) {
    return NotFoundPage(
      message: 'Halaman ${state.uri.path} tidak ditemukan',
    );
  },
);
```

`NotFoundPage` akan muncul jika:
- Route path tidak cocok dengan definisi mana pun
- User akses link invalid

### 7.2 No Internet Route

`/no-internet` didaftarkan sebagai **top-level route** (bukan di dalam shell) agar bisa diakses dari mana saja:

```dart
GoRoute(
  path: '/no-internet',
  name: 'noInternet',
  builder: (_, __) => const NoInternetPage(),
);
```

Navigasi ke `/no-internet`:
- **Splash/pre-auth:** `context.go('/no-internet')` — full screen replacement
- **Di dalam app:** Snackbar saja (tanpa navigasi) — lebih baik UX

### 8.2 Full Code

```dart
// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppRouter {
  final AppServices _appServices;

  AppRouter(this._appServices);

  late final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: _appServices,

    redirect: (context, state) {
      final status = _appServices.status;
      final loc = state.uri.path;

      final publicRoutes = <String>{
        '/onboarding', '/sign-in', '/no-internet',
      };
      final isPublicRoute = publicRoutes.any((r) => loc.startsWith(r));
      final isAuthRoute = loc.startsWith('/sign-in') || loc.startsWith('/sign-up');

      switch (status) {
        case AppStatus.loading:
          return null;
        case AppStatus.onboarding:
          return loc == '/onboarding' ? null : '/onboarding';
        case AppStatus.unauthenticated:
          return (isAuthRoute || loc == '/onboarding') ? null : '/sign-in';
        case AppStatus.authenticated:
          return (isAuthRoute || loc == '/onboarding') ? '/home' : null;
      }
    },

    routes: [
      // ══════════════════════════════════
      // PRE-AUTH
      // ══════════════════════════════════
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'signIn',
        builder: (_, __) => const SignInPage(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            builder: (_, __) => const ForgotPasswordPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/sign-up',
        name: 'signUp',
        builder: (_, __) => const SignUpPage(),
        routes: [
          GoRoute(
            path: 'create-profile',
            name: 'createProfile',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>?;
              return CreateProfilePage(
                email: data?['email'] ?? '',
                password: data?['password'] ?? '',
                fullname: data?['name'] ?? '',
              );
            },
          ),
        ],
      ),

      // ══════════════════════════════════
      // MAIN SHELL
      // ══════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppShell(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', name: 'home', builder: (_, __) => const HomePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/loc', name: 'locationSearch', builder: (_, __) => const LocPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/booking-history', name: 'bookingHistory', builder: (_, __) => const BookingHistoryPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/profile', name: 'profile', builder: (_, __) => const ProfilePage()),
            ],
          ),
        ],
      ),

      // ══════════════════════════════════
      // STACK — DOCTOR
      // ══════════════════════════════════
      GoRoute(
        path: '/doctor/search',
        name: 'doctorSearch',
        builder: (_, __) => const DoctorSearchPage(),
      ),
      GoRoute(
        path: '/doctor/:doctorId',
        name: 'doctorDetail',
        builder: (_, state) => DoctorDetailPage(
          doctorId: state.pathParameters['doctorId']!,
        ),
      ),

      // ══════════════════════════════════
      // STACK — BOOKING
      // ══════════════════════════════════
      GoRoute(
        path: '/booking/:doctorId',
        name: 'bookAppointment',
        builder: (_, state) => BookAppointmentPage(
          doctorId: state.pathParameters['doctorId']!,
        ),
      ),
      GoRoute(
        path: '/booking/success',
        name: 'bookingSuccess',
        builder: (_, __) => const BookingSuccessPage(),
      ),
      GoRoute(
        path: '/booking-history/:appointmentId',
        name: 'bookingDetail',
        builder: (_, state) => BookingDetailPage(
          appointmentId: state.pathParameters['appointmentId']!,
        ),
      ),

      // ══════════════════════════════════
      // STACK — PROFILE
      // ══════════════════════════════════
      GoRoute(path: '/profile/edit', name: 'editProfile', builder: (_, __) => const EditProfilePage()),
      GoRoute(path: '/profile/favorite', name: 'favorite', builder: (_, __) => const FavoritePage()),
      GoRoute(path: '/profile/notification', name: 'notification', builder: (_, __) => const NotificationPage()),
      GoRoute(path: '/profile/settings', name: 'settings', builder: (_, __) => const SettingsPage()),
      GoRoute(path: '/profile/help', name: 'helpSupport', builder: (_, __) => const HelpSupportPage()),
      GoRoute(path: '/profile/tnc', name: 'termsAndConditions', builder: (_, __) => const TermsAndConditionsPage()),

      // ══════════════════════════════════
      // STACK — UTILITY
      // ══════════════════════════════════
      GoRoute(path: '/no-internet', name: 'noInternet', builder: (_, __) => const NoInternetPage()),
    ],

    errorBuilder: (context, state) => NotFoundPage(
      message: 'Halaman ${state.uri.path} tidak ditemukan',
    ),
  );
}
```

---

## Summary Routing Table

| Path | Name | Type | Auth | Parent | Bottom Nav |
|---|---|---|---|---|---|
| `/onboarding` | onboarding | Pre-auth | ❌ | — | — |
| `/sign-in` | signIn | Pre-auth | ❌ | — | — |
| `/sign-in/forgot-password` | forgotPassword | Pre-auth (nested) | ❌ | signIn | — |
| `/sign-up` | signUp | Pre-auth | ❌ | — | — |
| `/sign-up/create-profile` | createProfile | Pre-auth (nested) | ❌ | signUp | — |
| `/home` | home | Shell (tab 0) | ✅ | shell | ✅ |
| `/loc` | locationSearch | Shell (tab 1) | ✅ | shell | ✅ |
| `/booking-history` | bookingHistory | Shell (tab 2) | ✅ | shell | ✅ |
| `/profile` | profile | Shell (tab 3) | ✅ | shell | ✅ |
| `/doctor/search` | doctorSearch | Stack | ✅ | — | ❌ |
| `/doctor/:doctorId` | doctorDetail | Stack | ✅ | — | ❌ |
| `/booking/:doctorId` | bookAppointment | Stack | ✅ | — | ❌ |
| `/booking/success` | bookingSuccess | Stack | ✅ | — | ❌ |
| `/booking-history/:id` | bookingDetail | Stack | ✅ | — | ❌ |
| `/profile/edit` | editProfile | Stack | ✅ | — | ❌ |
| `/profile/favorite` | favorite | Stack | ✅ | — | ❌ |
| `/profile/notification` | notification | Stack | ✅ | — | ❌ |
| `/profile/settings` | settings | Stack | ✅ | — | ❌ |
| `/profile/help` | helpSupport | Stack | ✅ | — | ❌ |
| `/profile/tnc` | termsAndConditions | Stack | ✅ | — | ❌ |
| `/no-internet` | noInternet | Stack | ❌ | — | ❌ |

---

*Dokumen ini adalah living document. Setiap perubahan routing harus di-update di sini sebelum implementasi.*
