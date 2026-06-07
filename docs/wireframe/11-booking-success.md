# Booking Success Page

| Field | Detail |
|---|---|
| **Route** | `/booking/success` (push) |
| **Component** | `BookingSuccessPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│            ┌──────────────────┐      │
│            │     ✅ Sukses    │      │
│            │     (Animasi)    │      │
│            │  Icon Checklist  │      │
│            └──────────────────┘      │
│                                     │
│       "Booking Berhasil!"            │
│   "Appointment kamu dengan           │
│    dr. Budi Santoso, Sp.PD           │
│    telah berhasil dibuat."           │
│                                     │
│  ┌─ Detail Booking ──────────────┐   │
│  │  👤 dr. Budi Santoso, Sp.PD   │   │
│  │  🏥 Klinik Sehat Bersama      │   │
│  │  📅 15 Jun 2026               │   │
│  │  🕐 09:00 - 09:30             │   │
│  │  💰 Rp150.000 (Simulasi)      │   │
│  │  🔔 Status: Pending           │   │
│  └──────────────────────────────┘   │
│                                     │
│  🔔 Notifikasi konfirmasi akan      │
│      dikirim ke perangkatmu          │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Kembali ke Home        │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  Lihat Riwayat Booking      │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Behavior |
|---|---|---|
| Success Icon | `Lottie` / custom animation | Checkmark animation, auto-play |
| Title | `Text` | `headlineLarge` |
| Description | `Text` | `bodySmall` |
| Booking Detail Card | `Container` with border | Data dari response create-appointment |
| Notification Hint | `Row(Icon + Text)` | "Notifikasi akan dikirim..." |
| Home Button | `LightFilledButton` | `context.go('/home')` — clear stack |
| History Button | `LightOutlineButton` | `context.go('/booking-history')` |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Auto-show** | Page load | Animasi success auto-play |
| **Tap "Kembali ke Home"** | Tap | `context.go('/home')` — go, bukan push |
| **Tap "Lihat Riwayat"** | Tap | `context.go('/booking-history')` |

**Notes:**
- Halaman ini **tidak memiliki back button** (user tidak boleh kembali ke form booking)
- Data booking ditampilkan dari response API `create-appointment` yang dikirim via state.extra
- FCM notification otomatis terkirim dari backend setelah booking berhasil
