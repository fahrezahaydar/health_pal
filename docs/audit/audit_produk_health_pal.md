# Audit Produk — Health Pal (Mobile App Flutter)

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Platform** | Mobile (Flutter — Android & iOS) |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 13 Juni 2026 |
| **Auditor** | Senior Product Manager |
| **Cakupan** | BRD v1.0 · PRD v1.0 · ERD v1.0 · API Contract v1.0 · USER_FLOW v2.0 · 21 Wireframe · TDD 01 (Arsitektur) |

---

## Ringkasan Skor

| Kriteria | Skor | Status |
|---|---|---|
| **1. Keselarasan Bisnis (BRD ↔ PRD)** | **75 / 100** | Perlu Perhatian |
| **2. Kesiapan Fitur Flutter** | **82 / 100** | Baik |
| **3. UX & Wireframe Flow** | **78 / 100** | Baik |
| **Skor Keseluruhan** | **78 / 100** | Layak Lanjut (dengan revisi minor) |

---

## 1. Keselarasan Bisnis (BRD ↔ PRD) — 75 / 100

### 1.1 Yang Sudah Selaras

- 5/5 Business Goals di BRD memiliki representasi fitur di PRD (search, booking, notifikasi, profil, integrasi).
- Push notification FCM untuk reminder H-1/H-0 di PRD selaras dengan Goal no-show -40% di BRD.
- State machine appointment (Pending → Upcoming → Completed/Cancelled) jelas dan implementable.
- Risk register di BRD (regulasi UU PDP, adopsi dokter) mulai di-address di ERD melalui RLS policy.

### 1.2 Yang Tidak Selaras

| # | Item BRD | Kondisi di PRD | Dampak |
|---|---|---|---|
| 1 | **Goal: Booking < 3-tap** (lama) | Alur aktual = 4–5 tap (Home → Search → Doctor Detail → Book → BSheet) | KPI utama BRD sulit tercapai |
| 2 | **P2 Should Have: Payment Gateway** (Midtrans/GoPay) | PRD §10: "Pembayaran **dummy/simulasi**" | Backward step, tidak memenuhi BRD |
| 3 | **P2 Should Have: Rekam Medis Ringkas** | PRD Out-of-Scope (riwayat appointment saja) | Cakupan lebih sempit dari BRD |
| 4 | **Target User: Dokter + Admin Klinik** | PRD fokus 100% pasien; tidak ada portal dokter/admin | 2 dari 3 persona terabaikan |
| 5 | **KPI: 50 mitra klinik (3 bulan)** | Tidak ada modul/kolom tracking kemitraan | KPI tidak terukur dari app |
| 6 | **BRD §6: "Mobile-first & seamless"** | Onboarding 3 slide + 2-step create profile = friction tinggi untuk first-time user | Drop-off risk |

---

## 2. Kesiapan Fitur Flutter — 82 / 100

### 2.1 Yang Matang

- Modularisasi fitur sangat jelas: `auth/`, `home/`, `doctor/`, `booking/`, `profile/`, `onboarding/`, `location/`. Tiap fitur punya 3 layer (data/domain/presentation).
- Clean Architecture di TDD 01 dengan aturan dependency yang eksplisit dan enforceable.
- State management strategy terdokumentasi jelas: BLoC untuk flow kompleks (SignIn, Booking), Cubit untuk sederhana (Onboarding, Home).
- GoRouter + StatefulShellRoute sudah ada code preview siap-implementasi (baris 666–874 USER_FLOW).
- Error handling berlapis: `ApiException → Failure → ErrorState → UI`, lengkap dengan mapping catalog.
- ERD sudah mature: denormalization, RLS, index optimization, PostgreSQL function `get_nearby_clinics`.
- API Contract 19 endpoint mencakup semua kebutuhan MVP, dengan format response dan error code yang konsisten.

### 2.2 Yang Perlu Diperbaiki Sebelum Sprint 1

| # | Masalah | File / Lokasi | Severity |
|---|---|---|---|
| 1 | API Contract duplikat Section 7 — "Facility Endpoints" muncul dua kali (baris 1536 dan seterusnya) dengan format berbeda | `api_contract_health_pal.md` | High |
| 2 | Endpoint inkonsisten — wireframe 06 pakai `GET /facilities/nearby` & `GET /appointments/upcoming`, tapi API contract tidak punya keduanya (ada `get_nearby_clinics` RPC saja) | `06-home.md` vs `api_contract_health_pal.md` | High |
| 3 | Inkonsistensi Bottom Nav — PRD/User Flow: `Home | Loc | Booking | Profile` (4 tab) — wireframe 06: `Home | Explore | Booking | Profile` | `prd_health_pal.md` vs `06-home.md` | Medium |
| 4 | Naming BLoC/Cubit di TDD inkonsisten: `OnboardingNotifier` (suffix "Notifier") padahal dideklarasikan sebagai Cubit. Juga `NotificationCubit` (toggle profil) vs cubit berbeda untuk inbox notifikasi | `tdd/01-arsitektur.md` baris 359, 273 | Medium |
| 5 | Home Page state terlalu granular — wireframe 06 mengusulkan 5+ Cubit terpisah (Home, Banner, Appointment, Specialization, Facility, Notification). Harus dikonsolidasikan agar tidak membebani Provider tree | `06-home.md` baris 269–276 | Medium |
| 6 | ERD tidak punya tabel `facilities` tapi wireframe 06 memanggil konsep "facility/nearby". Wireframe harusnya pakai entitas `clinics` | `erd_healh_pal.md` vs `06-home.md` | Medium |
| 7 | Tidak ada design system wireframe — ukuran font, padding, color token tidak konsisten antar wireframe. Akan menghambat implementasi widget | `docs/wireframe/*.md` | Low |
| 8 | Snake_case vs camelCase untuk JSON key di API contract (snake) vs Dart convention (camel) — perlu strategi mapping eksplisit (ada di ERD §5 tapi belum ada di TDD) | `tdd/01-arsitektur.md` | Low |
| 9 | `BookingCubit` = Bloc, `BookingHistoryCubit` = Cubit — naming `Cubit` vs `Bloc` di TDD tabel 5.4 ambigu. Sebaiknya konsisten: `BookingBloc` & `BookingHistoryBloc` | `tdd/01-arsitektur.md` baris 366–368 | Low |
| 10 | Tidak ada wireframe untuk: Onboarding 3 slide detail, Edit Profile, Notification Settings, Settings, Help & Support, T&C, Booking Success screen | `docs/wireframe/` | Medium |

---

## 3. UX & Wireframe Flow — 78 / 100

### 3.1 Yang Logis

- Onboarding Flow (3 slide → Sign In/Up) clean dan konvensional.
- Auth flow (Sign Up → Create Profile → Fill Profile) terpisah jadi 3 langkah mencegah form panjang.
- Forgot Password sebagai 1 rute + 3 sub-step dalam Cubit — smart pattern untuk Flutter, tidak menambah kedalaman navigasi.
- Main Shell dengan 4 branch `StatefulShellRoute.indexedStack` — state per-tab terjaga dengan benar.
- Booking flow happy path (Home → Search → Detail → Book → Success) ≤ 5 tap, dengan edge case (slot conflict, expired) sudah dimitigasi.
- Status badge (Pending=Kuning, Upcoming=Hijau, Completed=Biru, Cancelled=Merah/Abu) aksesibel untuk color-blind sebagian.
- Empty state di Home, Search, History sudah didefinisikan dengan CTA eksplisit.

### 3.2 Yang Perlu Diperbaiki

| # | Masalah | Dampak ke Development Flutter | Severity |
|---|---|---|---|
| 1 | Date picker muncul 2x — di Doctor Detail (`09-doctor-detail.md`) dan Book Appointment (`10-book-appointment.md`) — bisa membingungkan user dan duplikasi logic | Perlu sinkronisasi state antar 2 page via `extra` param | High |
| 2 | Wireframe 06 Home menyebut "Bottom Nav: Home | Explore | Booking | Profile" — tidak cocok dengan PRD (4 tab) | Inkonsistensi langsung di UI builder | High |
| 3 | Home terlalu padat (Banner + Upcoming + Categories + Nearby + Bottom Nav) — scroll panjang, banyak API call paralel | Potensi bottleneck loading & memory | Medium |
| 4 | Toggle Notifikasi di Profile + sub-menu Notification — ambigu fungsi (reminder booking vs push umum?) | Perlu pemisahan state yang jelas | Medium |
| 5 | Doctor Detail tidak menampilkan jumlah slot tersedia per hari di date chip — user harus tap dulu untuk tahu availability | UX friction, BRD klaim "seamless" terlanggar | Medium |
| 6 | Book Appointment menampilkan full date picker padahal tanggal sudah dipilih di Detail. Default value, tidak perlu picker penuh | UI tidak efisien | Medium |
| 7 | Tidak ada loading skeleton di wireframe selain shimmer — fragmentasi loading UX | Implementasi loading state tidak standar. **Resolved:** ADR Skeletonizer menetapkan `skeletonizer: ^1.4.0` sebagai standard. shimmer DEPRECATED. | Low |
| 8 | Bottom Sheet konfirmasi di Book Appointment redundan dengan summary card di atas — user mengkonfirmasi hal yang sama 2x | Tap tambahan, menurunkan "seamless" claim | Low |
| 9 | No Internet page — `21-no-internet.md` adalah fallback generik, tapi flow diagram menunjukkan redirect ke `/no-internet` dari 4 lokasi berbeda. Perlu strategi cache per-fitur | Risk: poor offline UX, meski sudah di-address di NFR §11 | Low |
| 10 | Iconografi pakai emoji (🏠 📍 📋 👤) — emoji rendering tidak konsisten di Android vs iOS (terutama iOS) | Visual inconsistency | Low |
| 11 | Tidak ada empty/loading/error state untuk sub-pages: Edit Profile, Favorite, Settings, Help, T&C | Implementasi akan bersifat tebak-tebakan | Medium |

---

## 4. Poin Perbaikan Produk

### 4.1 HIGH Priority (Blokir Sprint 1)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| H1 | Selesaikan inkonsistensi API endpoint antara wireframe Home dan API Contract | Flutter Readiness | `06-home.md`, `api_contract_health_pal.md` | Tambah endpoint `GET /rest/v1/appointments?status=in.(pending,upcoming)&limit=1&order=slot_date.asc` untuk Upcoming Card. Tambah `POST /functions/v1/nearby-facilities` atau ganti ke `get_nearby_clinics` RPC. |
| H2 | Fix duplikat Section 7 di API Contract | Dokumentasi | `api_contract_health_pal.md` baris 1536+ | Hapus duplikat; konsolidasi "Facility" → "Clinic" (sesuai ERD) |
| H3 | Selaraskan "Booking < 3-tap" BRD (lama) dengan flow aktual | Bisnis | `brd_health_pal.md` §2, `prd_health_pal.md` §7 | Revisi klaim: ganti jadi "< 5 tap" atau redesign Home dengan Quick Book dari Favorites. Update KPI. |
| H4 | Tambah wireframe untuk halaman yang hilang: Onboarding 3 slide detail, Edit Profile, Notification Settings, Settings, Help, T&C, Booking Success | UX/Wireframe | `docs/wireframe/` | Minimal 1 wireframe per halaman. Format konsisten dengan wireframe 06–17. |
| H5 | Konsolidasi Date Picker (hanya di Book Appointment, Doctor Detail cukup info teks) | UX/Wireframe | `09-doctor-detail.md`, `10-book-appointment.md` | Hapus date picker dari Detail; tampilkan "Tersedia: 5 slot" per tanggal. Pilih tanggal hanya di halaman Book. |
| H6 | Fix inkonsistensi Bottom Nav antara PRD/User Flow dan Wireframe 06 | UX/Wireframe | `06-home.md` | Ganti `Explore` → `Loc` agar match dengan PRD dan route. |

### 4.2 MEDIUM Priority (Sprint 1–2)

| ID | Judul | Kategori | File Target | Rekomendasi |
|---|---|---|---|---|
| M1 | Tambah Business Rule untuk Dokter & Admin Klinik (sekalipun v1.0 fokus pasien) | Bisnis | `brd_health_pal.md` §3 | Dokumentasikan secara eksplisit bahwa portal dokter/admin **post-MVP**. Tambahkan timeline. |
| M2 | Tracking kemitraan klinik (KPI 50 mitra) | Bisnis | `prd_health_pal.md` §6.3 | Tambah minimal kolom `is_partner` di tabel `clinics` + flag di Loc Tab untuk highlight klinik partner. |
| M3 | Konsolidasi Cubit di Home Page | Flutter Readiness | `06-home.md`, `tdd/01-arsitektur.md` | Satukan jadi 1 `HomeCubit` dengan multi-section state, atau gunakan `MultiBlocProvider` dengan 1 coordinator. |
| M4 | Standarkan naming BLoC/Cubit | Flutter Readiness | `tdd/01-arsitektur.md` | Pilih: semua `Bloc` atau semua `Cubit` sesuai kompleksitas. Rename `OnboardingNotifier` → `OnboardingCubit`. |
| M5 | Definisikan Design System mini (font, color, radius, padding, touch target) | UX/Wireframe | `docs/wireframe/00-design-system.md` (baru) | Buat dokumen singkat: typography scale, color palette (sesuai status badge), spacing 4/8 grid, touch target 48dp. |
| M6 | Bedakan toggle "Reminder Booking" vs "Push Notification" di Profile | UX/Wireframe | `14-profile.md`, `17-notification-settings.md` | Rename menu: "Notifikasi" (master toggle) + "Reminder" (sub-toggle). |
| M7 | Tampilkan jumlah slot tersedia per tanggal di Doctor Detail | UX/Wireframe | `09-doctor-detail.md` | Misal: "Sen, 15 Jun • 8 slot" untuk user info cepat. |
| M8 | Mapping snake_case ↔ camelCase didokumentasikan eksplisit | Flutter Readiness | `tdd/01-arsitektur.md` | Tambahkan strategi: pakai `fromJson`/`toJson` di Model layer saja, Entity di domain tetap camelCase. |
| M9 | Empty/loading/error state untuk semua sub-pages Profile | UX/Wireframe | `docs/wireframe/15–20*.md` | Tambah pattern konsisten. |
| M10 | Tambah wireframe Onboarding 3 slide | UX/Wireframe | `docs/wireframe/01-onboarding.md` | Saat ini hanya ada title, belum ada layout. |

### 4.3 LOW Priority (Sprint 2–3, Polish)

| ID | Judul | Kategori | Rekomendasi |
|---|---|---|---|
| L1 | Ganti emoji icon bottom nav dengan icon set proper (Material Symbols) | UX | Bundle `flutter_icons` atau pakai Flutter built-in `Icons`. Update wireframe. |
| L2 | Konsolidasi "Simulasi" badge di Book Appointment — pakai pattern chip seragam | UX | Samakan style dengan status badge. |
| L3 | Hapus bottom sheet konfirmasi yang redundan di Book Appointment | UX | Konfirmasi inline via `AlertDialog` saja, atau langsung submit dengan snackbar undo. |
| L4 | Tambah "Bahasa" filter di Doctor Detail (PRD §6.4 menyebut "bahasa konsultasi" tapi tidak ada filter) | UX/PRD | Tambah filter bahasa atau hapus dari list elemen jika belum supported. |
| L5 | Pertimbangkan deep linking untuk banner promo (`action_url` di API sudah ada, belum ada handler di Flutter) | Flutter Readiness | Tambah `app_links` package handling di `app_router.dart`. |
| L6 | Tambah "Lihat Peta" inline mini-map di Doctor Detail (bukan link external) | UX | Tingkatkan konversi booking dengan visual context. |
| L7 | Standarkan placeholder loading | Flutter Readiness | **RESOLVED:** ADR Skeletonizer — `skeletonizer: ^1.4.0` adalah satu-satunya solusi. shimmer DEPRECATED. Dokumentasi di AGENTS.md §Skeleton Loading Rule. |
| L8 | Review apakah `BookingHistoryCubit` perlu di-rename jadi `BookingHistoryBloc` (sesuai TDD tabel 5.4) | Dokumentasi | Pilih satu konvensi. |

---

## 5. Rekomendasi Strategis (Tambahan)

1. **Sebelum Sprint 1**: Lock down design system mini (typography, color, spacing) — wireframe tanpa token ini akan menghambat paralelisme antar developer.

2. **Definisikan "Done" per fitur** — TDD 10 (testing) menyebut acceptance, tapi belum ada checklist visual completeness (semua state: loading/empty/error/success).

3. **Risiko timeline 20 minggu** — dengan 6 endpoint Edge Function + 19 endpoint total + 6 fitur + FCM integration + Maps + kompleksitas RLS, MVP 10 minggu terasa optimistic. Pertimbangkan cut 1 P3 ke v1.1: **(a) Quick Categories**, **(b) Notification inbox UI** (API sudah siap, UI bisa ditunda).

4. **Compliance check** — PRD §11 sudah sebut RLS, tapi belum ada wireframe/flow untuk **user consent** (UU PDP) saat pertama kali membuka Profile/Edit. Tambah 1 langkah consent di Onboarding.

5. **Pertimbangkan App Clip / Instant App** untuk Android — flow Home → Search → Detail bisa di-trigger dari push notification banner promo (saat user tap notifikasi). Meningkatkan re-engagement.

---

## 6. Verdict

**Health Pal sudah punya fondasi produk yang solid (78/100) untuk lanjut ke implementasi.**

- Arsitektur teknis dan strategi state management siap.
- Alur utama logis dan konvensional.
- 6 blocker High Priority harus diselesaikan sebelum Sprint 1 dimulai (khususnya H1, H2, H6).
- Inkonsistensi minor antar dokumen perlu dirapikan dalam 1 sprint dokumentasi.

Setelah 6 poin High di-address, estimasi skor akan naik ke **86–88/100** dan proyek siap masuk fase development dengan risiko teknis rendah.

---

## 7. Action Items Ringkas

| # | ID | Tindakan | Owner (Rekomendasi) | Target |
|---|---|---|---|---|
| 1 | H1, H2 | Fix API Contract duplikat + tambah endpoint Home | Backend Lead | Sebelum Sprint 1 |
| 2 | H3 | Revisi KPI "Booking < 3-tap" (lama) di BRD/PRD | Product Manager | Sebelum Sprint 1 |
| 3 | H4 | Lengkapi 7 wireframe yang hilang | UI/UX Designer | Sprint 1 (minggu 1–2) |
| 4 | H5, H6 | Redesign Doctor Detail & Home bottom nav | UI/UX Designer | Sprint 1 (minggu 1) |
| 5 | M1, M2 | Update BRD & ERD untuk partner clinic tracking | Product Manager + DB Architect | Sprint 1 (minggu 1) |
| 6 | M3, M4, M8 | Refactor state management & naming | Tech Lead | Sprint 1 (minggu 2) |
| 7 | M5 | Buat design system mini | UI/UX Designer | Sprint 1 (minggu 1) |
| 8 | M6, M7 | Redesign Profile toggle & Doctor Detail slot count | UI/UX Designer | Sprint 2 |
| 9 | M9, M10 | Lengkapi state & wireframe Onboarding | UI/UX Designer | Sprint 2 |
| 10 | L1–L8 | Polish & konsistensi | Frontend Dev | Sprint 3 |

---

*Dokumen ini merupakan audit snapshot. Setiap perubahan besar pada BRD/PRD/ERD/API Contract/Wireframe harus memicu re-audit untuk menjaga alignment skor di atas 80/100.*
