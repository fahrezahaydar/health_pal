# Technical Design Document — Bagian 8: Caching Strategy

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Storage** | SharedPreferences (MVP), Hive (v2.0) |

---

## Daftar Isi

1. [Caching Philosophy](#1-caching-philosophy)
2. [Cache Matrix](#2-cache-matrix)
3. [Cache Implementation](#3-cache-implementation)
4. [Cache Invalidation](#4-cache-invalidation)
5. [Offline Behavior](#5-offline-behavior)

---

## 1. Caching Philosophy

```
MVP (v1.0): SharedPreferences untuk cache ringan (JSON string).
v2.0: Migrasi ke Hive untuk cache kompleks.
```

**Prinsip:**
- Cache hanya untuk data yang **jarang berubah** (spesialisasi, banner)
- Data yang **real-time** (slot, booking) tidak di-cache, selalu remote
- Cache digunakan sebagai **fallback** saat offline, bukan primary source

---

## 2. Cache Matrix

| Data | Cache? | Durasi | Storage | Update Trigger |
|---|---|---|---|---|
| Onboarding status | ✅ | Permanent | SharedPref | Selesai onboarding |
| Auth session | ✅ | Until expiry | Supabase SDK | Login/logout |
| User profile | ✅ | Session | SharedPref | Login & edit profil |
| Specializations | ✅ | 7 hari | SharedPref (JSON) | Pull to refresh |
| Banners | ✅ | 5 menit | SharedPref (JSON) | Pull to refresh |
| Recent searches | ✅ | Session | SharedPref | Tap search |
| Doctor list | ❌ | — | — | — |
| Doctor slots | ❌ | — | — | — |
| Appointments | ❌ | — | — | — |

---

## 3. Cache Implementation

```dart
// lib/core/services/cache_service.dart
@lazySingleton
class CacheService {
  final SharedPreferences _prefs;

  CacheService(this._prefs);

  // ── Generic ──
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<void> setJson(String key, Map<String, dynamic> json) =>
      _prefs.setString(key, jsonEncode(json));

  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    return raw != null ? jsonDecode(raw) as Map<String, dynamic> : null;
  }

  Future<void> setJsonList(String key, List<Map<String, dynamic>> list) =>
      _prefs.setString(key, jsonEncode(list));

  List<Map<String, dynamic>>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  // ── TTL ──
  bool isExpired(String key, Duration maxAge) {
    final savedAt = _prefs.getString('${key}_saved_at');
    if (savedAt == null) return true;
    final savedTime = DateTime.parse(savedAt);
    return DateTime.now().difference(savedTime) > maxAge;
  }

  Future<void> setWithTtl(String key, String value, Duration maxAge) async {
    await _prefs.setString(key, value);
    await _prefs.setString('${key}_saved_at', DateTime.now().toIso8601String());
  }
}
```

---

## 4. Cache Invalidation

| Event | Invalidate |
|---|---|
| User logout | All user data, session |
| User edit profile | Profile cache |
| Pull to refresh di Home | Banners cache |
| Pull to refresh di Loc | — |
| Booking berhasil | Upcoming cache |
| Appointment dibatalkan | Upcoming cache |

```dart
Future<void> clearUserCache() async {
  final keys = _prefs.getKeys().where((k) =>
    k.startsWith('profile_') ||
    k.startsWith('banners_') ||
    k.startsWith('upcoming_')
  );
  for (final key in keys) {
    await _prefs.remove(key);
  }
}
```

---

## 5. Offline Behavior

| Skenario | Perilaku | UI Indikator |
|---|---|---|
| Home: offline | Tampilkan banner + upcoming dari cache | Banner "Data mungkin tidak terbaru" |
| Search: offline | Snackbar error, tidak ada hasil | Snackbar "Periksa koneksi" |
| Booking: offline | Snackbar error, form tetap | Snackbar "Periksa koneksi" |
| Booking History: offline | Tampilkan cache (jika ada) | Banner "Data mungkin tidak terbaru" |
| Auth: offline | Tidak bisa login/register | Snackbar "Periksa koneksi" |

```dart
// connectivity_plus listener di AppServices
void _initConnectivityListener() {
  Connectivity().onConnectivityChanged.listen((result) {
    final isOnline = result != ConnectivityResult.none;
    _isOnline = isOnline;
    notifyListeners();  // GoRouter tidak redirect, UI yang adjust
  });
}
```
