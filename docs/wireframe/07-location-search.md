# Location Search Page

| Field | Detail |
|---|---|
| **Route** | `/loc` (Shell Tab 1) |
| **Component** | `LocPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ 📍 Location Search                  │
│                                     │
│  ┌─ Map View ──────────────────┐    │
│  │                             │    │
│  │     🗺️  Google Map          │    │
│  │                             │    │
│  │        📍 Pin Klinik        │    │
│  │                             │    │
│  └──────────────────────────────┘   │
│  [Allow Location Access?]          │
│           [Allow] [Deny]           │
│                                     │
│  ┌──── Filter Chips ────────────┐   │
│  │ [Umum] [Anak] [Kulit] [Gigi]│   │
│  │   [+ More]  [Jarak ▼]       │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Doctor Card ────────────────┐   │
│  │ 👤 dr. Budi Santoso, Sp.PD   │   │
│  │    ⭐ 4.85 (234 ulasan)      │   │
│  │    🏥 Klinik Sehat Bersama   │   │
│  │    📍 1.2 km • Bandung       │   │
│  │    💰 Rp150,000              │   │
│  └──────────────────────────────┘   │
│  ┌─ Doctor Card ────────────────┐   │
│  │ 👤 dr. Sari Dewi, Sp.A       │   │
│  │    ⭐ 4.70 (189 ulasan)      │   │
│  │    🏥 RS Mitra Husada        │   │
│  │    📍 2.5 km • Bandung       │   │
│  │    💰 Rp120,000              │   │
│  └──────────────────────────────┘   │
│                                     │
│──────── Bottom Nav Bar ─────────────│
│  🏠 Home  📍 Loc  📋 Hist  👤 Prof │
└─────────────────────────────────────┘
```

### Fallback (izin lokasi ditolak)
```
┌─────────────────────────────────────┐
│ 📍 Location Search                  │
│                                     │
│         ┌──────────────────┐        │
│         │  Izin lokasi     │        │
│         │  diperlukan      │        │
│         │  untuk peta      │        │
│         └──────────────────┘        │
│                                     │
│  ┌─ Kota ───────────────────────┐   │
│  │  📍  Masukkan nama kota      │   │
│  └──────────────────────────────┘   │
│                                     │
│  [Filter chips same as above]       │
│  [Doctor list same as above]        │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Data Source |
|---|---|---|
| Map View | `GoogleMap` widget | `google_maps_flutter` |
| Pin Marker | `Marker` | Koordinat dari `clinics.lat` + `clinics.lng` |
| Location Permission | `FutureBuilder` | `geolocator` package |
| City Input (fallback) | `AppTextFormField` | Manual input |
| Filter Chips | `ListView` horizontal / `Wrap` | `GET /rest/v1/specializations` |
| Sort Dropdown | `AppDropdownButton<String>` | Jarak / Rating / Fee |
| Doctor Card | `Container` with `InkWell` | `POST /functions/v1/doctors-by-location` |
| Scroll View | `ListView.builder` | Pagination (20 items) |

**Doctor Card Components (reusable widget):**
```
┌─────────────────────────────────────┐
│ ┌────┐                              │
│ │    │ dr. Budi Santoso, Sp.PD      │
│ │Foto│ ⭐ 4.85 (234)                │
│ │    │ 🏥 Klinik Sehat Bersama      │
│ └────┘ 📍 1.2 km • 💰 Rp150,000    │
└─────────────────────────────────────┘
```

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tab Loc** | Tap bottom nav ke-2 | Request location permission (jika belum) |
| **Permission: Allow** | Tap "Allow" | Tampilkan map + pin dokter |
| **Permission: Deny** | Tap "Deny" | Tampilkan fallback input kota |
| **Map** | Drag/zoom | Pin marker reposition |
| **Tap pin** | Tap marker | Info window: nama klinik |
| **Filter chip** | Tap chip | Tambah/hapus filter spesialisasi → refresh list |
| **Sort dropdown** | Pilih opsi | Ubah `order` parameter → refresh list |
| **Tap doctor card** | Tap | Navigasi ke `/doctor/:doctorId` |
| **Pull to refresh** | Swipe bawah | Refresh map markers + list dokter |

**BLoC:** `LocCubit` — menyimpan state: koordinat user, radius, specialization filter, list dokter, loading/error.

**Edge Cases:**
- GPS mati → fallback input kota
- Tidak ada dokter dalam radius → empty state
- Semua filter aktif → 0 hasil → "Tidak ada dokter dengan filter ini"
