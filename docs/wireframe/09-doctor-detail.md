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
│  ┌─ Ketersediaan Jadwal ────────┐   │
│  │  📅 Tersedia 8 slot untuk    │   │
│  │     7 hari ke depan           │   │
│  │  ─────────────────────────   │   │
│  │  🕐 [09:00] [09:30] [10:00] │   │
│  │     [10:30] [11:00]         │   │
│  │     (hijau=tersedia,         │   │
│  │      abu=terbooking)        │   │
│  │                              │   │
│  │  ℹ️  Pilih tanggal & slot    │   │
│  │     di halaman Booking       │   │
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
│  ┌─ Ketersediaan Jadwal ────────┐   │
│  │  📅 Belum ada slot untuk     │   │
│  │     7 hari ke depan           │   │
│  │  ─────────────────────────   │   │
│  │     "Tidak ada jadwal        │   │
│  │      tersedia saat ini.       │   │
│  │      Coba lagi besok."       │   │
│  │                              │   │
│  │  ℹ️  Dokter mungkin belum    │   │
│  │     membuka jadwal praktik.  │   │
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
| Availability Text | `Container` with icon | `GET /rest/v1/doctor_slots?doctor_id&slot_date=gte.today&limit=1&is_booked=eq.false` → count 7 hari ke depan |
| Slot List | `Wrap` of chips (sample 5 slot pertama) | `GET /rest/v1/doctor_slots?doctor_id&slot_date=gte.today&limit=5&order=slot_date.asc,slot_start.asc` |
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
| **Tap slot (sample 5 pertama)** | Tap green chip | Highlight slot (lokal, hanya untuk visual reference) |
| **Tap "Book Appointment"** | Tap | Navigasi ke `/booking/:doctorId` dengan extra: `{doctor, suggestedSlotId?}` |
| **Tap "Lihat Peta"** | Tap | Buka Google Maps URL `https://maps.google.com/?q=lat,lng` |
| **Tap "Lihat semua ulasan"** | Tap | Expand / halaman ulasan (v1.1) |
| **Slot loading** | API call | Tampilkan shimmer pada slot area |
| **Slot error** | API error | Snackbar: "Gagal memuat jadwal" |

**BLoC:** `DoctorDetailCubit` — states: `loading`, `loaded(doctor, slotCount7Days, sampleSlots, reviews)`, `error`.

**Catatan Perubahan v1.0.1 (SS#10):**
- **Hapus:** Komponen pemilihan hari horizontal (day chips). Alasan: duplikasi dengan halaman Book Appointment, dan untuk user info cepat cukup text "Tersedia X slot untuk 7 hari ke depan"
- **Slot List:** Hanya tampilkan 5 sample slot pertama sebagai preview. Pemilihan tanggal & slot penuh dilakukan di halaman Book Appointment
- **Navigasi:** Tombol "Book Appointment" kirim `extra: {doctor, suggestedSlotId?}` ke `/booking/:doctorId` (tanpa `selectedDate` lagi)
- **API:** `GET /rest/v1/doctor_slots?doctor_id&slot_date=gte.today&is_booked=eq.false&limit=5&order=slot_date.asc,slot_start.asc`

**Availability Text Logic:**
- Hitung total slot `is_booked=false` dalam 7 hari ke depan dari `doctor_slots`
- Tampilkan: "📅 Tersedia X slot untuk 7 hari ke depan" (X = count, 0 = "Belum ada slot")
- Update real-time saat user pull-to-refresh
