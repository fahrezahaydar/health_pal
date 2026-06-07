# Terms & Conditions Page

| Field | Detail |
|---|---|
| **Route** | `/profile/tnc` (push) |
| **Component** | `TermsAndConditionsPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    Terms & Conditions      │
│                                     │
│  ┌─ Content ────────────────────┐   │
│  │  📄 1. Ketentuan Umum       │   │
│  │     Lorem ipsum dolor sit    │   │
│  │     amet, consectetur        │   │
│  │     adipiscing elit...       │   │
│  │                             │   │
│  │  2. Privasi & Data          │   │
│  │     Sed do eiusmod tempor   │   │
│  │     incididunt ut labore... │   │
│  │                             │   │
│  │  3. Penggunaan Layanan      │   │
│  │     Ut enim ad minim veniam,│   │
│  │     quis nostrud...         │   │
│  │                             │   │
│  │  4. Batasan Tanggung Jawab  │   │
│  │     Duis aute irure dolor   │   │
│  │     in reprehenderit...     │   │
│  │                             │   │
│  │  5. Perubahan Ketentuan     │   │
│  │     Excepteur sint occaecat │   │
│  │     cupidatat non...        │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Title | `Text` | "Terms & Conditions" |
| Content | `ListView` / `SingleChildScrollView` | Read-only text |
| Section Title | `Text` | Bold, section headings |
| Section Body | `Text` | `bodySmall` |

**Notes:**
- Halaman statis, tidak ada interaksi selain scroll dan back
- Konten diambil dari legal document yang perlu disiapkan tim legal
