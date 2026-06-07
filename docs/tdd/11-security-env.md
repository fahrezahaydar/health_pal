# Technical Design Document — Bagian 11: Security & Environment

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Acuan** | BRD, ERD RLS Policy |

---

## Daftar Isi

1. [Environment Variables](#1-environment-variables)
2. [Supabase Security (RLS)](#2-supabase-security-rls)
3. [Data Encryption](#3-data-encryption)
4. [Secure Storage](#4-secure-storage)
5. [API Key Management](#5-api-key-management)
6. [Audit & Logging](#6-audit--logging)

---

## 1. Environment Variables

### 1.1 File `.env`

```
# ─── Supabase ───
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...

# ─── Firebase ───
FIREBASE_API_KEY=...
FIREBASE_PROJECT_ID=...
FIREBASE_APP_ID=...

# ─── App Config ───
APP_NAME=health_pal
APP_VERSION=v1.0.0
```

### 1.2 Loading di Flutter

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  configureDependencies();
  final appServices = getIt<AppServices>();
  await appServices.init();
  runApp(const HealthPalApp());
}
```

### 1.3 Aturan

- `.env` **TIDAK** di-commit ke git (masuk `.gitignore`)
- Template `.env.example` di-commit (berisi placeholder)
- Semua akses environment via `dotenv.env['KEY']!`
- Crash jika key tidak ada (fail fast di development)

---

## 2. Supabase Security (RLS)

### 2.1 Policy per Tabel (dari ERD)

| Tabel | Policy | Rule |
|---|---|---|
| `user_profiles` | SELECT, UPDATE | `auth.uid() = auth_id` |
| `user_fcm_tokens` | ALL | `auth.uid() = (SELECT auth_id FROM user_profiles WHERE id = user_id)` |
| `appointments` | SELECT, INSERT | `auth.uid() = (SELECT auth_id FROM user_profiles WHERE id = patient_id)` |
| `appointments` | UPDATE (cancel) | Hanya kolom `status`, `cancelled_at`; status harus `pending` atau `upcoming` |
| `doctor_slots` | SELECT | Public (semua user bisa lihat) |
| `doctors` | SELECT | Public |
| `clinics` | SELECT | Public |
| `specializations` | SELECT | Public |
| `banners` | SELECT | Public, dengan filter `is_active = true AND ...` |
| `notifications` | SELECT, UPDATE | `auth.uid() = (SELECT auth_id FROM user_profiles WHERE id = user_id)` |

### 2.2 Flutter-side RLS Enforcement

```dart
// Flutter TIDAK bisa bypass RLS — semua query via SupabaseClient
// otomatis menyertakan token JWT user yang login.

// Contoh: query appointment user sendiri
final appointments = await supabase
  .from('appointments')
  .select('*, doctors(*), doctor_slots(*)')
  .eq('patient_id', profileId)       // ← filter client-side
  .order('created_at', ascending: false);

// RLS di server juga memvalidasi:
//   auth.uid() = (SELECT auth_id FROM user_profiles WHERE id = patient_id)
// Jadi meskipun client ganti patient_id di query, RLS tetap tolak.
```

---

## 3. Data Encryption

### 3.1 In Transit

- Semua koneksi Supabase via HTTPS (TLS 1.3)
- FCM via encrypted channel (Google infrastructure)
- Tidak ada plain HTTP

### 3.2 At Rest (Flutter-side)

| Data | Storage | Protection |
|---|---|---|
| Auth session | Supabase SDK internal | Secure storage (encrypted) |
| JWT token | Supabase SDK internal | SDK handle sendiri |
| User profile (cache) | SharedPreferences | **Tidak dienkripsi** (MVP) |
| FCM token | SharedPreferences | **Tidak dienkripsi** (MVP) |
| Sensitive data (DOB, gender) | Remote only | Tidak di-cache di device |

### 3.3 Future Encryption (v2.0)

```yaml
# flutter_secure_storage untuk token sensitif
flutter_secure_storage: ^9.0.0
```

```dart
// Penyimpanan token di encrypted storage
final storage = FlutterSecureStorage();
await storage.write(key: 'session_token', value: token);
```

---

## 4. Secure Storage

### 4.1 Saat Ini (MVP)

| Storage | Package | Keamanan |
|---|---|---|
| SharedPreferences | `shared_preferences` | Plain text |
| Supabase Auth session | SDK internal (SecureStorage) | ✅ Encrypted |

### 4.2 Target (v2.0)

```yaml
flutter_secure_storage: ^9.0.0   # Android EncryptedSharedPreferences, iOS Keychain
```

| Data | Pindah ke? | Alasan |
|---|---|---|
| FCM tokens | FlutterSecureStorage | Token bisa dipakai spam |
| User profile cache | FlutterSecureStorage | DOB, gender termasuk data pribadi |

---

## 5. API Key Management

### 5.1 Supabase Anon Key

- Disimpan di `.env` (tidak di-commit)
- Di-load via `flutter_dotenv`
- **Bukan rahasia** (anon key = public key, safe di client)
- Yang penting adalah RLS di server (bukan anon key)

### 5.2 Firebase Keys

- Disimpan di `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS)
- File-file ini masuk `.gitignore` atau di-encrypt
- Firebase App Check untuk proteksi tambahan (v2.0)

---

## 6. Audit & Logging

### 6.1 Flutter-side

```dart
// Hanya log di development
class AppLogger {
  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO] $message');
  }

  static void error(String message, [Object? error]) {
    if (kDebugMode) debugPrint('[ERROR] $message $error');
    // v2.0: kirim ke Sentry / Firebase Crashlytics
  }
}
```

### 6.2 Supabase-side

Semua operasi database sudah di-log oleh Supabase secara otomatis (PostgreSQL logs). Untuk audit tambahan (v2.0):

- Trigger `appointments` → insert ke `audit_logs` table
- Capture: siapa, apa, kapan (auth.uid())
- Log login attempt (dari Supabase Auth logs)

---

## 7. Checklist Keamanan

```
[ ] Supabase RLS diaktifkan di semua tabel
[ ] .env tidak di-commit ke git
[ ] google-services.json di .gitignore
[ ] GoogleService-Info.plist di .gitignore
[ ] Tidak ada hardcode API key di source code
[ ] Semua query via SupabaseClient (bukan HTTP raw)
[ ] Input user di-validasi client-side + server-side
[ ] JWT expired → auto logout
[ ] Error message tidak expose detail teknis
[ ] kDebugMode guard di semua log
```
