# Business Requirements Document
## health_pal — Doctor Appointment Mobile Application

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Platform** | Mobile (Flutter — Android & iOS) |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juni 2026 |
| **Status** | Discovery Phase |
| **Dibuat oleh** | Business Analyst |

---

## Daftar Isi

1. [Latar Belakang & Pernyataan Masalah](#1-latar-belakang--pernyataan-masalah)
2. [Tujuan Bisnis](#2-tujuan-bisnis)
3. [Target User](#3-target-user)
4. [Fitur Utama (Scope MVP)](#4-fitur-utama-scope-mvp)
5. [Prioritas Requirement](#5-prioritas-requirement)
6. [Kenapa Mobile-First & Seamless Experience Itu Krusial](#6-kenapa-mobile-first--seamless-experience-itu-krusial)
7. [KPI & Success Metrics](#7-kpi--success-metrics)
8. [Asumsi & Batasan](#8-asumsi--batasan)
9. [Risiko & Mitigasi](#9-risiko--mitigasi)
10. [Estimasi Timeline (High-Level)](#10-estimasi-timeline-high-level)

---

## 1. Latar Belakang & Pernyataan Masalah

Sistem booking dokter di Indonesia masih sangat terfragmentasi. Pasien harus menelepon klinik satu per satu, tidak mendapat visibilitas ketersediaan dokter secara real-time, dan sering membuang waktu di antrean fisik. Di sisi lain, dokter dan klinik kehilangan potensi pasien karena tidak punya saluran digital yang efisien.

### Masalah Utama yang Diselesaikan

- **Tidak ada platform terpadu** — Tidak ada satu tempat untuk mencari dan booking dokter lintas klinik atau rumah sakit.
- **Tidak ada visibilitas slot real-time** — Pasien tidak bisa melihat ketersediaan jadwal dokter tanpa telepon manual.
- **Antrean fisik tidak efisien** — Pengalaman menunggu di klinik membuang waktu produktif pasien.
- **Tingkat no-show tinggi** — Tidak ada sistem reminder otomatis, sehingga pasien sering lupa atau tidak datang.
- **Rekam medis tersebar** — Riwayat kesehatan pasien tidak terpusat dan sulit diakses saat pindah faskes.

---

## 2. Tujuan Bisnis

1. Membangun platform mobile terpadu yang menghubungkan pasien dengan dokter lintas klinik dan rumah sakit.
2. Mereduksi no-show appointment minimal **40%** melalui sistem notifikasi otomatis.
3. Menyederhanakan proses booking menjadi **kurang dari 5 tap** dari halaman utama.
4. Memberikan pengalaman pengguna yang seamless dan cepat, sehingga dapat bersaing dengan pemain eksisting (Alodokter, Halodoc, SehatQ).
5. Menjadi platform terpercaya untuk data rekam medis ringkas pasien di Indonesia.

---

## 3. Target User

### 3.1 Pasien / Individu (Primary User)

- **Profil:** Usia 18–55 tahun, smartphone-savvy, tinggal di kota besar dan menengah.
- **Kebutuhan:** Menemukan dokter yang tepat, booking jadwal cepat, dan mendapat reminder sebelum konsultasi.
- **Pain point saat ini:** Harus telepon klinik satu per satu, tidak tahu ketersediaan dokter, antri panjang.

### 3.2 Dokter / Tenaga Medis (Secondary User)

- **Profil:** Dokter umum dan spesialis yang berpraktik di klinik atau rumah sakit.
- **Kebutuhan:** Mengelola jadwal praktik secara digital, mengurangi no-show, memperluas jangkauan pasien.
- **Pain point saat ini:** Manajemen jadwal manual, tidak ada data historis pasien yang terstruktur.

### 3.3 Admin Klinik / RS (Tertiary User)

- **Profil:** Staf operasional yang bertanggung jawab atas pendaftaran dan manajemen pasien harian.
- **Kebutuhan:** Dashboard untuk melihat dan mengelola antrian, konfirmasi appointment, dan laporan harian.
- **Pain point saat ini:** Proses manual via telepon dan buku catatan, rawan human error.

---

## 4. Fitur Utama (Scope MVP)

### 4.1 Pencarian Dokter

- Filter berdasarkan spesialisasi, lokasi, dan ketersediaan jadwal.
- Profil lengkap dokter (foto, pendidikan, pengalaman, rumah sakit afiliasi).
- Rating dan ulasan dari pasien terverifikasi.

### 4.2 Booking Appointment

- Kalender slot jadwal real-time yang selalu up-to-date.
- Proses booking selesai dalam 1–5 tap.
- Konfirmasi booking instan via notifikasi push dan SMS.

### 4.3 Notifikasi & Reminder

- Push notification H-1 dan H-0 sebelum jadwal konsultasi.
- Implementasi Firebase Cloud Messaging (FCM) untuk keandalan delivery.
- Update status real-time (konfirmasi, reschedule, pembatalan).

### 4.4 Rekam Medis Ringkas

- Riwayat kunjungan dan appointment sebelumnya.
- Catatan diagnosa dan resep dari dokter.
- Fitur upload dokumen kesehatan (foto, PDF hasil lab).

### 4.5 Pembayaran

- Integrasi payment gateway lokal (Midtrans, GoPay, OVO, DANA).
- Dukungan pembayaran dengan BPJS Kesehatan dan asuransi swasta.
- Riwayat transaksi yang dapat diunduh sebagai kwitansi.

### 4.6 Telemedicine *(Roadmap v2)*

- Video call konsultasi dengan dokter.
- Chat konsultasi berbasis teks.
- Penerbitan e-Resep digital.

---

## 5. Prioritas Requirement

| Prioritas | Requirement | Justifikasi |
|---|---|---|
| **P1 — Must Have** | Pencarian dokter + booking slot real-time | Core value proposition utama aplikasi |
| **P1 — Must Have** | Sistem autentikasi pasien & profil pengguna | Fondasi keamanan dan personalisasi |
| **P1 — Must Have** | Push notification via FCM untuk reminder | Kunci menurunkan no-show rate |
| **P2 — Should Have** | Integrasi payment gateway (Midtrans / GoPay) | Meningkatkan konversi dan kenyamanan |
| **P2 — Should Have** | Riwayat appointment & rekam medis ringkas | Retensi pengguna jangka panjang |
| **P2 — Should Have** | Rating & ulasan dokter oleh pasien | Membangun kepercayaan ekosistem |
| **P3 — Nice to Have** | Fitur telemedicine / video call | Diferensiasi kompetitif fase lanjutan |
| **P3 — Nice to Have** | AI-based doctor recommendation engine | Personalisasi berbasis data historis |

---

## 6. Kenapa Mobile-First & Seamless Experience Itu Krusial

**1. Dominasi mobile di Indonesia**
Lebih dari 70% pengguna internet Indonesia mengakses layanan digital eksklusif lewat smartphone. Mobile bukan pilihan tambahan — ini adalah satu-satunya channel yang relevan untuk mayoritas target user.

**2. Konteks penggunaan yang unik**
Pengguna yang sedang tidak sehat atau butuh dokter segera memiliki toleransi frustrasi yang sangat rendah. Friction sekecil apapun — loading lama, form panjang, navigasi membingungkan — langsung meningkatkan drop-off rate secara signifikan.

**3. Efisiensi engineering dengan Flutter**
Dengan Flutter, satu codebase dapat menargetkan Android dan iOS secara bersamaan. Ini berarti efisiensi development tinggi tanpa mengorbankan native feel dan performa di kedua platform.

**4. Push notification sebagai lever bisnis**
Reminder appointment via push notification (FCM) adalah mekanisme paling efektif untuk menurunkan no-show rate. Kapabilitas ini hanya bisa dieksekusi secara optimal di platform mobile.

**5. Keunggulan kompetitif melalui UX**
Booking selesai dalam kurang dari 5 tap adalah keunggulan kompetitif konkret versus kompetitor yang masih menggunakan flow telepon, form web panjang, atau aplikasi dengan UX yang berat.

---

## 7. KPI & Success Metrics

| Metrik | Target | Metode Pengukuran |
|---|---|---|
| Waktu booking end-to-end | < 5 tap / < 60 detik | In-app analytics (funnel) |
| Penurunan no-show rate | ↓ 40% vs. baseline | Perbandingan data pre/post launch |
| Rating app store | ≥ 4.5 bintang | Google Play & App Store rating |
| Load time halaman utama | < 2 detik (4G) | Firebase Performance Monitoring |
| Retensi pengguna (bulan ke-1) | ≥ 60% | Cohort analysis via analytics |
| Jumlah mitra dokter/klinik | ≥ 50 mitra (3 bulan) | CRM tracking |

---

## 8. Asumsi & Batasan

### Asumsi

- Target user memiliki akses smartphone Android atau iOS dengan koneksi internet minimal 4G.
- Mitra klinik bersedia menyediakan data jadwal dokter secara real-time melalui API atau dashboard admin.
- Regulasi UU PDP dan PMK terkait data kesehatan sudah dipelajari dan menjadi constraint desain dari awal.

### Batasan (Out of Scope — MVP)

- Fitur telemedicine / video call (dijadwalkan di v2).
- Integrasi langsung dengan sistem HIS (Hospital Information System) pihak ketiga.
- Versi web (web app) — fokus eksklusif pada mobile untuk MVP.
- Multi-bahasa (MVP hanya mendukung Bahasa Indonesia).

---

## 9. Risiko & Mitigasi

| Risiko | Dampak | Probabilitas | Mitigasi |
|---|---|---|---|
| Regulasi data kesehatan (UU PDP, PMK) | Tinggi | Sedang | Libatkan legal counsel sejak tahap desain; enkripsi end-to-end data pasien |
| Adopsi rendah dari sisi dokter & klinik | Tinggi | Sedang | Program onboarding gratis & insentif early adopter untuk mitra |
| Persaingan ketat (Alodokter, Halodoc, SehatQ) | Sedang | Tinggi | Fokus pada UX lebih cepat & fitur offline-first untuk area jaringan lemah |
| Skalabilitas backend saat traffic tinggi | Tinggi | Rendah | Arsitektur microservices + Firebase real-time + load testing berkala |
| Keamanan data medis pasien | Tinggi | Rendah | Implementasi HTTPS, enkripsi at-rest, audit keamanan berkala |

---

## 10. Estimasi Timeline (High-Level)

| Fase | Durasi | Deliverable Utama |
|---|---|---|
| **Discovery & Design** | 4 minggu | Finalisasi Figma, validasi user research, arsitektur teknis |
| **MVP Development** | 10 minggu | Auth, search dokter, booking real-time, notifikasi FCM |
| **QA & Testing** | 3 minggu | Unit test, widget test, integration test (termasuk auth flow) |
| **Beta Launch** | 2 minggu | Soft launch ke 500 user, feedback loop, hotfix prioritas |
| **Public Release v1.0** | 1 minggu | Submission Google Play Store & App Store |
| **Total** | **~20 minggu** | |

---

## Changelog

| Versi | Tanggal | Perubahan |
|---|---|---|
| v1.0 | Juni 2026 | Initial draft |
| v1.0.1 | 13 Jun 2026 | **SS#9 Revisi KPI:** Target "Booking < 5 tap" (dari target lama 3 langkah yang tidak achievable). Update di §2 Tujuan Bisnis #3, §4.2 Booking Appointment, §6 Keunggulan Kompetitif #5, §7 KPI & Success Metrics. Rationale: flow aktual Home → Search → Doctor Detail → Book → Success = minimum 4-5 tap. |

---

*Dokumen ini merupakan living document dan akan diperbarui seiring perkembangan discovery dan validasi dengan stakeholder.*