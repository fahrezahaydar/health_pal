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
| Loading | Shimmer / `DotLoader` | Selama API call |
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
