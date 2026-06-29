# Profile Screen Wireframe Documentation

## ASCII Wireframe

```text
┌──────────────────────────────────────────────┐
│                                              │
│                 Profile                      │
│                                              │
│            ┌───────────────┐                 │
│            │               │                 │
│            │   Avatar      │◉ Edit           │
│            │               │                 │
│            └───────────────┘                 │
│                                              │
│            Daniel Martinez                   │
│            +123 856479683                    │
│                                              │
├──────────────────────────────────────────────┤
│ 👤  Edit Profile                        >    │
├──────────────────────────────────────────────┤
│ ♡   Favorite                            >    │
├──────────────────────────────────────────────┤
│ 🔔  Notifications                       >    │
├──────────────────────────────────────────────┤
│ ⚙   Settings                           >     │
├──────────────────────────────────────────────┤
│ 💬  Help & Support                     >      │
├──────────────────────────────────────────────┤
│ 🛡   Terms & Conditions                >      │
├──────────────────────────────────────────────┤
│ ↩   Log Out                                   │
│                                              │
│                                              │
│                                              │
├──────────────────────────────────────────────┤
│   Home    Location   Calendar    Profile     │
└──────────────────────────────────────────────┘
```

---

## Layout Structure

```text
Scaffold
├── SafeArea
│
├── Column
│   │
│   ├── Page Title
│   │
│   ├── Profile Header
│   │   ├── Avatar
│   │   ├── Edit Avatar Button
│   │   ├── Name
│   │   └── Phone Number
│   │
│   ├── Menu List
│   │   ├── Edit Profile
│   │   ├── Favorite
│   │   ├── Notifications
│   │   ├── Settings
│   │   ├── Help & Support
│   │   ├── Terms & Conditions
│   │   └── Log Out
│   │
│   └── Spacer
│
└── BottomNavigationBar
```

---

## Component Hierarchy

```text
ProfileScreen
│
├── App Header
│   └── Text (Profile)
│
├── Profile Header
│   ├── Stack
│   │   ├── Circle Avatar
│   │   └── Edit Avatar FAB
│   │
│   ├── User Name
│   └── Phone Number
│
├── Settings Menu
│   │
│   ├── ProfileMenuTile
│   ├── ProfileMenuTile
│   ├── ProfileMenuTile
│   ├── ProfileMenuTile
│   ├── ProfileMenuTile
│   ├── ProfileMenuTile
│   └── LogoutMenuTile
│
└── Bottom Navigation
```

---

## Components Table

| Component | Flutter Widget | Description |
|------------|----------------|-------------|
| Screen | `Scaffold` | Main screen container |
| Safe Area | `SafeArea` | Prevent overlap with system UI |
| Header | `Text` | Screen title |
| Avatar | `CircleAvatar` / `ClipOval` | User profile picture |
| Avatar Edit | `Positioned` + `IconButton` | Edit profile picture button |
| Name | `Text` | User full name |
| Phone | `Text` | Phone number |
| Menu Container | `Expanded` + `ListView` | Scrollable menu list |
| Menu Item | `ListTile` | Icon, title, trailing arrow |
| Divider | `Divider` | Separator between menu items |
| Logout Item | `ListTile` | Logout action |
| Bottom Navigation | `NavigationBar` | Bottom navigation menu |

---

## Suggested Flutter Widget Tree

```text
Scaffold
├── SafeArea
│   └── Column
│       ├── SizedBox
│       ├── Text("Profile")
│       ├── SizedBox
│       ├── Center
│       │   └── Column
│       │       ├── Stack
│       │       │   ├── CircleAvatar
│       │       │   │   └── CachedNetworkImage
│       │       │   └── Positioned
│       │       │       └── FilledButton/IconButton
│       │       ├── SizedBox
│       │       ├── Text(User Name)
│       │       └── Text(Phone Number)
│       │
│       ├── SizedBox
│       │
│       ├── Expanded
│       │   └── ListView.separated
│       │       ├── ProfileMenuTile
│       │       ├── ProfileMenuTile
│       │       ├── ProfileMenuTile
│       │       ├── ProfileMenuTile
│       │       ├── ProfileMenuTile
│       │       ├── ProfileMenuTile
│       │       └── LogoutMenuTile
│       │
│       └── SizedBox
│
└── NavigationBar
    ├── NavigationDestination (Home)
    ├── NavigationDestination (Location)
    ├── NavigationDestination (Appointment)
    └── NavigationDestination (Profile)
```

---

## Reusable Widgets Suggestion

```text
ProfileHeader
├── Avatar
├── Edit Avatar Button
├── Name
└── Phone Number

ProfileMenuTile
├── Leading Icon
├── Title
├── Optional Subtitle
├── Trailing Chevron
└── onTap

LogoutMenuTile
├── Logout Icon
├── Title
└── onTap
```

---

## Recommended Folder Structure

```text
profile/
├── pages/
│   └── profile_page.dart
│
├── widgets/
│   ├── profile_header.dart
│   ├── profile_avatar.dart
│   ├── profile_menu_tile.dart
│   └── logout_menu_tile.dart
│
├── models/
│   └── profile_menu.dart
│
└── bloc/
    ├── profile_cubit.dart
    └── profile_state.dart
```

---

## Update Flow — Logout Confirmation

```text
Profile Screen
│
├── Profile Header
├── Menu List
│   ├── Edit Profile
│   ├── Favorite
│   ├── Notifications
│   ├── Settings
│   ├── Help & Support
│   ├── Terms & Conditions
│   └── Log Out
│          │
│          ▼
│    Logout Confirmation Dialog
│          │
│     ┌────┴────┐
│     │         │
│  Cancel   Yes, Logout
│     │         │
│     │         ▼
│     │    Logout Process
│     │         │
│     │         ▼
│     │   Navigate to Login
│     │
│     ▼
│  Close Dialog
│
└── Bottom Navigation
```

### Logout Modal Wireframe

```text
                    ┌────────────────────────────┐
                    │           Logout           │
                    ├────────────────────────────┤
                    │                            │
                    │ Are you sure you want     │
                    │ to log out?               │
                    │                            │
                    │ ┌──────────┐ ┌──────────┐ │
                    │ │ Cancel   │ │Yes,Logout│ │
                    │ └──────────┘ └──────────┘ │
                    └────────────────────────────┘
```

### Logout Component Table

| Component | Flutter Widget | Description |
|------------|----------------|-------------|
| Logout Dialog | `AlertDialog` / `Dialog` | Confirmation dialog before logout |
| Dialog Title | `Text` | "Logout" |
| Dialog Message | `Text` | Confirmation message |
| Cancel Button | `OutlinedButton` / `FilledButton.tonal` | Close dialog |
| Confirm Button | `FilledButton` | Perform logout |
| Dialog Actions | `Row` | Horizontal action buttons |

### Logout Interaction Flow

```text
User taps "Log Out"
        │
        ▼
Show Logout Dialog
        │
        ├──────────────┐
        │              │
        ▼              ▼
    Cancel       Yes, Logout
        │              │
        ▼              ▼
 Close Dialog     Logout User
                       │
                       ▼
             Clear Authentication
                       │
                       ▼
             Navigate to Login Screen
```

---

## Changelog

| Versi | Tanggal | Perubahan |
|---|---|---|
| v1.0 | Jun 2026 | Initial wireframe (old: avatar + nickname + email, menu: Edit/Favorite/Notification/Settings/Help/T&C/Logout) |
| v2.0 | 30 Jun 2026 | Redesign: avatar edit overlay button, phone number replaces nickname + email, menu labels updated (plural "Notifications", "Help & Support", "Terms & Conditions", "Log Out"), bottom nav labels clarified (Home/Location/Calendar/Profile), logout dialog layout specified, reusable widgets suggestion added |
