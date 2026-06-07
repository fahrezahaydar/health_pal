# Help and Support Page

| Field | Detail |
|---|---|
| **Route** | `/profile/help` (push) |
| **Component** | `HelpSupportPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    Help and Support        │
│                                     │
│  ┌─ FAQ List ───────────────────┐   │
│  │  ❓ Bagaimana cara booking   │   │
│  │     dokter?              ▶   │   │
│  ├──────────────────────────────┤   │
│  │  ❓ Bagaimana membatalkan    │   │
│  │     appointment?         ▶   │   │
│  ├──────────────────────────────┤   │
│  │  ❓ Apakah data saya aman?   │   │
│  │                          ▶   │   │
│  ├──────────────────────────────┤   │
│  │  ❓ Bagaimana cara ganti     │   │
│  │     password?            ▶   │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌── Contact Us ────────────────┐   │
│  │  📧 Email: support@healthpal │   │
│  │  📞 Telepon: 021-12345678    │   │
│  │  💬 Live Chat (09:00-21:00)  │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| FAQ Items | `ExpansionTile` / custom | Expandable QA |
| Contact Section | `Container` | Static info |
| Email | `GestureDetector` | Buka email client |
| Phone | `GestureDetector` | Buka dialer |
| Live Chat | `GestureDetector` | v1.1 |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap FAQ** | Tap | Expand/collapse jawaban |
| **Tap email** | Tap | Buka `mailto: support@healthpal.app` |
| **Tap telepon** | Tap | Buka `tel: 021-12345678` |
| **Tap Live Chat** | Tap | Snackbar: "Fitur belum tersedia" (v1.1) |
