# Notification Settings Page

| Field | Detail |
|---|---|
| **Route** | `/profile/notification` (push) |
| **Component** | `NotificationPage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    Notification            │
│                                     │
│  ┌─ Toggle List ────────────────┐   │
│  │  🔔 Reminder Appointment     │   │
│  │  "Dapatkan pengingat sebelum │   │
│  │   jadwal konsultasi"         │   │
│  │                          [🔊]│   │
│  ├──────────────────────────────┤   │
│  │  💬 Promo & Tips Kesehatan   │   │
│  │  "Info promo dan tips dari   │   │
│  │   mitra klinik"             │   │
│  │                          [🔊]│   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Inbox Notifikasi ───────────┐   │
│  │  🔔 15 Jun 09:00             │   │
│  │  "Jangan lupa! Besok kamu    │   │
│  │   ada jadwal dengan dr.Budi" │   │
│  ├──────────────────────────────┤   │
│  │  🔔 07 Jun 11:00             │   │
│  │  "Booking kamu dengan        │   │
│  │   dr.Budi sudah dikonfirmasi"│   │
│  ├──────────────────────────────┤   │
│  │  🔔 07 Jun 10:30             │   │
│  │  "Booking berhasil! Menunggu │   │
│  │   konfirmasi."               │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Section | Component | Widget |
|---|---|---|
| Toggle | Reminder Toggle | `Switch` / `CupertinoSwitch` |
| Toggle | Promo Toggle | `Switch` |
| Inbox Title | Section Header | `Text` "Riwayat Notifikasi" |
| Inbox Item | Notification Card | `Container` + `InkWell` |
| Inbox Item Text | Title + Body | `Column(Text)` |
| Dot Unread | Unread indicator | Small circle (biru jika `is_read = false`) |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Toggle Reminder** | On/Off | `PATCH /rest/v1/user_profiles` → `notif_reminder_enabled` |
| **Toggle Promo** | On/Off | `PATCH /rest/v1/user_profiles` → `notif_promo_enabled` (kolom baru) |
| **Tap inbox item** | Tap | Mark as read → push /booking-history/:appointmentId |
| **Pull to refresh** | Swipe | Refresh inbox dari API |

**Data Source:** `GET /rest/v1/notifications?user_id=&order=sent_at.desc`
