# API Contract — REST API Specifications
## health_pal — Doctor Appointment Mobile Application

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Backend** | Supabase (PostgreSQL + PostgREST + Edge Functions) |
| **Base URL** | `https://<project-ref>.supabase.co` |
| **API Version** | v1 |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Dibuat oleh** | Senior Backend Engineer & API Architect |

---

## Daftar Isi

1. [Konvensi & Standar Global](#1-konvensi--standar-global)
2. [Auth Endpoints](#2-auth-endpoints)
   - 2.1 Register dengan Email & Password
   - 2.2 Login dengan Email & Password
   - 2.3 Login dengan Google OAuth
   - 2.4 Logout
   - 2.5 Refresh Token
   - 2.6 Forgot Password
3. [Profile Endpoints](#3-profile-endpoints)
   - 3.1 Get Profile Saya
   - 3.2 Setup / Update Profile
   - 3.3 Upload Avatar
   - 3.4 Upsert FCM Token
4. [Specialization Endpoints](#4-specialization-endpoints)
   - 4.1 Get All Specializations
5. [Doctor Endpoints](#5-doctor-endpoints)
   - 5.1 Search Dokter
   - 5.2 Get Dokter by Location (Radius)
   - 5.3 Get Detail Dokter
   - 5.4 Get Slot Tersedia
6. [Appointment Endpoints](#6-appointment-endpoints)
   - 6.1 Create Appointment (Booking)
   - 6.2 Get Booking History
   - 6.3 Get Detail Appointment
   - 6.4 Cancel Appointment
7. [Banner Endpoints](#7-banner-endpoints)
   - 7.1 Get Active Banners
8. [Notification Endpoints](#8-notification-endpoints)
   - 8.1 Get Notifications
   - 8.2 Mark Notification as Read
9. [Error Response Catalog](#9-error-response-catalog)

---

## 1. Konvensi & Standar Global

### Base URLs

| Tipe | URL |
|---|---|
| **PostgREST (CRUD langsung)** | `https://<ref>.supabase.co/rest/v1` |
| **Edge Functions (custom logic)** | `https://<ref>.supabase.co/functions/v1` |
| **Auth** | `https://<ref>.supabase.co/auth/v1` |
| **Storage** | `https://<ref>.supabase.co/storage/v1` |

### Standard Headers

```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>              ← wajib di semua request
Authorization: Bearer <access_token>    ← wajib untuk endpoint yang butuh auth
```

> **Catatan Flutter:** `SUPABASE_ANON_KEY` disimpan di `.env` dan di-load via `flutter_dotenv`. Jangan hardcode di source code.

### Format Key JSON

Seluruh request body dan response menggunakan **`snake_case`** — konsisten dengan nama kolom PostgreSQL dan Dart convention saat menggunakan `fromJson` factory.

### Standard Response Envelope

Semua Edge Function custom menggunakan envelope berikut:

**Success:**
```json
{
  "success": true,
  "data": { ... },
  "message": "Operasi berhasil"
}
```

**Error:**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Pesan error yang dapat ditampilkan ke user"
  }
}
```

> **Catatan:** Endpoint PostgREST langsung (non-Edge Function) mengembalikan format standar PostgREST (array atau object JSON tanpa envelope). Ini akan dicatat per endpoint.

### Status HTTP yang Digunakan

| Code | Makna |
|---|---|
| `200` | OK — GET berhasil |
| `201` | Created — POST berhasil membuat resource |
| `204` | No Content — DELETE / operasi tanpa response body |
| `400` | Bad Request — validasi gagal / request tidak valid |
| `401` | Unauthorized — token tidak ada atau expired |
| `403` | Forbidden — token valid tapi tidak punya akses |
| `404` | Not Found — resource tidak ditemukan |
| `409` | Conflict — duplikat data (contoh: slot sudah dibooking) |
| `422` | Unprocessable Entity — data valid secara format tapi gagal diproses |
| `500` | Internal Server Error — error di sisi server |

---

## 2. Auth Endpoints

Base path: `https://<ref>.supabase.co/auth/v1`

---

### 2.1 Register dengan Email & Password

```
POST /auth/v1/signup
```

**Description:** Mendaftarkan user baru dengan email dan password. Supabase akan mengirimkan email verifikasi secara otomatis.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
```

**Request Body:**
```json
{
  "email": "rina@example.com",
  "password": "Passw0rd!",
  "data": {
    "full_name": "Rina Kartika"
  }
}
```

**Success Response `201`:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "expires_at": 1751234567,
  "refresh_token": "v1.refresh_token_string_here",
  "user": {
    "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "email": "rina@example.com",
    "email_confirmed_at": null,
    "created_at": "2026-06-07T10:00:00.000Z",
    "app_metadata": {
      "provider": "email"
    },
    "user_metadata": {
      "full_name": "Rina Kartika"
    }
  }
}
```

**Error Responses:**

`400` — Email sudah terdaftar:
```json
{
  "code": 400,
  "error_code": "user_already_exists",
  "msg": "User already registered"
}
```

`422` — Format email tidak valid atau password terlalu pendek:
```json
{
  "code": 422,
  "error_code": "validation_failed",
  "msg": "Password should be at least 8 characters"
}
```

---

### 2.2 Login dengan Email & Password

```
POST /auth/v1/token?grant_type=password
```

**Description:** Login user yang sudah terdaftar menggunakan email dan password. Setelah login sukses, **wajib panggil `GET /rest/v1/me`** (lihat §3.5) untuk mengambil `is_profile_complete` sebelum routing ke `/home` atau `/sign-up/create-profile`.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
```

**Request Body:**
```json
{
  "email": "rina@example.com",
  "password": "Passw0rd!"
}
```

**Success Response `200`:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "expires_at": 1751234567,
  "refresh_token": "v1.refresh_token_string_here",
  "user": {
    "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "email": "rina@example.com",
    "email_confirmed_at": "2026-06-07T10:05:00.000Z",
    "created_at": "2026-06-07T10:00:00.000Z",
    "app_metadata": {
      "provider": "email"
    }
  }
}
```

> **Catatan Flutter:** Response di atas **TIDAK** berisi `is_profile_complete`. Setelah menerima `access_token`, panggil `GET /rest/v1/me?select=*` (lihat §3.5) untuk mendapatkan profil lengkap termasuk `is_profile_complete`. Field ini krusial untuk routing decision: `true` → `/home`, `false` → `/sign-up/create-profile`.

**Error Responses:**

`400` — Email atau password salah:
```json
{
  "code": 400,
  "error_code": "invalid_credentials",
  "msg": "Invalid login credentials"
}
```

`400` — Email belum diverifikasi:
```json
{
  "code": 400,
  "error_code": "email_not_confirmed",
  "msg": "Email not confirmed"
}
```

---

### 2.3 Login dengan Google OAuth

```
GET /auth/v1/authorize?provider=google&redirect_to=<deep_link>
```

**Description:** Menginisiasi flow OAuth Google. Di Flutter, proses ini ditangani oleh `supabase_flutter` SDK via `signInWithOAuth(OAuthProvider.google)`. Endpoint ini didokumentasikan sebagai referensi internal.

**Flow:**
1. Flutter memanggil `supabase.auth.signInWithOAuth(OAuthProvider.google)`
2. SDK membuka browser / in-app browser ke URL ini
3. Setelah Google auth selesai, Supabase redirect ke `redirect_to` (deep link app)
4. Flutter menerima session dari deep link callback

**Success:** Session tersimpan otomatis oleh Supabase Flutter SDK. Response sama dengan format di 2.2.

---

### 2.4 Logout

```
POST /auth/v1/logout
```

**Description:** Menginvalidasi session aktif dan refresh token user.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Request Body:** *(kosong)*

**Success Response `204`:** *(No Content)*

**Error Responses:**

`401` — Token tidak valid atau sudah expired:
```json
{
  "code": 401,
  "error_code": "not_authenticated",
  "msg": "User not authenticated"
}
```

---

### 2.5 Refresh Token

```
POST /auth/v1/token?grant_type=refresh_token
```

**Description:** Memperbarui `access_token` yang sudah expired menggunakan `refresh_token`. Biasanya ditangani otomatis oleh Supabase Flutter SDK.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
```

**Request Body:**
```json
{
  "refresh_token": "v1.refresh_token_string_here"
}
```

**Success Response `200`:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.new_token...",
  "token_type": "bearer",
  "expires_in": 3600,
  "expires_at": 1751238167,
  "refresh_token": "v1.new_refresh_token_here",
  "user": {
    "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "email": "rina@example.com"
  }
}
```

**Error Responses:**

`400` — Refresh token tidak valid atau sudah digunakan:
```json
{
  "code": 400,
  "error_code": "refresh_token_not_found",
  "msg": "Invalid Refresh Token: Already Used"
}
```

---

### 2.6 Forgot Password

```
POST /auth/v1/recover
```

**Description:** Mengirimkan email reset password ke alamat yang terdaftar.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
```

**Request Body:**
```json
{
  "email": "rina@example.com"
}
```

**Success Response `200`:** *(Supabase selalu return 200 meski email tidak ditemukan — demi keamanan)*
```json
{}
```

---

## 3. Profile Endpoints

Base path: `https://<ref>.supabase.co/rest/v1` (PostgREST)

---

### 3.1 Get Profile Saya

```
GET /rest/v1/user_profiles?auth_id=eq.<auth_uid>&select=*
```

**Description:** Mengambil data profil user yang sedang login. Digunakan saat app launch untuk cek `is_profile_complete` dan populate data home screen.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Query Params:**
| Param | Value | Keterangan |
|---|---|---|
| `auth_id` | `eq.<auth_uid>` | Filter berdasarkan auth UID user yang login |
| `select` | `*` | Ambil semua kolom |

**Success Response `200`:**
```json
[
  {
    "id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "auth_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "full_name": "Rina Kartika",
    "nickname": "Rina",
    "avatar_url": "https://<ref>.supabase.co/storage/v1/object/public/avatars/rina.jpg",
    "date_of_birth": "1998-03-15",
    "gender": "female",
    "notif_reminder_enabled": true,
    "is_profile_complete": true,
    "created_at": "2026-06-07T10:00:00.000Z",
    "updated_at": "2026-06-07T10:15:00.000Z"
  }
]
```

> **Catatan Flutter:** Response adalah array. Ambil elemen index `[0]`. Jika array kosong → user perlu setup profil (onboarding).

**Error Responses:**

`401` — Token tidak ada atau expired:
```json
{
  "code": 401,
  "message": "JWT expired"
}
```

---

### 3.2 Setup / Update Profile

```
POST /rest/v1/user_profiles
```
*(Untuk insert pertama kali — onboarding)*

```
PATCH /rest/v1/user_profiles?auth_id=eq.<auth_uid>
```
*(Untuk update profil yang sudah ada)*

**Description:**
- `POST` — Dipanggil sekali setelah register, saat user selesai mengisi form onboarding.
- `PATCH` — Dipanggil dari halaman Edit Profile.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
Prefer: return=representation    ← agar response mengembalikan data yang baru di-upsert
```

**Request Body (POST — Onboarding):**
```json
{
  "auth_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "full_name": "Rina Kartika",
  "nickname": "Rina",
  "date_of_birth": "1998-03-15",
  "gender": "female",
  "is_profile_complete": true
}
```

**Request Body (PATCH — Edit Profile):**
```json
{
  "full_name": "Rina Kartika Dewi",
  "nickname": "Rina",
  "date_of_birth": "1998-03-15",
  "gender": "female",
  "notif_reminder_enabled": false
}
```

**Success Response `201` (POST) / `200` (PATCH):**
```json
[
  {
    "id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "auth_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "full_name": "Rina Kartika Dewi",
    "nickname": "Rina",
    "avatar_url": null,
    "date_of_birth": "1998-03-15",
    "gender": "female",
    "notif_reminder_enabled": false,
    "is_profile_complete": true,
    "created_at": "2026-06-07T10:00:00.000Z",
    "updated_at": "2026-06-07T11:00:00.000Z"
  }
]
```

**Error Responses:**

`400` — Constraint violation (contoh: gender value tidak valid):
```json
{
  "code": "23514",
  "details": null,
  "hint": null,
  "message": "new row for relation \"user_profiles\" violates check constraint"
}
```

`401`:
```json
{ "code": 401, "message": "JWT expired" }
```

---

### 3.3 Upload Avatar

```
POST /storage/v1/object/avatars/<user_id>/<filename>
```

**Description:** Upload foto profil user ke Supabase Storage bucket `avatars`. Setelah upload berhasil, URL publik di-PATCH ke `user_profiles.avatar_url`.

**Headers:**
```
Content-Type: image/jpeg        ← atau image/png sesuai file
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Request Body:** Binary file (multipart/form-data dari Flutter `File` object)

**Success Response `200`:**
```json
{
  "Key": "avatars/p1q2r3s4-t5u6-7890-vwxy-z12345678901/profile.jpg"
}
```

**Public URL format setelah upload:**
```
https://<ref>.supabase.co/storage/v1/object/public/avatars/<user_id>/<filename>
```

**Error Responses:**

`400` — File terlalu besar (default limit Supabase 5MB):
```json
{
  "error": "Payload too large",
  "message": "The object exceeded the maximum allowed size"
}
```

`401`:
```json
{ "error": "Invalid JWT" }
```

---

### 3.4 Upsert FCM Token

```
POST /functions/v1/upsert-fcm-token
```

**Description:** Menyimpan atau memperbarui FCM token device user. Dipanggil setiap kali user berhasil login. Menggunakan Edge Function karena logic upsert berdasarkan `(user_id, platform)` lebih clean ditangani server-side.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "fcm_token": "dGhpcyBpcyBhIHNhbXBsZSBGQ00gdG9rZW4...",
  "platform": "android"
}
```

**Success Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "f1a2b3c4-d5e6-7890-fghi-j12345678901",
    "user_id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "fcm_token": "dGhpcyBpcyBhIHNhbXBsZSBGQ00gdG9rZW4...",
    "platform": "android",
    "updated_at": "2026-06-07T10:01:00.000Z"
  },
  "message": "FCM token berhasil disimpan"
}
```

**Error Responses:**

`400` — Platform tidak valid:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_PLATFORM",
    "message": "Platform harus 'android' atau 'ios'"
  }
}
```

`401`:
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Token tidak valid atau sudah expired"
  }
}
```

---

### 3.5 Get My Profile (Current User via `/me`)

```
GET /rest/v1/me?select=*
```

**Description:** Mengambil data profil user yang sedang login secara singkat dan aman via **PostgREST view/alias `/me`**. RLS policy `auth.uid() = auth_id` menjamin user hanya bisa membaca profil miliknya sendiri. Endpoint ini **direkomendasikan** untuk dipanggil segera setelah login/signup (lihat §2.1, §2.2) untuk mengambil `is_profile_complete` — field yang krusial untuk routing decision di User Flow 4.1 (`/home` vs `/sign-up/create-profile`).

**Cara kerja di PostgREST:**
View `me` adalah wrapper tipis di atas `user_profiles` yang memfilter otomatis berdasarkan `auth.uid()`. Migrasi SQL-nya:
```sql
CREATE VIEW me AS
  SELECT * FROM user_profiles
  WHERE auth_id = auth.uid();

-- Grant akses ke authenticated users
GRANT SELECT ON me TO authenticated;
```

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Query Params:**
| Param | Value | Keterangan |
|---|---|---|
| `select` | `*` | Ambil semua kolom profil |

**Success Response `200`:**
```json
{
  "id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
  "auth_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "full_name": "Rina Kartika",
  "nickname": "Rina",
  "avatar_url": "https://<ref>.supabase.co/storage/v1/object/public/avatars/rina.jpg",
  "date_of_birth": "1998-03-15",
  "gender": "female",
  "notif_reminder_enabled": true,
  "is_profile_complete": true,
  "created_at": "2026-06-07T10:00:00.000Z",
  "updated_at": "2026-06-07T10:15:00.000Z"
}
```

> **Catatan Flutter:** Berbeda dengan §3.1 (`GET /rest/v1/user_profiles?auth_id=eq.<auth_uid>`) yang return **array**, endpoint ini return **object tunggal** (bukan array). Lebih simple untuk di-parse. Gunakan ini di `AppServices.init()` setelah refresh token / session restore.

**Error Responses:**

`401` — Token tidak ada atau expired:
```json
{
  "code": 401,
  "message": "JWT expired"
}
```

`200` dengan `{}` (empty object) — User belum punya profil. Redirect ke `/sign-up/create-profile`.

---

## 4. Specialization Endpoints

---

### 4.1 Get All Specializations

```
GET /rest/v1/specializations?select=*&order=name.asc
```

**Description:** Mengambil semua data spesialisasi dokter. Digunakan untuk filter chips di Loc tab. Data ini jarang berubah — **disarankan di-cache di Flutter** menggunakan `SharedPreferences` atau Hive.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Success Response `200`:**
```json
[
  {
    "id": "s1a2b3c4-d5e6-7890-spec-000000000001",
    "name": "Umum",
    "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/umum.png",
    "created_at": "2026-01-01T00:00:00.000Z"
  },
  {
    "id": "s1a2b3c4-d5e6-7890-spec-000000000002",
    "name": "Anak",
    "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/anak.png",
    "created_at": "2026-01-01T00:00:00.000Z"
  },
  {
    "id": "s1a2b3c4-d5e6-7890-spec-000000000003",
    "name": "Kulit & Kelamin",
    "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/kulit.png",
    "created_at": "2026-01-01T00:00:00.000Z"
  },
  {
    "id": "s1a2b3c4-d5e6-7890-spec-000000000004",
    "name": "Gigi",
    "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/gigi.png",
    "created_at": "2026-01-01T00:00:00.000Z"
  }
]
```

---

## 5. Doctor Endpoints

---

### 5.1 Search Dokter

```
GET /rest/v1/doctors?select=*,clinics(*),specializations(*)&is_active=eq.true&or=(full_name.ilike.*<query>*,specializations.name.ilike.*<query>*)&order=rating_avg.desc
```

**Description:** Full-text search dokter berdasarkan nama dokter atau nama spesialisasi. Digunakan dari search bar di Home dan Loc tab. Query menggunakan PostgREST `ilike` untuk case-insensitive matching.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Query Params:**

| Param | Contoh Value | Keterangan |
|---|---|---|
| `select` | `*,clinics(*),specializations(*)` | Include relasi klinik dan spesialisasi |
| `is_active` | `eq.true` | Hanya dokter aktif |
| `full_name` | `ilike.*joko*` | Search nama dokter (case-insensitive) |
| `specialization_id` | `eq.<uuid>` | Filter by spesialisasi (opsional) |
| `order` | `rating_avg.desc` | Urutkan by rating tertinggi |
| `limit` | `20` | Pagination — default 20 |
| `offset` | `0` | Pagination offset |

**Contoh URL lengkap:**
```
GET /rest/v1/doctors
  ?select=id,full_name,photo_url,experience_years,consultation_fee,rating_avg,rating_count,
          clinics(id,name,city),specializations(id,name,icon_url)
  &is_active=eq.true
  &full_name=ilike.*budi*
  &order=rating_avg.desc
  &limit=20
  &offset=0
```

**Success Response `200`:**
```json
[
  {
    "id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "full_name": "dr. Budi Santoso, Sp.PD",
    "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi.jpg",
    "experience_years": 12,
    "consultation_fee": 150000.00,
    "rating_avg": 4.85,
    "rating_count": 234,
    "clinics": {
      "id": "c1a2b3c4-d5e6-7890-cln1-000000000001",
      "name": "Klinik Sehat Bersama",
      "city": "Bandung"
    },
    "specializations": {
      "id": "s1a2b3c4-d5e6-7890-spec-000000000001",
      "name": "Penyakit Dalam",
      "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/pd.png"
    }
  },
  {
    "id": "d1a2b3c4-e5f6-7890-doc1-000000000002",
    "full_name": "dr. Budi Prasetyo, Sp.A",
    "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi2.jpg",
    "experience_years": 8,
    "consultation_fee": 120000.00,
    "rating_avg": 4.70,
    "rating_count": 189,
    "clinics": {
      "id": "c1a2b3c4-d5e6-7890-cln1-000000000002",
      "name": "RS Mitra Husada",
      "city": "Bandung"
    },
    "specializations": {
      "id": "s1a2b3c4-d5e6-7890-spec-000000000002",
      "name": "Anak",
      "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/anak.png"
    }
  }
]
```

---

### 5.2 Get Dokter by Location (Radius)

```
POST /functions/v1/doctors-by-location
```

**Description:** Mencari dokter terdekat berdasarkan koordinat GPS user. Menggunakan Edge Function karena query radius (Haversine formula via PostGIS) tidak bisa dilakukan langsung via PostgREST URL.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "latitude": -6.9175,
  "longitude": 107.6191,
  "radius_km": 5,
  "specialization_id": "s1a2b3c4-d5e6-7890-spec-000000000002",
  "limit": 20,
  "offset": 0
}
```

| Field | Tipe | Wajib | Keterangan |
|---|---|---|---|
| `latitude` | `float` | Ya | Koordinat user saat ini |
| `longitude` | `float` | Ya | Koordinat user saat ini |
| `radius_km` | `int` | Tidak | Default `5` km |
| `specialization_id` | `string` | Tidak | Filter by spesialisasi |
| `limit` | `int` | Tidak | Default `20` |
| `offset` | `int` | Tidak | Default `0` |

**Success Response `200`:**
```json
{
  "success": true,
  "data": [
    {
      "id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
      "full_name": "dr. Budi Santoso, Sp.PD",
      "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi.jpg",
      "experience_years": 12,
      "consultation_fee": 150000.00,
      "rating_avg": 4.85,
      "rating_count": 234,
      "distance_km": 1.23,
      "clinics": {
        "id": "c1a2b3c4-d5e6-7890-cln1-000000000001",
        "name": "Klinik Sehat Bersama",
        "address": "Jl. Merdeka No. 10, Bandung",
        "city": "Bandung",
        "latitude": -6.9210,
        "longitude": 107.6087
      },
      "specializations": {
        "id": "s1a2b3c4-d5e6-7890-spec-000000000001",
        "name": "Penyakit Dalam",
        "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/pd.png"
      }
    }
  ],
  "meta": {
    "total": 1,
    "limit": 20,
    "offset": 0,
    "radius_km": 5
  }
}
```

**Error Responses:**

`400` — Koordinat tidak disertakan:
```json
{
  "success": false,
  "error": {
    "code": "MISSING_COORDINATES",
    "message": "latitude dan longitude wajib diisi"
  }
}
```

`400` — Radius melebihi batas maksimum:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_RADIUS",
    "message": "Radius maksimum adalah 50 km"
  }
}
```

---

### 5.3 Get Detail Dokter

```
GET /rest/v1/doctors?id=eq.<doctor_id>&select=*,clinics(*),specializations(*)&is_active=eq.true
```

**Description:** Mengambil data lengkap satu dokter beserta informasi klinik dan spesialisasi. Digunakan di halaman Detail Dokter.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Success Response `200`:**
```json
[
  {
    "id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "full_name": "dr. Budi Santoso, Sp.PD",
    "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi.jpg",
    "description": "Dokter spesialis penyakit dalam dengan pengalaman 12 tahun di bidang diabetes dan hipertensi.",
    "experience_years": 12,
    "education": "FK Universitas Padjadjaran (2008), Sp.PD RSUP Dr. Hasan Sadikin (2014)",
    "consultation_fee": 150000.00,
    "rating_avg": 4.85,
    "rating_count": 234,
    "is_active": true,
    "created_at": "2026-01-01T00:00:00.000Z",
    "updated_at": "2026-06-01T00:00:00.000Z",
    "clinics": {
      "id": "c1a2b3c4-d5e6-7890-cln1-000000000001",
      "name": "Klinik Sehat Bersama",
      "address": "Jl. Merdeka No. 10, Bandung",
      "city": "Bandung",
      "latitude": -6.9210,
      "longitude": 107.6087,
      "phone": "022-12345678",
      "image_url": "https://<ref>.supabase.co/storage/v1/object/public/clinics/klinik1.jpg"
    },
    "specializations": {
      "id": "s1a2b3c4-d5e6-7890-spec-000000000001",
      "name": "Penyakit Dalam",
      "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/pd.png"
    }
  }
]
```

**Error Responses:**

`200` dengan array kosong `[]` — Dokter tidak ditemukan atau tidak aktif. Flutter harus handle case ini dan tampilkan halaman 404/error.

---

### 5.4 Get Slot Tersedia

```
GET /rest/v1/doctor_slots
  ?doctor_id=eq.<doctor_id>
  &slot_date=eq.<YYYY-MM-DD>
  &is_booked=eq.false
  &order=slot_start.asc
```

**Description:** Mengambil daftar slot waktu yang tersedia untuk seorang dokter pada tanggal tertentu. Digunakan di Detail Dokter (setelah user memilih tanggal di kalender) dan di Book Appointment screen.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Query Params:**

| Param | Contoh Value | Keterangan |
|---|---|---|
| `doctor_id` | `eq.<uuid>` | ID dokter |
| `slot_date` | `eq.2026-06-15` | Tanggal yang dipilih user (format ISO `YYYY-MM-DD`) |
| `is_booked` | `eq.false` | Hanya slot yang belum dibooking |
| `order` | `slot_start.asc` | Urut dari pagi ke siang |

**Success Response `200`:**
```json
[
  {
    "id": "sl1a2b3c-d4e5-6789-slot-000000000001",
    "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "schedule_id": "sc1a2b3c-d4e5-6789-sch1-000000000001",
    "slot_date": "2026-06-15",
    "slot_start": "09:00:00",
    "slot_end": "09:30:00",
    "is_booked": false,
    "created_at": "2026-06-07T00:00:00.000Z"
  },
  {
    "id": "sl1a2b3c-d4e5-6789-slot-000000000002",
    "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "schedule_id": "sc1a2b3c-d4e5-6789-sch1-000000000001",
    "slot_date": "2026-06-15",
    "slot_start": "09:30:00",
    "slot_end": "10:00:00",
    "is_booked": false,
    "created_at": "2026-06-07T00:00:00.000Z"
  },
  {
    "id": "sl1a2b3c-d4e5-6789-slot-000000000003",
    "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "schedule_id": "sc1a2b3c-d4e5-6789-sch1-000000000001",
    "slot_date": "2026-06-15",
    "slot_start": "10:00:00",
    "slot_end": "10:30:00",
    "is_booked": false,
    "created_at": "2026-06-07T00:00:00.000Z"
  }
]
```

**Error Responses:**

`200` dengan `[]` — Tidak ada slot tersedia pada tanggal tersebut. Flutter tampilkan empty state "Tidak ada jadwal tersedia untuk tanggal ini."

---

### 5.5 Get Nearby Clinics

```
POST /rest/v1/rpc/get_nearby_clinics
```

**Description:** Mengembalikan daftar klinik terdekat dari lokasi user berdasarkan koordinat GPS. Endpoint ini **distinct** dari §5.2 (`doctors-by-location`) — fokus pada **klinik sebagai entitas** (untuk Home Page section "Nearby Medical Centers" di wireframe 06), bukan daftar dokter. Menggunakan PostgreSQL function dengan Haversine formula (lihat ERD §8 untuk definisi function). RLS: public read (tidak perlu auth untuk melihat klinik).

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "user_lat": -6.2088,
  "user_lng": 106.8456,
  "radius_meters": 10000
}
```

| Field | Tipe | Wajib | Default | Keterangan |
|---|---|---|---|---|
| `user_lat` | `float` | Ya | — | Latitude lokasi user |
| `user_lng` | `float` | Ya | — | Longitude lokasi user |
| `radius_meters` | `int` | Tidak | `10000` | Radius pencarian dalam meter (max 50000) |

**Success Response `200`:**
```json
[
  {
    "id": "c1a2b3c4-d5e6-7890-clinic-000000000001",
    "name": "Klinik Sehat Bersama",
    "address": "Jl. Sudirman No. 123, Jakarta Selatan",
    "city": "Jakarta",
    "latitude": -6.2100,
    "longitude": 106.8470,
    "phone": "021-1234567",
    "image_url": "https://<ref>.supabase.co/storage/v1/object/public/clinics/klinik1.jpg",
    "distance_meters": 1200,
    "doctor_count": 5
  }
]
```

| Field | Tipe | Keterangan |
|---|---|---|
| `id` | `string` (UUID) | ID klinik |
| `name` | `string` | Nama klinik |
| `address` | `string` | Alamat lengkap |
| `city` | `string` | Kota |
| `latitude` | `float` | Koordinat lintang |
| `longitude` | `float` | Koordinat bujur |
| `phone` | `string` | Nomor telepon |
| `image_url` | `string?` | URL foto klinik |
| `distance_meters` | `float` | Jarak dari lokasi user (meter) |
| `doctor_count` | `int` | Jumlah dokter aktif di klinik |

**Error Responses:**

`400` — Koordinat tidak disertakan:
```json
{
  "code": "MISSING_COORDINATES",
  "message": "user_lat dan user_lng wajib diisi"
}
```

`400` — Radius melebihi batas:
```json
{
  "code": "INVALID_RADIUS",
  "message": "Radius maksimum adalah 50000 meter (50 km)"
}
```

> **Catatan:** Function `get_nearby_clinics` didefinisikan di ERD §8 dengan signature `(user_lat FLOAT8, user_lng FLOAT8, radius_meters INT DEFAULT 10000)`. Query ini menggunakan Haversine formula di SQL — bukan PostGIS — untuk kompatibilitas lebih luas.

---

## 6. Appointment Endpoints

---

### 6.1 Create Appointment (Booking)

```
POST /functions/v1/create-appointment
```

**Description:** Membuat booking appointment baru. Menggunakan Edge Function (bukan PostgREST langsung) karena proses ini memerlukan **atomic transaction**: (1) cek ulang `is_booked` slot, (2) insert `appointments`, (3) update `doctor_slots.is_booked = true`, (4) trigger notifikasi FCM — semua dalam satu transaksi untuk mencegah race condition double booking.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
  "slot_id": "sl1a2b3c-d4e5-6789-slot-000000000001",
  "complaint_note": "Sudah 3 hari demam dan batuk, disertai sesak napas ringan."
}
```

| Field | Tipe | Wajib | Keterangan |
|---|---|---|---|
| `doctor_id` | `string` (UUID) | Ya | ID dokter yang dipilih |
| `slot_id` | `string` (UUID) | Ya | ID slot waktu yang dipilih |
| `complaint_note` | `string` | Tidak | Keluhan pasien, maks. 300 karakter |

**Success Response `201`:**
```json
{
  "success": true,
  "data": {
    "id": "ap1a2b3c-d4e5-6789-appt-000000000001",
    "patient_id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "slot_id": "sl1a2b3c-d4e5-6789-slot-000000000001",
    "status": "pending",
    "complaint_note": "Sudah 3 hari demam dan batuk, disertai sesak napas ringan.",
    "consultation_fee_snapshot": 150000.00,
    "booked_at": "2026-06-07T10:30:00.000Z",
    "confirmed_at": null,
    "completed_at": null,
    "cancelled_at": null,
    "created_at": "2026-06-07T10:30:00.000Z",
    "updated_at": "2026-06-07T10:30:00.000Z",
    "doctors": {
      "full_name": "dr. Budi Santoso, Sp.PD",
      "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi.jpg",
      "specializations": {
        "name": "Penyakit Dalam"
      },
      "clinics": {
        "name": "Klinik Sehat Bersama",
        "address": "Jl. Merdeka No. 10, Bandung"
      }
    },
    "slots": {
      "slot_date": "2026-06-15",
      "slot_start": "09:00:00",
      "slot_end": "09:30:00"
    }
  },
  "message": "Booking berhasil dibuat. Menunggu konfirmasi."
}
```

**Error Responses:**

`409` — Slot sudah dibooking orang lain (race condition):
```json
{
  "success": false,
  "error": {
    "code": "SLOT_ALREADY_BOOKED",
    "message": "Slot waktu ini sudah dipesan oleh pasien lain. Silakan pilih slot lain."
  }
}
```

`400` — `complaint_note` melebihi 300 karakter:
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Catatan keluhan maksimal 300 karakter"
  }
}
```

`404` — Dokter atau slot tidak ditemukan:
```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Dokter atau slot tidak ditemukan"
  }
}
```

`401`:
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Token tidak valid atau sudah expired"
  }
}
```

`500` — Error transaksi database:
```json
{
  "success": false,
  "error": {
    "code": "TRANSACTION_FAILED",
    "message": "Terjadi kesalahan saat memproses booking. Silakan coba lagi."
  }
}
```

---

### 6.2 Get Booking History

```
GET /rest/v1/appointments
  ?patient_id=eq.<profile_id>
  &select=*,doctors(id,full_name,photo_url,specializations(name)),doctor_slots(slot_date,slot_start,slot_end)
  &order=created_at.desc
  &limit=20
  &offset=0
```

**Description:** Mengambil daftar semua riwayat appointment milik user yang login. Mendukung filter by status dan pagination.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Query Params Tambahan (Opsional):**

| Param | Contoh Value | Keterangan |
|---|---|---|
| `status` | `eq.upcoming` | Filter by status: `pending`, `upcoming`, `completed`, `cancelled` |
| `limit` | `20` | Jumlah item per halaman |
| `offset` | `20` | Offset untuk pagination halaman berikutnya |

**Success Response `200`:**
```json
[
  {
    "id": "ap1a2b3c-d4e5-6789-appt-000000000001",
    "patient_id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "slot_id": "sl1a2b3c-d4e5-6789-slot-000000000001",
    "status": "upcoming",
    "complaint_note": "Sudah 3 hari demam dan batuk.",
    "consultation_fee_snapshot": 150000.00,
    "booked_at": "2026-06-07T10:30:00.000Z",
    "confirmed_at": "2026-06-07T11:00:00.000Z",
    "completed_at": null,
    "cancelled_at": null,
    "cancellation_reason": null,
    "created_at": "2026-06-07T10:30:00.000Z",
    "updated_at": "2026-06-07T11:00:00.000Z",
    "doctors": {
      "id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
      "full_name": "dr. Budi Santoso, Sp.PD",
      "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi.jpg",
      "specializations": {
        "name": "Penyakit Dalam"
      }
    },
    "doctor_slots": {
      "slot_date": "2026-06-15",
      "slot_start": "09:00:00",
      "slot_end": "09:30:00"
    }
  }
]
```

---

### 6.3 Get Detail Appointment

```
GET /rest/v1/appointments
  ?id=eq.<appointment_id>
  &patient_id=eq.<profile_id>
  &select=*,doctors(id,full_name,photo_url,experience_years,specializations(name,icon_url),clinics(name,address,phone)),doctor_slots(slot_date,slot_start,slot_end)
```

**Description:** Mengambil data lengkap satu appointment. Digunakan di halaman Detail Appointment dari Booking History.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Success Response `200`:**
```json
[
  {
    "id": "ap1a2b3c-d4e5-6789-appt-000000000001",
    "patient_id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "slot_id": "sl1a2b3c-d4e5-6789-slot-000000000001",
    "status": "upcoming",
    "complaint_note": "Sudah 3 hari demam dan batuk, disertai sesak napas ringan.",
    "consultation_fee_snapshot": 150000.00,
    "booked_at": "2026-06-07T10:30:00.000Z",
    "confirmed_at": "2026-06-07T11:00:00.000Z",
    "completed_at": null,
    "cancelled_at": null,
    "cancellation_reason": null,
    "created_at": "2026-06-07T10:30:00.000Z",
    "updated_at": "2026-06-07T11:00:00.000Z",
    "doctors": {
      "id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
      "full_name": "dr. Budi Santoso, Sp.PD",
      "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi.jpg",
      "experience_years": 12,
      "specializations": {
        "name": "Penyakit Dalam",
        "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/pd.png"
      },
      "clinics": {
        "name": "Klinik Sehat Bersama",
        "address": "Jl. Merdeka No. 10, Bandung",
        "phone": "022-12345678"
      }
    },
    "doctor_slots": {
      "slot_date": "2026-06-15",
      "slot_start": "09:00:00",
      "slot_end": "09:30:00"
    }
  }
]
```

**Error Responses:**

`200` dengan `[]` — Appointment tidak ditemukan atau bukan milik user ini (RLS sudah handle di level DB).

---

### 6.4 Cancel Appointment

```
POST /functions/v1/cancel-appointment
```

**Description:** Membatalkan appointment dengan status `pending` atau `upcoming`. Menggunakan Edge Function karena proses ini meliputi: (1) validasi status appointment, (2) update status ke `cancelled`, (3) set `doctor_slots.is_booked = false` (slot dikembalikan), (4) kirim notifikasi FCM pembatalan — semua dalam satu transaksi.

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "appointment_id": "ap1a2b3c-d4e5-6789-appt-000000000001",
  "cancellation_reason": "Ada keperluan mendadak, tidak bisa hadir."
}
```

| Field | Tipe | Wajib | Keterangan |
|---|---|---|---|
| `appointment_id` | `string` (UUID) | Ya | ID appointment yang akan dibatalkan |
| `cancellation_reason` | `string` | Tidak | Alasan pembatalan |

**Success Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "ap1a2b3c-d4e5-6789-appt-000000000001",
    "status": "cancelled",
    "cancelled_at": "2026-06-07T14:00:00.000Z",
    "cancellation_reason": "Ada keperluan mendadak, tidak bisa hadir."
  },
  "message": "Appointment berhasil dibatalkan."
}
```

**Error Responses:**

`422` — Appointment sudah `completed` atau sudah `cancelled`:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_STATUS_TRANSITION",
    "message": "Appointment dengan status 'completed' tidak dapat dibatalkan."
  }
}
```

`403` — Appointment bukan milik user ini:
```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "Anda tidak memiliki akses untuk membatalkan appointment ini."
  }
}
```

`404` — Appointment tidak ditemukan:
```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Appointment tidak ditemukan."
  }
}
```

---

### 6.5 Get Upcoming Appointment (untuk Home Page)

```
GET /rest/v1/appointments
  ?patient_id=eq.<profile_id>
  &status=in.(pending,upcoming)
  &select=*,doctors(id,full_name,photo_url,specializations(name,icon_url),clinics(id,name,address,phone)),doctor_slots(slot_date,slot_start,slot_end)
  &order=doctor_slots.slot_date.asc
  &limit=1
```

**Description:** Mengambil appointment **terdekat** milik user yang berstatus `pending` atau `upcoming`. Digunakan untuk "Upcoming Treatment" card di Home Page (lihat wireframe 06 §4). Hanya return 1 item — appointment dengan tanggal paling dekat.

**Catatan PostgreSQL/PostgREST:**
- Filter `status=in.(pending,upcoming)` menggunakan IN syntax PostgREST untuk match multiple values
- Order by nested column `doctor_slots.slot_date` via JOIN PostgREST
- Karena ada JOIN ke `doctor_slots`, ordering di atas memerlukan alias PostgREST — jika gagal, fallback: order di Flutter side

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Query Params:**
| Param | Value | Keterangan |
|---|---|---|
| `patient_id` | `eq.<profile_id>` | Filter by user (RLS juga handle) |
| `status` | `in.(pending,upcoming)` | Hanya status aktif (exclude completed/cancelled) |
| `select` | `*,doctors(...),doctor_slots(...)` | Include relasi dokter dan slot |
| `order` | `doctor_slots.slot_date.asc` | Tanggal terdekat dulu |
| `limit` | `1` | Cuma 1 item untuk card |

**Success Response `200`:**
```json
[
  {
    "id": "ap1a2b3c-d4e5-6789-appt-000000000001",
    "patient_id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "doctor_id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
    "slot_id": "sl1a2b3c-d4e5-6789-slot-000000000001",
    "status": "upcoming",
    "complaint_note": "Sudah 3 hari demam dan batuk.",
    "consultation_fee_snapshot": 150000.00,
    "booked_at": "2026-06-07T10:30:00.000Z",
    "confirmed_at": "2026-06-07T11:00:00.000Z",
    "completed_at": null,
    "cancelled_at": null,
    "cancellation_reason": null,
    "created_at": "2026-06-07T10:30:00.000Z",
    "updated_at": "2026-06-07T11:00:00.000Z",
    "doctors": {
      "id": "d1a2b3c4-e5f6-7890-doc1-000000000001",
      "full_name": "dr. Budi Santoso, Sp.PD",
      "photo_url": "https://<ref>.supabase.co/storage/v1/object/public/doctors/budi.jpg",
      "specializations": {
        "name": "Penyakit Dalam",
        "icon_url": "https://<ref>.supabase.co/storage/v1/object/public/icons/pd.png"
      },
      "clinics": {
        "id": "c1a2b3c4-d5e6-7890-cln1-000000000001",
        "name": "Klinik Sehat Bersama",
        "address": "Jl. Merdeka No. 10, Bandung",
        "phone": "022-12345678"
      }
    },
    "doctor_slots": {
      "slot_date": "2026-06-15",
      "slot_start": "09:00:00",
      "slot_end": "09:30:00"
    }
  }
]
```

**Empty Response `200` dengan `[]`:**
User tidak punya appointment aktif. Flutter render empty state di Home Page dengan CTA "Cari Dokter Sekarang".

**Error Responses:**

`401` — Token tidak ada atau expired:
```json
{
  "code": 401,
  "message": "JWT expired"
}
```

> **Catatan Flutter:** Profile ID bisa didapat dari `GET /rest/v1/me` (lihat §3.5). Disimpan di memory setelah login untuk efisiensi.

---

## 7. Banner Endpoints

---

### 7.1 Get Active Banners

```
GET /rest/v1/banners
  ?is_active=eq.true
  &or=(starts_at.is.null,starts_at.lte.<now_iso>)
  &or=(ends_at.is.null,ends_at.gte.<now_iso>)
  &order=display_order.asc
```

**Description:** Mengambil semua banner yang aktif dan sedang dalam periode tayang. Digunakan di carousel Home Screen. Disarankan di-cache 5 menit di Flutter.

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Success Response `200`:**
```json
[
  {
    "id": "bn1a2b3c-d4e5-6789-bnr1-000000000001",
    "title": "Konsultasi Gratis dengan Dokter Umum",
    "image_url": "https://<ref>.supabase.co/storage/v1/object/public/banners/promo1.jpg",
    "action_url": "healthpal://doctors?specialization=umum",
    "display_order": 1,
    "is_active": true,
    "starts_at": "2026-06-01T00:00:00.000Z",
    "ends_at": "2026-06-30T23:59:59.000Z",
    "created_at": "2026-05-28T00:00:00.000Z"
  },
  {
    "id": "bn1a2b3c-d4e5-6789-bnr1-000000000002",
    "title": "Dokter Spesialis Anak Terbaik di Bandung",
    "image_url": "https://<ref>.supabase.co/storage/v1/object/public/banners/promo2.jpg",
    "action_url": "healthpal://doctors?specialization=anak&city=bandung",
    "display_order": 2,
    "is_active": true,
    "starts_at": null,
    "ends_at": null,
    "created_at": "2026-05-20T00:00:00.000Z"
  }
]
```

---

## 8. Notification Endpoints

---

### 8.1 Get Notifications

```
GET /rest/v1/notifications
  ?user_id=eq.<profile_id>
  &order=sent_at.desc
  &limit=30
  &offset=0
```

**Description:** Mengambil daftar riwayat notifikasi user. Digunakan untuk inbox notifikasi in-app (opsional di MVP, siap untuk v1.1).

**Headers:**
```
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
```

**Success Response `200`:**
```json
[
  {
    "id": "nt1a2b3c-d4e5-6789-notif-00000000001",
    "user_id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "appointment_id": "ap1a2b3c-d4e5-6789-appt-000000000001",
    "type": "reminder_h1",
    "title": "Reminder Jadwal Besok",
    "body": "Jangan lupa! Besok kamu ada jadwal dengan dr. Budi Santoso, Sp.PD pukul 09:00.",
    "is_read": false,
    "sent_at": "2026-06-14T09:00:00.000Z",
    "created_at": "2026-06-14T09:00:00.000Z"
  },
  {
    "id": "nt1a2b3c-d4e5-6789-notif-00000000002",
    "user_id": "p1q2r3s4-t5u6-7890-vwxy-z12345678901",
    "appointment_id": "ap1a2b3c-d4e5-6789-appt-000000000001",
    "type": "booking_confirmed",
    "title": "Booking Dikonfirmasi",
    "body": "Appointment kamu dengan dr. Budi Santoso, Sp.PD sudah dikonfirmasi. Jadwal: 15 Jun 2026 pukul 09:00.",
    "is_read": true,
    "sent_at": "2026-06-07T11:00:00.000Z",
    "created_at": "2026-06-07T11:00:00.000Z"
  }
]
```

---

### 8.2 Mark Notification as Read

```
PATCH /rest/v1/notifications?id=eq.<notification_id>&user_id=eq.<profile_id>
```

**Description:** Menandai satu notifikasi sebagai sudah dibaca. Filter `user_id` di query memastikan user hanya bisa update notifikasi miliknya sendiri (defense in depth di atas RLS).

**Headers:**
```
Content-Type: application/json
apikey: <SUPABASE_ANON_KEY>
Authorization: Bearer <access_token>
Prefer: return=representation
```

**Request Body:**
```json
{
  "is_read": true
}
```

**Success Response `200`:**
```json
[
  {
    "id": "nt1a2b3c-d4e5-6789-notif-00000000001",
    "is_read": true,
    "sent_at": "2026-06-14T09:00:00.000Z"
  }
]
```

---

## 9. Error Response Catalog

Referensi cepat semua error code yang mungkin dikembalikan API, beserta handling yang disarankan di sisi Flutter.

| HTTP Code | Error Code | Pesan | Flutter Handling |
|---|---|---|---|
| `400` | `VALIDATION_ERROR` | Input tidak valid | Tampilkan pesan error di field form |
| `400` | `INVALID_PLATFORM` | Platform FCM tidak valid | Log error, retry silent |
| `400` | `MISSING_COORDINATES` | Koordinat GPS tidak dikirim | Minta izin lokasi ulang |
| `400` | `INVALID_RADIUS` | Radius pencarian melebihi batas | Set radius ke default (5km) |
| `401` | `UNAUTHORIZED` | Token expired atau tidak ada | Refresh token → retry; jika gagal → logout |
| `403` | `FORBIDDEN` | Akses ditolak | Tampilkan snackbar error, jangan retry |
| `404` | `NOT_FOUND` | Resource tidak ditemukan | Tampilkan halaman 404 / empty state |
| `409` | `SLOT_ALREADY_BOOKED` | Slot sudah dipesan | Kembali ke halaman pilih slot, refresh data |
| `422` | `INVALID_STATUS_TRANSITION` | Transisi status tidak valid | Refresh detail appointment |
| `500` | `TRANSACTION_FAILED` | Error transaksi DB | Tampilkan dialog "Coba lagi" |
| `500` | `INTERNAL_SERVER_ERROR` | Error server umum | Tampilkan dialog "Terjadi kesalahan" |

### Contoh Global Error Handler di Flutter (Dart)

```dart
// lib/core/network/api_exception.dart
class ApiException implements Exception {
  final int statusCode;
  final String errorCode;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.errorCode,
    required this.message,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>? ?? {};
    return ApiException(
      statusCode: json['statusCode'] as int? ?? 500,
      errorCode: error['code'] as String? ?? 'UNKNOWN_ERROR',
      message: error['message'] as String? ?? 'Terjadi kesalahan. Silakan coba lagi.',
    );
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isSlotConflict => errorCode == 'SLOT_ALREADY_BOOKED';
  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'ApiException($statusCode): [$errorCode] $message';
}
```

---

## Changelog

| Versi | Tanggal | Perubahan |
|---|---|---|
| v1.0 | Juni 2026 | Initial release — 19 endpoint |
| v1.0.1 | 13 Jun 2026 | **Showstopper fixes:** Hapus duplikat Section 7; tambah §3.5 `GET /me`; tambah §5.5 `get_nearby_clinics`; tambah §6.5 Get Upcoming Appointment; standarkan enum Gender ke `other`; standarkan nested key ke plural (PostgREST convention) |

---

*Dokumen ini adalah living document. Setiap perubahan endpoint harus didiskusikan dengan tim mobile dan diupdate di sini sebelum implementasi dimulai. Versi API selalu disertakan di base path Edge Function untuk memudahkan backward compatibility.*