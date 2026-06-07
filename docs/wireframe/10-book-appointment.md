# Book Appointment Page

| Field | Detail |
|---|---|
| **Route** | `/booking/:doctorId` (push) |
| **Component** | `BookAppointmentPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)   Book Appointment         │
│                                     │
│  ┌─ Doctor Summary ─────────────┐   │
│  │ ┌────┐ dr. Budi Santoso      │   │
│  │ │    │ Spesialis Penyakit    │   │
│  │ │foto│ Dalam                 │   │
│  │ └────┘                       │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Pilih Tanggal ──────────────┐   │
│  │  📅 15 Jun 2026        [📅]  │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Pilih Slot Waktu ───────────┐   │
│  │  🕐 [09:00] [09:30] [10:00]  │   │
│  │     [10:30]                  │   │
│  │  [slot terpilih = highlight] │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Catatan Keluhan ───────────────┐│
│  │  📝  Ceritakan keluhanmu...     ││
│  │                                 ││
│  │                  0/300 karakter ││
│  └──────────────────────────────────┘│
│                                     │
│  ┌─ Ringkasan Biaya ────────────┐   │
│  │  💰 Biaya Konsultasi         │   │
│  │     Rp150.000  [Simulasi]    │   │
│  │                               │   │
│  │  ⚠️ Pembayaran dilakukan     │   │
│  │     langsung di klinik       │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     Konfirmasi Booking      │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘

─ ─ ─ ─ ─ ─ CONFIRMATION BOTTOM SHEET ─ ─ ─ ─ ─ ─
┌─────────────────────────────────────┐
│                                     │
│  ┌─ Ringkasan Booking ──────────┐   │
│  │  👤 dr. Budi Santoso         │   │
│  │  📅 15 Jun 2026              │   │
│  │  🕐 09:00 - 09:30            │   │
│  │  💰 Rp150.000 (Simulasi)     │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │      Konfirmasi Booking     │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │           Batal             │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Data Source |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Doctor Summary | `Row(Image + Column(Text))` | Passed from Detail page |
| Date Picker | `AppDatePickerFormField` / horizontal `ListView` | Pre-selected from Detail |
| Slot Grid | `Wrap` of chips | `doctor_slots` (filtered by date) |
| Selected Slot | Highlighted chip | State variable `_selectedSlotId` |
| Complaint Field | `AppTextFormField` | multiline, max 300 chars |
| Char Counter | `Text` | `${current}/300` |
| Fee Summary | `Container` with badge | `doctors.consultation_fee` |
| Simulation Badge | `Container` with label "Simulasi" | Static |
| Payment Note | `Text` kecil | "Pembayaran dilakukan langsung di klinik" |
| Confirm Button | `LightFilledButton` | Open bottom sheet |
| **Bottom Sheet** | `showModalBottomSheet` | — |
| Summary Card | `Container` | Read-only booking summary |
| Confirm Button | `LightFilledButton` | `POST /functions/v1/create-appointment` |
| Cancel Button | `LightOutlineButton` | Close sheet |
| Loading | `AppLoadingDialog` | During API call |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Pilih tanggal** | Tap date | Refresh slot list untuk tanggal tersebut |
| **Pilih slot** | Tap chip hijau | `_selectedSlotId` terisi, chip terhighlight |
| **Isi keluhan** | Mengetik | Char counter update; >300 → error "Maks 300 karakter" |
| **Tap "Konfirmasi Booking"** | — | Bottom sheet muncul jika slot terpilih |
| **Tap "Konfirmasi Booking"** | Slot belum dipilih | Snackbar: "Pilih slot terlebih dahulu" |
| **Bottom Sheet: Confirm** | Tap | Loading → `POST /functions/v1/create-appointment` |
| **Bottom Sheet: Batal** | Tap | Tutup sheet, kembali ke form |
| **API: 201 sukses** | Auto | Navigasi ke `/booking/success` |
| **API: 409 conflict** | Auto | Dialog: "Slot sudah dipesan" → refresh slot |
| **API: 500 error** | Auto | Dialog: "Coba lagi" |

**BLoC:** `BookingCubit` — states: `BookingInitial`, `BookingLoading`, `BookingSuccess`, `BookingError(code, message)`.

**Validation Rules:**
- Slot wajib dipilih → button disable jika null
- Keluhan opsional, max 300 karakter
- Tanggal default dari Doctor Detail page
