# Appointment Card Redesign — Implementation Plan

**Tanggal:** 29 Juni 2026
**Referensi:** ADR-012, wireframe v2.0 (`docs/wireframe/22-appointment-card.md`)

---

## 1. Database Changes (Backend)

| # | Item | SQL | Kategori | Dependency |
|---|------|-----|----------|------------|
| — | **Tidak ada perubahan tabel** | — | — | None |

**Tidak ada perubahan database.** Semua field yang dibutuhkan Appointment Card v2.0 sudah tersedia di tabel `appointments`, `doctors`, `doctor_slots`, `clinics`, `specializations`.

> **Catatan:** Reschedule/Change Date (deferred) akan membutuhkan migration baru jika diimplementasi nanti — ubah `slot_id` di appointment existing + validasi slot availability.

---

## 2. API Contract Update

| # | Item | Detail | Kategori |
|---|------|--------|----------|
| 1 | **Update `GET /rest/v1/appointments` select** (§6.2) | Tambah `clinics(name)` di nested doctors select agar clinic name tersedia di response list. Saat ini: `doctors(id,full_name,photo_url,specializations(name))` → `doctors(id,full_name,photo_url,specializations(name),clinics(name))` | B (data ada, select kurang) |

**Catatan:** §6.3 (Get Detail Appointment) sudah include `clinics(name,address,phone)` — tidak perlu perubahan.

---

## 3. Data Layer (Flutter)

### 3.1 Model & Entity Update

| # | Item | File Target | Kategori |
|---|------|-------------|----------|
| — | **Tidak ada perubahan model/entity** | — | — |

Semua field sudah tersedia di `AppointmentEntity`:
- `doctorName` ✅ (derived dari `doctor.fullName`)
- `specializationName` ✅ (derived dari `doctor.specializationName`)
- `clinicName` ✅ (derived dari `doctor.clinicName`) — perlu `clinics(name)` di select
- `doctorPhotoUrl` ✅ (derived dari `doctor.photoUrl`)
- `slotDate` + `startTimeDisplay` ✅ (derived dari `slot`)
- `status` ✅

### 3.2 DataSource Update

| # | Item | File Target | Kategori |
|---|------|-------------|----------|
| 1 | **Update `getAppointmentHistory` select** — tambah `clinics(name)` | `booking_remote_datasource.dart:68` | B |

**Current:**
```dart
'*, doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(name, address, phone)), doctor_slots(slot_date, slot_start, slot_end)',
```

> **Catatan:** Query ini sudah include `clinics(...)` — kemungkinan sudah di-update sebelumnya. Verifikasi aktual sebelum implementasi. Lihat §Catatan Query Aktual di bawah.

### 3.3 UseCase Update

| # | Item | File Target |
|---|------|-------------|
| — | **Tidak ada perubahan use case** | — |

### 3.4 DI Update

| # | Item | File Target |
|---|------|-------------|
| — | **Tidak perlu codegen** (tidak ada model baru) | — |

---

## 4. Presentation Layer (Flutter)

### 4.1 Widget Rewrite

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| 1 | **Rewrite `AppointmentCard`** — layout v2.0: header (date+badge), divider, doctor info row (photo 2:3 + details), divider (optional), action buttons | `lib/widgets/card/appointment_card.dart` | 30 menit |

**Detail perubahan `AppointmentCard`:**
- `build`: Column layout dengan Header → Divider → DoctorInfoRow → (Divider → ActionRow)
- `HeaderRow`: Row(DateTimeText, Spacer, StatusBadge)
- `DoctorInfoRow`: Row(ClipRRect + AspectRatio(2/3) + AppNetworkImage, Expanded(Column(name, specialization, hospitalRow)))
- `HospitalRow`: Row(Icon(location), Text(clinicName))
- `ActionRow`: Row(Expanded(SecondaryButton), SizedBox(12), Expanded(PrimaryButton)) — conditional per status
- `_showCancelDialog`: extract ke method sendiri (reuse dari booking_detail_page pattern)
- `onTap` card: navigate ke detail (sama seperti v1.0)

### 4.2 Consumer Page Updates

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| 2 | **Update `BookingHistoryPage`** — pass callbacks baru ke `AppointmentCard` | `booking_history_page.dart` | 5 menit |
| 3 | **HomePage `UpcomingAppointmentCard`** — **TIDAK TERSENTUH**. Keputusan ADR-012: widget terpisah, tidak reuse AppointmentCard di Home. | `home_page.dart` | — |

### 4.3 Status Badge Update

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| 4 | **Update `StatusBadge` colors** — sesuai ADR-012 §3 (Pending=Orange, Upcoming=Blue, Completed=Green, Canceled=Red) | `lib/widgets/card/status_badge.dart` | 5 menit |

### 4.4 State & Bloc Update

| # | Item | File Target | Estimasi |
|---|------|-------------|----------|
| — | **Tidak ada perubahan state/bloc** | — | — |

Cancel action akan memanggil `BookingDetailCubit.cancelAppointment` pattern yang sama. Untuk Booking History, perlu handle cancel success → refresh list. Opsi: panggil `BookingHistoryCubit.refresh()` setelah cancel sukses.

---

## 5. Dependency Order & Urutan Implementasi

```text
1. Update StatusBadge colors (independent)
        │
        ▼
2. Update API select untuk clinic name (booking_remote_datasource.dart)
        │
        ▼
3. Rewrite AppointmentCard (appointment_card.dart)
        │
        ▼
4. Update consumer page (booking_history_page.dart — pass callbacks)
        │
        ▼
5. flutter analyze (verifikasi 0 issue)
        │
        ▼
6. Visual verification vs wireframe 22-appointment-card.md
```

---

## 6. Verifikasi

| # | Item | Status |
|---|------|--------|
| 1 | StatusBadge: Pending=Orange, Upcoming=Blue, Completed=Green, Canceled=Red | ⬜ |
| 2 | AppointmentCard layout: HeaderRow → Divider → DoctorInfo → (Divider → ActionRow) | ⬜ |
| 3 | Doctor photo: ClipRRect + AspectRatio(2/3), width ~80 | ⬜ |
| 4 | Doctor info: name, specialization, hospital row with location icon | ⬜ |
| 5 | Action buttons per status (lihat tabel di bawah) | ⬜ |
| 6 | Cancel action: panggil RPC → success → refresh list | ⬜ |
| 7 | Re-Book action: navigasi ke DoctorDetailPage / BookAppointmentPage | ⬜ |
| 8 | Reschedule/Change Date: disabled/sembunyi (sesuai ADR) | ⬜ |
| 9 | Add Review: disabled/sembunyi (sesuai ADR) | ⬜ |
| 10 | onTap card: navigasi ke `/booking-history/:appointmentId` | ⬜ |
| 11 | Skeletonizer: reuse production widget (lihat rule AGENTS.md) | ⬜ |
| 12 | `flutter analyze` — 0 issues | ⬜ |
| 13 | Visual match dengan wireframe 22-appointment-card.md | ⬜ |

### Status → Action Button Mapping

| Status | Left Button | Right Button | Implementasi |
|--------|-------------|--------------|--------------|
| Pending | Cancel (✅ siap) | Change Date (❌ defer — disabled) | Cancel: panggil `cancel_appointment` RPC |
| Upcoming | Cancel (✅ siap) | Reschedule (❌ defer — disabled) | Cancel: panggil `cancel_appointment` RPC |
| Completed | Re-Book (✅ existing flow) | Add Review (❌ defer — disabled) | Re-Book: `context.push('/booking/:doctorId')` |
| Canceled | — | — | No action row |

---

## 7. Blast Radius

| Consumer | File | Perubahan |
|----------|------|-----------|
| ⬜ `AppointmentCard` | `lib/widgets/card/appointment_card.dart` | Rewrite total — layout v2.0 |
| ⬜ `StatusBadge` | `lib/widgets/card/status_badge.dart` | Update colors (P=Orange, U=Blue, C=Green) |
| ⬜ `BookingHistoryPage` | `lib/features/booking/presentation/page/booking_history_page.dart` | Pass callbacks baru ke AppointmentCard |
| ❌ `HomePage` | `lib/features/home/presentation/page/home_page.dart` | Tidak tersentuh — pakai `UpcomingAppointmentCard` terpisah (ADR-012) |
| ❌ `UpcomingAppointmentCard` | `lib/widgets/card/upcoming_appointment_card.dart` | Tidak tersentuh — widget terpisah, tidak reuse AppointmentCard |
| ⬜ `BookingRemoteDataSource` | `lib/features/booking/data/datasource/booking_remote_datasource.dart` | Update select clause — tambah `clinics(name)` |
| ❌ `AppointmentEntity/Model` | `lib/features/booking/` | Tidak tersentuh |
| ❌ ERD / Database | — | Tidak tersentuh |
| ❌ API Contract (selain select) | — | Tidak tersentuh |

---

## 8. Catatan Query Aktual

Verifikasi datasource sebelum implementasi:

```dart
// booking_remote_datasource.dart:68 — Get Booking History
'*, doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(name, address, phone)), doctor_slots(slot_date, slot_start, slot_end)',
```

**Apakah sudah include `clinics(name)`?** Jika sudah (terlihat dari kode di atas), tidak perlu perubahan API contract. Jika belum (hanya `doctors(id, full_name, photo_url, specializations(name))`), tambahkan.

---

## 9. Deferred — Reschedule, Change Date, Add Review

| Fitur | Alasan Defer | ADR Reference |
|-------|-------------|---------------|
| **Reschedule / Change Date** | Membutuhkan endpoint backend baru + validasi slot availability + cancel window. Tidak blocking untuk MVP. | ADR-012 §6 |
| **Add Review** | Fitur Reviews (input + display) di-defer ke sprint mendatang. Tombol disabled sampai siap. | ADR-009 (Doctor Detail), ADR-012 §6 |

Kedua fitur ini ditampilkan di wireframe (`22-appointment-card.md`) sebagai referensi layout masa depan, tapi tombol disembunyikan/di-disable di implementasi awal.

---

*Dibuat: 29 Juni 2026 · Referensi: ADR-012, Wireframe v2.0*
