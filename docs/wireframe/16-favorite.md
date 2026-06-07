# Favorite Page

| Field | Detail |
|---|---|
| **Route** | `/profile/favorite` (push) |
| **Component** | `FavoritePage` |
| **Status** | 🔧 Proposed (v1.1) |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    Favorite Dokter         │
│                                     │
│  ┌─ Doctor Card ────────────────┐   │
│  │ 👤 dr. Budi Santoso, Sp.PD   │   │
│  │    ⭐ 4.85 (234 ulasan)      │   │
│  │    🏥 Klinik Sehat Bersama   │   │
│  │    📍 Bandung        ❤️      │   │
│  └──────────────────────────────┘   │
│  ┌─ Doctor Card ────────────────┐   │
│  │ 👤 dr. Sari Dewi, Sp.A       │   │
│  │    ⭐ 4.70 (189 ulasan)      │   │
│  │    🏥 RS Mitra Husada        │   │
│  │    📍 Bandung        ❤️      │   │
│  └──────────────────────────────┘   │
│                                     │
│         [Loading more...]           │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Page Title | `Text` | "Favorite Dokter" |
| Doctor Card | Same card as Loc/Search | Reusable `DoctorCard` widget |
| Favorite Icon | `IconButton` (filled ❤️) | Tap → unfavorite |
| Empty State | `Column(Icon, Text)` | "Belum ada dokter favorit" |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap back** | Tap | `context.pop()` |
| **Tap doctor card** | Tap | Navigasi ke `/doctor/:doctorId` |
| **Tap ❤️** | Tap | Unfavorite → hapus dari list + snackbar "Dihapus dari favorit" |
| **Pull to refresh** | Swipe | Refresh list |

**Notes:**
- Fitur ini masuk **v1.1 roadmap** (out of scope MVP berdasarkan PRD)
- Data disimpan di tabel `doctor_favorites` (belum ada di ERD — perlu ditambahkan)

Daftar favorite pasien.
