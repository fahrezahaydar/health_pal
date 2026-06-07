# Booking History Page

| Field | Detail |
|---|---|
| **Route** | `/booking-history` (Shell Tab 2) |
| **Component** | `BookingHistoryPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ 📋 Booking History                  │
│                                     │
│  ┌── Tabbar ────────────────────┐   │
│  │ [Semua] [Pending] [Upcoming] │   │
│  │ [Completed] [Canceled]       │   │
│  │      ──────underline──────   │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Appointment Card ────────────┐   │
│  │ 👤 dr. Budi Santoso, Sp.PD    │   │
│  │    🏥 Klinik Sehat Bersama    │   │
│  │    📅 15 Jun 2026 • 09:00     │   │
│  │                    [🟡 Pending]│   │
│  └──────────────────────────────┘   │
│  ┌─ Appointment Card ────────────┐   │
│  │ 👤 dr. Sari Dewi, Sp.A        │   │
│  │    🏥 RS Mitra Husada         │   │
│  │    📅 10 Jun 2026 • 14:00     │   │
│  │                    [🟢 Upcoming]│   │
│  └──────────────────────────────┘   │
│  ┌─ Appointment Card ────────────┐   │
│  │ 👤 dr. Andi, Sp.KK            │   │
│  │    🏥 Klinik Kulit Sehat      │   │
│  │    📅 01 Jun 2026 • 10:00     │   │
│  │                    [🔵 Completed]│   │
│  └──────────────────────────────┘   │
│                                     │
│         [Loading more...]           │
│                                     │
│──────── Bottom Nav Bar ─────────────│
│  🏠 Home  📍 Loc  📋 Hist  👤 Prof │
└─────────────────────────────────────┘
```

### Empty State for Tab
```
│  ┌─ Appointment Card ────────────┐   │
│                                  │   │
│         📋 Tidak ada             │   │
│      appointment dengan          │   │
│      status "Pending"            │   │
│                                  │   │
│  └──────────────────────────────┘   │
```

---

## Component Breakdown

| Component | Widget | Data Source |
|---|---|---|
| Page Title | `Text` | "Booking History" |
| Tabbar | `TabBar` (5 tabs) | `TabController(length: 5)` |
| Tab Items | `Tab` | Semua, Pending, Upcoming, Completed, Canceled |
| TabView | `TabBarView` | 5 halaman, masing-masing `ListView.builder` |
| Appointment Card | `Container` + `InkWell` | `GET /rest/v1/appointments?patient_id=&status=` |
| Status Badge | `Container` with color | Pending=🟡, Upcoming=🟢, Completed=🔵, Canceled=🔴 |
| Doctor Photo | `Image.network` (circle, 40px) | `doctors.photo_url` |
| Pagination | `ScrollController` | Infinite scroll, limit=20 |

**Status Badge Colors:**
| Status | Warna | Hex |
|---|---|---|
| Pending | Amber / Kuning | `#FFA726` |
| Upcoming | Hijau | `#4CAF50` |
| Completed | Biru | `#2196F3` |
| Canceled | Merah / Abu | `#EF5350` / `#9E9E9E` |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap tab** | Tap chip tab | Filter by status → refresh list via Cubit |
| **Tap appointment card** | Tap | Navigasi ke `/booking-history/:appointmentId` |
| **Pull to refresh** | Swipe bawah | Refresh seluruh list untuk tab aktif |
| **Scroll ke bawah** | Scroll | Infinite scroll, load 20 item berikutnya |
| **Tab berubah** | — | `BookingHistoryCubit.filterByStatus(status)` |
| **Empty state** | Auto | Tampilkan "Tidak ada appointment dengan status X" |
| **Error state** | API error | Snackbar: "Gagal memuat riwayat" + retry |

**BLoC:** `BookingHistoryCubit` — states per tab: `loading`, `loaded(appointments, hasMore)`, `empty`, `error`.

**Tab Filter Logic:**
- "Semua" → tanpa parameter `status`
- "Pending" → `status=eq.pending`
- "Upcoming" → `status=eq.upcoming`
- "Completed" → `status=eq.completed`
- "Canceled" → `status=eq.cancelled`
