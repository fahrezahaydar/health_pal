# Doctor Search Page

| Field | Detail |
|---|---|
| **Route** | `/doctor/search` (push) |
| **Component** | `DoctorSearchPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    🔍 Cari Dokter         │
│                                     │
│  ┌─ Search Bar ─────────────────┐   │
│  │ 🔍  Nama / Spesialisasi  [X]│   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌── Filter Chips ──────────────┐   │
│  │ [Semua] [Umum] [Anak] [Kulit]│   │
│  │ [Gigi] [+More ▼]            │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Doctor Card ────────────────┐   │
│  │ 👤 dr. Budi Santoso, Sp.PD   │   │
│  │    ⭐ 4.85 (234 ulasan)      │   │
│  │    🏥 Klinik Sehat Bersama   │   │
│  │    📍 Bandung                │   │
│  │    💰 Rp150,000              │   │
│  └──────────────────────────────┘   │
│  ┌─ Doctor Card ────────────────┐   │
│  │ 👤 dr. Sari Dewi, Sp.A       │   │
│  │    ⭐ 4.70 (189 ulasan)      │   │
│  │    🏥 RS Mitra Husada        │   │
│  │    📍 Bandung                │   │
│  │    💰 Rp120,000              │   │
│  └──────────────────────────────┘   │
│  ┌─ Doctor Card ────────────────┐   │
│  │ 👤 dr. Andi, Sp.KK           │   │
│  │    ⭐ 4.90 (312 ulasan)      │   │
│  │    🏥 Klinik Kulit Sehat     │   │
│  │    📍 Bandung                │   │
│  │    💰 Rp200,000              │   │
│  └──────────────────────────────┘   │
│                                     │
│         [Loading more...]           │
└─────────────────────────────────────┘
```

### Empty State
```
┌─────────────────────────────────────┐
│ ← (back)    🔍 Cari Dokter         │
│                                     │
│  ┌─ Search Bar ─────────────────┐   │
│  │ 🔍  xxxxxxxxxxxxxx      [X]  │   │
│  └──────────────────────────────┘   │
│                                     │
│        🔍                           │
│    "Dokter tidak ditemukan"         │
│   Coba gunakan kata kunci lain      │
│                                     │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Data Source |
|---|---|---|
| AppBar | `Row(Back, SearchInput)` | — |
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Search Input | `TextField` | `onChanged` → debounce 300ms |
| Clear Button | `Icon(Iconsax.closeCircle)` | Hapus text + reset results |
| Filter Chips | `ListView` horizontal | `specializations` list |
| Doctor Card | Same as `LocPage` reusable card | `GET /rest/v1/doctors?full_name=ilike.*keyword*` |
| Loading | Skeletonizer (reuse production card widget via `Skeletonizer(enabled: true, child: DoctorCard(...))`) | Selama API call |
| Empty State | `Column(Icon, Text)` | Array response = 0 |
| Pagination | `ScrollController` listener | Infinite scroll, limit=20 |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Search input** | Mengetik | Debounce 300ms → `GET /rest/v1/doctors` dengan `ilike` |
| **Clear [X]** | Tap | Hapus input → reset list ke initial state |
| **Filter chip** | Tap | `specialization_id` filter → refresh list |
| **Tap doctor card** | Tap | Navigasi ke `/doctor/:doctorId` |
| **Scroll ke bawah** | Scroll | Trigger pagination (limit/offset) |
| **Empty result** | Auto | Tampilkan "Dokter tidak ditemukan" |
| **Network error** | Auto | Snackbar: "Periksa koneksi" + retry button |

**Debounce Logic:**
```
User mengetik "bud" → wait 300ms → API call
User mengetik "budi" dalam 300ms → cancel previous → wait 300ms baru → API call
```

**BLoC:** `SearchCubit` — states: `SearchInitial`, `SearchLoading`, `SearchLoaded(doctors, hasMore)`, `SearchError`, `SearchEmpty`.

---

## Doctor Card — v2.0 (Redesigned)

```text
┌──────────────────────────────────────────────────────────────┐
│ ┌────────────┐  Dr. David Patel                    ♡          │
│ │            │─────────────────────────────────────────────── │
│ │   Photo    │  Cardiologist                               │
│ │  (1:1)     │                                              │
│ │            │  📍 Cardiology Center, USA                  │
│ └────────────┘                                              │
│                ⭐ 5.0   |   1,872 Reviews                   │
└──────────────────────────────────────────────────────────────┘
```

### Layout Structure
```text
Card
└── Row
    ├── Left
    │   └── Doctor Image
    │       ├── Aspect Ratio: 1:1
    │       └── Rounded Corners
    │
    └── Right (Expanded)
        ├── Top Row
        │   ├── Doctor Name
        │   └── Favorite Button
        ├── Divider
        ├── Specialization
        ├── Location Row
        │   ├── Location Icon
        │   └── Hospital/Clinic Name
        └── Rating Row
            ├── Star Icon
            ├── Rating Value
            ├── Separator
            └── Review Count
```

### Components

| Component       | Description                                         |
| --------------- | --------------------------------------------------- |
| Doctor Image    | Doctor profile photo with rounded corners           |
| Favorite Button | Heart icon (outline/filled) positioned at top-right |
| Doctor Name     | Doctor's full name                                  |
| Divider         | Horizontal divider below the name                   |
| Specialization  | Doctor's medical specialty                          |
| Location        | Hospital or clinic name with location icon          |
| Rating          | Star icon with average rating                       |
| Reviews         | Total number of patient reviews                     |

### Suggested Flutter Widget Tree
```text
Card
└── InkWell
    └── Padding
        └── Row
            ├── ClipRRect
            │   └── AspectRatio(1/1)
            │       └── Image
            ├── SizedBox(width: 16)
            └── Expanded
                └── Column
                    ├── Row
                    │   ├── Expanded(Text: Name)
                    │   └── FavoriteButton
                    ├── Divider
                    ├── Text(Specialization)
                    ├── Row(Location)
                    └── Row(Rating)
```

> **Versi:** v2.0 — 27 Juni 2026
> **Perubahan dari v1.0 (ASCII di atas):**
> - Layout berubah dari vertikal (full-width list) ke horizontal (foto kiri, info kanan)
> - **Tambah:** Foto dokter dengan aspect ratio 1:1 (persegi, rounded corners)
> - **Tambah:** Favorite button (❤️) di pojok kanan atas card
> - **Tambah:** Rating row dengan separator (⭐ 5.0 | 1,872 Reviews)
> - **Tambah:** Location icon sebelum nama klinik/rumah sakit
> - **Tambah:** Divider horizontal di bawah nama dokter
> - **Hapus:** Icon 👤 (diganti foto profil)
> - **Hapus:** Icon 💰 biaya konsultasi (dipindah ke halaman detail)
> - **Hapus:** Kota (📍) — lokasi sekarang pakai nama klinik + icon, kota ditampilkan di halaman detail
