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
| **Pilih tanggal** | Tap date picker | Tampilkan date picker dialog → selected date di-set → refresh slot list untuk tanggal tersebut |
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
- Tanggal **WAJIB** dipilih manual (tidak ada default dari Doctor Detail — see Catatan v1.0.1)

---

## Catatan Perubahan v1.0.1 (SS#10)

**Perubahan Kontrak Navigasi (Doctor Detail → Book Appointment):**

Pada versi sebelumnya, halaman Book Appointment menerima `extra: {selectedDate}` dari Doctor Detail dan auto-set tanggal. Mulai v1.0.1, **kontrak ini berubah**:
- Doctor Detail (SS#10) sudah **TIDAK LAGI** punya date picker, jadi tidak ada `selectedDate` yang dikirim
- Book Appointment menjadi halaman **single source of truth** untuk pemilihan tanggal
- Navigasi: `context.push('/booking/:doctorId', extra: {doctor, suggestedSlotId?})`
  - `doctor` — object doctor lengkap (untuk Doctor Summary card)
  - `suggestedSlotId` — **opsional**, slot yang di-tap di Doctor Detail (untuk pre-select)
  - **TIDAK ADA** `selectedDate` lagi

**Alasan perubahan:**
1. Menghindari duplikasi date picker (antara Doctor Detail dan Book Appointment)
2. Mempercepat load Doctor Detail (tidak perlu fetch 7 hari slot sekaligus)
3. Memisahkan concerns: Doctor Detail fokus info dokter, Book Appointment fokus input booking

**Inisialisasi state saat halaman dibuka:**
```dart
// BookingCubit constructor
BookingCubit({required this.doctor, String? suggestedSlotId})
  : super(BookingState.initial()) {
  // Default: hari ini (jika available) atau null
  selectedDate = _findFirstAvailableDate(doctor.id);
  
  // Pre-select slot jika user tap di Doctor Detail
  if (suggestedSlotId != null) {
    selectedSlotId = suggestedSlotId;
  }
}
```

**API Call Pattern:**
- `GET /rest/v1/doctor_slots?doctor_id=eq.<id>&slot_date=eq.<selectedDate>&is_booked=eq.false&order=slot_start.asc` → slot list untuk tanggal yang dipilih
- Saat user pilih tanggal lain → refetch dengan `slot_date` baru
