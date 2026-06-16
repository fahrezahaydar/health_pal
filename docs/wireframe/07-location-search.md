# Location Search Page

| Field | Detail |
|---|---|
| **Route** | `/loc` (Shell Tab 1) |
| **Component** | `LocPage` |
| **Status** | 🟡 Implemented (list-only — Map View deferred ke Sprint 5 via flutter_map) |

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
│  ┌─ Clinic Card ────────────────┐   │
│  │ 🏥 Klinik Sehat Bersama      │   │
│  │ 📍 1.2 km                    │   │
│  │ 👨‍⚕️ 5 dokter tersedia        │   │
│  │ [🗺️ Lihat Peta]              │   │
│  └──────────────────────────────┘   │
│  ┌─ Clinic Card ────────────────┐   │
│  │ 🏥 RS Mitra Husada           │   │
│  │ 📍 2.5 km                    │   │
│  │ 👨‍⚕️ 3 dokter tersedia        │   │
│  │ [🗺️ Lihat Peta]              │   │
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
| Map View | `FlutterMap` widget | `flutter_map` (OpenStreetMap) — *Deferred to Sprint 5 (AD-8: gratis, no API key)* |
| Pin Marker | `Marker` | Koordinat dari `clinics.lat` + `clinics.lng` |
| Location Permission | `FutureBuilder` | `geolocator` package |
| City Input (fallback) | `AppTextFormField` | Manual input |
| Filter Chips | `ListView` horizontal / `Wrap` | `GET /rest/v1/specializations` |
| Sort Dropdown | `AppDropdownButton<String>` | Jarak / Nama / Jumlah Dokter |
| Clinic Card | `Container` with `InkWell` | `POST /rest/v1/rpc/get_nearby_clinics` (API §5.5) |
| Scroll View | `ListView.builder` | Pagination (20 items) |

**Clinic Card Components (reusable widget):**
```
┌─────────────────────────────────────┐
│ ┌────────┐                          │
│ │        │ Klinik Sehat Bersama     │
│ │ Foto   │ 📍 1.2 km                │
│ │ Klinik │ 👨‍⚕️ 5 dokter            │
│ └────────┘ [🗺️ Lihat Peta]          │
└─────────────────────────────────────┘
```

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tab Loc** | Tap bottom nav ke-2 | Request location permission (jika belum) |
| **Permission: Allow** | Tap "Allow" | Tampilkan list klinik terdekat |
| **Permission: Deny** | Tap "Deny" | Tampilkan fallback input kota |
| **Filter chip** | Tap chip | Tambah/hapus filter spesialisasi → filter list |
| **Sort dropdown** | Pilih opsi | Sort list by jarak / nama / jumlah dokter |
| **Tap clinic card** | Tap | Navigasi ke `/doctor/search?clinic=:clinicId` (Sprint 5) |
| **Tap "Lihat Peta"** | Tap | Buka Google Maps app dengan pin koordinat klinik |
| **Pull to refresh** | Swipe bawah | Refresh list klinik |

**BLoC:** `LocCubit` — menyimpan state: koordinat user, radius, filter spesialisasi, sort mode, list klinik, loading/error.

**Edge Cases:**
- GPS mati → fallback input kota
- Tidak ada klinik dalam radius → empty state: "Tidak ada klinik di radius ini, coba perbesar radius"
- Semua filter aktif → 0 hasil → "Tidak ada klinik dengan filter ini"
