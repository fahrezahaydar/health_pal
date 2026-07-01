# ADR 014: Health Pal UI Framework — Foundation

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | Juli 2026 |
| **Penulis** | Principal Flutter Framework Architect (MiniMax-M3) |
| **Pemutus** | Project Owner + CTO + Tech Lead |
| **Dampak** | UI framework baru; additive, non-breaking; pubspec dependencies (jangka panjang) |

---

## 1. Konteks

### 1.1 Tentang Proyek Health Pal

Health Pal adalah aplikasi mobile Flutter (Android + iOS) yang sudah memasuki fase **production-scale**. Per `docs/tdd/01-arsitektur.md`, aplikasi ini mengadopsi pola **Feature-First Clean Architecture** dengan tiga lapis per fitur (Presentation / Domain / Data), state management `flutter_bloc` + Cubit, dependency injection `injectable` + `get_it`, routing `go_router` dengan `StatefulShellRoute.indexedStack`, dan Supabase sebagai satu-satunya backend.

Sprint A1–A9 telah selesai. Saat ini tim sedang dalam transisi ke Sprint B1 (Unit Testing) per `docs/progress/sprint_roadmap.md`. Dokumen PRD v1.0, BRD v1.0, ERD, API Contract (19 endpoint), USER_FLOW (7 Mermaid diagram), dan 21 wireframe telah final.

### 1.2 Tentang UI Saat Ini

Saat ini UI Health Pal **sudah 80% Material-independent** — tetapi tersebar di banyak file tanpa konsolidasi. Inventarisasi menunjukkan:

| Aspek | Status | Catatan |
|---|---|---|
| `flutter/material.dart` imports | **88 file** (35% dari 248 total `.dart` di `lib/`) | Tersebar di semua fitur |
| `flutter/cupertino.dart` imports | **1 file** | Hanya `app_theme.dart` (untuk `CupertinoThemeData`) |
| `flutter/widgets.dart` only imports | **27 file** | Widgets yang sudah "murni" — pionir framework |
| `flex_color_scheme` | Aktif | Untuk `FlexThemeData.light`/`dark` — pembungkus `ThemeData` Material |
| Custom token layer | Ada, parsial | `AppTheme` (colors), `AppTextTheme` (TextStyle), `AppIcons` (IconData references) |
| Custom button layer | Ada, parsial | `LightFilledButton`, `LightOutlineButton`, `LightIconButton` — semua `widgets.dart` only |
| Custom form layer | Ada, parsial | `AppForm` + `AppFormField` + `AppInputField` — semua `widgets.dart` only, pakai `EditableText` langsung |
| Custom dialog layer | Ada, parsial | `AppLoadingDialog`, `AppCustomDialog`, `AppDatePickerDialog` — pakai `showGeneralDialog` |
| Custom network image | Ada | `AppNetworkImage` + `cached_network_image` (masih import Material untuk `Icon` saja) |

### 1.3 Inventarisasi Penggunaan Material (Per Komponen)

| Komponen Material | Jumlah Penggunaan | Lokasi Tipikal |
|---|---|---|
| `Scaffold` | 22 | Setiap page (HomePage, LoginPage, ProfilePage, dll) |
| `AppBar` | 14 | Halaman dengan navigation header (Settings, Profile, Booking, Doctor) |
| `AlertDialog` | 3 | `AppConfirmDialog`, `SettingsPage`, `BookingDetailPage` |
| `TextField` / `TextFormField` | 11 | `LoginPage`, `SignUpPage`, `CreateProfilePage`, `EditProfilePage` — masih pakai Form bawaan |
| `Form` + `FormState` + `GlobalKey<FormState>` | 7 | `LoginPage`, `SignUpPage`, `CreateProfilePage` |
| `FilledButton` | 6 | `OnboardingPage`, `LoginPage`, `EmptyStateView` |
| `OutlinedButton` | 3 | `LoginPage`, `EmptyStateView` |
| `IconButton` | 12 | `DoctorCard`, dan lain-lain |
| `InkWell` | 9 | `AppShell`, `AppointmentCard`, `DatePickerField` |
| `RefreshIndicator` | 7 | `HomePage`, `DoctorSearchPage`, `DoctorDetailPage`, `BookingHistoryPage` |
| `ScaffoldMessenger` | 3 | Snackbar di `BookingHistoryPage`, `SettingsPage`, `NoInternetPage` |
| `Theme.of(context)` | 8 | `AppShell`, `OnboardingPage`, `LoginPage` (membaca `colorScheme` & `textTheme`) |
| `ColorScheme` | 3 | `AppShell`, `OnboardingPage` |
| `TabBar` | 1 | (booking tabs) |
| `ListTile` | 1 | (location) |
| `Card(` | 2 | (jarang) |
| `showModalBottomSheet` | 1 | `LogoutBottomModal` |
| `TimeOfDay` (show import) | 8 | `json_converters.dart`, `appointment_entity.dart`, `doctor_slot_entity.dart`, `booking_bloc.dart`, `date_formatter.dart`, model files |

### 1.4 Pola yang Sudah Benar (Patron)

Beberapa tim sudah menulis widget dengan **zero Material dependency** di `lib/widgets/`:

- `LightFilledButton` (`lib/widgets/button/primary_button.dart`) — hanya `package:flutter/widgets.dart` + `AppTheme` color tokens.
- `LightOutlineButton` (`lib/widgets/button/outline_button.dart`) — sama, zero Material.
- `LightIconButton` (`lib/widgets/button/light_icon_button.dart`) — sama.
- `AppInputField` (`lib/widgets/input/app_input_field.dart`) — pakai `EditableText` langsung (low-level), `FocusScope` & `TextEditingController`, zero Material.
- `AppForm` + `AppFormField` (`lib/widgets/form/app_form.dart`) — pure `InheritedWidget` untuk scope, zero Material.
- `AppLoadingDialog` (`lib/widgets/dialog/app_loading_dialog.dart`) — pakai `showGeneralDialog` (low-level), zero Material.
- `AppCustomDialog` (`lib/widgets/dialog/app_succes_dialog.dart`) — `showGeneralDialog` + `FadeTransition` + `ScaleTransition` (transisi manual).
- `AppDatePickerDialog` (`lib/widgets/dialog/app_date_picker_dialog.dart`) — `GestureDetector` + `Container` + `DefaultTextStyle`, zero Material.
- `AppBadge` (`lib/widgets/badge/app_badge.dart`) — `Stack` + `Positioned` + `DecoratedBox`, zero Material.
- `CardContainer` (`lib/widgets/layouts/card_container.dart`) — `Container` + `BoxDecoration`.
- `ErrorSection` (`lib/widgets/loader/error_section.dart`) — `Container` + `GestureDetector`.
- `LoadingView` + `DotLoader` (`lib/widgets/loader/`) — `CustomPainter` untuk spinner.
- `HeaderTitle` (`lib/widgets/layouts/header_title.dart`) — `Row` + `Text` + `GestureDetector`.
- `SimpleGestureDetector` (`lib/widgets/swipe/swipe_detector.dart`) — `GestureDetector` wrapper dengan threshold config.

### 1.5 Pola yang Masih Salah

- **`Scaffold` & `AppBar`** — semua 22 `Scaffold` + 14 `AppBar` di-import dari Material. Tidak ada alternatif framework internal.
- **`MaterialApp.router` di `main.dart`** — `MaterialApp` adalah root Material widget. Tidak bisa diganti tanpa `WidgetsApp` atau custom `App`.
- **`FlexColorScheme` + `ThemeData`** — `app_theme.dart` mengembalikan `ThemeData` Material yang dipakai `MaterialApp`. Seluruh sistem `Theme.of(context).colorScheme` dan `Theme.of(context).textTheme` bergantung pada ini.
- **`InkWell`** — dipakai di `AppShell` dan `AppointmentCard`. `InkWell` butuh parent `Material` ancestor untuk render ripple. Inkonsisten dengan framework-foundation (ganti ke `GestureDetector` + custom ripple via `InkResponse` equivalent).
- **`Form` / `TextFormField`** — `AppForm` sudah ada, tapi `LoginPage`, `SignUpPage`, `CreateProfilePage` masih pakai `Material.Form` + `Material.TextFormField` + `GlobalKey<FormState>`. Duplikasi.
- **`RefreshIndicator`** — 7 uses. Tidak ada alternatif internal.
- **`ScaffoldMessenger`** — snackbar masih pakai Material.
- **`TimeOfDay`** — 8 file import `TimeOfDay` dari Material. Ini masalah serius karena `TimeOfDay` ada di `package:flutter/material.dart` (bukan `widgets.dart`). Harus diganti value object kustom.
- **`AlertDialog`** — 3 uses. Internal dialog sudah pakai `Container` + `BoxDecoration` + manual layout, hanya `AlertDialog` API yang masih Material. Bisa 1:1 replaced dengan wrapper.

### 1.6 Mengapa Keputusan Ini Diperlukan

1. **Mengunci Material sebagai ketergantungan** — tanpa framework abstraction, sulit untuk:
   - Memindahkan `ThemeData` ke sistem token-driven (`AppThemeData`).
   - Mendukung multi-platform (mobile + future web/desktop + future native) dengan satu API.
   - Membuat dark/light/high-contrast theme system yang konsisten.
   - Mengganti icon system (Iconsax → custom SVG) tanpa merombak semua call sites.

2. **Duplikasi implisit** — `AppInputField` vs `TextFormField`, `AppLoadingDialog` vs `AlertDialog`, `LightFilledButton` vs `FilledButton`. Developer baru bingung mana yang dipakai (lihat inkonsistensi: `LoginPage` pakai Material, `OnboardingPage` campur).

3. **Lock-in ke Material ripple/elevation semantics** — `InkWell` punya `Material` ancestor requirement. `Scaffold` mengatur default text/style untuk descendant. Ini coupling implisit yang tidak terdokumentasi.

4. **Bundle size & startup** — `material.dart` menarik transitive `cupertino.dart` (~150KB terkompresi) yang tidak dipakai di Health Pal (1 file saja yang import Cupertino, itu pun hanya untuk `CupertinoThemeData`).

5. **Accessibility & RTL** — `MaterialApp` punya `localizationsDelegates: [DefaultMaterialLocalizations.delegate, ...]` di `main.dart`. Tanpa framework abstraction, sulit memastikan semua widget punya `Semantics` yang konsisten untuk screen reader.

---

## 2. Pernyataan Masalah

Arsitektur UI Health Pal saat ini **tidak memiliki UI framework** — Material menjadi default implisit. Konsekuensinya:

1. **Theme system** terikat pada `ThemeData` (Material). Tidak ada token abstraction.
2. **Common components** (`Scaffold`, `AppBar`, `Form`, `AlertDialog`, `RefreshIndicator`, `ScaffoldMessenger`) tidak punya alternatif internal.
3. **Inkonsistensi** — beberapa widget sudah Material-free (`LightFilledButton`), yang lain masih 100% Material (`FilledButton` di `OnboardingPage`).
4. **TimeOfDay leak** — value object dari Material dipakai di domain (`appointment_entity.dart`, `doctor_slot_entity.dart`), model layer, dan JSON converter. Pelanggaran clean architecture (`docs/tdd/01-arsitektur.md` §2.2: "Domain tidak boleh import `package:flutter/...`").
5. **Migrasi parsial** — tanpa ADR dan strategi, setiap PR menambah Material widget baru, bukan mengurangi.

Tanpa intervensi arsitektural, code debt ini akan **meningkat secara eksponensial** seiring Sprint B ke atas.

---

## 3. Goals

1. **Membangun UI framework internal** dengan nama `HP*` prefix (Health Pal) yang menjadi satu-satunya source of truth untuk widget, theme, dan interaksi.
2. **Menghilangkan 100% `flutter/material.dart` imports** di luar framework itu sendiri (target akhir).
3. **Menghilangkan 100% `flutter/cupertino.dart` imports** (target akhir).
4. **Mengganti `ThemeData` / `ColorScheme` / `TextTheme` Material** dengan `AppThemeData` / `AppColorScheme` / `AppTextStyleSet` (token-driven).
5. **Menggunakan kembali widget yang sudah ada** (LightFilledButton, AppInputField, AppForm, AppLoadingDialog, AppCustomDialog, AppBadge, dll) sebagai building block framework — **bukan menulis ulang**.
6. **Migrasi inkremental** — zero-downtime, setiap commit harus keep app running.
7. **Backward compatibility** — legacy widget lama tetap bisa coexist dengan framework baru via adapter pattern.
8. **Aksesibilitas penuh** — semantics, focus traversal, keyboard navigation, RTL, text scaling.
9. **Testable** — semua widget framework harus unit-testable tanpa MaterialApp (gunakan `TestWidgetsFlutterBinding` + `Directionality` + `MediaQuery` saja).
10. **Performance** — bundle size tidak boleh naik lebih dari 5% (post-migration harus lebih kecil).

---

## 4. Non-Goals

Sesuai mandat prompt dan prinsip non-disruptive, keputusan ini **secara eksplisit TIDAK mencakup**:

1. ❌ **Tidak merombak** user flow, business logic, atau state management.
2. ❌ **Tidak mengubah** API contracts, ERD, atau Supabase schema.
3. ❌ **Tidak memodifikasi** Cubit/Bloc, Repository, DataSource, atau DTO.
4. ❌ **Tidak mengubah** routing (`go_router`) atau DI (`injectable`/`get_it`).
5. ❌ **Tidak menyentuh** localization strategy (saat ini hanya `DefaultMaterialLocalizations.delegate` di `main.dart`; akan disediakan `AppLocalizations` wrapper di ADR berikutnya).
6. ❌ **Tidak membuat** icon library baru — tetap pakai `iconsax_latest` + `Material Icons` (per AGENTS.md Icon Convention).
7. ❌ **Tidak menghapus** `shimmer`/`skeletonizer`/`cached_network_image` (dependensi pihak ketiga).
8. ❌ **Tidak membuat** test baru di fase ini (Sprint B1 Testing tetap on-track di luar framework migration).
9. ❌ **Tidak mengganti** engine rendering, animation, atau state restoration mechanism.
10. ❌ **Tidak menyediakan** dark mode framework di ADR ini (dark mode pakai `AppTheme.dark` saat ini; framework token ADR ini menyediakannya, full dark mode logic di ADR berikutnya).

---

## 5. Constraints

1. **Existing feature modules** (`lib/features/**`) tetap untouched selama mungkin. Setiap migrasi adalah perubahan terisolasi per fitur.
2. **Existing Bloc architecture** tidak berubah.
3. **Existing routing** (`StatefulShellRoute.indexedStack` di `core/router/app_router.dart`) tidak berubah.
4. **Existing API contracts** tidak berubah.
5. **Existing business logic** tidak berubah.
6. **Incremental migration only** — setiap PR harus app tetap runnable (`flutter analyze` clean + `flutter build` success).
7. **No Material dependency** di package `lib/framework/` (layer terendah framework).
8. **No Cupertino dependency** di package `lib/framework/`.
9. **Framework boleh import** hanya: `package:flutter/widgets.dart`, `package:flutter/rendering.dart`, `package:flutter/painting.dart`, `package:flutter/gestures.dart`, `package:flutter/services.dart`, `package:flutter/foundation.dart`, `package:flutter/animation.dart`, `dart:ui`, `dart:async`, `dart:math`.
10. **Setiap ADR berikutnya** untuk komponen framework harus incremental, additive, dan backward-compatible.

---

## 6. Existing Project Findings (Ringkasan Inspeksi)

### 6.1 Struktur Folder Saat Ini

```
lib/
├── core/
│   ├── constants/        # app_constants.dart
│   ├── di/               # locator, register_module (injectable)
│   ├── enums/            # AppStatus, BookingStatus, FailureCode, Gender
│   ├── extensions/       # color_ext.dart (Material Color → hex)
│   ├── network/          # Result, ApiException, ErrorHandler, json_converters
│   ├── router/           # AppRouter (GoRouter)
│   ├── services/         # AppServices, CacheService, FcmService, SharedPrefs
│   ├── theme/            # app_theme.dart, app_text_theme.dart, app_icons.dart
│   └── utils/            # date_formatter, debouncer, retry, validators
├── features/             # auth, booking, doctor, home, loc, onboarding, profile, settings
├── firebase_options.dart
├── main.dart             # entry: dotenv → Supabase → DI → AppServices → runApp
├── preview/              # widget previews (dev only)
└── widgets/              # SHARED: button, card, dialog, form, input, layouts, loader, picker, shared, swipe, badge
```

### 6.2 Shared Widgets yang Sudah "Pure"

| Widget | File | Material-free? |
|---|---|---|
| `LightFilledButton` | `lib/widgets/button/primary_button.dart` | ✅ |
| `LightOutlineButton` | `lib/widgets/button/outline_button.dart` | ✅ |
| `LightIconButton` | `lib/widgets/button/light_icon_button.dart` | ✅ (import Material unused, bisa dibersihkan) |
| `AppInputField` | `lib/widgets/input/app_input_field.dart` | ✅ |
| `AppForm` + `AppFormField` | `lib/widgets/form/app_form.dart` | ✅ |
| `AppTextFormField` | `lib/widgets/form/app_form_field.dart` | ✅ |
| `AppLoadingDialog` | `lib/widgets/dialog/app_loading_dialog.dart` | ✅ |
| `AppCustomDialog` | `lib/widgets/dialog/app_succes_dialog.dart` | ✅ |
| `AppDatePickerDialog` | `lib/widgets/dialog/app_date_picker_dialog.dart` | ✅ |
| `AppBadge` | `lib/widgets/badge/app_badge.dart` | ✅ |
| `HeaderTitle` | `lib/widgets/layouts/header_title.dart` | ✅ |
| `CardContainer` | `lib/widgets/layouts/card_container.dart` | ✅ (import Material untuk `Border` saja — bisa ganti) |
| `ErrorSection` | `lib/widgets/loader/error_section.dart` | ⚠️ (import Material untuk `Icon` saja) |
| `LoadingView` + `DotLoader` | `lib/widgets/loader/` | ✅ (LoadingView import Material unused) |
| `PlaceholderImage` | `lib/widgets/shared/placeholder_image.dart` | ⚠️ (import Material untuk `Icon` saja) |
| `EmptyStateView` | `lib/widgets/shared/empty_state_view.dart` | ❌ (pakai `OutlinedButton` Material) |
| `AppNetworkImage` | `lib/widgets/shared/app_network_image.dart` | ⚠️ (import Material untuk `Icon` saja) |
| `SimpleGestureDetector` | `lib/widgets/swipe/swipe_detector.dart` | ❌ (Material `HitTestBehavior` — bisa diganti) |
| `AppShell` | `lib/widgets/app_shell.dart` | ❌ (`Scaffold` Material) |

### 6.3 Theme & Token Layer Saat Ini

- `AppTheme` (`lib/core/theme/app_theme.dart`) — static colors (`primary`, `onPrimary`, `grey50–900`, semantic colors, status colors). **Sudah token-driven**, tapi tipe `Color` Material (yang sama dengan `dart:ui` Color, jadi aman).
- `AppTextTheme` (`lib/core/theme/app_text_theme.dart`) — static `TextStyle` (Material type tapi underlying `dart:ui` TextStyle). **Sudah token-driven**.
- `AppIcons` (`lib/core/theme/app_icons.dart`) — static `IconData` references (Iconsax). **Sudah centralized**.
- `FlexColorScheme` — third-party wrapper untuk `ThemeData`. Akan diganti sistem custom.

### 6.4 Duplikasi yang Teridentifikasi

| Duplikasi | Lokasi | Catatan |
|---|---|---|
| `LightFilledButton` vs `FilledButton` Material | `widgets/button/` vs `LoginPage`, `OnboardingPage`, `EmptyStateView` | 2 sistem button paralel |
| `AppForm` vs Material `Form` | `widgets/form/app_form.dart` vs `LoginPage`, `SignUpPage` | Developer pakai yang Material |
| `AppInputField` vs `TextFormField` Material | `widgets/input/` vs `LoginPage`, `EditProfilePage` | Inkonsistensi |
| `AppLoadingDialog` + `AppCustomDialog` vs `AlertDialog` Material | `widgets/dialog/` vs `AppConfirmDialog`, `SettingsPage` | Partial replacement |
| `InkWell` Material vs `GestureDetector` framework | `AppShell`, `AppointmentCard`, `DatePickerField` | Inkonsistensi |
| `ColorScheme` dari `Theme.of()` vs `AppTheme` constants | `AppShell`, `OnboardingPage` | 2 cara baca warna |

### 6.5 Peluang Migrasi (Quick Wins)

1. **Hapus import Material unused** — `LightIconButton`, `LoadingView`, beberapa card widget masih import Material tapi tidak pakai widget Material apa pun. Cleansing cepat.
2. **Replace `Icon` Material** dengan custom `HPIcon` (rendering icon dari `IconData` ke `RichText`/`TextPainter` — sudah ada di `flutter/widgets.dart`).
3. **Replace `OutlinedButton` di `EmptyStateView`** dengan `LightOutlineButton` (sudah ada).
4. **Replace `FilledButton` di `OnboardingPage`** dengan `LightFilledButton`.
5. **Replace `OutlinedButton.icon` di `LoginPage`** dengan `LightOutlineButton` (sudah support `icon`).
6. **Replace `InkWell`** di `AppShell`, `AppointmentCard`, `DatePickerField` dengan `GestureDetector` + custom ripple (atau pakai `HPRipple` widget baru yang nanti didefine di ADR berikutnya).

### 6.6 Masalah Arsitektur Tersembunyi

1. **`TimeOfDay` di Domain Layer** — 8 file pakai `TimeOfDay` (termasuk `appointment_entity.dart`, `doctor_slot_entity.dart`). Ini **melanggar** `docs/tdd/01-arsitektur.md` §2.2: "Domain tidak boleh import `package:flutter/...`". ADR ini mengakui masalah dan mendefer solusi ke ADR 016 (Domain Value Object Standardization) — di luar scope framework UI.
2. **`flutter_dotenv` & `main.dart` initialization order** — tidak terkait framework UI.
3. **`ScaffoldMessenger` untuk Snackbar** — perlu diganti `HPSnackbar` framework. Defer ke ADR 015 (Feedback Layer).

---

## 7. Opsi yang Dipertimbangkan

### Opsi A — Status Quo (Terus Pakai Material)

- **Pro:** Tidak ada pekerjaan tambahan. App jalan.
- **Pro:** Dokumentasi Material sudah mature.
- **Kontra:** Tidak menyelesaikan masalah yang diuraikan di §1.6 (lock-in, duplikasi, TimeOfDay leak).
- **Kontra:** Code debt bertambah setiap sprint.
- **Kontra:** Bundle size stagnan atau naik.
- **Kontra:** Setiap developer baru akan pakai `Scaffold`/`AppBar`/`FilledButton` Material karena lebih familiar — **memperburuk** inkonsistensi.
- **Kesimpulan:** ❌ Ditolak. Tidak sustainable.

### Opsi B — Full Custom Framework dari Nol (Tanpa Reuse Widget Lama)

- **Pro:** Clean slate, naming convention konsisten dari awal.
- **Pro:** Bisa optimal untuk use case Health Pal.
- **Kontra:** Membuang `LightFilledButton`, `AppInputField`, `AppForm`, `AppLoadingDialog` yang sudah stabil dan teruji.
- **Kontra:** Effort besar (~3-4 sprint hanya untuk re-write).
- **Kontra:** Risk regression.
- **Kesimpulan:** ❌ Ditolak. Melanggar mandat prompt §"Avoid introducing duplicate abstractions. Prefer migrating existing shared widgets into the framework instead of rewriting them."

### Opsi C — Adopt Cupertino / Fluent UI Package

- **Pro:** Framework pihak ketiga yang mature.
- **Kontra:** Lock-in ke package eksternal (coupling lebih buruk dari Material — Material built-in).
- **Kontra:** Material dan Cupertino punya design language yang sangat berbeda; Health Pal punya design system sendiri (lihat `AppTheme` colors yang tidak standard Material palette).
- **Kontra:** Tidak menyelesaikan masalah `ThemeData`/token — hanya mengganti Material dengan Cupertino.
- **Kesimpulan:** ❌ Ditolak.

### Opsi D — Framework Berlapis, Reuse Widget Existing, Adapter untuk Legacy (DIUSULKAN)

- **Pro:** Layered architecture (Foundation → Theme → Primitives → Interaction → Layout → Navigation → Input → Feedback → Components), setiap layer dependency hanya ke layer di bawahnya.
- **Pro:** Reuse widget existing: `LightFilledButton` → `HPButton`, `AppInputField` → `HPTextField`, `AppForm` → `HPForm`, `AppLoadingDialog` → `HPLoadingDialog`, `AppCustomDialog` → `HPDialog`, `AppBadge` → `HPBadge`, dll.
- **Pro:** Adapter pattern untuk legacy: `LegacyScaffoldAdapter` yang wrap `Scaffold` Material, atau sebaliknya, `HPScaffold` yang pure tapi expose API mirip.
- **Pro:** Migrasi inkremental per fitur. Setiap feature bisa di-swap dari Material ke framework tanpa rewrite.
- **Pro:** Zero-downtime: legacy Material widget tetap bisa coexist dengan framework baru.
- **Kontra:** Butuh investasi waktu di awal (3-5 sprint untuk foundation + theme + primitives).
- **Kontra:** Adapter pattern bisa terasa "messy" di tengah transisi.
- **Kontra:** Dua parallel API untuk sementara.
- **Kesimpulan:** ✅ **DITERIMA.** Paling sesuai dengan mandat prompt, reuse existing, non-disruptive, incremental.

---

## 8. Keputusan (Decision)

### 8.1 Arsitektur Framework

Diusulkan: **HP UI Framework** — framework berlapis internal, prefix `HP` (Health Pal), dependency direction strictly downward, **zero Material/Cupertino** di semua layer.

```
┌────────────────────────────────────────────────────────────────────┐
│  LAYER 9 — HEALTH PAL COMPONENTS                                   │
│  HPDoctorCard, HPAppointmentCard, HPBannerCarousel, HPHomeScaffold │
│  (composite: page-level atau section-level)                        │
│  Depends on: Layer 1–8                                             │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 8 — FEEDBACK                                                │
│  HPSnackbar, HPToast, HPTooltip, HPProgressIndicator, HPSkeleton   │
│  Depends on: Layer 1–7                                             │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 7 — INPUT                                                   │
│  HPTextField, HPPasswordField, HPPinField, HPCheckbox, HPRadio,   │
│  HPSwitch, HPSlider, HPDatePicker, HPTimePicker, HPDropdown       │
│  Depends on: Layer 1–6                                             │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 6 — NAVIGATION                                              │
│  HPAppBar, HPTabBar, HPBottomNavBar, HPDrawer, HPBackButton       │
│  Depends on: Layer 1–5                                             │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 5 — LAYOUT                                                  │
│  HPScaffold, HPListView, HPGridView, HPSafeArea, HPPadding,        │
│  HPColumn, HPRow, HPStack, HPScrollView, HPAspectRatio            │
│  Depends on: Layer 1–4                                             │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 4 — INTERACTION                                             │
│  HPGestureDetector, HPInkRipple, HPFocusable, HPDraggable,        │
│  HPLongPress, HPTapRegion                                          │
│  Depends on: Layer 1–3                                             │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 3 — PRIMITIVES                                              │
│  HPText, HPIcon, HPContainer, HPBox, HPImage, HPDivider,          │
│  HPCard, HPBadge, HPChip, HPAvatar, HPListTile, HPDialog          │
│  Depends on: Layer 1–2                                             │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 2 — THEME                                                   │
│  AppThemeData, AppColorScheme, AppTextStyleSet, AppSpacing,        │
│  AppRadius, AppBorder, AppShadow, AppMotion, AppIconTheme,        │
│  AppComponentTheme (resolved component tokens)                     │
│  Depends on: Layer 1                                               │
├────────────────────────────────────────────────────────────────────┤
│  LAYER 1 — FOUNDATION                                              │
│  Color, TextStyle, EdgeInsets, Duration, Curve, Rect, Offset,      │
│  Size, FontWeight, TextDirection, Locale, Brightness              │
│  (semua dari dart:ui + flutter/widgets.dart — NO Material)        │
└────────────────────────────────────────────────────────────────────┘
```

### 8.2 Folder Structure (Usulan)

```
lib/
├── core/                    # UNCHANGED — services, DI, router, network, theme tokens
│   ├── theme/               # Diperluas: AppThemeData, AppColorScheme, AppTextStyleSet, AppSpacing, dll
│   ├── router/              # UNCHANGED
│   ├── di/                  # UNCHANGED
│   ├── services/            # UNCHANGED
│   ├── network/             # UNCHANGED
│   ├── constants/           # UNCHANGED
│   ├── enums/               # UNCHANGED
│   ├── extensions/          # UNCHANGED
│   └── utils/               # UNCHANGED
├── framework/               # NEW — UI Framework (zero Material)
│   ├── foundation/          # Layer 1: re-exports dart:ui primitives, type aliases
│   ├── theme/               # Layer 2: AppThemeData, AppColorScheme, AppTextStyleSet, AppSpacing, AppRadius, AppBorder, AppShadow, AppMotion, AppIconTheme, AppComponentTheme, AppThemeBuilder
│   ├── primitives/          # Layer 3: HPText, HPIcon, HPContainer, HPBox, HPImage, HPDivider, HPCard, HPBadge, HPChip, HPAvatar, HPListTile, HPDialog
│   ├── interaction/         # Layer 4: HPGestureDetector, HPInkRipple, HPFocusable, HPDraggable, HPTapRegion
│   ├── layout/              # Layer 5: HPScaffold, HPListView, HPGridView, HPSafeArea, HPScrollView, dll
│   ├── navigation/          # Layer 6: HPAppBar, HPTabBar, HPBottomNavBar, HPDrawer, HPBackButton
│   ├── input/               # Layer 7: HPTextField, HPPasswordField, HPPinField, HPCheckbox, HPRadio, HPSwitch, HPSlider, HPDatePicker, HPTimePicker, HPDropdown
│   ├── feedback/            # Layer 8: HPSnackbar, HPToast, HPTooltip, HPProgressIndicator, HPSkeleton
│   ├── components/          # Layer 9: HPDoctorCard, HPAppointmentCard, HPBannerCarousel, HPHomeScaffold, HPHomeSection, HPProfileSection, dll
│   ├── adapters/            # Legacy adapters: LegacyScaffold, LegacyAppBar, LegacyFilledButton, dll (Material-backed, for incremental migration)
│   └── hp.dart              # Barrel export: import 'package:health_pal/framework/hp.dart'; → all framework APIs
├── features/                # UNCHANGED — feature modules (gradually migrate to framework)
│   ├── auth/
│   ├── booking/
│   ├── doctor/
│   ├── home/
│   ├── loc/
│   ├── onboarding/
│   ├── profile/
│   └── settings/
├── widgets/                 # LEGACY SHARED WIDGETS — deprecated over time, mapped to framework
│   ├── button/              # → framework/primitives/ HPButton (delegate)
│   ├── card/                # → framework/components/
│   ├── dialog/              # → framework/feedback/ or framework/primitives/
│   ├── form/                # → framework/input/ HPForm, HPTextField
│   ├── input/               # → framework/input/
│   ├── layouts/             # → framework/layout/
│   ├── loader/              # → framework/feedback/
│   ├── picker/              # → framework/input/
│   ├── shared/              # → framework/primitives/ or framework/components/
│   ├── swipe/               # → framework/interaction/
│   ├── badge/               # → framework/primitives/
│   ├── app_shell.dart       # → framework/components/ HPAppShell
│   └── not_found_page.dart  # → framework/layout/ or framework/components/
├── firebase_options.dart    # UNCHANGED
├── main.dart                # Modified: replace MaterialApp.router with HPApp (framework root)
└── preview/                 # Widget previews (dev only) — kept as-is
```

### 8.3 Layer Dependency Direction (Strict)

```
hp_components  →  hp_feedback
              →  hp_input
              →  hp_navigation
              →  hp_layout
              →  hp_interaction
              →  hp_primitives
              →  hp_theme
              →  hp_foundation
```

**DILARANG** ada import yang melompat layer (mis. `hp_primitives` import `hp_navigation`) atau circular. Akan di-enforce via `analysis_options.yaml` custom lint di ADR berikutnya.

### 8.4 Token-Driven Theme System

`AppThemeData` adalah value object immutable yang membawa seluruh design token:

```dart
// Pseudocode — bukan implementasi
abstract final class AppThemeData {
  AppColorScheme get colors;       // primary, onPrimary, grey50–900, semantic, status
  AppTextStyleSet get text;        // headline, title, body, label (headlineLarge, bodyMedium, dll — mirror TextTheme untuk familiarity)
  AppSpacing get spacing;          // xs(4), sm(8), md(12), lg(16), xl(20), 2xl(24), 3xl(32), 4xl(40)
  AppRadius get radius;            // none(0), sm(4), md(8), lg(12), xl(16), pill(9999)
  AppBorder get border;            // thin(1), thick(2)
  AppShadow get shadow;            // sm, md, lg (offset, blur, color)
  AppMotion get motion;            // fast(150), normal(250), slow(400); curves.standard, curves.emphasized
  AppIconTheme get iconTheme;      // size (xs/sm/md/lg/xl), color resolver
  AppComponentTheme get component; // resolved component tokens (button, input, card, dll)

  static AppThemeData light();    // factory: light mode token set
  static AppThemeData dark();     // factory: dark mode token set
  static AppThemeData of(BuildContext context); // lookup via InheritedWidget
  static AppThemeData? maybeOf(BuildContext context);
}
```

Setiap widget framework baca token via `AppThemeData.of(context)`. Tidak ada lagi `Theme.of(context).colorScheme.primary`.

### 8.5 Root Widget

`MaterialApp.router` di `main.dart` akan diganti dengan `HPApp.router` — custom root widget yang **zero Material** (extend `WidgetsApp` saja, dengan `pageRouteBuilder` custom, `onGenerateRoute` custom, `localizationsDelegates` custom).

> Catatan: `WidgetsApp` ada di `package:flutter/widgets.dart` — bukan Material. Aman.

### 8.6 Reuse Strategy (Migrasi Widget Lama → Framework)

| Widget Lama (lib/widgets/) | Widget Framework Baru | Lokasi | Catatan |
|---|---|---|---|
| `LightFilledButton` | `HPButton.filled` | `framework/primitives/hp_button.dart` | Refactor class name, internal implementation tetap (pakai `GestureDetector` + `AnimatedContainer` + `AppThemeData.of`). |
| `LightOutlineButton` | `HPButton.outlined` | `framework/primitives/hp_button.dart` | Sama. |
| `LightIconButton` | `HPButton.icon` | `framework/primitives/hp_button.dart` | Sama. |
| `AppInputField` | `HPTextField` | `framework/input/hp_text_field.dart` | Refactor: pakai `AppTextStyleSet` dari `AppThemeData.of`, bukan `AppTextTheme` static. |
| `AppForm` + `AppFormField` | `HPForm` + `HPFormField` | `framework/input/hp_form.dart` | API identik, class rename. |
| `AppLoadingDialog` | `HPLoadingDialog` | `framework/feedback/hp_loading_dialog.dart` | Pakai `HPDialog` (Layer 3) sebagai base. |
| `AppCustomDialog` | `HPDialog` | `framework/primitives/hp_dialog.dart` | Refactor: type `HPDialogType`, base widget. |
| `AppDatePickerDialog` | `HPDatePicker` | `framework/input/hp_date_picker.dart` | Bawa `DateTime` (dart:core), bukan `TimeOfDay` Material. |
| `AppBadge` | `HPBadge` | `framework/primitives/hp_badge.dart` | Identik, class rename. |
| `CardContainer` | `HPCard` | `framework/primitives/hp_card.dart` | Identik, class rename. |
| `ErrorSection` | `HPErrorSection` | `framework/feedback/hp_error_section.dart` | Identik, class rename. |
| `LoadingView` + `DotLoader` | `HPLoadingView` + `HPDotLoader` | `framework/feedback/` | Identik. |
| `HeaderTitle` | `HPSectionHeader` | `framework/components/hp_section_header.dart` | Identik. |
| `PlaceholderImage` | `HPImage.placeholder` | `framework/primitives/hp_image.dart` | Refactor. |
| `EmptyStateView` | `HPEmptyState` | `framework/feedback/hp_empty_state.dart` | Pakai `HPButton.outlined` bukan `OutlinedButton`. |
| `AppNetworkImage` | `HPImage.network` | `framework/primitives/hp_image.dart` | Tetap pakai `cached_network_image`. |
| `SimpleGestureDetector` | `HPGestureDetector` | `framework/interaction/hp_gesture_detector.dart` | Refactor. |
| `AppShell` (bottom nav) | `HPAppShell` | `framework/components/hp_app_shell.dart` | Pakai `HPScaffold` + `HPBottomNavBar`. |

**File lama di `lib/widgets/` akan dideprecate** dengan `// @Deprecated('Use HPButton.filled from lib/framework/primitives/')` annotation, dan pointer ke widget baru. **File tidak langsung dihapus** sampai seluruh call site di fitur sudah di-migrasi (incremental).

### 8.7 Adapter untuk Inkremental Migrasi

Untuk fitur yang belum siap di-migrasi, sediakan `framework/adapters/`:

- `LegacyScaffold` — wrap `Scaffold` Material, expose API mirip `HPScaffold` (subset). Compile-time bridge.
- `LegacyAppBar` — wrap `AppBar` Material.
- `LegacyFilledButton` — wrap `FilledButton` Material, gaya visual di-bridge ke `HPButton.filled`.
- `LegacyOutlinedButton` — wrap `OutlinedButton` Material.
- `LegacyTextButton` — wrap `TextButton` Material.
- `LegacyIconButton` — wrap `IconButton` Material.
- `LegacyTextFormField` — wrap `TextFormField` Material, gunakan `AppInputField` internal jika mungkin.
- `LegacyForm` — wrap `Form` Material, delegate ke `HPForm` jika controller compatible.
- `LegacyRefreshIndicator` — wrap `RefreshIndicator` Material.
- `LegacyScaffoldMessenger` — wrap `ScaffoldMessenger`, expose `showSnackBar` API.
- `LegacyAlertDialog` — wrap `AlertDialog` Material.

Adapter pattern memungkinkan **mixed code**: satu page bisa `HPScaffold` body + `LegacyAppBar` (jika `AppBar` widget belum siap).

### 8.8 `TimeOfDay` Replacement (Catatan untuk ADR Berikutnya)

`TimeOfDay` Material akan diganti `AppTimeOfDay` value object di domain layer. ADR ini **mencatat** masalah tapi **mendefer** solusi ke **ADR 016: Domain Value Object Standardization** karena menyangkut clean architecture boundary, bukan UI framework. Untuk Layer 7 (`HPTimePicker`) di framework, gunakan `AppTimeOfDay` saja.

### 8.9 Naming Convention

| Pola | Contoh | Aturan |
|---|---|---|
| Foundation types | `AppColor`, `AppTextStyle` | Prefix `App*` (existing) |
| Theme tokens | `AppThemeData`, `AppColorScheme`, `AppSpacing` | Prefix `App*` |
| Widgets | `HPScaffold`, `HPButton`, `HPTextField` | Prefix `HP*` (Health Pal) |
| Variants | `HPButton.filled`, `HPButton.outlined`, `HPButton.icon` | Constructor variants, bukan subclass |
| Adapters | `LegacyScaffold`, `LegacyAppBar` | Prefix `Legacy*` |
| Enums | `HPDialogType`, `HPButtonSize` | Prefix `HP*` |
| Files | `hp_scaffold.dart`, `hp_button.dart` | snake_case + prefix `hp_` |

---

## 9. Migration Plan

### 9.1 Prinsip Migrasi

1. **Foundation First** — Layer 1 (foundation) + Layer 2 (theme) **harus selesai dan stabil** sebelum Layer 3+ mulai dipakai.
2. **Additive Only** — seteah Layer 1+2 ready, setiap Layer 3–9 bisa ditambahkan satu per satu tanpa break existing.
3. **Per-Feature Migration** — migrasi widget di feature module hanya **setelah** widget framework yang dibutuhkan sudah ready.
4. **Dual Runtime** — legacy Material widget + framework widget coexist via adapter.
5. **No Big Bang** — tidak ada PR yang menyentuh > 5 file sekaligus untuk migrasi.
6. **Test Gate** — setiap layer harus lulus `flutter analyze` + smoke test (`flutter test` + manual `flutter run`) sebelum lanjut ke layer berikutnya.

### 9.2 Phase Plan (Rencana Multi-Sprint)

| Phase | Sprint | Layer | Deliverable |
|---|---|---|---|
| **P0 — Foundation** | Sprint C1 | Layer 1 | `framework/foundation/` (type aliases, re-exports `dart:ui` primitives). **Zero runtime code**, hanya type alias. Aman. |
| **P1 — Theme Tokens** | Sprint C1 | Layer 2 | `framework/theme/`: `AppColorScheme`, `AppTextStyleSet`, `AppSpacing`, `AppRadius`, `AppBorder`, `AppShadow`, `AppMotion`, `AppIconTheme`, `AppComponentTheme`, `AppThemeData` + `AppThemeScope` InheritedWidget. Migrasi `lib/core/theme/app_theme.dart` (existing tokens) dan `app_text_theme.dart` ke format baru (tapi keep `AppTheme` static colors untuk backward compat sampai legacy dihapus). |
| **P2 — Primitives** | Sprint C2 | Layer 3 | `HPText`, `HPIcon`, `HPContainer`, `HPBox`, `HPImage`, `HPDivider`, `HPCard`, `HPBadge`, `HPChip`, `HPAvatar`, `HPListTile`, `HPDialog`. **Reuse:** `AppBadge` → `HPBadge`, `CardContainer` → `HPCard`. |
| **P3 — Interaction** | Sprint C2 | Layer 4 | `HPGestureDetector`, `HPInkRipple`, `HPFocusable`, `HPDraggable`, `HPTapRegion`. **Reuse:** `SimpleGestureDetector` → `HPGestureDetector`. |
| **P4 — Layout** | Sprint C3 | Layer 5 | `HPScaffold`, `HPListView`, `HPGridView`, `HPSafeArea`, `HPScrollView`, dll. **Adapter:** `LegacyScaffold`. |
| **P5 — Navigation** | Sprint C3 | Layer 6 | `HPAppBar`, `HPTabBar`, `HPBottomNavBar`, `HPDrawer`, `HPBackButton`. **Adapter:** `LegacyAppBar`. |
| **P6 — Input** | Sprint C4 | Layer 7 | `HPTextField`, `HPPasswordField`, `HPPinField`, `HPCheckbox`, `HPRadio`, `HPSwitch`, `HPSlider`, `HPDatePicker`, `HPTimePicker`, `HPDropdown`. **Reuse:** `AppInputField` → `HPTextField`, `AppForm` → `HPForm`, `AppDatePickerDialog` → `HPDatePicker`. **Adapter:** `LegacyTextFormField`, `LegacyForm`. |
| **P7 — Feedback** | Sprint C4 | Layer 8 | `HPSnackbar`, `HPToast`, `HPTooltip`, `HPProgressIndicator`, `HPSkeleton`. **Reuse:** `AppLoadingDialog` → `HPLoadingDialog`, `LoadingView`/`DotLoader` → `HPLoadingView`/`HPDotLoader`, `ErrorSection` → `HPErrorSection`, `EmptyStateView` → `HPEmptyState`. **Adapter:** `LegacyScaffoldMessenger` (untuk `showSnackBar`). |
| **P8 — Health Pal Components** | Sprint C5 | Layer 9 | `HPDoctorCard`, `HPAppointmentCard`, `HPBannerCarousel`, `HPHomeScaffold`, `HPProfileSection`, `HPBookingSection`, dll. **Reuse:** `DoctorCard` → `HPDoctorCard`, `AppointmentCard` → `HPAppointmentCard`, `AppShell` → `HPAppShell`. |
| **P9 — Root Widget** | Sprint C5 | `HPApp` | `HPApp` di `lib/main.dart` menggantikan `MaterialApp.router`. Tetap register `GoRouter`, `localizationsDelegates` custom, theme dari `AppThemeData`. **Adapter:** temporary `LegacyMaterialLocalizations` agar L10n tetap jalan. |
| **P10 — Per-Feature Migration** | Sprint C6+ | Migration | Migrasi per fitur: Auth → Home → Doctor → Booking → Profile → Loc → Settings → Onboarding. Tiap fitur: ganti import `package:flutter/material.dart` → `package:health_pal/framework/hp.dart`, swap widget satu per satu. |
| **P11 — Pubspec Cleanup** | Sprint C8 | Dependency | Setelah P10 selesai (semua fitur migrated): hapus `flex_color_scheme` dari `pubspec.yaml`, hapus `DefaultMaterialLocalizations.delegate`, hapus `uses-material-design` dari pubspec assets section. **Zero Material di runtime.** |
| **P12 — Legacy Deprecation** | Sprint C9 | Cleanup | `@Deprecated` annotation di seluruh widget lama di `lib/widgets/`. Linter warning. Hapus `lib/widgets/` setelah beberapa sprint stabil. |

### 9.3 Urutan Migrasi Fitur (P10)

Berdasarkan kompleksitas dan jumlah Material dependency:

1. **Onboarding** (1 page, 1 Material `FilledButton` + `Scaffold` + `AppBar` tidak ada) — **low risk**.
2. **Settings** (5 pages, `AppBar` 5×, `Scaffold` 5×, `AlertDialog` 1×, `ScaffoldMessenger` 2×) — **medium**.
3. **Auth** (4 pages, `Form` 3×, `TextFormField` 5×, `FilledButton` 3×, `OutlinedButton` 2×) — **medium-high**.
4. **Home** (1 page, `Scaffold` 1×, `RefreshIndicator` 1×) — **medium**.
5. **Doctor** (2 pages, `AppBar` 2×, `Scaffold` 2×, `RefreshIndicator` 2×, `TabBar` 1×) — **medium-high**.
6. **Booking** (5 pages, `AppBar` 3×, `Scaffold` 4×, `AlertDialog` 1×, `RefreshIndicator` 2×, `ScaffoldMessenger` 1×) — **high**.
7. **Profile** (5 pages, `AppBar` 3×, `Scaffold` 5×, `RefreshIndicator` 1×) — **medium**.
8. **Loc** (1 page, `Scaffold` 1×, `showModalBottomSheet` 1×) — **low**.

### 9.4 Strategi Backward Compatibility

- **Static methods** di legacy `AppTheme`, `AppTextTheme`, `AppIcons` **tetap dipertahankan** sampai P12. Hanya ditambah facade ke `AppThemeData.of(context)` untuk adapter.
- **`AppLoadingDialog.show` / `AppLoadingDialog.dismiss`** API tetap sama — internal delegate ke `HPLoadingDialog`.
- **`AppBadge(count, child)`** signature tetap — class rename via typedef.
- **`AppForm` / `AppFormField` / `AppTextFormField`** signature tetap — class rename.

### 9.5 Strategi Test (Outside Sprint B1)

Framework UI akan menyertakan **golden test** dan **widget test** di `test/framework/` (di luar Sprint B1 unit test plan). Akan didefine di **ADR 017: Framework Testing Strategy**.

---

## 10. Risiko

### 10.1 Risiko Teknis

| Risiko | Severity | Mitigasi |
|---|---|---|
| **TimeOfDay Material di Domain** — 8 file import `TimeOfDay` di layer yang seharusnya pure Dart. | High | ADR 016 (deferred). Untuk framework Layer 7, definisikan `AppTimeOfDay` value object parallel; sediakan converter `TimeOfDay ↔ AppTimeOfDay`. Domain akan bermigrasi belakangan. |
| **InkWell ripple hilang** — `InkWell` Material punya Material ancestor requirement. Saat ganti ke `GestureDetector`, ripple effect hilang. | Medium | `HPInkRipple` di Layer 4 — custom `RenderObject` atau `AnimatedContainer` color transition (lebih sederhana). Visual continuity. |
| **Localizations** — `MaterialApp` punya `DefaultMaterialLocalizations.delegate`. Tanpa MaterialApp, harus custom delegate. | Medium | `HPApp` akan register `DefaultWidgetsLocalizations.delegate` + custom `AppLocalizations` (untuk string i18n — saat ini app belum multi-locale, jadi deprioritas). |
| **Page transitions** — `MaterialApp` punya `pageRouteBuilder` default yang pakai Material `FadeUpwardsPageTransitionsBuilder`. | Low | `HPApp` set `pageRouteBuilder: (settings, builder) => PageRouteBuilder(...)` dengan transition custom. Default: `FadeTransition` + `SlideTransition`. |
| **Focus traversal** — `Material` widget punya `FocusTraversalGroup` default. | Medium | `HPScaffold` (Layer 5) wrap body dengan `FocusTraversalGroup` + `FocusScope`. |
| **Text scaling** — `MediaQuery.textScaler` harus dihormati. | Low | `HPText` (Layer 3) baca `MediaQuery.textScalerOf(context)` dan apply via `TextPainter`. |
| **RTL** — Beberapa widget Material auto-flip di RTL. | Medium | `HPRow`/`HPColumn` aware `Directionality.of(context)`. Test dengan `Directionality(textDirection: TextDirection.rtl)`. |
| **Form submission pattern** — `Form.onSubmit` via `FormState.validate()` + `Navigator.pop`. | Low | `HPForm` punya API yang sama: `HPFormState.validate()`, `HPFormState.save()`, `HPFormState.reset()`. |
| **Snackbar positioning** — `ScaffoldMessenger` punya logic snackbar queueing. | Medium | `HPSnackbar` framework sediakan overlay-based queueing (pakai `OverlayEntry`). ADR 015 detail. |
| **Bundle size** — Custom framework mungkin lebih besar dari Material. | Low | Custom framework akan smaller karena no Material. Tapi `FlexColorScheme` bisa dihapus (~50KB). |

### 10.2 Risiko Kompatibilitas

| Risiko | Severity | Mitigasi |
|---|---|---|
| **Plugin/theme expects Material** — `cached_network_image` butuh `Material` ancestor untuk placeholder? | Low | `cached_network_image` tidak butuh Material. Hanya `Image.network` default. |
| **Third-party package** — `flutter_map`, `lottie`, `flutter_svg` apakah butuh Material? | Low | `flutter_map` pure widgets. `lottie` pure widgets. `flutter_svg` pure widgets. Semua aman. |
| **`flutter_auto_size_text`** (Onboarding) — apakah punya Material dependency? | Low | Cek di P10 saat Onboarding dimigrasi. Kemungkinan besar aman. |
| **`smooth_page_indicator`** (Onboarding) — sama. | Low | Sama. |
| **`provider`** (Onboarding) — sama. | Low | Sama. |
| **`carousel_slider_plus`** (Home banner) — apakah pure widgets? | Medium | Cek. Mungkin perlu adapter. |
| **`readmore`** (Booking detail) — apakah pure widgets? | Medium | Cek. Mungkin perlu adapter. |
| **`calendar_date_picker2`** (DatePicker) — apakah pure widgets? | Medium | Cek. Jika tidak, sediakan `HPDatePicker` native (seperti `AppDatePickerDialog` lama) dan deprecate `calendar_date_picker2`. |

### 10.3 Risiko Maintenance

| Risiko | Severity | Mitigasi |
|---|---|---|
| **Dokumentasi usang** — ADRs lama menyebut Material. | Low | Update `AGENTS.md` di akhir P12. Tambah section "UI Framework" dengan link ke ADR ini. |
| **Developer baru pakai Material** | Medium | `analysis_options.yaml` custom rule (di ADR 018): `avoid_material_import` (warn/error). Code review checklist. |
| **Adapter pattern menumpuk** | Medium | P12: hapus adapter setelah semua fitur migrated. Track di sprint plan. |
| **Test infra belum siap** | Medium | ADR 017 (testing strategy) akan siapkan `test/framework/` infrastructure parallel. |

---

## 11. Future Work (ADR Berikutnya)

ADR ini hanya fondasi. ADR 015 sampai ADR-N akan mendetailkan setiap layer dan sub-sistem. Estimasi roadmap:

| ADR | Topik | Target Sprint |
|---|---|---|
| **ADR 014** | **(this)** UI Framework Foundation | C1 |
| **ADR 015** | Feedback Layer (Snackbar, Toast, Tooltip, Skeleton) | C4 |
| **ADR 016** | Domain Value Object Standardization (`AppTimeOfDay`, `AppDate`, `AppDateTime`) | C2 (parallel) |
| **ADR 017** | Framework Testing Strategy (golden test, widget test, `HPTestHarness`) | C5 |
| **ADR 018** | Custom Lint Rules (`avoid_material_import`, `no_cupertino_import`, `layer_dependency_check`) | C6 |
| **ADR 019** | Migration Playbook per Fitur (step-by-step per `lib/features/*/`) | C6+ |
| **ADR 020** | Dark Mode Strategy (saat ini `AppTheme.dark` ada tapi tidak dipakai di `MaterialApp(themeMode: ThemeMode.light)`) | C7 |
| **ADR 021** | Localization & Internationalization (`AppLocalizations`, multi-locale support) | C8 |
| **ADR 022** | Accessibility Audit (Semantics, FocusTraversal, screen reader) | C8 |
| **ADR 023** | Legacy Cleanup & Final Material Removal | C9 |

---

## 12. Resolved Decisions (Approved)

Semua pertanyaan pada tahap proposed telah dijawab dan disetujui oleh **Project Owner + CTO + Tech Lead** sebelum ADR ini dipromosikan ke status **Accepted**. Keputusan final dicatat untuk dokumentasi dan eksekusi lintas sprint.

| # | Topik | Keputusan Final | Rationale |
|---|---|---|---|
| Q1 | Naming prefix widget | **`HP*`** (uppercase, dua huruf kapital) | Lebih tegas, tidak konflik dengan Flutter internal, identik dengan brand "Health Pal". Class: `HPScaffold`, `HPButton`, `HPTextField`, `HPApp`. File: `hp_*.dart` (snake_case). |
| Q2 | Lokasi folder framework | **`lib/framework/`** (in-tree) | Lebih cepat di-bootstrap, tidak perlu pubspec terpisah. Bisa di-split ke `packages/hp_framework/` di kemudian hari jika reuse lintas project. |
| Q3 | `AppTheme` static colors (`AppTheme.primary`, `AppTheme.grey50`, dll) | **Pertahankan sebagai facade read-only sampai P12** | Backward compatibility untuk legacy code + adapter. Delegate ke `AppThemeData.light().colors.primary`. Deprecated (bukan removed) di P12. |
| Q4 | `flex_color_scheme` (third-party `ThemeData` wrapper) | **Hapus di P11** (setelah semua fitur dimigrasi + visual parity confirmed) | Bundle size turun ~50KB, tidak ada benefit lagi setelah `AppThemeData` siap. Sisa `flex_color_scheme` di `pubspec.yaml` akan di-prune. |
| Q5 | `TimeOfDay` Material removal dari domain | **Defer ke ADR 016** (Domain Value Object Standardization) | Di luar scope UI framework. Untuk framework Layer 7 (`HPTimePicker`), gunakan `AppTimeOfDay` value object parallel; sediakan converter `TimeOfDay ↔ AppTimeOfDay` sampai domain bermigrasi. |
| Q6 | Material Icons selama transisi | **Sesuai `AGENTS.md`** — Material fallback untuk icon baru, swap ke Iconsax manual oleh Project Owner. Framework Layer 3 `HPIcon` agnostic terhadap source (terima `IconData` apapun). | Pertahankan workflow existing (lihat AGENTS.md → "Icon Convention Sprint 2+"), tidak menambah kompleksitas baru. |
| Q7 | Legacy widgets di `lib/widgets/` | **Hapus semua setelah 1 sprint stabil tanpa warning** (P12) | Tambahkan `@Deprecated('Use HP* from lib/framework/')` annotation di setiap file legacy. Linter warning. Total removal setelah 1 sprint stabil. Track di sprint plan. |
| Q8 | Adapter pattern (`LegacyScaffold` dll) di production binary | **Include in binary** sampai P12 | Bundle impact minimal (10-20 baris wrapper per widget). Dev-only tidak mungkin karena plugin/library lain mungkin import adapter dari production code. |
| Q9 | `HPApp` (root) + `DefaultMaterialLocalizations` stub | **Ya, sediakan minimal `LocalizationsDelegate` stub** untuk plugin compatibility | Plugin yang cek `MaterialLocalizations.of(context)?.something` akan tetap kerja. Detail implementasi di ADR 021 (Localization & i18n). |
| Q10 | Sprint plan C1–C9 sebagai fase | **Ya, disetujui** | Sequence dan dependency antar fase sudah benar. Durasi sprint fleksibel sesuai capacity tim. Sprint planner bebas adjust sprint boundary tanpa ubah ADR. |

**Tanggal approval:** Juli 2026
**Disetujui oleh:** Project Owner + CTO + Tech Lead
**Catatan operasional:** Keputusan di atas menjadi **kontrak** untuk seluruh fase C1–C9. Perubahan harus melalui ADR baru.

---

## 13. Referensi

- `docs/tdd/01-arsitektur.md` — Feature-First Clean Architecture, aturan dependency.
- `docs/tdd/04-state-management.md` — BLoC/Cubit pattern.
- `docs/tdd/06-api-error-handling.md` — Error mapping.
- `docs/tdd/07-di-graph.md` — Injectable modules.
- `docs/tdd/10-testing.md` — Sprint B1 testing policy.
- `docs/adr/001_skeletonizer.md` — Pattern ADR Health Pal (template style).
- `docs/adr/003_font_migration.md` — Migrasi Inter & Poppins (referensi migrasi sukses).
- `docs/adr/006_standardize_cached_network_image.md` — Contoh standarisasi library.
- `docs/adr/008_standardize_placeholder_widgets.md` — Contoh standarisasi widget.
- `docs/adr/009_doctor_detail_redesign.md` — Contoh redesign per page.
- `docs/adr/012_appointment_card_redesign.md` — Contoh redesign card.
- `docs/adr/013-profile-page-redesign.md` — Contoh redesign page.
- `AGENTS.md` — Icon Convention, Skeleton Loading Rule.
- `lib/core/theme/app_theme.dart` — Existing token layer.
- `lib/core/theme/app_text_theme.dart` — Existing text token layer.
- `lib/core/theme/app_icons.dart` — Existing icon registry.
- `lib/widgets/button/`, `lib/widgets/form/`, `lib/widgets/dialog/`, `lib/widgets/loader/`, `lib/widgets/badge/`, `lib/widgets/layouts/`, `lib/widgets/swipe/`, `lib/widgets/shared/` — Shared widgets yang akan dimigrasi.
- `lib/main.dart` — `MaterialApp.router` (akan diganti `HPApp`).
- `lib/core/router/app_router.dart` — GoRouter (tidak berubah).

---

*This ADR is a living document. Status: **✅ Accepted** (Juli 2026). Future ADRs (015–023) will incrementally expand the framework defined here. Supersede dengan ADR baru jika ada perubahan mendasar; update in-place untuk klarifikasi minor.*
