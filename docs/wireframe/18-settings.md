# Settings Page

| Field | Detail |
|---|---|
| **Route** | `/profile/settings` (push) |
| **Component** | `SettingsPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    Settings                │
│                                     │
│  ┌─ List ───────────────────────┐   │
│  │  🌐 Bahasa                  │   │
│  │     Indonesia           ▶   │   │
│  ├──────────────────────────────┤   │
│  │  🔒 Ubah Password           │   │
│  │                          ▶  │   │
│  ├──────────────────────────────┤   │
│  │  💾 Hapus Cache             │   │
│  │     12.5 MB             [X] │   │
│  ├──────────────────────────────┤   │
│  │  ℹ️ Versi Aplikasi           │   │
│  │     v1.0.0 (build 1)        │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Language | `ListTile` | Multi-language (v1.1) |
| Change Password | `ListTile` | Link ke `/sign-in/forgot-password` (atau flow terpisah) |
| Clear Cache | `ListTile` + value | Hapus cache lokal |
| App Version | `ListTile` | Informational, tidak interaktif |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap Bahasa** | Tap | Bottom sheet pilihan bahasa (v1.1) |
| **Tap "Ubah Password"** | Tap | Navigasi ke `/sign-in/forgot-password` |
| **Tap "Hapus Cache"** | Tap | Dialog konfirmasi → hapus cache + snackbar |

**Notes:**
- Bahasa: out of scope MVP (v1.1)
- Ubah Password: reuse flow Forgot Password yang sudah ada
