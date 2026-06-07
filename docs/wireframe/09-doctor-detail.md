# Doctor Details / Doctor Appointments Page

| Field | Detail |
|---|---|
| **Route** | `/doctor/:doctorId` (push) |
| **Component** | `DoctorDetailPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)         ⭐ Bagikan │❤️│   │
│                                     │
│  ┌─ Doctor Header ──────────────┐   │
│  │ ┌──────────┐                 │   │
│  │ │  Foto    │ dr. Budi        │   │
│  │ │ Dokter   │ Santoso, Sp.PD  │   │
│  │ │ (80px)   │ Penyakit Dalam  │   │
│  │ └──────────┘ ⭐ 4.85 (234)   │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Info Card ──────────────────┐   │
│  │  🎓 Pendidikan              │   │
│  │    FK Unpad (2008), Sp.PD   │   │
│  │    RSUP Dr. Hasan Sadikin   │   │
│  │                             │   │
│  │  💼 Pengalaman: 12 tahun    │   │
│  │                             │   │
│  │  🏥 Klinik Sehat Bersama    │   │
│  │    Jl. Merdeka No. 10       │   │
│  │    📍 Bandung [Lihat Peta]  │   │
│  │                             │   │
│  │  💰 Biaya: Rp150,000        │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Pilih Jadwal ───────────────┐   │
│  │  📅 [Mo] [Tu] [We] [Th] [Fr]│   │
│  │  [Sa] [Su]                   │   │
│  │  ─────────────────────────   │   │
│  │  🕐 [09:00] [09:30] [10:00] │   │
│  │     [10:30] [11:00]         │   │
│  │     (hijau=tersedia,         │   │
│  │      abu=terbooking)        │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Ulasan Pasien ──────────────┐   │
│  │  ⭐⭐⭐⭐⭐ "Dokter ramah..."  │   │
│  │     — Andi, 2 hari lalu      │   │
│  │                             │   │
│  │  ⭐⭐⭐⭐⭐ "Penjelasan..."   │   │
│  │     — Sari, 1 minggu lalu   │   │
│  │                             │   │
│  │  [Lihat semua ulasan →]     │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     Book Appointment        │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### No Slot Available
```
│  ┌─ Pilih Jadwal ───────────────┐   │
│  │  📅 [Mo] [Tu] [We] [Th] [Fr]│   │
│  │  [Sa] [Su]                   │   │
│  │  ─────────────────────────   │   │
│  │     "Tidak ada jadwal        │   │
│  │      tersedia untuk          │   │
│  │      tanggal ini"            │   │
│  └──────────────────────────────┘   │
```

---

## Component Breakdown

| Component | Widget | Data Source |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Share Button | `IconButton` | Share sheet (opsional) |
| Favorite | `IconButton` (toggle ❤️) | `POST /profile/favorite` |
| Doctor Photo | `Image.network` (circle) | `doctors.photo_url` |
| Doctor Name | `Text` | `doctors.full_name` |
| Specialization | `Text` (badge) | `specializations.name` |
| Rating | `Row(Star, Text)` | `doctors.rating_avg` + `rating_count` |
| Info Card | `Container` with sections | — |
| Education | `Column(Icon + Text)` | `doctors.education` |
| Experience | `Row(Icon + Text)` | `doctors.experience_years` |
| Clinic Info | `Column` with mini map | `clinics` (JOIN) |
| Map Link | `GestureDetector` → "Lihat Peta" | Buka Google Maps external |
| Fee | `Text` | `doctors.consultation_fee` |
| Date Picker | Horizontal `ListView` | 7 hari ke depan |
| Slot List | `Wrap` of chips | `GET /rest/v1/doctor_slots` |
| Available Slot | `Container` hijau | `is_booked = false` |
| Booked Slot | `Container` abu | `is_booked = true` |
| Reviews | `Column` of review cards | `GET /rest/v1/reviews` (v1.1) |
| CTA Button | `LightFilledButton` | Navigasi `/booking/:doctorId` |
| Empty Slot | `Text` | "Tidak ada jadwal tersedia" |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap back** | Tap | `context.pop()` |
| **Tap ❤️ favorite** | Tap | Toggle filled/outline → API favorite |
| **Tap tanggal** | Tap date chip | `GET /rest/v1/doctor_slots?doctor_id&slot_date=` → refresh slot list |
| **Tap slot tersedia** | Tap green chip | Slot terpilih (highlight) |
| **Tap "Book Appointment"** | Tap | Navigasi ke `/booking/:doctorId` dengan argumen doctor dan slot |
| **Tap "Lihat Peta"** | Tap | Buka Google Maps URL `https://maps.google.com/?q=lat,lng` |
| **Tap "Lihat semua ulasan"** | Tap | Expand / halaman ulasan (v1.1) |
| **Slot loading** | API call | Tampilkan shimmer pada slot area |
| **Slot error** | API error | Snackbar: "Gagal memuat jadwal" |

**BLoC:** `DoctorDetailCubit` — states: `loading`, `loaded(doctor, slots, selectedDate, reviews)`, `error`.

**Date Selection Logic:**
- Default: hari ini (jika masih ada slot)
- Jika hari ini tidak ada slot → auto-select hari pertama yang punya slot
- Jika tidak ada slot sama sekali dalam 7 hari → tampilkan empty state
