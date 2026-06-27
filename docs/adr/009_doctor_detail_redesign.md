# ADR 009: Doctor Detail Page Redesign v2.0

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 28 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Database (1 migration), Data Layer (DoctorModel/Entity), DataSource (1 new method), Presentation Layer (full page rewrite), 5 new widget files |

---

## 1. Konteks

Halaman Doctor Detail (`doctor_detail_page.dart`) saat ini mengimplementasi wireframe v1.0.1 dengan layout: DoctorCardDetail, Info Card (Pendidikan, Pengalaman, Klinik, Biaya), Slot Availability preview, dan Reviews placeholder. Layout ini memiliki beberapa kekurangan berdasarkan evaluasi UX:

| Aspek | v1.0.1 | Masalah |
|-------|--------|---------|
| **Header dokter** | Foto lingkaran 80px | Tidak proporsional; wireframe baru pakai 2:3 (portrait) |
| **Informasi** | Tercampur dalam satu Info Card | Tidak scalable; setiap tambahan info (stats, working time) bikin card makin panjang |
| **Stats** | Tidak ada | User perlu informasi cepat: jumlah pasien, pengalaman, rating, ulasan — tanpa scroll panjang |
| **About/Bio** | Tersembunyi di Info Card | Bio dokter perlu section sendiri dengan "View More" expandable |
| **Working Time** | Tidak ada | User tidak bisa lihat jam praktik tanpa buka halaman booking |
| **Reviews** | Placeholder "Fitur ulasan datang di v1.1" | Wireframe baru punya Reviews header dengan "See All" — tapi daftar review individual di-defer |
| **Slot preview** | Menampilkan 5 sample slot | Menambah kompleksitas scroll; slot dipilih penuh di halaman Booking |

### Field Audit

Berdasarkan perbandingan wireframe v2.0 dengan ERD, API Contract, dan implementasi aktual, ditemukan gap berikut:

| Field | Wireframe v2.0 | ERD/API Saat Ini | Kategori |
|-------|----------------|------------------|----------|
| Doctor name | ✅ Dr. David Patel | `doctors.full_name` ✅ | A |
| Doctor photo | ✅ Photo 2:3 | `doctors.photo_url` ✅ | A |
| Specialization | ✅ Cardiologist | `specializations.name` (nested) ✅ | A |
| Hospital/Clinic | ✅ Golden Cardiology Center + pin | `clinics.name` + `clinics.address` (nested) ✅ | A |
| Rating | ✅ 5 (⭐) | `doctors.rating_avg` ✅ | A |
| Review count | ✅ 1,872 | `doctors.rating_count` ✅ | A |
| Experience | ✅ 10+ tahun | `doctors.experience_years` ✅ | A |
| About/Bio | ✅ Expandable "View More" | `doctors.description` ✅ | A |
| Favorite toggle | ✅ ♡ button | Local state (existing) ✅ | A |
| **Patient count** | ❌ 2,000+ | **Belum ada** di DB/Model/Entity | **C** |
| **Working time** | ❌ Monday–Friday, 08:00–18:00 | `doctor_schedules` **sudah ada** di DB tapi **belum di-fetch** oleh data layer | **B** |
| Individual reviews | ⏳ (Deferred) | `reviews` table (ERD future) | Out of Scope |

**Kategori:**
- **A** — Sudah ada di DB + API + kode (tidak perlu kerja apapun)
- **B** — Sudah ada di DB tapi belum di-expose di API/kode
- **C** — Belum ada di DB sama sekali — perlu migration baru

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: Redesign penuh — migration DB + data layer + UI baru (DIUSULKAN)

Implementasi wireframe v2.0 secara lengkap: tambah kolom `total_patients` di DB, expose `doctor_schedules` ke data layer, rewrite DoctorDetailPage dengan widget baru.

**Pro:**
- Satu sprint — semua fitur sekaligus, tidak ada partial implementation.
- Konsisten dengan wireframe — user experience sesuai desain.
- Semua field baru langsung terpakai.

**Kontra:**
- Perubahan besar di satu sprint — risiko regression lebih tinggi.

### Opsi B: Partial — UI baru tanpa patient_count dan working_time

Implementasi widget baru tapi hanya pakai field yang sudah ada. Patient count dan working time diskip.

**Pro:**
- Zero DB change — migrasi nol.
- Cepat deliver.

**Kontra:**
- Wireframe tidak lengkap — patient count dan working time muncul sebagai placeholder/stub.
- UX tidak sesuai desain — user tidak bisa lihat jam praktik dan jumlah pasien.

### Opsi C: Hanya update UI — tetap pakai layout lama

Pertahankan struktur v1.0.1, hanya update styling minor.

**Pro:**
- Minimal effort.

**Kontra:**
- Tidak mengatasi masalah yang sudah diidentifikasi.
- Wireframe obsolete — dokumen tidak sinkron dengan implementasi.
- Tidak scalable untuk penambahan fitur ke depan.

---

## 3. Keputusan

**Pilih Opsi A: Redesign penuh Doctor Detail Page v2.0.**

### Detail Keputusan

1. **Database Migration** — Tambah kolom `total_patients INT4 DEFAULT 0` di tabel `doctors`.
2. **DoctorModel/Entity** — Tambah field `totalPatients` (int), tambah field `schedules` (List of schedule data).
3. **DataSource** — `getDoctorDetail` perlu include `doctor_schedules` di query select. Jika PostgREST tidak support nested array dengan `single()`, buat method terpisah atau fallback query.
4. **Data Layer** — Buat model `DoctorScheduleModel` + entity `DoctorScheduleEntity` jika diperlukan (atau cukup derived `workingTimeDisplay` string di entity).
5. **Hapus dari DoctorDetailPage:**
   - `DoctorCardDetail` widget — diganti dengan `DoctorInfoCard`.
   - Info Card (Pendidikan, Pengalaman, Klinik, Biaya) — dipecah ke komponen terpisah.
   - Slot availability preview (SS#10) — dipindah atau dihapus sesuai wireframe.
   - Reviews placeholder — diganti dengan ReviewsHeader (deferred content).
6. **Tambah di DoctorDetailPage:**
   - `DoctorInfoCard` — foto 2:3, nama, divider, spesialisasi, hospital row.
   - `DoctorStatsRow` — 4 StatItem (Patients, Experience, Rating, Reviews).
   - `AboutSection` — section title, description, "View More" expandable.
   - `WorkingTimeSection` — section title, schedule text.
   - `ReviewsHeader` — "Reviews" title + "See All" button (content deferred).
7. **Reviews section** — Header dan tata letak diimplementasikan, tapi konten daftar review individual (ReviewCard) di-defer ke sprint mendatang. State penuh section ini sebagai empty/placeholder.
8. **AppBar** — Ubah title menjadi "Doctor Details" (atau "Detail Dokter" tergantung lokal), hapus Share button, pertahankan Favorite + Back.

### Skema Data Baru

```sql
-- Migration: tambah kolom total_patients
ALTER TABLE doctors ADD COLUMN total_patients INT4 NOT NULL DEFAULT 0;

-- Comment: Denormalized field — bisa di-update via trigger atau manual
COMMENT ON COLUMN doctors.total_patients IS 'Total pasien yang pernah ditangani (display only)';
```

```dart
// DoctorEntity — field baru
class DoctorEntity extends Equatable {
  // ... existing fields ...
  final int totalPatients;
  final List<DoctorScheduleEntity>? schedules;
  final String? workingTimeDisplay;

  const DoctorEntity({
    // ... existing params ...
    this.totalPatients = 0,
    this.schedules,
    this.workingTimeDisplay,
  });
}
```

---

## 4. Alasan

1. **Konsistensi dengan wireframe v2.0** — Satu source of truth untuk desain halaman Detail Dokter.
2. **Patient count sebagai denormalized field** — Query untuk menghitung jumlah unique pasien dari appointments setiap kali render tidak efisien. Denormalized `total_patients` cukup di-update periodik (scheduled job atau trigger).
3. **Working time dari doctor_schedules** — Tabel sudah ada di ERD sejak awal. Tinggal di-query dan diformat di data layer. Tidak perlu migration baru.
4. **Stats Row sebagai entry point informasi** — Empat metrik (patients, experience, rating, reviews) memberi user gambaran cepat tentang dokter + kredibilitas.
5. **About Section expandable** — Bio dokter bisa panjang; "View More" mencegah scroll overload sambil tetap menyediakan akses ke informasi lengkap.
6. **Pisah Reviews header dari content** — User tetap bisa lihat bahwa section Reviews ada (dengan "See All"), tapi konten individual di-defer. Tidak ada placeholder broken.
7. **Hapus slot preview dari Doctor Detail** — Slot dipilih penuh di halaman Booking (konsisten dengan SS#10 yang menghapus date picker). Detail Dokter fokus pada identitas dan kredibilitas dokter, bukan jadwal.

---

## 5. Konsekuensi

### Positif

- ✅ Wireframe v2.0 terimplementasi penuh — user experience sesuai desain.
- ✅ Info penting (stats, working time) muncul tanpa scroll panjang.
- ✅ Bio dokter expandable — tidak boros ruang.
- ✅ Reviews section ready untuk sprint berikutnya — tinggal tambah content.
- ✅ Patient count siap untuk future auto-calculation via trigger.
- ✅ Working time sudah di DB — tidak perlu migration baru untuk tabel schedules.

### Negatif

- ⚠️ **1 migration SQL baru** — tambah kolom `total_patients`.
- ⚠️ **Breaking change** — `DoctorDetailPage` layout total berubah; semua widget terkait perlu rewrite.
- ⚠️ **DataSource perubahan** — `getDoctorDetail` perlu include `doctor_schedules`; ini bisa nambah response size.
- ⚠️ **DoctorCardDetail** — Widget ini cuma dipakai di Doctor Detail Page; jika di-refactor, widget ini bisa dihapus atau diadaptasi.
- ⚠️ **DoctorStatsRow membutuhkan 4 icon spesifik** — Pasien (👥), Experience (🎖), Rating (⭐), Reviews (💬). Icon Material harus dipilih yang paling mendekati.
- ⚠️ **DoctorInfoCard foto 2:3** — Ini berbeda dari foto lingkaran 80px di v1.0.1. Layout card berubah total.

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| `doctor_schedules` tidak bisa di-include via PostgREST `select` dengan `.single()` | Gunakan query terpisah (parallel fetch) — `getDoctorDetail` dan `getDoctorSchedules` paralel di Cubit. Tidak signifikan menambah latency. |
| `total_patients` = 0 untuk semua dokter setelah migration | Sesuai — seed data tidak punya field ini. Admin bisa update manual atau via trigger nanti. Untuk MVP, tampilkan "0" atau "N/A". |
| Layout foto 2:3 merusak skeleton loading | Pastikan Skeletonizer mock data sudah include `totalPatients` dan `workingTimeDisplay`. Reuse production widget via Skeletonizer (pattern ADR-001). |
| Working time display logic kompleks (multiple day ranges) | Untuk MVP, cukup tampilkan daftar hari + jam kerja dalam format text sederhana. Jika ada gap (misal Senin-Jumat 08:00-18:00, Sabtu 08:00-12:00), tampilkan sebagai list. |
| 4 icon stats tidak cocok persis dengan emoji wireframe | Fallback ke Material Icons yang paling mendekati. Tambah TODO untuk swap ke iconsax (lihat Icon Convention di AGENTS.md). |

---

## 6. Compliance

| Mekanisme | Detail |
|-----------|--------|
| **Wireframe** | `docs/wireframe/09-doctor-detail.md` — v2.0 |
| **ADR ini** | Dokumen keputusan arsitektur |
| **Todo List** | `docs/progress/doctor_detail_redesign_plan.md` |
| **Code Review** | WAJIB cek: (1) layout match wireframe v2.0, (2) DoctorStatsRow tampil benar dengan 4 icon, (3) AboutSection expandable, (4) WorkingTimeSection dari data `doctor_schedules`, (5) Reviews section header tanpa konten individual |
| **Skeletonizer (ADR-001)** | Loading state wajib pakai Skeletonizer + reuse production widget |
| **CachedNetworkImage (ADR-006)** | Foto dokter wajib pakai `AppNetworkImage` |
| **Reusable Widgets (ADR-008)** | WAJIB pakai `AppNetworkImage` untuk network image, DILARANG inline `CachedNetworkImage` |

---

## 7. Out of Scope

Fitur **Reviews (daftar review individual)** — termasuk ReviewCard, ReviewerAvatar, RatingRow, ReviewText — sengaja **tidak dimasukkan** dalam ADR ini. Fitur ini membutuhkan:

- Migration tabel `reviews` (sudah ada di ERD sebagai future table)
- Endpoint baru `GET /rest/v1/reviews?doctor_id=eq.<id>`
- Data layer: ReviewModel, ReviewEntity
- UI: ReviewCard widget, infinite scroll / pagination
- Trigger update `rating_avg` dan `rating_count` di `doctors`

ADR terpisah akan dibuat saat sprint yang menangani fitur Reviews tiba. Hanya Reviews header (title + "See All" button) yang masuk scope ADR ini — sebagai placeholder visual.

---

## 8. Referensi

- Wireframe: `docs/wireframe/09-doctor-detail.md` — v2.0
- ERD: `docs/erd/erd_healh_pal.md` — tabel `doctors`, `doctor_schedules`, `clinics`
- API Contract: `docs/api_contract/api_contract_health_pal.md` — §5.3 Get Detail Dokter
- PRD: `docs/product/prd_health_pal.md` — §6.4 Detail Dokter
- ADR 001: Skeletonizer — standarisasi loading skeleton
- ADR 005: Clinic Card Redesign — pattern stats row reference
- ADR 006: CachedNetworkImage — standarisasi network image
- ADR 007: Doctor Card Redesign — konsistensi field rating, reviewCount, isFavorite
- ADR 008: Standarisasi Placeholder Widget — `AppNetworkImage`
- Existing Widget: `lib/widgets/card/doctor_card_detail.dart`
- Current Page: `lib/features/doctor/presentation/page/doctor_detail_page.dart`
- Todo List: `docs/progress/doctor_card_redesign_todo.md`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*
