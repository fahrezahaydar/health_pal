# Product Requirements Document
## health_pal — Doctor Appointment Mobile Application

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Platform** | Mobile — Flutter (Android & iOS) |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Status** | In Review |
| **Primary User** | Pasien / Individu |
| **Backend** | Supabase (PostgreSQL, Auth, Realtime) |

---

## Daftar Isi

1. [Overview Produk](#1-overview-produk)
2. [Arsitektur & Tech Stack](#2-arsitektur--tech-stack)
3. [User Persona](#3-user-persona)
4. [User Stories](#4-user-stories)
5. [Struktur Navigasi](#5-struktur-navigasi)
6. [Screen & Functional Requirements](#6-screen--functional-requirements)
   - 6.1 Onboarding & Autentikasi
   - 6.2 Home Screen
   - 6.3 Search by Location (Loc Tab)
   - 6.4 Detail Dokter
   - 6.5 Book Appointment
   - 6.6 Booking History
   - 6.7 Profile
7. [Alur Booking (Happy Path)](#7-alur-booking-happy-path)
8. [Status Appointment & State Machine](#8-status-appointment--state-machine)
9. [Notifikasi](#9-notifikasi)
10. [Pembayaran (Dummy MVP)](#10-pembayaran-dummy-mvp)
11. [Non-Functional Requirements](#11-non-functional-requirements)
12. [Out of Scope (MVP)](#12-out-of-scope-mvp)
13. [Acceptance Criteria Ringkas](#13-acceptance-criteria-ringkas)

---

## 1. Overview Produk

**health_pal** adalah aplikasi mobile Flutter yang memungkinkan pasien menemukan dokter, melihat jadwal tersedia, dan melakukan booking appointment secara digital — tanpa perlu telepon klinik.

### Problem Statement
Pasien kesulitan menemukan dan booking dokter yang tepat karena tidak ada platform terpadu dengan data jadwal real-time. Proses manual via telepon membuang waktu dan rentan no-show.

### Solusi
Aplikasi mobile-first dengan alur booking singkat (Cari Dokter → Pilih Dokter → Detail → Book → Selesai), dilengkapi reminder otomatis via push notification untuk menekan no-show.

---

## 2. Arsitektur & Tech Stack

| Layer | Teknologi |
|---|---|
| **Mobile Framework** | Flutter (Dart) |
| **State Management** | flutter_bloc / Cubit |
| **Backend & Database** | Supabase (PostgreSQL + Realtime) |
| **Autentikasi** | Supabase Auth (Email + Google Sign-In) |
| **Push Notification** | Firebase Cloud Messaging (FCM) |
| **Pembayaran (MVP)** | Simulasi / Dummy (tanpa gateway nyata) |
| **Maps & Geolocation** | flutter_map (OpenStreetMap) / geolocator package (*Google Maps diganti Sprint 4 — ADR: gratis, no API key) |
| **Storage (foto profil, dokumen)** | Supabase Storage |

---

## 3. User Persona

### Pasien — Primary User

| Atribut | Detail |
|---|---|
| **Nama Persona** | Rina, 28 tahun |
| **Lokasi** | Bandung, Jawa Barat |
| **Device** | Android mid-range |
| **Goals** | Booking dokter spesialis cepat, tahu jadwal tersedia tanpa telepon |
| **Frustrasi** | Harus telepon klinik, tidak tahu dokter masuk atau tidak, antri lama |
| **Tech literacy** | Menengah — terbiasa pakai Gojek, Tokopedia, Instagram |

---

## 4. User Stories

### Autentikasi
- Sebagai pasien, saya ingin mendaftar dengan email & password agar punya akun personal.
- Sebagai pasien, saya ingin login dengan Google agar proses masuk lebih cepat.
- Sebagai pasien, saya ingin melengkapi profil saya (nama, foto, tanggal lahir, gender) setelah pertama kali login.

### Home
- Sebagai pasien, saya ingin melihat banner promo dokter unggulan di halaman utama agar saya tahu rekomendasi terbaru.
- Sebagai pasien, saya ingin mencari dokter langsung dari search bar di home agar saya bisa akses cepat.
- Sebagai pasien, saya ingin melihat appointment aktif (upcoming) saya di home agar tidak perlu buka tab lain.

### Pencarian & Lokasi
- Sebagai pasien, saya ingin mencari dokter berdasarkan lokasi saya agar menemukan yang terdekat.
- Sebagai pasien, saya ingin memfilter dokter berdasarkan spesialisasi agar hasil lebih relevan.

### Detail Dokter
- Sebagai pasien, saya ingin melihat profil lengkap dokter (foto, spesialisasi, pengalaman, klinik afiliasi) agar bisa menilai sebelum booking.
- Sebagai pasien, saya ingin melihat rating dan ulasan dokter dari pasien lain.
- Sebagai pasien, saya ingin melihat slot jadwal yang tersedia sebelum memutuskan booking.

### Booking
- Sebagai pasien, saya ingin memilih tanggal dan slot waktu yang tersedia agar bisa pilih sesuai jadwal saya.
- Sebagai pasien, saya ingin mengisi keluhan singkat sebelum konfirmasi agar dokter tahu konteks kunjungan.
- Sebagai pasien, saya ingin melihat ringkasan booking sebelum konfirmasi agar tidak salah data.
- Sebagai pasien, saya ingin mendapat konfirmasi booking berupa notifikasi push setelah berhasil.

### Riwayat & Notifikasi
- Sebagai pasien, saya ingin melihat semua riwayat appointment (Pending, Upcoming, Completed, Cancelled).
- Sebagai pasien, saya ingin membatalkan appointment yang masih Pending atau Upcoming.
- Sebagai pasien, saya ingin mendapat reminder H-1 dan H-0 sebelum jadwal konsultasi.

### Profil
- Sebagai pasien, saya ingin mengedit data profil saya kapan saja.
- Sebagai pasien, saya ingin bisa logout dari aplikasi.

---

## 5. Struktur Navigasi

Aplikasi menggunakan **Bottom Navigation Bar** dengan 4 tab utama:

```
┌─────────────────────────────────────────────┐
│                  App Content                 │
├──────────┬──────────┬───────────┬────────────┤
│   Home   │   Loc    │  Booking  │  Profile   │
│  (🏠)   │  (📍)   │ History   │   (👤)    │
│          │          │  (📋)    │            │
└──────────┴──────────┴───────────┴────────────┘
```

| Tab | Deskripsi |
|---|---|
| **Home** | Dashboard utama: banner, search bar, upcoming appointment |
| **Loc** | Cari dokter berdasarkan lokasi pengguna + filter spesialisasi |
| **Booking History** | Semua riwayat appointment dengan filter status |
| **Profile** | Data diri pengguna, edit profil, logout |

### Navigasi Tambahan (Stack / Modal)
- Detail Dokter → di-push dari Home atau Loc
- Book Appointment → di-push dari Detail Dokter
- Konfirmasi Booking → modal/bottom sheet dari Book Appointment
- Notifikasi Detail → dari system notification tray

---

## 6. Screen & Functional Requirements

---

### 6.1 Onboarding & Autentikasi

#### Splash Screen
- Tampilkan logo health_pal selama ±2 detik.
- Cek sesi aktif: jika ada → langsung ke Home; jika tidak → ke Login.

#### Login Screen
| Elemen | Requirement |
|---|---|
| Login dengan Email & Password | Input email + password, validasi format email, minimum 8 karakter password |
| Login dengan Google | Integrasi Supabase Auth + Google OAuth |
| Link ke Register | Navigasi ke halaman registrasi |
| Forgot Password | Kirim email reset password via Supabase Auth |

#### Register Screen
| Elemen | Requirement |
|---|---|
| Input email & password | Validasi format + konfirmasi password |
| Daftar dengan Google | One-tap via Google OAuth |
| Verifikasi email | Supabase kirim email verifikasi setelah daftar |

#### Onboarding — Setup Profil (First-time Login)
Muncul sekali setelah akun pertama kali dibuat. User wajib melengkapi sebelum masuk ke Home.

| Field | Tipe | Wajib |
|---|---|---|
| Nama lengkap | Text input | Ya |
| Nickname | Text input | Ya |
| Foto profil | Image picker (kamera / galeri) | Tidak |
| Email | Pre-filled dari auth, read-only | Ya |
| Tanggal lahir | Date picker | Ya |
| Gender | Dropdown (Laki-laki / Perempuan / Lainnya) | Ya |

---

### 6.2 Home Screen

| Elemen | Requirement |
|---|---|
| **Greeting** | "Halo, {nickname}!" dengan foto profil kecil di kanan atas |
| **Search Bar** | Input teks → navigasi ke hasil pencarian dokter (nama / spesialisasi) |
| **Banner Promo** | Horizontal scroll carousel; data dari Supabase (tabel `banners`); tap → detail/URL |
| **Upcoming Appointment** | Card appointment terdekat milik user (status Pending / Upcoming); tap → detail booking |
| **Quick Categories** *(opsional v1.1)* | Grid ikon spesialisasi sebagai shortcut ke Loc tab dengan filter ter-preset |

**Edge cases:**
- Jika tidak ada upcoming appointment → tampilkan empty state dengan CTA "Cari Dokter".
- Jika belum ada banner → section banner disembunyikan.

---

### 6.3 Loc Tab — Search Dokter by Location

| Elemen | Requirement |
|---|---|
| **Peta** | flutter_map (OpenStreetMap) menampilkan posisi user + pin lokasi klinik/dokter — *Deferred ke Sprint 5 (AD-8: gratis, no API key)* |
| **Izin Lokasi** | Request permission geolocation saat pertama buka tab; jika ditolak → tampilkan fallback input kota manual |
| **Search & Filter** | Search bar nama dokter / spesialisasi + filter chips (spesialisasi, jarak, rating) |
| **List Dokter** | Card list di bawah peta: foto, nama, spesialisasi, klinik, rating, jarak dari lokasi user |
| **Tap Card** | Navigasi ke Detail Dokter |

**Data yang dibutuhkan dari Supabase:**
- Tabel `doctors`: id, nama, spesialisasi, klinik, foto, rating, lat, lng
- Query: filter by radius dari koordinat user (PostGIS atau Haversine formula)

---

### 6.4 Detail Dokter

| Elemen | Requirement |
|---|---|
| **Header** | Foto dokter, nama, spesialisasi, nama klinik, rating bintang + jumlah ulasan |
| **Informasi Dokter** | Deskripsi singkat, pengalaman (tahun), pendidikan, bahasa konsultasi |
| **Lokasi Klinik** | Alamat + mini map (tap → buka Google Maps) |
| **Jadwal Tersedia** | Horizontal date picker (7 hari ke depan) → tampilkan slot waktu yang available |
| **Ulasan Pasien** | List 3 ulasan terbaru; tap "Lihat semua" → expand atau halaman baru |
| **CTA Button** | Tombol "Book Appointment" fixed di bagian bawah screen |

**Logika slot jadwal:**
- Slot diambil dari tabel `doctor_schedules` di Supabase.
- Slot yang sudah di-booking (status bukan Cancelled) tidak bisa dipilih.
- Slot ditampilkan sebagai chips: hijau = tersedia, abu = tidak tersedia.

---

### 6.5 Book Appointment

Halaman ini muncul setelah user tap "Book Appointment" dari Detail Dokter.

| Elemen | Requirement |
|---|---|
| **Ringkasan Dokter** | Foto, nama, spesialisasi (read-only, dari halaman sebelumnya) |
| **Pilih Tanggal** | Date picker, default ke tanggal yang sudah dipilih di Detail Dokter |
| **Pilih Slot Waktu** | Grid chips slot tersedia untuk tanggal yang dipilih |
| **Catatan Keluhan** | Text area opsional (maks. 300 karakter): keluhan singkat untuk dokter |
| **Ringkasan Biaya** | Label "Biaya Konsultasi" + nominal (dummy/simulasi); badge "Simulasi" |
| **Tombol Konfirmasi** | Buka bottom sheet konfirmasi sebelum submit |

#### Bottom Sheet Konfirmasi Booking
- Tampilkan ringkasan: nama dokter, tanggal, slot, biaya simulasi.
- Dua tombol: **"Konfirmasi Booking"** dan **"Batal"**.
- Setelah konfirmasi → insert ke tabel `appointments` dengan status `Pending`.
- Tampilkan success screen / snackbar → kembali ke Home.

---

### 6.6 Booking History Tab

| Elemen | Requirement |
|---|---|
| **Filter Tab** | Chip tabs: Semua / Pending / Upcoming / Completed / Cancelled |
| **List Appointment** | Card per appointment: foto dokter, nama, spesialisasi, tanggal & waktu, status badge |
| **Tap Card** | Buka Detail Appointment |

#### Detail Appointment (Screen/Modal)
| Elemen | Requirement |
|---|---|
| Info lengkap booking | Nama dokter, klinik, tanggal, slot, catatan keluhan, biaya simulasi |
| Status badge | Warna sesuai status (lihat bagian 8) |
| **Tombol Batalkan** | Muncul hanya jika status Pending atau Upcoming; konfirmasi dialog sebelum batalkan |
| Riwayat status | Timeline perubahan status appointment (opsional v1.1) |

---

### 6.7 Profile Tab

| Elemen | Requirement |
|---|---|
| **Avatar & Nama** | Foto profil + nama lengkap + nickname |
| **Data Diri** | Email (read-only), tanggal lahir, gender |
| **Tombol Edit Profil** | Buka form edit: nama, nickname, foto, tanggal lahir, gender |
| **Pengaturan Notifikasi** | Toggle on/off reminder appointment |
| **Tombol Logout** | Konfirmasi dialog → Supabase Auth sign out → kembali ke Login |

---

## 7. Alur Booking (Happy Path)

```
[Home / Loc Tab]
      │
      ▼
[Cari Dokter]
  (nama / spesialisasi / lokasi)
      │
      ▼
[Pilih Dokter dari List]
      │
      ▼
[Detail Dokter]
  - Lihat profil & ulasan
  - Pilih tanggal di kalender
  - Lihat slot tersedia
      │
      ▼
[Tap "Book Appointment"]
      │
      ▼
[Book Appointment Screen]
  - Konfirmasi tanggal & slot
  - Isi catatan keluhan (opsional)
  - Lihat ringkasan biaya (simulasi)
      │
      ▼
[Bottom Sheet Konfirmasi]
      │
      ▼
[Booking Berhasil]
  - Status: Pending
  - Push notification terkirim
  - Kembali ke Home (tampil upcoming card)
```

---

## 8. Status Appointment & State Machine

```
[Pending] ──── (konfirmasi sistem / admin) ────▶ [Upcoming]
    │                                                  │
    │ (user batalkan)                    (tanggal lewat & selesai)
    ▼                                                  ▼
[Cancelled]                                      [Completed]
    ▲                                                  
    │ (user batalkan sebelum jadwal)                   
[Upcoming] ──────────────────────────────────▶ [Cancelled]
```

| Status | Warna Badge | Deskripsi | Aksi yang Tersedia |
|---|---|---|---|
| **Pending** | Kuning / Amber | Booking masuk, menunggu konfirmasi | Batalkan |
| **Upcoming** | Hijau | Sudah dikonfirmasi, jadwal belum tiba | Batalkan |
| **Completed** | Biru | Jadwal sudah berlalu / kunjungan selesai | Beri ulasan (v1.1) |
| **Cancelled** | Merah / Abu | Dibatalkan oleh user atau sistem | — |

**Aturan transisi:**
- `Pending → Upcoming`: dilakukan oleh sistem/admin (Supabase trigger atau manual).
- `Pending / Upcoming → Cancelled`: bisa dilakukan user dari aplikasi.
- `Upcoming → Completed`: otomatis setelah waktu slot terlewati (Supabase scheduled function / cron).

---

## 9. Notifikasi

| Trigger | Waktu Kirim | Isi Pesan |
|---|---|---|
| Booking berhasil | Segera setelah submit | "Booking kamu dengan Dr. {nama} berhasil! Menunggu konfirmasi." |
| Status berubah ke Upcoming | Saat status update | "Appointment kamu dengan Dr. {nama} sudah dikonfirmasi. Jadwal: {tanggal} {waktu}." |
| Reminder H-1 | 24 jam sebelum slot | "Jangan lupa! Besok kamu ada jadwal dengan Dr. {nama} pukul {waktu}." |
| Reminder H-0 | 2 jam sebelum slot | "Appointment kamu dengan Dr. {nama} 2 jam lagi. Persiapkan dirimu!" |
| Booking dibatalkan | Saat status update ke Cancelled | "Appointment kamu dengan Dr. {nama} pada {tanggal} telah dibatalkan." |

**Implementasi:** Firebase Cloud Messaging (FCM). Token FCM disimpan di tabel `user_fcm_tokens` di Supabase dan diperbarui setiap login.

---

## 10. Pembayaran (Dummy MVP)

Fitur pembayaran di MVP bersifat **simulasi** — tidak ada integrasi gateway nyata.

| Elemen | Detail |
|---|---|
| **Tampilan** | Nominal biaya konsultasi ditampilkan di Book Appointment screen |
| **Badge** | Label "Simulasi" / "Demo" di samping nominal agar user tahu ini bukan transaksi nyata |
| **Alur** | User tap "Konfirmasi Booking" → langsung berhasil tanpa proses pembayaran nyata |
| **Catatan di UI** | Teks kecil: "Pembayaran dilakukan langsung di klinik" |
| **Roadmap v2** | Integrasi Midtrans atau Xendit untuk pembayaran nyata |

---

## 11. Non-Functional Requirements

| Kategori | Requirement |
|---|---|
| **Performa** | Load time halaman utama < 2 detik pada koneksi 4G |
| **Offline** | Tampilkan cached data terakhir jika tidak ada koneksi; indikator "offline" muncul |
| **Keamanan** | Semua request ke Supabase menggunakan RLS (Row Level Security); token JWT divalidasi server-side |
| **Privasi Data** | Data pasien (tanggal lahir, gender) tidak ditampilkan ke pihak lain tanpa consent |
| **Aksesibilitas** | Ukuran font minimum 14sp; kontras warna mengikuti WCAG AA; semua tombol memiliki area tap ≥ 48x48dp |
| **Kompatibilitas** | Android 8.0 (API 26) ke atas; iOS 13 ke atas |
| **Ukuran Aplikasi** | Target ukuran APK < 30 MB |

---

## 12. Out of Scope (MVP)

Fitur berikut **tidak** masuk dalam MVP v1.0 dan dijadwalkan untuk rilis berikutnya:

- Telemedicine / video call konsultasi
- Chat antara pasien dan dokter
- e-Resep digital
- Integrasi BPJS Kesehatan
- Integrasi payment gateway nyata (Midtrans / Xendit)
- Dashboard admin klinik / RS
- Portal dokter (manajemen jadwal dari sisi dokter)
- Fitur ulasan & rating (input dari pasien)
- Multi-bahasa (selain Bahasa Indonesia)
- Versi web aplikasi

---

## 13. Acceptance Criteria Ringkas

| Fitur | Acceptance Criteria |
|---|---|
| **Login Email** | User bisa login dengan email & password yang terdaftar; error message muncul jika salah |
| **Login Google** | User bisa login 1-tap dengan akun Google; sesi tersimpan |
| **Setup Profil** | Form onboarding muncul hanya saat pertama login; semua field wajib tervalidasi sebelum lanjut |
| **Search Dokter** | Hasil pencarian muncul dalam < 2 detik; hasil relevan dengan kata kunci nama / spesialisasi |
| **Loc Tab** | Peta menampilkan pin dokter terdekat; list dokter terfilter berdasarkan radius lokasi user |
| **Detail Dokter** | Slot tersedia dan tidak tersedia dibedakan secara visual; slot yang sudah dibooking tidak bisa dipilih |
| **Booking** | Appointment berhasil tersimpan di Supabase dengan status Pending; notifikasi push terkirim dalam 30 detik; **end-to-end flow selesai dalam < 5 tap** (Home → Search → Doctor Detail → Book → Success, v1.0.1) |
| **Booking History** | Filter status bekerja; card appointment menampilkan info yang benar sesuai data Supabase |
| **Batalkan Appointment** | Tombol batalkan hanya muncul untuk status Pending / Upcoming; status berubah ke Cancelled setelah konfirmasi |
| **Reminder Notifikasi** | Notifikasi H-1 dan H-0 terkirim pada waktu yang tepat via FCM |
| **Logout** | Session Supabase dihapus; user diarahkan ke Login screen |

---

*Dokumen ini adalah living document. Setiap perubahan requirement harus didiskusikan dengan tim dan diupdate di sini sebelum implementasi dimulai.*

## Changelog

| Versi | Tanggal | Perubahan |
|---|---|---|
| v1.0 | Juni 2026 | Initial draft |
| v1.0.1 | 13 Jun 2026 | **SS#9 Revisi KPI:** Tambah acceptance criteria "Booking end-to-end < 5 tap" (sinkron dengan BRD v1.0.1). Rationale: flow Home → Search → Doctor Detail → Book → Success = minimum 4-5 tap; target lama (3 langkah) tidak achievable tanpa redesign major. |