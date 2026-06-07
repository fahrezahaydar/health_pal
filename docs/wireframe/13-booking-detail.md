# Booking Detail Page

| Field | Detail |
|---|---|
| **Route** | `/booking-history/:appointmentId` (push) |
| **Component** | `BookingDetailPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)   Detail Appointment       │
│                                     │
│  ┌─ Header ─────────────────────┐   │
│  │ ┌──────┐ dr. Budi Santoso    │   │
│  │ │ Foto │ Sp.PD               │   │
│  │ │ (64) │ 🟡 Pending          │   │
│  │ └──────┘                     │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Info Booking ───────────────┐   │
│  │  📅 Tanggal: 15 Jun 2026     │   │
│  │  🕐 Waktu: 09:00 - 09:30     │   │
│  │  🏥 Klinik: Sehat Bersama    │   │
│  │  📍 Alamat: Jl. Merdeka 10   │   │
│  │  📞 Telepon: 022-12345678    │   │
│  │                             │   │
│  │  💰 Biaya: Rp150.000        │   │
│  │     (Simulasi)              │   │
│  │                             │   │
│  │  📝 Keluhan:                 │   │
│  │  "Sudah 3 hari demam dan    │   │
│  │   batuk, disertai sesak."   │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Status Timeline ────────────┐   │
│  │  ✅ 07 Jun • Booking dibuat  │   │
│  │  ⏳  Menunggu konfirmasi     │   │
│  │  ⚪  Jadwal konsultasi       │   │
│  │  ⚪  Selesai                 │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     Batalkan Appointment    │    │
│  └─────────────────────────────┘    │
│  (hanya untuk status Pending /      │
│          Upcoming)                  │
└─────────────────────────────────────┘
```

### Canceled State
```
│  ┌─ Status Timeline ────────────┐   │
│  │  ✅ 07 Jun • Booking dibuat  │   │
│  │  ✅ 07 Jun • Dibatalkan      │   │
│  │  📝 Alasan: "Ada keperluan   │   │
│  │     mendadak"               │   │
│  └──────────────────────────────┘   │
│                                     │
│  (No cancel button)                 │
```

### Completed State
```
│  ┌─ Status Timeline ────────────┐   │
│  │  ✅ 07 Jun • Booking dibuat  │   │
│  │  ✅ 07 Jun • Dikonfirmasi    │   │
│  │  ✅ 15 Jun • Kunjungan selesai│   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     Beri Ulasan (v1.1)      │    │
│  └─────────────────────────────┘    │
│  (hanya untuk status Completed)     │
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Doctor Photo | `Image.network` (circle) | `doctors.photo_url` |
| Doctor Name | `Text` | `doctors.full_name` |
| Specialization | `Text` | `specializations.name` |
| Status Badge | `Container` colored | warna sesuai status |
| Info Card | `Container` with border | — |
| Detail Fields | `Row(Icon + Column)` | Tanggal, waktu, klinik, alamat, telepon, biaya, keluhan |
| Timeline | `Column` of timeline items | Status history |
| Cancel Button | `LightFilledButton` (red) | Visible only for Pending/Upcoming |
| Review Button | `LightOutlineButton` | Visible only for Completed (v1.1) |
| Cancel Dialog | `AppCustomDialog` | Konfirmasi + optional alasan |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap back** | Tap | `context.pop()` |
| **Tap "Batalkan"** | Tap | Dialog konfirmasi: "Yakin batalkan?" + field alasan (opsional) |
| **Konfirmasi batal** | Tap "Ya" | Loading → `POST /functions/v1/cancel-appointment` |
| **Batal sukses** | API 200 | Status berubah → timeline update → FCM terkirim |
| **Batal gagal 403** | API 403 | Snackbar: "Bukan appointment kamu" |
| **Batal gagal 422** | API 422 | Snackbar: "Tidak bisa batalkan" |
| **Tap "Beri Ulasan"** | Tap | Navigasi ke halaman rating (v1.1) |
| **Waktu slot lewat** | Otomatis | Dialog: "Appointment sudah lewat" → refresh status → completed |

**BLoC:** `BookingDetailCubit` — states: `loading`, `loaded(appointment)`, `cancelling`, `cancelled`, `error`.

**Timeline Logic (dynamic dari appointment fields):**
1. ✅ `booked_at` — "Booking dibuat"
2. ✅ `confirmed_at` — "Dikonfirmasi" (hanya jika ada)
3. ❌ `completed_at` — "Kunjungan selesai" (hanya jika ada)
4. ❌ `cancelled_at` — "Dibatalkan" (hanya jika ada, dengan alasan)
