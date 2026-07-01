# HealthPalAppBar — Wireframe v1.0

| Field | Detail |
|---|---|
| **Component** | `HealthPalAppBar` |
| **Pengguna** | Semua page yang menggunakan `Scaffold.appBar` (14 pages) |
| **Status** | 🔧 Proposed (v1.0) |
| **Tanggal** | 1 Juli 2026 |
| **Supersedes** | Inline `AppBar(...)` di 14 page (replaced by single component) |

---

## 1. Latar Belakang

Audit AppBar (1 Juli 2026) menemukan 14 page dengan inline `AppBar(...)`:

| Masalah | Dampak |
|---|---|
| **14 duplikasi kode** — setiap page define AppBar sendiri dengan properti yang 90% sama | Maintenance burden, inkonsistensi visual |
| **3 icon Material langsung** (`Icons.arrow_back`) tanpa TODO comment | Melanggar Icon Convention AGENTS.md (Sprint 2+) |
| **2 page pakai default back button** — tidak konsisten dengan 6 page lain yang pakai `AppIcons.arrowBack` | Visual inconsistency |
| **Semua file import `material.dart`** untuk AppBar | Melanggar AGENTS.md "No Material package — use raw Flutter widgets only" |
| **0 reusable widget** — tidak ada custom AppBar atau PreferredSizeWidget | Setiap perubahan style perlu diedit di 14 tempat |

---

## 2. Inventaris AppBar per Page

| No | Page | Variasi | Leading | Title | Actions | backgroundColor | elevation | centerTitle | Note |
|:---:|------|:-------:|:-------:|:-----:|:------:|:--------------:|:---------:|:----------:|------|
| 1 | `create_profile_page.dart` | Back Only | `AppIcons.arrowBack` | (none) | — | default | default | — | Auth flow |
| 2 | `icon_page.dart` | Title Only | default back | `Text('App Icons (${icons.length})')` | — | default | default | — | Dev tool |
| 3 | `booking_detail_page.dart` | Standard | `Icons.arrow_back` | `Text('Detail Appointment')` | — | `white` | `0` | — | Material icon |
| 4 | `booking_history_page.dart` | +TabBar | default back | `Text('My Bookings')` | — | `white` | `0` | `true` | TabBar bottom |
| 5 | `book_appointment_page.dart` | Standard | `Icons.arrow_back` | `Text('Book Appointment')` | — | `white` | `0` | `true` | Material icon |
| 6 | `doctor_detail_page.dart` | +Favorite | `Icons.arrow_back` | `Text('Detail Dokter')` | `favorite` toggle | `white` | `0` | `true` | Material icon |
| 7 | `doctor_search_page.dart` | Standard | `Icons.arrow_back` | `Text('Cari Dokter')` | — | `white` | `0` | `true` | Material icon |
| 8 | `edit_profile_page.dart` | Standard | `AppIcons.arrowBack` | `Text('Edit Profile')` | — | `white` | `0` | `true` | Custom icon |
| 9 | `favorite_page.dart` | Standard | `AppIcons.arrowBack` | `Text('Favorite')` | — | `white` | `0` | `true` | Custom icon |
| 10 | `notification_page.dart` | Dynamic | `AppIcons.arrowBack` | `Text('Notifikasi')` + badge | `Tandai semua` button | `white` | `0` | `true` | Dynamic |
| 11 | `profile_page.dart` | Root (no back) | (none) | `Text('Profile')` | — | `white` | `0` | `true` | Tab page |
| 12 | `help_support_page.dart` | Standard | `AppIcons.arrowBack` | `Text('Help & Support')` | — | `white` | `0` | `true` | Custom icon |
| 13 | `settings_page.dart` | Root (no back) | (none) | `Text('Settings')` | — | `white` | `0` | `true` | Tab page |
| 14 | `terms_and_conditions_page.dart` | Standard | `AppIcons.arrowBack` | `Text('Terms & Conditions')` | — | `white` | `0` | `true` | Custom icon |

---

## 3. Variant Wireframes

### Variant 1 — Root / Tab Page (no leading, title only)

```text
┌─────────────────────────────────────────────┐
│               Profile                       │  ← Title (center)
├─────────────────────────────────────────────┤
│                                               │
```

**Used by:** `profile_page.dart`, `settings_page.dart`
**Count:** 2 pages

### Variant 2 — Standard (leading back + title)

```text
┌─────────────────────────────────────────────┐
│ ←   Edit Profile                            │  ← Leading (arrow) + Title
├─────────────────────────────────────────────┤
│                                               │
```

**Used by:** `booking_detail_page.dart`, `book_appointment_page.dart`, `doctor_search_page.dart`, `edit_profile_page.dart`, `favorite_page.dart`, `help_support_page.dart`, `terms_and_conditions_page.dart`
**Count:** 7 pages

### Variant 3 — Back Only (leading back, no title)

```text
┌─────────────────────────────────────────────┐
│ ←                                           │  ← Leading only
├─────────────────────────────────────────────┤
│                                               │
```

**Used by:** `create_profile_page.dart`
**Count:** 1 page

### Variant 4 — With Action (leading back + title + action icon)

```text
┌─────────────────────────────────────────────┐
│ ←  Detail Dokter                     ♥      │  ← Leading + Title + Action
├─────────────────────────────────────────────┤
│                                               │
```

**Used by:** `doctor_detail_page.dart`
**Count:** 1 page

### Variant 5 — With TabBar (leading back + title + tab bar bottom)

```text
┌─────────────────────────────────────────────┐
│ ←  My Bookings                              │
├─────────────────────────────────────────────┤
│ Semua  Pending  Upcoming  Completed  Cancelled│  ← TabBar
└─────────────────────────────────────────────┘
```

**Used by:** `booking_history_page.dart`
**Count:** 1 page

### Variant 6 — Dynamic Title + Action (title badge + conditional action)

```text
┌─────────────────────────────────────────────┐
│ ←  Notifikasi  [3]          Tandai semua     │  ← Badge + Action
├─────────────────────────────────────────────┤
│                                               │
```

**Used by:** `notification_page.dart`
**Count:** 1 page

### Variant 7 — Title Only (no leading, title with counter)

```text
┌─────────────────────────────────────────────┐
│          App Icons (42)                      │  ← Title with counter
├─────────────────────────────────────────────┤
│                                               │
```

**Used by:** `icon_page.dart`
**Count:** 1 page

---

## 4. Component Hierarchy

```
Scaffold
 └── appBar: HealthPalAppBar (PreferredSizeWidget)       ← Single component
      ├── — showBack: bool                               ← If true, show leading arrow
      ├── — title: Widget?                               ← Title widget
      ├── — actions: List<Widget>?                       ← Right-side actions
      ├── — bottom: PreferredSizeWidget?                 ← For TabBar case
      ├── — backgroundColor: Color                       ← Default AppTheme.white
      ├── — elevation: double                            ← Default 0
      └── — centerTitle: bool                            ← Default true
```

### Special Cases (handled by page, not by HealthPalAppBar)

- **notification_page.dart**: Title with unread badge + conditional "Tandai semua" → passed as `title:` widget (pre-built Row) and `actions:` widget (BlocBuilder).
- **booking_history_page.dart**: TabBar → passed as `bottom:` parameter.
- **doctor_detail_page.dart**: Favorite toggle → passed as `actions:` widget.

---

## 5. Components Table

| Komponen | Tipe | Default | Variant 1 Root | Variant 2 Std | Variant 3 Back Only | Variant 4 Action | Variant 5 TabBar | Variant 6 Dynamic | Variant 7 Counter |
|---|---|---|---|:---:|:---:|:---:|:---:|:---:|:---:|---:|
| `leading` | `Widget?` | auto: `BackButton()` | `null` | auto | auto | auto | auto | auto | auto |
| `title` | `Widget?` | `null` | `Text(title)` | `Text(title)` | `null` | `Text(title)` | `Text(title)` | widget (badge) | `Text(title)` |
| `actions` | `List<Widget>?` | `null` | `null` | `null` | `null` | `[favoriteBtn]` | `null` | `[markAllBtn]` | `null` |
| `bottom` | `PreferredSizeWidget?` | `null` | `null` | `null` | `null` | `null` | `TabBar` | `null` | `null` |
| `backgroundColor` | `Color` | `AppTheme.white` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `elevation` | `double` | `0` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `centerTitle` | `bool` | `true` | ✅ | ✅ | — | ✅ | ✅ | ✅ | ✅ |

---

## 6. Proposed Widget Interface

```dart
class HealthPalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HealthPalAppBar({
    super.key,
    this.title,
    this.showBack = true,          // auto-hide when Navigator.canPop() == false
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.elevation = 0,
    this.centerTitle = true,
  });

  final Widget? title;
  final bool showBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final double elevation;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}
```

### Default `leading` logic:

```dart
Widget? get _leading {
  if (!showBack) return null;
  // Auto-detect: if Navigator.canPop(context) == false, return const SizedBox.shrink()
  // Else: IconButton with AppIcons.arrowBack
}
```

---

## 7. Migration Table

| No | Page | Current | Target | Notes |
|:---:|------|:-------:|:------:|-------|
| 1 | `create_profile_page.dart` | Inline AppBar | `HealthPalAppBar(showBack: true)` | Title not needed |
| 2 | `icon_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text(...), showBack: true)` | Counter in title |
| 3 | `booking_detail_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Detail Appointment'))` | Fix icon to AppIcons.arrowBack |
| 4 | `booking_history_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('My Bookings), bottom: TabBar(...))` | TabBar passthrough |
| 5 | `book_appointment_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Book Appointment'))` | Fix icon + TODO |
| 6 | `doctor_detail_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Detail Dokter'), actions: [favoriteBtn])` | Fix icon + TODO |
| 7 | `doctor_search_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Cari Dokter'))` | Fix icon + TODO |
| 8 | `edit_profile_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Edit Profile'))` | Already uses AppIcons ✅ |
| 9 | `favorite_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Favorite'))` | Already uses AppIcons ✅ |
| 10 | `notification_page.dart` | Inline AppBar | `HealthPalAppBar(title: badgeRow, actions: [markAllBtn])` | Custom title widget |
| 11 | `profile_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Profile'), showBack: false)` | Root page |
| 12 | `help_support_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Help & Support'))` | Already uses AppIcons ✅ |
| 13 | `settings_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Settings'), showBack: false)` | Root page |
| 14 | `terms_and_conditions_page.dart` | Inline AppBar | `HealthPalAppBar(title: Text('Terms & Conditions'))` | Already uses AppIcons ✅ |

---

## 8. Files Affected

### Created (2 new)

```
lib/widgets/app_bar/health_pal_app_bar.dart       — New component
lib/widgets/app_bar/index.dart                     — Barrel export (optional)
```

### Modified (14 page files — change `appBar:` block only)

```
lib/features/auth/presentation/page/create_profile_page.dart
lib/features/auth/presentation/page/icon_page.dart
lib/features/booking/presentation/page/booking_detail_page.dart
lib/features/booking/presentation/page/booking_history_page.dart
lib/features/booking/presentation/page/book_appointment_page.dart
lib/features/doctor/presentation/page/doctor_detail_page.dart
lib/features/doctor/presentation/page/doctor_search_page.dart
lib/features/profile/presentation/page/edit_profile_page.dart
lib/features/profile/presentation/page/favorite_page.dart
lib/features/profile/presentation/page/notification_page.dart
lib/features/profile/presentation/page/profile_page.dart
lib/features/settings/presentation/page/help_support_page.dart
lib/features/settings/presentation/page/settings_page.dart
lib/features/settings/presentation/page/terms_and_conditions_page.dart
```

### Import changes (14 pages — material.dart → widgets.dart)

Semua page di atas akan ganti `import 'package:flutter/material.dart'` dengan `import 'package:flutter/widgets.dart'` karena `HealthPalAppBar` adalah widget murni dari `widgets.dart` (tidak perlu Material).

---

## 9. Proposed Implementation Plan

| Step | Task | Dependencies |
|------|------|-------------|
| 1 | Create `lib/widgets/app_bar/health_pal_app_bar.dart` (widget) | None |
| 2 | Create `lib/widgets/app_bar/index.dart` (barrel) | Step 1 |
| 3 | Migrate 14 pages: replace inline `AppBar(...)` with `HealthPalAppBar(...)` | Step 1 |
| 4 | Fix icon consistency: replace `Icons.arrow_back` with `AppIcons.arrowBack` + TODO | Step 3 |
| 5 | Change imports: `material.dart` → `widgets.dart` di 14 pages | Step 3 |
| 6 | Remove unused `import 'package:flutter/material.dart'` (ganti dengan widgets) | Step 5 |
| 7 | `flutter analyze` — verify 0 issues | Step 6 |
| 8 | Cleanup: hapus `material.dart` import jika tidak ada penggunaan Material lain | Step 7 |

---

*Dokumen ini adalah draft wireframe untuk HealthPalAppBar component. Eksekusi di sprint terpisah (B3+).*
