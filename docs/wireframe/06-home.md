# Home Page

| Field | Detail |
|---|---|
| **Route** | `/home` (Shell Tab 0) |
| **Component** | `HomePage` |
| **Status** | 🔧 Stub — perlu rebuild total |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ "Halo, Rina!"              👤 (48px)│
│                                     │
│  ┌─ Search ─────────────────────┐   │
│  │ 🔍  Search doctor, special.. │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Banner Carousel ────────────┐   │
│  │  ┌──────────────────────┐    │   │
│  │  │   Promo Image #1     │    │   │
│  │  │   "Konsultasi Gratis"│    │   │
│  │  └──────────────────────┘    │   │
│  │      ○ ○ ○ (dots)           │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Upcoming Appointment ───────┐   │
│  │  👤 dr. Budi Santoso        │   │
│  │     Spesialis Penyakit Dalam│   │
│  │     📅 15 Jun 2026 • 09:00  │   │
│  │     🏥 Klinik Sehat Bersama │   │
│  │     [🔔 Reminder Aktif]     │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Quick Categories ───────────┐   │
│  │  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐  │   │
│  │  │  │ │  │ │  │ │  │ │  │  │   │
│  │  │Um│ │An│ │Ku│ │Gi│ │Ma│  │   │
│  │  │um│ │ak│ │lit│ │gi│ │ta│  │   │
│  │  └──┘ └──┘ └──┘ └──┘ └──┘  │   │
│  └──────────────────────────────┘   │
│                                     │
│──────── Bottom Nav Bar ─────────────│
│  🏠 Home  📍 Loc  📋 Hist  👤 Prof │
└─────────────────────────────────────┘
```

### Empty State (no upcoming)
```
┌─────────────────────────────────────┐
│ "Halo, Rina!"              👤 (48px)│
│  ┌─ Search ─────────────────────┐   │
│  │ 🔍  Search doctor, special.. │   │
│  └──────────────────────────────┘   │
│  ┌─ Banner Carousel ────────────┐   │
│  │  ┌──────────────────────┐    │   │
│  │  │   Promo Image #1     │    │   │
│  │  └──────────────────────┘    │   │
│  └──────────────────────────────┘   │
│                                     │
│         📋 Tidak ada jadwal         │
│           appointment hari ini      │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     Cari Dokter Sekarang    │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─ Quick Categories ───────────┐   │
│  │  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐  │   │
│  │  │Um│ │An│ │Ku│ │Gi│ │Ma│  │   │
│  │  │um│ │ak│ │lit│ │gi│ │ta│  │   │
│  │  └──┘ └──┘ └──┘ └──┘ └──┘  │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Zone | Component | Widget | Data Source |
|---|---|---|---|
| Header | Greeting Text | `Text` | `user_profiles.nickname` |
| Header | Avatar | `AppPhotoPicker` (display only) | `user_profiles.avatar_url` |
| Search | Search Bar | `TextField` + prefix icon 🔍 | — |
| Banner | Carousel | `PageView.builder` + `SmoothPageIndicator` | `GET /rest/v1/banners` |
| Banner Item | Card | `Image.network` + overlay text | `banners.image_url` |
| Upcoming | Card | `Container` with border radius | `GET /rest/v1/appointments?status=in.(pending,upcoming)` |
| Categories | Grid | `GridView` / `Wrap` | `specializations` (cached) |
| Category Item | Icon + Label | `GestureDetector` → `Column(Icon, Text)` | `specializations.name` |
| Empty State | Illustration + Text | `Column(Icon, Text, Button)` | — |
| CTA Button | `LightFilledButton` | Navigate ke `/doctor/search` | — |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Greeting** | — | Memuat `nickname` dari `user_profiles` |
| **Tap search bar** | Tap | Focus keyboard → input → navigasi ke `/doctor/search` |
| **Banner swipe** | Geser | `PageView` horizontal, auto-scroll tiap 5 detik |
| **Tap banner** | Tap | Buka `action_url` (deep link / web) |
| **Tap upcoming card** | Tap | Navigasi ke `/booking-history/:appointmentId` |
| **Tap category** | Tap | Navigasi ke `/loc` dengan filter spesialisasi ter-preset |
| **Tap CTA (empty)** | Tap | Navigasi ke `/doctor/search` |
| **Pull to refresh** | Swipe kebawah | Refresh banner + upcoming + categories |

**State Management:** Setiap zone bisa independen:
- Greeting + avatar → `ProfileCubit` atau `UserCubit`
- Banner → `BannerCubit` (auto-refresh tiap 5 menit)
- Upcoming → `AppointmentCubit` (filter `pending` + `upcoming`)
- Categories → `SpecializationCubit` (cache lokal)

**⚠️ Saat ini:** `HomePage` hanya menampilkan `Center(child: Text('Home Page'))` — belum ada satu pun komponen di atas yang terimplementasi.
