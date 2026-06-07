# No Internet Page

| Field | Detail |
|---|---|
| **Route** | `/no-internet` (fullscreen) |
| **Component** | `NoInternetPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│            ┌──────────────┐          │
│            │    📡        │          │
│            │  (offline)   │          │
│            │  ilustrasi   │          │
│            └──────────────┘          │
│                                     │
│       "Tidak Ada Koneksi"           │
│     "Periksa koneksi internetmu     │
│      dan coba lagi."               │
│                                     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │         Coba Lagi           │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Illustration | `Image.asset` / `Icon` | Offline illustration |
| Title | `Text` | "Tidak Ada Koneksi" |
| Description | `Text` | "Periksa koneksi internetmu dan coba lagi." |
| Retry Button | `LightFilledButton` | Tap → cek koneksi → retry |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap "Coba Lagi"** | Tap | Cek koneksi → jika online: `context.pop()`; jika offline: tetap + snackbar |
| **Koneksi pulih otomatis** | `connectivity_plus` listener | Auto-pop jika user sedang di halaman ini |

**Trigger ditampilkan:**
- App launch → `AppServices.init()` gagal karena offline
- Setiap API call gagal karena network error → navigasi ke `/no-internet` (hanya jika di splash/pre-auth)
- Jika di dalam app: snackbar "Periksa koneksi" (tanpa navigasi)
