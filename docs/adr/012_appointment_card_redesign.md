# ADR 012: Appointment Card Redesign v2.0

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 29 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Widget (`AppointmentCard`), Page (`BookingHistoryPage`, `HomePage`), entity `AppointmentEntity`, data source select clause, 1 wireframe baru (`22-appointment-card.md`), 1 wireframe update (`12-booking-history.md`) |

---

## 1. Konteks

Appointment Card v1.0 (terdefinisi di `lib/widgets/card/appointment_card.dart` dan `docs/wireframe/12-booking-history.md`) memiliki layout:

```
┌─ Appointment Card v1.0 ────────────┐
│ 👤 dr. Budi Santoso              🟡│
│    Klinik Sehat Bersama            │
│    15 Jun 2026 • 09:00 - 09:30    │
└────────────────────────────────────┘
```

Setelah evaluasi UX dan alignment dengan wireframe baru, ditemukan beberapa kekurangan:

| Aspek | v1.0 | Masalah |
|-------|------|---------|
| **Action buttons** | ❌ Tidak ada | User tidak bisa cancel/reschedule langsung dari history — harus masuk detail dulu |
| **Foto dokter** | Circle 48px (1:1 crop) | Tidak konsisten dengan Doctor Detail Page yang pakai 2:3. Foto terlalu kecil untuk card lebar. |
| **Date/Time** | Inline di info column | Kurang prominent — seharusnya visible pertama kali dilihat |
| **Specialization** | ❌ Tidak ada | User harus masuk detail untuk lihat spesialisasi |
| **Clinic name** | Tanpa icon lokasi | Kurang informatif dibanding row dengan icon 📍 |
| **Header/divider** | ❌ Tidak ada | Tanpa struktur visual, card terlihat flat |

### Referensi Desain Baru

Wireframe `22-appointment-card.md` mendefinisikan card multi-row dengan header (date + badge), divider, doctor info (photo 2:3 + name/specialization/clinic), divider, dan action buttons.

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: Redesign AppointmentCard — multi-row, 2:3 photo, action buttons (DIUSULKAN)

Satu widget `AppointmentCard` v2.0 untuk Booking History List + Home Page Upcoming section.

- **Pro:** Layout informatif — date+badge di header, action buttons langsung visible.
- **Pro:** Foto 2:3 konsisten dengan Doctor Detail Page (`DoctorInfoCard` pakai square 96x96, tapi `DoctorDetailPage` wireframe mensyaratkan 2:3).
- **Pro:** Action buttons per status — user bisa cancel/re-book tanpa tap ke detail.
- **Pro:** Satu widget untuk history + home — zero duplikasi layout.
- **Kontra:** Breaking change untuk `AppointmentCard` — semua consumer perlu update.

### Opsi B: Split — AppointmentCardHistory + AppointmentCardHome

Widget terpisah untuk konteks history (dengan action buttons) dan home (tanpa action buttons, compact).

- **Pro:** Masing-masing optimal untuk konteksnya (home card bisa lebih compact).
- **Kontra:** Duplikasi layout ~70%.
- **Kontra:** Maintenance overhead — perubahan layout harus di-sync ke 2 widget.
- **Kontra:** Tidak konsisten dengan pendekatan satu widget untuk satu komponen.

### Opsi C: Minimal change — hanya tambah action buttons

Pertahankan layout row v1.0, cukup tambah action buttons di bawah info.

- **Pro:** Minimal change — foto tetap circle 48px, layout sama.
- **Kontra:** Foto 48px terlalu kecil untuk proporsi card lebar (inkonsisten dengan DoctorCard 108x108).
- **Kontra:** Tidak mengatasi masalah header/specialization/clinic prominence.
- **Kontra:** Layout row jadi terlalu panjang vertikal (foto kecil + info + action buttons).

---

## 3. Keputusan

**Pilih Opsi A: Redesign AppointmentCard ke v2.0 — multi-row layout, 2:3 photo, action buttons per status.**

### Detail Keputusan

1. **Layout:** Column multi-row — Header (date + badge), Divider, Doctor Info (Row: photo 2:3 + name/specialization/clinic), Divider (jika ada actions), Action Buttons (jika status != cancelled).

2. **Doctor Photo: 2:3 aspect ratio.** Alasan:
   - Wireframe Appointment Card mensyaratkan 2:3 — konsisten dengan Doctor Detail Page yang juga mensyaratkan foto proporsional (bukan lingkaran).
   - Berbeda dengan `DoctorCard` (ADR-007, 1:1 108x108) karena konteksnya berbeda: Doctor Card adalah identity card untuk list/search, Appointment Card adalah transaction card untuk history.
   - **Konsisten** dengan `DoctorInfoCard` di Doctor Detail Page yang juga square 96x96 (1:1) — tapi ini juga akan di-review di ADR terpisah.
   - **Keputusan tegas:** AppointmentCard pakai `AspectRatio(2/3)` dengan width ~80, height ~120. Tidak perlu konsisten dengan DoctorCard (1:1) karena context berbeda.

3. **Status Badge Colors — updated:**

   | Status | Before | After | Alasan |
   |--------|--------|-------|--------|
   | Pending | Amber `#FFA726` (🔴 duplikat dengan warna warn) | **Orange `#FF9800`** | Lebih kontras, standard "menunggu" |
   | Upcoming | Hijau `#4CAF50` (📊 salah — hijau untuk selesai) | **Blue `#2196F3`** | Biru = informasi jadwal akan datang (standard UX) |
   | Completed | Biru `#2196F3` (📊 salah — biru untuk info) | **Green `#4CAF50`** | Hijau = selesai/berhasil (standard UX) |
   | Canceled | Merah/Abu `#EF5350` | **Merah `#EF5350`** | Konsisten, merah tetap untuk pembatalan |

   **Rationale:** Status badge warna sebelumnya tidak konsisten dengan standard UX (hijau seharusnya "selesai", biru seharusnya "informasi"). Perubahan ini menyelaraskan dengan ekspektasi umum pengguna.

4. **Action Buttons — behavior untuk setiap status:**

   | Tombol | Behavior | Status Backend |
   |--------|----------|:--------------:|
   | **Cancel** | Panggil `cancel_appointment` RPC (sudah siap) | ✅ **Siap** |
   | **Change Date** (Pending) | 🔴 Navigasi ke halaman reschedule (placeholder) | ❌ **Defer** |
   | **Reschedule** (Upcoming) | 🔴 Navigasi ke halaman reschedule (placeholder) | ❌ **Defer** |
   | **Re-Book** (Completed) | Navigasi ke `DoctorDetailPage`/`BookAppointmentPage` dengan doctorId yang sama | ✅ **Existing flow** |
   | **Add Review** (Completed) | 🔴 Tombol visible tapi disabled/placeholder (konsisten ADR-009) | ❌ **Defer** |

5. **API Contract Update (§6.2 Get Booking History):** Tambah `clinics(name)` di nested select doctors agar clinic name tersedia di response. Saat ini select clause adalah `doctors(id,full_name,photo_url,specializations(name))` — perlu tambah `clinics(name)`.

### Widget Interface Baru (Proposed)

```dart
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    required this.appointment,
    this.onTap,
    this.onCancel,
    this.onReschedule,    // untuk Change Date + Reschedule
    this.onReBook,        // untuk Re-Book
    this.onAddReview,     // untuk Add Review (deferred)
  });

  final AppointmentEntity appointment;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onReBook;
  final VoidCallback? onAddReview;
}
```

---

## 4. Alasan

1. **Layout multi-row** — Informasi appointment disajikan dalam struktur yang jelas (header → doctor → actions), mirroring pola Clinic Card v2.0 dan Doctor Detail v2.0.
2. **Action buttons dari list** — Reduce tap count untuk cancel/action umum. User tidak perlu masuk ke detail untuk cancel appointment.
3. **Foto 2:3** — Proporsi foto lebih natural dan konsisten dengan detail page. Context AppointmentCard berbeda dengan DoctorCard (search/list identity vs transaction history).
4. **Status badge warna di-update** — UX lebih intuitif: biru = upcoming (informasi), hijau = completed (selesai), orange = pending (menunggu), merah = cancelled.
5. **Re-Book via existing flow** — Tidak perlu endpoint baru. `context.push('/booking/:doctorId')` reuse Book Appointment flow.
6. **Reschedule/Change Date di-defer** — Fitur ini membutuhkan endpoint backend baru dan validasi kompleks. Tidak blocking untuk release saat ini.

---

## 5. Konsekuensi

### Positif

- ✅ Layout informatif — header + doctor info + actions dalam 1 card.
- ✅ Action buttons dari list — reduce tap count untuk cancel/re-book.
- ✅ Foto 2:3 — proporsi lebih baik, konsisten dengan Doctor Detail.
- ✅ Status badge warna UX-correct — hijau=selesai, biru=informasi, orange=menunggu.
- ✅ Re-Book bisa reuse existing booking flow — zero backend change.
- ✅ Cancel sudah siap — BUG-006 FIX#4 selesai.

### Negatif

- ⚠️ **Breaking change** — `AppointmentCard` widget mengubah layout total. Consumer pages perlu update:
  - `booking_history_page.dart` — layout card berubah, parameter baru (onCancel, dll).
  - `home_page.dart` (UpcomingAppointmentCard) — jika memutuskan untuk reuse AppointmentCard.
- ⚠️ **Reschedule/Change Date tombol tampil tapi non-fungsional** — UX risk: user tap lalu lihat "Coming soon". Mitigasi: disabled button dengan snackbar info.
- ⚠️ **Add Review tombol non-fungsional** — Konsisten dengan ADR-009 (Reviews deferred). Sama mitigasi: disabled/snackbar.
- ⚠️ **API query update** — select clause untuk Get Booking History perlu tambah `clinics(name)`.

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| Foto 2:3 terlalu besar di card list | Set width ~80px (sedikit lebih besar dari v1.0 48px, tapi proporsional untuk 2:3 = 80x120). |
| Action buttons terlalu banyak tombol disabled | Untuk tombol deferred (Reschedule, Add Review) → disabled dengan snackbar "Fitur akan segera hadir". Atau sembunyikan saja sampai fitur siap. **Keputusan: sembunyikan** — wireframe menunjukkan tombol, tapi implementasi awal cukup yang sudah siap (Cancel, Re-Book). |
| Reschedule/Change Date tombol ada di wireframe tapi tidak diimplementasi | Catat di `docs/progress/appointment_card_redesign_plan.md` sebagai deferred. Saat fitur siap, cukup enable tombol + routing. |
| `clinics(name)` select tambahan bisa memperberat response | Tambahan minimal (1 kolom string) — tidak signifikan. |

---

## 6. Out of Scope

Fitur berikut **tidak** masuk implementasi Appointment Card v2.0, tapi wireframe-nya sudah menyertakan tata letak (button position). Tombol disembunyikan/di-disable sampai fitur siap:

- **Reschedule / Change Date** — Membutuhkan endpoint backend baru (`reschedule_appointment`). Validasi kompleks (slot availability, cancel window). Akan direncanakan di sprint mendatang dengan ADR terpisah.
- **Add Review** — Konsisten dengan ADR-009 (Doctor Detail Redesign). Fitur Reviews (input + display) di-defer ke sprint mendatang.
- **Visit Count** — Ditampilkan di wireframe Doctor Detail, belum diputuskan untuk Appointment Card.

---

## 7. Compliance

| Mekanisme | Detail |
|---|---|
| **Wireframe** | `docs/wireframe/22-appointment-card.md` — Appointment Card v2.0 |
| **Wireframe Update** | `docs/wireframe/12-booking-history.md` — status badge colors, component table |
| **ADR ini** | Dokumen keputusan arsitektur |
| **Plan** | `docs/progress/appointment_card_redesign_plan.md` |
| **Code Review** | WAJIB cek: (1) AppointmentCard layout match wireframe 22, (2) action button visibility per status, (3) status badge color update |

---

## 8. Referensi

- Wireframe: `docs/wireframe/22-appointment-card.md` — Appointment Card v2.0
- Wireframe: `docs/wireframe/12-booking-history.md` — Booking History Page (update)
- ADR 007: Doctor Card Redesign v2.0 — pattern reference
- ADR 009: Doctor Detail Redesign — pattern untuk deferred features (Reviews)
- Existing Widget: `lib/widgets/card/appointment_card.dart`
- Consumer Pages: `lib/features/booking/presentation/page/booking_history_page.dart`, `lib/core/router/app_router.dart`
- Audit: `docs/audit/appointment_backend_audit.md` — confirm cancel is ready
- Bug: `docs/bug/BUG-006-appointment-backend.md` — cancel implementation status

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*
