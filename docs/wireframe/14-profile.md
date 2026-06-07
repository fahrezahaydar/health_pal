# Profile Page

| Field | Detail |
|---|---|
| **Route** | `/profile` (Shell Tab 3) |
| **Component** | `ProfilePage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│            Profile                  │
│                                     │
│  ┌─ User Card ──────────────────┐   │
│  │                             │   │
│  │      ┌──────────┐           │   │
│  │      │  Avatar  │           │   │
│  │      │  (80px)  │           │   │
│  │      └──────────┘           │   │
│  │        Rina Kartika          │   │
│  │        @rina                 │   │
│  │        rina@example.com      │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Menu List ──────────────────┐   │
│  │  👤  Edit Profile        ▶  │   │
│  ├──────────────────────────────┤   │
│  │  ❤️  Favorite            ▶  │   │
│  ├──────────────────────────────┤   │
│  │  🔔  Notification       [🔊]│   │
│  ├──────────────────────────────┤   │
│  │  ⚙️  Settings            ▶  │   │
│  ├──────────────────────────────┤   │
│  │  🆘  Help and Support    ▶  │   │
│  ├──────────────────────────────┤   │
│  │  📄  T & C               ▶  │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │          Logout             │    │
│  └─────────────────────────────┘    │
│                                     │
│──────── Bottom Nav Bar ─────────────│
│  🏠 Home  📍 Loc  📋 Hist  👤 Prof │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Data Source |
|---|---|---|
| Avatar | `AppPhotoPicker` (display) | `user_profiles.avatar_url` |
| Full Name | `Text` | `user_profiles.full_name` |
| Nickname | `Text` | `@user_profiles.nickname` |
| Email | `Text` | `user_profiles.email` (auth) |
| Menu Items | `ListTile` / custom `GestureDetector` | Static list |
| Toggle Notif | `Switch` / `CupertinoSwitch` | `user_profiles.notif_reminder_enabled` |
| Logout Button | `LightFilledButton` (red outline) | Konfirmasi dialog → `AppServices.logout()` |
| Logout Dialog | `AppCustomDialog` | "Yakin ingin logout?" |

**Menu Item Mapping:**
| Icon | Label | Route |
|---|---|---|
| 👤 | Edit Profile | `/profile/edit` |
| ❤️ | Favorite | `/profile/favorite` |
| 🔔 | Notification | `/profile/notification` |
| ⚙️ | Settings | `/profile/settings` |
| 🆘 | Help and Support | `/profile/help` |
| 📄 | T & C | `/profile/tnc` |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap "Edit Profile"** | Tap | Push `/profile/edit` |
| **Tap "Favorite"** | Tap | Push `/profile/favorite` |
| **Tap "Notification"** | Tap | Push `/profile/notification` |
| **Toggle Notification** | Toggle switch | `PATCH /rest/v1/user_profiles` → update `notif_reminder_enabled` |
| **Tap "Settings"** | Tap | Push `/profile/settings` |
| **Tap "Help and Support"** | Tap | Push `/profile/help` |
| **Tap "T & C"** | Tap | Push `/profile/tnc` |
| **Tap "Logout"** | Tap | Dialog konfirmasi → ya: `AppServices.logout()` → redirect `/sign-in` |
| **Pull to refresh** | Swipe bawah | Refresh profil dari API |

**⚠️ Catatan:** Profile page dan seluruh sub-pages belum ada implementasinya.
