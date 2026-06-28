# Location Page Wireframe

| Field | Detail |
|---|---|
| **Route** | /loc (Shell Tab 1) |
| **Component** | LocPage |
| **Status** | 🟡 Planned — Map-based redesign (ADR-010) |
| **Clinic Card** | v2.0 — redesign with cover image, rating, review count, category, duration, favorite |

---

## Page Wireframe (ASCII)

`	ext
┌──────────────────────────────────────────────┐
│                  Status Bar                  │
├──────────────────────────────────────────────┤
│ ┌──────────────────────────────────────────┐ │
│ │ 🔍 Search Clinic / Hospital              │ │
│ └──────────────────────────────────────────┘ │
│                                              │
│                                              │
│              Interactive Map                 │
│                                              │
│        📍          📍              📍        │
│                                              │
│               📍                             │
│                                              │
│                          📍                  │
│                                              │
│══════════════════════════════════════════════│
│ ┌──────────────────────────┐ ┌────────────┐ │
│ │ Clinic Card              │ │ Clinic...  │ │
│ │ Image                    │ │ Image      │ │
│ │ Name                     │ │ Name       │ │
│ │ Address                  │ │ Address    │ │
│ │ Rating                   │ │ Rating     │ │
│ │ Distance                 │ │ Distance   │ │
│ └──────────────────────────┘ └────────────┘ │
├──────────────────────────────────────────────┤
│  🏠          📍           📅          👤      │
└──────────────────────────────────────────────┘
`

---

## Layout Structure

`	ext
Scaffold
├── Body
│   └── Stack
│       ├── InteractiveMap
│       ├── SafeArea
│       │   └── SearchBar
│       └── Align(BottomCenter)
│           └── ClinicCarousel
│
└── BottomNavigationBar
`

---

## Component Hierarchy

`	ext
LocationPage
├── MapView
│   └── Marker × N
│
├── SearchBar
│   ├── SearchIcon
│   └── TextField
│
├── ClinicCarousel
│   └── ClinicCard × N
│
└── BottomNavigationBar
    ├── Home
    ├── Location (Selected)
    ├── Appointment
    └── Profile
`

---

## Clinic Card

`	ext
ClinicCard
├── ClinicImage
├── FavoriteButton
├── ClinicName
├── AddressRow
├── RatingRow
├── Divider
└── BottomInfoRow
    ├── Distance
    └── Category
`

---

## Map Marker

`	ext
MapMarker
├── Pin Background
└── Doctor / Clinic Thumbnail
`

---

## Components

| Component         | Description                               |
| ----------------- | ----------------------------------------- |
| Map View          | Interactive map displaying nearby clinics |
| Search Bar        | Search clinic or hospital by keyword      |
| Map Marker        | Clinic location with thumbnail            |
| Clinic Carousel   | Horizontal list of nearby clinics         |
| Clinic Card       | Clinic summary information                |
| Bottom Navigation | Primary application navigation            |

---

## Suggested Flutter Widget Tree

`	ext
Scaffold
├── Stack
│   ├── FlutterMap
│   │   └── MarkerLayer
│   │       └── Marker × N
│   │
│   ├── SafeArea
│   │   └── Padding(16)
│   │       └── SearchBar
│   │
│   └── Align(bottomCenter)
│       └── Padding(bottom: 24)
│           └── SingleChildScrollView(
│               scrollDirection: Axis.horizontal,
│               child: Row(
│                   children: ClinicCard × N,
│               ),
│           )
│
└── BottomNavigationBar
`

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tab Loc** | Tap bottom nav ke-2 | Request location permission (jika belum) |
| **Permission: Allow** | Tap "Allow" | Tampilkan map dengan pin klinik terdekat + carousel |
| **Permission: Deny** | Tap "Deny" | Tampilkan fallback input kota |
| **Search bar** | Input teks | Filter clinic list & markers di map by name/keyword |
| **Tap marker** | Tap pin di map | Center map ke klinik + highlight card di carousel |
| **Tap clinic card** | Tap card di carousel | Navigasi ke /doctor/search?clinic=:clinicId |
| **Swipe carousel** | Horizontal scroll | Scroll antar card klinik (auto-update marker highlight) |
| **Pull to refresh** | Swipe bawah di map area | Refresh data klinik & reset map posisi |

**BLoC:** LocCubit — menyimpan state: koordinat user, radius, list klinik, loading/error, search keyword, selected clinic index.

**Edge Cases:**
- GPS mati → fallback input kota (manual latitude/longitude)
- Tidak ada klinik dalam radius → empty state di carousel: "Tidak ada klinik di radius ini, coba perbesar radius"
- Search bar tidak ada hasil → carousel kosong + map tetap tampil tanpa perubahan
- Marker terlalu banyak (>50) → cluster marker via lutter_map_marker_cluster

---

## Perbedaan dengan Wireframe v2.0 (List-based)

| Aspek | v2.0 (List-based) | v3.0 (Map-based) |
|-------|--------------------|-------------------|
| **Layout** | CustomScrollView (vertical scroll) | Stack (full-screen map + overlays) |
| **Map** | 200px partial map (SliverToBoxAdapter) | Full-screen interactive map (dominant) |
| **Clinic Display** | Vertical SliverList | Horizontal ClinicCarousel overlay |
| **Filter Chips** | ✅ Ada (horizontal scroll chips) | ❌ Dihapus |
| **Sort Row** | ✅ Ada (jarak/nama/dokter) | ❌ Dihapus |
| **Info Banner** | ✅ "X klinik ditemukan" | ❌ Dihapus |
| **Search Bar** | AppBar title "Klinik Terdekat" | ✅ In-page SearchBar overlay |
| **Radius Selector** | AppBar dropdown (PopupMenuButton) | ❌ Dihapus (multi-level zoom sebagai ganti) |
| **Pull to Refresh** | RefreshIndicator | Map long-press / button refresh |
| **Card Orientation** | Vertical (single column) | Horizontal (carousel) |

---

## Versi

| Versi | Tanggal | Perubahan |
|-------|---------|-----------|
| v1.0 | Juni 2026 | Initial — nama, alamat, distance, doctor count |
| v2.0 | 24 Juni 2026 | **Redesign:** cover image, favorite button, rating + stars + review count, category badge, distance + duration. Hapus doctor count + "Lihat Peta" button (deferred ke tap card). |
| v3.0 | 28 Juni 2026 | **Map-based redesign (ADR-010):** Layout berubah dari CustomScrollView list-based ke Stack full-screen map-based. Hapus filter chips, sort row, info banner, radius dropdown. Tambah SearchBar overlay, horizontal ClinicCarousel overlay. Map jadi elemen dominan (full-screen), bukan partial 200px. Map package: flutter_map (OpenStreetMap) — sudah ada di pubspec sejak ADR-002. |

(End of file - total 250 lines)
