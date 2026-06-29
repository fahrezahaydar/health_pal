# Appointment Card Redesign — Fix List

**Tanggal:** 29 Juni 2026
**Referensi:** ADR-012, `docs/wireframe/22-appointment-card.md`, `docs/progress/appointment_card_redesign_plan.md`

---

## Verifikasi Awal (STEP 2)

### Select Clause `clinics(name)` — ✅ SUDAH ADA

Plan §3.2 dan §8 menanyakan apakah `getAppointmentHistory` select clause sudah include `clinics(name)`. Verifikasi kode aktual:

```dart
// booking_remote_datasource.dart:68
'*, doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(name, address, phone)), doctor_slots(slot_date, slot_start, slot_end)',
```

✅ **Sudah include `clinics(name, address, phone)`.** Tidak perlu perubahan di API/data layer. FIX untuk "tambah clinics(name)" dihapus dari fix list.

### Kesesuaian Entity — ✅ SUDAH LENGKAP

| Field yang dibutuhkan wireframe | Sumber di Entity | Status |
|-------------------------------|-------------------|--------|
| `appointment.dateTime` | `slot?.slotDate` + `slot?.startTimeDisplay` | ✅ |
| `appointment.status` | `status` field | ✅ |
| `doctor.photo` (2:3) | `doctor?.photoUrl` | ✅ |
| `doctor.name` | `doctor?.fullName` | ✅ |
| `doctor.specialization` | `doctor?.specializationName` | ✅ |
| `clinic.name` | `doctor?.clinicName` | ✅ |

### Status Badge Existing — PERLU UPDATE

`status_badge.dart` saat ini pakai warna: Pending=grey, Upcoming=paleGreen, Completed=paleBlue, Canceled=lightPink. ADR-012 mensyaratkan: Pending=Orange, Upcoming=Blue, Completed=Green, Canceled=Red.

### AppointmentCard Existing — PERLU REWRITE TOTAL

`appointment_card.dart` v1.0: single row, circle 48px photo, tanpa action buttons. Harus di-rewrite ke v2.0.

### BookingHistoryPage Existing — PERLU UPDATE

`booking_history_page.dart` saat ini pass `onTap` saja ke `AppointmentCard`. Setelah rewrite, perlu pass `onCancel` dan `onReBook`.

---

## Todo Fix List

| # | Item | Kategori | File Target | Severity | Status |
|---|------|----------|-------------|:--------:|:------:|
| **1** | **Update `StatusBadge` colors** sesuai ADR-012: Pending=Orange (`#FF9800`), Upcoming=Blue (`#2196F3`), Completed=Green (`#4CAF50`), Canceled=Red (`#EF5350`). Update background + text colors. | Flutter | `lib/widgets/card/status_badge.dart` | 🟡 Medium | ⬜ |
| **2** | **Rewrite `AppointmentCard`** ke layout v2.0 — multi-row Column: HeaderRow (DateTime + StatusBadge), Divider, DoctorInfoRow (AspectRatio 2:3 photo + name/specialization/clinic), Divider, ActionRow (2 buttons conditional per status). Action buttons: Cancel (Pending/Upcoming) call `onCancel`, Re-Book (Completed) call `onReBook`. Reschedule/Change Date/Add Review **disembunyikan** (ADR-012 §6 — deferred). | Flutter | `lib/widgets/card/appointment_card.dart` | 🟡 Medium | ⬜ |
| **3** | **Update `BookingHistoryPage`** — pass `onCancel` dan `onReBook` callbacks ke `AppointmentCard`. `onCancel` → panggil `BookingDetailCubit.cancelAppointment` (via RPC) + `BookingHistoryCubit.refresh()` setelah sukses. `onReBook` → `context.push('/booking/:doctorId', extra: {doctorId, doctorName, consultationFee})`. | Flutter | `lib/features/booking/presentation/page/booking_history_page.dart` | 🟡 Medium | ⬜ |
| **4** | **Update `AppointmentCard.skeleton()`** — sesuaikan layout skeleton dengan widget v2.0 yang baru (header row, photo placeholder 2:3, action row placeholder). | Flutter | `lib/widgets/card/appointment_card.dart` (skeleton factory) | 🟢 Low | ⬜ |
| **5** | **Final QA** — `flutter analyze` 0 issues, visual match dengan `docs/wireframe/22-appointment-card.md`, tap Cancel → RPC success → list refresh, tap card → navigasi ke detail, tap Re-Book → navigasi ke booking. | Flutter | (all files above) | 🟡 Medium | ⬜ |

### Item yang TIDAK Masuk Fix List (Out of Scope per ADR-012)

| Item | Alasan | Referensi |
|------|--------|-----------|
| `clinics(name)` di select clause | ✅ **Sudah ada** di kode | Plan §3.2, §8 |
| Reschedule / Change Date (Pending) | ❌ **Defer** — tombol disembunyikan | ADR-012 §6 |
| Reschedule (Upcoming) | ❌ **Defer** — tombol disembunyikan | ADR-012 §6 |
| Add Review (Completed) | ❌ **Defer** — tombol disembunyikan | ADR-012 §6 (konsisten ADR-009) |
| HomePage `UpcomingAppointmentCard` | ❌ **Tidak tersentuh** — widget terpisah | ADR-012 §Decision #7 |

---

## Aturan Eksekusi

1. Satu FIX dikerjakan per perintah "fix N" (misal "fix 1" untuk StatusBadge colors).
2. Setiap FIX selesai → `flutter analyze` dipastikan 0 issues.
3. Setiap FIX selesai → update checkbox di tabel ini dari ⬜ ke ✅ + commit dengan conventional message: `fix(flutter): appointment card redesign FIX#N — description`.
4. **Tidak ada file test** yang dibuat — sesuai testing policy di AGENTS.md (Sprint 1 — Testing Policy).
5. Urutan pengerjaan WAJIB sesuai nomor FIX (dependency: #2 membutuhkan #1 selesai, #3 membutuhkan #2 selesai).
6. FIX #4 bisa digabung dengan #2 (skeleton di dalam file yang sama).
7. FIX #5 adalah final QA — hanya verify, tidak ada kode baru.

---

*Dibuat: 29 Juni 2026 · Referensi: ADR-012, Wireframe v2.0, Plan appointment_card_redesign_plan.md*
