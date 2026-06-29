# Appointment Card Wireframe — v2.0

| Field | Detail |
|---|---|
| **Component** | `AppointmentCard` |
| **Pengguna** | Booking History Page, Home Page (Upcoming section) |
| **Status** | 🔧 Proposed (v2.0) |
| **Tanggal** | 29 Juni 2026 |
| **Supersedes** | Appointment card layout di `12-booking-history.md` v1.0 |

---

## Card Wireframe (Base Layout)

```text
┌────────────────────────────────────────────────────────────┐
│ May 22, 2023 · 10:00 AM              [ Upcoming ]          │
├────────────────────────────────────────────────────────────┤
│ ┌────────────┐  Dr. James Robinson                        │
│ │            │  Orthopedic Surgery                        │
│ │   Photo    │  📍 Elite Ortho Clinic, USA               │
│ │   2 : 3    │                                           │
│ └────────────┘                                            │
├────────────────────────────────────────────────────────────┤
│                 Action Buttons                            │
└────────────────────────────────────────────────────────────┘
```

---

## Status Variants

### Pending

```text
┌────────────────────────────────────────────────────────────┐
│ May 22, 2023 · 10:00 AM               [ Pending ]          │
├────────────────────────────────────────────────────────────┤
│ Doctor Information                                         │
├────────────────────────────────────────────────────────────┤
│ [ Cancel ]                     [ Change Date ]             │
└────────────────────────────────────────────────────────────┘
```

---

### Upcoming

```text
┌────────────────────────────────────────────────────────────┐
│ May 22, 2023 · 10:00 AM              [ Upcoming ]          │
├────────────────────────────────────────────────────────────┤
│ Doctor Information                                         │
├────────────────────────────────────────────────────────────┤
│ [ Cancel ]                      [ Reschedule ]             │
└────────────────────────────────────────────────────────────┘
```

---

### Completed

```text
┌────────────────────────────────────────────────────────────┐
│ May 22, 2023 · 10:00 AM             [ Completed ]          │
├────────────────────────────────────────────────────────────┤
│ Doctor Information                                         │
├────────────────────────────────────────────────────────────┤
│ [ Re-Book ]                    [ Add Review ]              │
└────────────────────────────────────────────────────────────┘
```

---

### Canceled

```text
┌────────────────────────────────────────────────────────────┐
│ May 22, 2023 · 10:00 AM              [ Canceled ]          │
├────────────────────────────────────────────────────────────┤
│ Doctor Information                                         │
└────────────────────────────────────────────────────────────┘
```

---

## Layout Structure

```text
AppointmentCard
├── Header
│   ├── Appointment Date & Time
│   └── Status Badge
├── Divider
├── Doctor Information
│   ├── Doctor Photo
│   └── Details
│       ├── Doctor Name
│       ├── Specialization
│       └── Hospital
├── Divider
└── Action Section
    ├── Left Button
    └── Right Button
```

---

## Component Hierarchy

```text
AppointmentCard
├── HeaderRow
│   ├── DateTimeText
│   └── AppointmentStatusBadge
├── DoctorInfo
│   ├── DoctorImage (2:3 aspect ratio, rounded corners)
│   ├── DoctorName
│   ├── Specialization
│   └── HospitalRow (icon + name)
└── AppointmentActionRow
    ├── SecondaryButton (outlined)
    └── PrimaryButton (filled)
```

---

## Status Badge Colors

| Status | Suggested Color | Wireframe 12 Legacy | Keputusan ADR |
|--------|-----------------|---------------------|---------------|
| Pending | Orange | Amber/Kuning (#FFA726) | **Ubah ke Orange** — lebih kontras di card baru |
| Upcoming | Blue | Hijau (#4CAF50) | **Ubah ke Blue** — wireframe baru spesifik minta blue |
| Completed | Green | Biru (#2196F3) | **Ubah ke Green** — green lebih natural untuk "selesai" |
| Canceled | Red/Grey | Merah/Abu (#EF5350) | **Konsisten** — pakai yang paling sesuai dengan AppTheme |

---

## Button Mapping

| Status | Left Button | Right Button | Catatan |
|--------|-------------|--------------|---------|
| Pending | Cancel | Change Date | Cancel ✅ (BUG-006 FIX#4). **Change Date 🔴 Belum ada backend** |
| Upcoming | Cancel | Reschedule | Cancel ✅. **Reschedule 🔴 Belum ada backend** |
| Completed | Re-Book | Add Review | Re-Book → navigate to `DoctorDetailPage`/`BookAppointmentPage` dengan doctor yang sama. **Add Review 🔴 Fitur Reviews belum ada** (deferred) |
| Canceled | — | — | No action buttons |

---

## Components

| Component | Widget | Data Source | Notes |
|-----------|--------|-------------|-------|
| Header | `Row(DateTime + StatusBadge)` | `AppointmentEntity.slotDate + slotStart` | Format: "May 22, 2023 · 10:00 AM" |
| Status Badge | `StatusBadge` (existing) | `AppointmentEntity.status` | Ubah warna sesuai wireframe baru |
| Doctor Photo | `AppNetworkImage` (2:3 ratio) | `AppointmentEntity.doctorPhotoUrl` | 2:3 ratio, rounded corners. **Berbeda dengan DoctorCard 1:1** — ini konteks berbeda (compact card vs identity card) |
| Doctor Name | `Text` | `AppointmentEntity.doctorName` | Bold, max 2 lines |
| Specialization | `Text` | `AppointmentEntity.specializationName` | Grey, small |
| Hospital Row | `Row(Icon + Text)` | `AppointmentEntity.clinicName` | Location icon + clinic name |
| Action Buttons | `Row(2 Expanded Buttons)` | Conditional per status | Left = outlined, Right = filled |

---

## Suggested Flutter Widget Tree

```dart
class AppointmentCard extends StatelessWidget {
  build(context) {
    return Container(
      child: Column(
        children: [
          // ── Header ──
          HeaderRow(
            dateTime: formatDateTime(appointment),
            statusBadge: StatusBadge(status: _status),
          ),
          const Divider(),
          // ── Doctor Info ──
          DoctorInfoRow(
            photo: AppNetworkImage(
              imageUrl: appointment.doctorPhotoUrl,
              aspectRatio: 2/3,  // atau width:80, height:120
            ),
            name: appointment.doctorName,
            specialization: appointment.specializationName,
            hospital: appointment.clinicName,
          ),
          if (status != 'cancelled') ...[
            const Divider(),
            // ── Action Buttons ──
            ActionRow(status: status),
          ],
        ],
      ),
    );
  }
}
```

---

## Perbandingan v1.0 → v2.0

| Aspek | v1.0 (saat ini) | v2.0 (wireframe baru) |
|-------|-----------------|----------------------|
| **Layout** | Single row (photo left + info right + badge) | Multi-row (header + divider + doctor info + divider + actions) |
| **Doctor Photo** | Circle 48px | 2:3 aspect ratio, rounded corners |
| **Date/Time** | Inline in info column | Dedicated header row |
| **Status Badge** | Inline in info column | Header row (right-aligned) |
| **Action Buttons** | ❌ Tidak ada | Dynamic per status |
| **Clinic Name** | Inline in info column | Dedicated row with location icon |
| **Specialization** | ❌ Tidak ada | Added in doctor info section |
| **Visit Count** | ❌ Tidak ada | (optional — future enhancement) |

---

## Catatan tentang Action Buttons

### Cancel (Pending & Upcoming)
**Status: ✅ Sudah ada implementasi.** Cancel appointment sudah di-fix melalui BUG-006 FIX#4 (RPC backend) dan FIX#5 (Flutter datasource). Tombol Cancel akan memanggil `cancel_appointment` RPC dan mengupdate state.

### Change Date (Pending) & Reschedule (Upcoming)
**Status: 🔴 Fitur baru — belum ada backend.** Wireframe ini memperkenalkan fitur "Change Date" dan "Reschedule" yang belum pernah ada di ERD, API Contract, atau audit sebelumnya. Ini membutuhkan:
- Endpoint/RPC baru: `reschedule_appointment(p_appointment_id, p_new_slot_id)` atau serupa
- Validasi: slot baru harus available, appointment harus status pending/upcoming
- Validasi cancel window (sama seperti cancel — minimal 60 menit)
- Atomic: UPDATE appointment.slot_id + release old slot + book new slot

**Scope decision:** Lihat ADR-012 §Keputusan untuk apakah fitur ini masuk sprint sekarang atau di-defer.

### Re-Book (Completed)
**Status: ✅ Bisa pakai navigasi existing.** Cukup navigate ke Doctor Detail page (atau langsung ke Book Appointment page) dengan `doctorId` yang sama dari appointment yang sudah completed. Tidak perlu logic/endpoint baru.

### Add Review (Completed)
**Status: 🟡 Deferred — konsisten dengan ADR Doctor Detail.** Fitur Reviews sudah di-defer di ADR-009 (Doctor Detail Redesign) ke sprint mendatang. Tombol "Add Review" bisa ditampilkan secara visual (sesuai wireframe) tapi disabled dengan tooltip/placeholder, atau disembunyikan sampai fitur Reviews tersedia.

---

## Changelog

| Versi | Tanggal | Perubahan |
|-------|---------|-----------|
| v2.0 | 29 Jun 2026 | Initial redesign — multi-row layout, action buttons per status, 2:3 photo |
