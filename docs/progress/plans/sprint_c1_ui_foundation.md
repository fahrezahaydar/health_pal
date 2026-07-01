# Sprint C1 Plan — UI Framework Foundation + Theme Tokens

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | Juli 2026 |
| **Sprint Window** | TBD (1 minggu setelah Sprint B1 closing — 5 hari kerja) |
| **Tema Sprint** | **"Layer 1 + Layer 2 — fondasi `HP*` framework tanpa satu baris widget feature pun berubah"** — membangun fondasi UI Framework Health Pal (foundation type aliases + 11 token class) dengan backward compatibility 100% untuk `AppTheme` / `AppTextTheme` static facade |
| **Acuan** | `docs/adr/014-ui-framework-foundation.md` §9.2 P0+P1 · `lib/core/theme/app_theme.dart` (existing tokens) · `lib/core/theme/app_text_theme.dart` (existing text styles) · `lib/core/theme/app_icons.dart` (existing icon registry) · Sprint B1 close report |
| **Tech Lead** | MiniMax-M3 |
| **Dependency** | Sprint B1 CLOSED ✅ (unit test foundation ready) · ADR 014 ACCEPTED ✅ (Q1–Q10 resolved) |
| **Testing Policy** | ✅ **TEST FILES DIIZINKAN** untuk kode framework baru (AppSpacing, AppRadius, AppThemeData, dll) — Pengecualian terbatas terhadap ADR 014 Non-Goal 8, dijuster dengan AD-6. Test untuk feature migrated tetap di luar scope C1 (defer ke P10). |

---

## 📊 Sprint C1 Progress Tracker

**Last Updated:** [TBD]
**Overall:** 0/? tasks (0%) — 📋 PLAN READY, menunggu kick-off

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|:--------:|--------|--------|---------|
| T1 | Sprint Opening Audit — `sprint_c1_audit.md` | 1h | ⬜ Not Started | — | Audit existing `AppTheme`/`AppTextTheme` + identifikasi semua call site token |
| T2 | Create `lib/framework/` directory structure + barrel `hp.dart` | 0.5h | ⬜ Not Started | — | Subdir: `foundation/`, `theme/` (kosong dulu) |
| T3 | Implement `AppFoundation` (type aliases) | 1h | ⬜ Not Started | — | Re-export `dart:ui` primitives — ZERO runtime code |
| T4 | Unit test untuk `AppFoundation` type aliases | 0.5h | ⬜ Not Started | — | Verify import chain resolves correctly |
| T5 | Implement `AppSpacing` + test | 1h | ⬜ Not Started | — | 8 size variants (xs, sm, md, lg, xl, 2xl, 3xl, 4xl) |
| T6 | Implement `AppRadius` + test | 1h | ⬜ Not Started | — | 6 radius variants (none, sm, md, lg, xl, pill) |
| T7 | Implement `AppBorder` + test | 0.5h | ⬜ Not Started | — | thin(1), thick(2), none(0) |
| T8 | Implement `AppShadow` + test | 1.5h | ⬜ Not Started | — | 5 elevation levels — pakai `BoxShadow` |
| T9 | Implement `AppMotion` + test | 1h | ⬜ Not Started | — | 3 duration + standard/emphasized curves |
| T10 | Implement `AppIconTheme` + test | 1h | ⬜ Not Started | — | Size variants (xs/sm/md/lg/xl) + color resolver |
| T11 | Implement `AppColorScheme` + test | 2h | ⬜ Not Started | — | Port dari `AppTheme` static colors + semantic methods |
| T12 | Implement `AppTextStyleSet` + test | 2h | ⬜ Not Started | — | Port dari `AppTextTheme` TextStyle + role mapping |
| T13 | Implement `AppComponentTheme` + test | 1.5h | ⬜ Not Started | — | Resolved component tokens (button, input, card, dialog) |
| T14 | Implement `AppThemeData` (aggregate) + test | 1.5h | ⬜ Not Started | — | Immutable value object + `light()`/`dark()` factories |
| T15 | Implement `AppThemeScope` (InheritedWidget) + test | 1.5h | ⬜ Not Started | — | `of()`/`maybeOf()` lookup pattern |
| T16 | Refactor `app_theme.dart` jadi facade delegating ke `AppThemeData` | 1h | ⬜ Not Started | — | Q3 decision: keep all `AppTheme.*` static API |
| T17 | Refactor `app_text_theme.dart` jadi facade delegating ke `AppTextStyleSet` | 1h | ⬜ Not Started | — | Q3 decision: keep all `AppTextTheme.*` static API |
| T18 | Verify zero callsite change (grep `AppTheme\.`, `AppTextTheme\.`) | 0.5h | ⬜ Not Started | — | All existing widget callsite compile tanpa modifikasi |
| T19 | Wrap `MaterialApp.router` di `main.dart` dengan `AppThemeScope` | 0.5h | ⬜ Not Started | — | NO behavior change — `MaterialApp` masih dipakai sampai P9 |
| T20 | Update `AGENTS.md` — tambah section "UI Framework" | 0.5h | ⬜ Not Started | — | Link ke ADR 014 + catatan C1 selesai |
| T21 | Update `docs/progress/sprint_roadmap.md` — tambah Sprint C row | 0.3h | ⬜ Not Started | — | Placeholder untuk C1–C9 |
| T22 | Visual parity check — 3 sample page | 1h | ⬜ Not Started | — | HomePage, LoginPage, DoctorSearchPage — render side-by-side, tidak ada diff pixel |
| T23 | `flutter analyze` — 0 issues | 0.1h | ⬜ Not Started | — | Termasuk test code |
| T24 | `flutter test` — all existing + new tests pass | 0.3h | ⬜ Not Started | — | B1 tests + C1 token tests, exit code 0 |
| T25 | `flutter build apk --debug` — sukses | 0.2h | ⬜ Not Started | — | Verify APK build OK (no Material import error baru) |
| T26 | Conventional commit + sprint review | 0.3h | ⬜ Not Started | — | `feat(framework): C1 — foundation + theme tokens` |

**Total estimasi: ~22 jam** (5 hari × ~4.5 jam/hari — sprint ringan karena additive-only)

---

## Daftar Isi

1. [Verdict & Sprint Theme](#1-verdict--sprint-theme)
2. [State Pre-C1 (Post-Sprint B1)](#2-state-pre-c1-post-sprint-b1)
3. [Sprint C1 Goals — SMART](#3-sprint-c1-goals--smart)
4. [Sprint Backlog — Per Pool](#4-sprint-backlog--per-pool)
5. [Weekly Schedule (5 Working Days)](#5-weekly-schedule-5-working-days)
6. [Architecture Decisions](#6-architecture-decisions)
7. [Definition of Done — Sprint C1](#7-definition-of-done--sprint-c1)
8. [Risiko & Mitigasi](#8-risiko--mitigasi)
9. [Deferred to Sprint C2+](#9-deferred-to-sprint-c2)
10. [Migration Strategy — Token Port](#10-migration-strategy--token-port)
11. [Sprint Ceremonies](#11-sprint-ceremonies)
12. [Score Card Template](#12-score-card-template)

---

## 1. Verdict & Sprint Theme

### 1.1 Verdict (Tech Lead)

🟢 **Sprint B1 closed dengan fondasi unit test siap. ADR 014 accepted dengan 10 keputusan final. Saatnya eksekusi Phase P0 (Foundation) + P1 (Theme Tokens).**

**State saat ini (post-B1):**
- Theme token layer sudah ada di `lib/core/theme/app_theme.dart` (`AppTheme` static colors, 25+ Color const) dan `app_text_theme.dart` (`AppTextTheme` static TextStyle, 9 TextStyle const).
- 88 file masih import `package:flutter/material.dart`. Dari jumlah itu: 8 file pakai `Theme.of(context)` / `ColorScheme` (untuk dimigrasi di P9 + P10), 22 pakai `Scaffold`, 14 pakai `AppBar`, 11 pakai `TextField`/`TextFormField`.
- 0 widget framework baru. Folder `lib/framework/` belum ada.
- `flex_color_scheme: ^8.4.0` masih dipakai untuk `FlexThemeData.light/dark` di `app_theme.dart` (akan dihapus di P11 per Q4 decision).

**Sprint C1 Theme:**
> **"Layer 1 + Layer 2 siap, zero regression, zero visual change."**

Sprint C1 adalah **sprint fondasi framework** — bukan sprint fitur, bukan sprint refactor widget. Fokus murni:
1. **Create `lib/framework/`** dengan Layer 1 (Foundation type aliases) — zero runtime code, zero risk.
2. **Port token classes** (Layer 2) — 11 token class (`AppSpacing` s/d `AppThemeData` + `AppThemeScope`).
3. **Backward compat** — `AppTheme.primary`, `AppTextTheme.bodyMedium`, dll tetap jalan sebagai facade delegating ke `AppThemeData.light().colors.primary` (Q3 decision Juli 2026).
4. **Test foundation** — unit test untuk setiap token class. Pengecualian terbatas terhadap ADR 014 Non-Goal 8, dijuster dengan AD-6 (test untuk kode framework baru diizinkan; test untuk feature existing tetap di luar scope C1).
5. **Zero feature migration** — `MaterialApp.router` di `main.dart` TIDAK diganti, `Scaffold`/`AppBar`/`FilledButton` TIDAK disentuh. Pure additive.

### 1.2 Sprint C1 Anti-Scope (Penting)

❌ **TIDAK** membuat widget `HP*` Layer 3+ (Primitives, Interaction, Layout, Navigation, Input, Feedback, Components) — defer ke Sprint C2–C5.
❌ **TIDAK** migrasi `MaterialApp.router` ke `HPApp` — defer ke Sprint C5 (P9 Root Widget).
❌ **TIDAK** migrasi feature page manapun (Auth, Home, Doctor, Booking, Profile, Loc, Settings, Onboarding) — defer ke Sprint C6+ (P10 Per-Feature Migration).
❌ **TIDAK** menghapus `flex_color_scheme` dari `pubspec.yaml` — defer ke Sprint C8 (P11 Pubspec Cleanup, Q4 decision).
❌ **TIDAK** menghapus legacy widget di `lib/widgets/` — defer ke Sprint C9 (P12 Legacy Cleanup, Q7 decision).
❌ **TIDAK** migrasi `TimeOfDay` Material dari domain layer — defer ke ADR 016 (Q5 decision).
❌ **TIDAK** setup custom lint `avoid_material_import` — defer ke Sprint C6+ (ADR 018).
❌ **TIDAK** membuat test untuk migrated feature (test untuk `MaterialApp`, `Scaffold`, `AppBar`, dll yang sudah ada) — tetap di luar scope C1.
❌ **TIDAK** setup dark mode penuh (`AppTheme.dark` tetap unused sampai P9+P11).
❌ **TIDAK** membuat localization/i18n — defer ke Sprint C8 (ADR 021).

### 1.3 Sprint C1 Success Indicator

Setelah C1 selesai, codebase harus dalam kondisi:
- `lib/framework/foundation/` dan `lib/framework/theme/` exist dengan 12 file Dart (11 token + 1 foundation).
- `lib/core/theme/app_theme.dart` dan `app_text_theme.dart` masih ada dan dipanggil dari ~80 call site tanpa modifikasi.
- `flutter analyze` exit 0.
- `flutter test` exit 0 (semua B1 test + ~15 test C1 baru).
- `flutter build apk --debug` sukses.
- Tidak ada perubahan visual pada HomePage, LoginPage, DoctorSearchPage (verified manual).
- `AGENTS.md` punya section "UI Framework" dengan link ke ADR 014.

---

## 2. State Pre-C1 (Post-Sprint B1)

### 2.1 Theme Token Layer Snapshot (Existing)

| Aspek | Status | File | Catatan |
|---|---|---|---|
| `AppTheme` static colors | ✅ Available | `lib/core/theme/app_theme.dart:21-69` | 25+ static `Color` const: `primary`, `onPrimary`, `white`, `grey50`–`grey900`, `deepTeal`, `teal`, `green`, `darkRed`, `blue`, `purple`, `orange`, dll. Hex literal, no abstraction. |
| `AppTheme.status*` | ✅ Available | `lib/core/theme/app_theme.dart:58-69` | Status badge colors: `statusPendingBg/Text`, `statusUpcomingBg/Text`, `statusCompletedBg/Text`, `statusCancelledBg/Text`. |
| `AppTheme.light` (ThemeData Material) | ✅ Available | `lib/core/theme/app_theme.dart:72-189` | `FlexThemeData.light(...)` + `outlinedButtonTheme` + `inputDecorationTheme`. **Material-bound** (akan di-deprecate di P9, dihapus di P11). |
| `AppTheme.dark` (ThemeData Material) | ⚠️ Defined but unused | `lib/core/theme/app_theme.dart:192-237` | `FlexThemeData.dark(...)`. Tidak dipakai (`MaterialApp(themeMode: ThemeMode.light)` di `main.dart:143`). |
| `AppTextTheme` static TextStyle | ✅ Available | `lib/core/theme/app_text_theme.dart:1-81` | 9 TextStyle const: `headlineLarge/Medium/Small`, `titleLarge`, `bodyLarge/Medium/Small`, `labelLarge/Medium/Small`. Inter + Poppins font family. |
| `AppTextTheme.textTheme` (Material TextTheme) | ✅ Available | `lib/core/theme/app_text_theme.dart:7-18` | Returns `TextTheme` Material — untuk kompatibilitas dengan `Theme.of(context).textTheme`. |
| `AppIcons` IconData registry | ✅ Available | `lib/core/theme/app_icons.dart:1-179` | 80+ `static const IconData` references (Iconsax). |
| `flex_color_scheme` package | ✅ Active | `pubspec.yaml:18` | Third-party wrapper untuk `ThemeData` Material. Akan dihapus di P11 (Q4). |
| `lib/framework/` | ❌ Not exist | — | Layer 1+ folder belum dibuat. |
| `AppThemeData` (custom aggregate) | ❌ Not exist | — | Token aggregate belum ada. |
| `AppThemeScope` (InheritedWidget) | ❌ Not exist | — | Theme lookup belum ada. |

### 2.2 Material Theme Dependency Snapshot

| Material API | Current Usage | File dengan dependency | Migration Plan |
|---|---|---|---|
| `Theme.of(context).colorScheme` | 3 uses | `lib/widgets/app_shell.dart:18`, `lib/features/onboarding/presentation/page/onboarding_page.dart:52` | Defer ke P9 + P10 |
| `Theme.of(context).textTheme` | 5 uses | `lib/features/onboarding/presentation/page/onboarding_page.dart:51`, `lib/features/auth/presentation/page/login_page.dart:64`, dll | Defer ke P9 + P10 |
| `ThemeData` (return type) | 1 def | `lib/core/theme/app_theme.dart:72, 192` | Replace dengan `AppThemeData` di P9 |
| `ColorScheme` (Material) | 0 explicit | — | Implicit via `ThemeData.colorScheme` |
| `TextTheme` (Material) | 1 return | `lib/core/theme/app_text_theme.dart:7-18` | Replace dengan `AppTextStyleSet` di P1 |
| `FlexSchemeColor` | 1 def | `lib/core/theme/app_theme.dart:75, 194` | Dihapus saat `flex_color_scheme` di-remove di P11 |

### 2.3 Call Site Audit Token Existing

| Token | Call Site Count | Sample File |
|---|---:|---|
| `AppTheme.primary` | ~30 | `lib/widgets/button/primary_button.dart:9`, `lib/widgets/loader/error_section.dart:42`, dll |
| `AppTheme.white` | ~25 | `lib/widgets/card/doctor_card.dart:64`, dll |
| `AppTheme.grey*` (50–900) | ~80 | berbagai widget |
| `AppTheme.blue` | ~5 | `lib/widgets/loader/error_section.dart:62` |
| `AppTheme.green/orange/red/...` | ~15 | status badge, icon color |
| `AppTextTheme.bodyMedium` | ~30 | `lib/widgets/card/appointment_card.dart:103` |
| `AppTextTheme.headlineSmall` | ~20 | `lib/widgets/card/doctor_card.dart:91` |
| `AppTextTheme.bodySmall` | ~25 | `lib/widgets/loader/error_section.dart:30` |
| `AppTextTheme.label*` | ~10 | button text |
| **Total** | **~240** | tersebar di 60+ file |

**Catatan audit:** Semua call site di atas akan **tetap bekerja** setelah C1 karena facade preserving signature. Tidak ada satu pun yang perlu dimodifikasi.

### 2.4 Catatan dari Sprint Sebelumnya

- **Sprint B1 closed** dengan 82 test files, 320 tests, 0 failing. Test infrastructure (`mockito`, `mocktail`, `bloc_test`) siap dipakai C1.
- **AGENTS.md** masih menyebut "Sprint 1 — Testing Policy" (sudah obsolete). Akan di-update di T20 C1 untuk menambah section "UI Framework" + remove/clarify Sprint 1 policy.
- **Sprint 2 §"Icon Convention"** di AGENTS.md masih berlaku: Material Icons untuk icon baru, swap ke Iconsax oleh Owner. **Tidak berubah** di C1.
- **Sprint 2 §"Skeleton Loading Rule"** masih berlaku: `Skeletonizer` + reuse production widget. **Tidak berubah** di C1.

---

## 3. Sprint C1 Goals — SMART

### Goal 1 — Foundation Layer 100% Ready (P0)

`lib/framework/foundation/` dengan type aliases untuk `dart:ui` primitives: `Color`, `TextStyle`, `EdgeInsets`, `Duration`, `Curve`, `Rect`, `Offset`, `Size`, `FontWeight`, `TextDirection`, `Locale`, `Brightness`. `lib/framework/hp.dart` barrel export skeleton. **ZERO runtime code** — hanya re-export `package:flutter/foundation.dart` + `package:flutter/painting.dart` subset. Aman karena tidak mengubah build output sama sekali.

### Goal 2 — Theme Tokens Layer 100% Ready (P1)

11 token class implemented + unit tested:

| # | Class | Isi | Lokasi File |
|---|---|---|---|
| 2.1 | `AppSpacing` | `xs(4)`, `sm(8)`, `md(12)`, `lg(16)`, `xl(20)`, `2xl(24)`, `3xl(32)`, `4xl(40)` | `lib/framework/theme/app_spacing.dart` |
| 2.2 | `AppRadius` | `none(0)`, `sm(4)`, `md(8)`, `lg(12)`, `xl(16)`, `pill(9999)` | `lib/framework/theme/app_radius.dart` |
| 2.3 | `AppBorder` | `thin(1)`, `thick(2)`, `none(0)` | `lib/framework/theme/app_border.dart` |
| 2.4 | `AppShadow` | `none`, `sm`, `md`, `lg`, `xl` — `BoxShadow` array | `lib/framework/theme/app_shadow.dart` |
| 2.5 | `AppMotion` | `fast(150ms)`, `normal(250ms)`, `slow(400ms)`; `Curves.standard`, `Curves.emphasized` | `lib/framework/theme/app_motion.dart` |
| 2.6 | `AppIconTheme` | size `xs(16)`, `sm(20)`, `md(24)`, `lg(32)`, `xl(48)` + `colorResolver(Color?)` | `lib/framework/theme/app_icon_theme.dart` |
| 2.7 | `AppColorScheme` | port dari `AppTheme` static colors + semantic methods (`surface`, `onSurface`, `error`, `onError`, `outline`, `outlineVariant`) | `lib/framework/theme/app_color_scheme.dart` |
| 2.8 | `AppTextStyleSet` | port dari `AppTextTheme` TextStyle + role mapping (`headlineLarge` → `headlineLargeRole`) | `lib/framework/theme/app_text_style_set.dart` |
| 2.9 | `AppComponentTheme` | resolved component tokens: `button`, `input`, `card`, `dialog` — agregat dari spacing/radius/border/shadow | `lib/framework/theme/app_component_theme.dart` |
| 2.10 | `AppThemeData` | aggregate immutable root — `light()` + `dark()` factories, `copyWith` | `lib/framework/theme/app_theme_data.dart` |
| 2.11 | `AppThemeScope` | `InheritedWidget` + `AppThemeData.of(context)` / `maybeOf` + update notification | `lib/framework/theme/app_theme_scope.dart` |

### Goal 3 — Backward Compatibility 100% (Q3 Decision)

`AppTheme.primary`, `AppTheme.grey50`, `AppTextTheme.bodyMedium`, dll **TETAP** bisa dipanggil dengan signature identik (static getter). Internal delegate ke `AppThemeData.light().colors.primary` (Q3 resolved decision). **Zero callsite change** di 240+ call site existing. Test: `flutter analyze` 0 issues tanpa satu pun modifikasi call site.

### Goal 4 — Zero Visual Change

Sample 3 page (`HomePage`, `LoginPage`, `DoctorSearchPage`) di-render sebelum dan sesudah token migration. **Tidak boleh ada perubahan pixel-level** karena `AppTheme` facade return identik value. Validasi manual via screenshot side-by-side.

### Goal 5 — Zero Regression

- `flutter analyze` 0 issues (termasuk test code, lint config, doc).
- `flutter test` exit code 0 — semua 320 test B1 pass tanpa modifikasi, + ~15 test C1 baru (1-2 per token class) juga pass.
- `flutter build apk --debug` sukses tanpa warning.

### Goal 6 — Documentation Updated

- `AGENTS.md` ditambah section "UI Framework" (di bawah section existing) dengan link ke ADR 014 + status C1 selesai.
- `docs/progress/sprint_roadmap.md` ditambah row Sprint C1 (placeholder C2–C9 di luar scope C1).
- `docs/adr/014-ui-framework-foundation.md` di-anotasi dengan note "Sprint C1 executed YYYY-MM-DD" di §11 Future Work.

---

## 4. Sprint Backlog — Per Pool

Total: **26 task, ~22 jam kerja** (5 hari × ~4.5 jam/hari). Dipecah jadi 8 pool (0, A, B, C, D, E, F, G).

### 4.1 Pool 0 — Sprint Setup (P0 prelude) — ~1.5 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T1 | **Sprint Opening Audit** — bikin `docs/audits/sprint_c1_audit.md` mapping existing `AppTheme`/`AppTextTheme` call site + identifikasi token value yang akan di-port | `docs/audits/sprint_c1_audit.md` (new) | 1h | Day 1 |
| T2 | **Create directory structure** + barrel `lib/framework/hp.dart` skeleton | `lib/framework/` (new) | 0.5h | Day 1 |

**Subtotal Pool 0: 1.5 jam**

### 4.2 Pool A — Foundation (Layer 1) — ~2 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T3 | **Implement `AppFoundation`** — re-export `dart:ui` primitives (`Color`, `TextStyle`, `EdgeInsets`, `Duration`, `Curve`, `Rect`, `Offset`, `Size`, `FontWeight`, `TextDirection`, `Locale`, `Brightness`) via `export 'package:flutter/painting.dart' show ...;` (ZERO new runtime code) | `lib/framework/foundation/app_foundation.dart` (new) | 1h | Day 1 |
| T4 | **Unit test untuk `AppFoundation`** — verify import chain resolves correctly (1 test: `expect(AppColor, isA<Type>());`) | `test/framework/foundation/app_foundation_test.dart` (new) | 0.5h | Day 1 |
| T4a | Update `lib/framework/hp.dart` barrel: `export 'foundation/app_foundation.dart';` | `lib/framework/hp.dart` (modify) | 0.1h | Day 1 |
| T4b | Verify `flutter analyze` masih 0 issues setelah T2–T4a | — | 0.1h | Day 1 |
| T4c | Commit: `feat(framework): C1 pool A — foundation type aliases` | — | 0.1h | Day 1 |
| T4d | Commit: `test(framework): C1 pool A — foundation smoke test` | — | 0.1h | Day 1 |

**Subtotal Pool A: 1.9 jam**

### 4.3 Pool B — Basic Tokens (Layer 2.1–2.6) — ~7 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T5 | **Implement `AppSpacing`** — `abstract final class AppSpacing` dengan `static const double xs = 4;` dll untuk 8 size variants. Static-only (tidak instantiate). | `lib/framework/theme/app_spacing.dart` (new) | 0.5h | Day 1-2 |
| T5a | Unit test: verify all 8 values + immutability | `test/framework/theme/app_spacing_test.dart` (new) | 0.5h | Day 2 |
| T6 | **Implement `AppRadius`** — 6 radius variants sebagai `static const Radius` (bukan double — agar langsung dipakai `BorderRadius.circular(AppRadius.md)`). | `lib/framework/theme/app_radius.dart` (new) | 0.5h | Day 2 |
| T6a | Unit test: verify all 6 values | `test/framework/theme/app_radius_test.dart` (new) | 0.5h | Day 2 |
| T7 | **Implement `AppBorder`** — `static const double thin = 1;`, `thick = 2;`, `none = 0;` | `lib/framework/theme/app_border.dart` (new) | 0.3h | Day 2 |
| T7a | Unit test | `test/framework/theme/app_border_test.dart` (new) | 0.2h | Day 2 |
| T8 | **Implement `AppShadow`** — 5 elevation levels sebagai `static const List<BoxShadow>` array. Gunakan `Color(0x1A000000)` base. | `lib/framework/theme/app_shadow.dart` (new) | 1h | Day 2 |
| T8a | Unit test: verify each elevation produces expected `BoxShadow` count + offset/blur | `test/framework/theme/app_shadow_test.dart` (new) | 0.5h | Day 2 |
| T9 | **Implement `AppMotion`** — 3 `Duration` + 2 `Curve` constants. `fast(150ms)`, `normal(250ms)`, `slow(400ms)`; `standard = Curves.easeInOut`, `emphasized = Curves.easeInOutCubicEmphasized` | `lib/framework/theme/app_motion.dart` (new) | 0.5h | Day 2 |
| T9a | Unit test | `test/framework/theme/app_motion_test.dart` (new) | 0.3h | Day 2 |
| T10 | **Implement `AppIconTheme`** — 5 size variants sebagai `static const double` + `static Color resolveColor(BuildContext, Color?)` helper | `lib/framework/theme/app_icon_theme.dart` (new) | 0.5h | Day 2 |
| T10a | Unit test | `test/framework/theme/app_icon_theme_test.dart` (new) | 0.3h | Day 2 |
| T10b | Commit per token class (T5, T6, T7, T8, T9, T10) — `feat(framework): C1 pool B.5 — AppSpacing` | — | 6×0.05h | Day 2 |

**Subtotal Pool B: 5.7 jam (~6 token class, ~6 test file, ~12 test cases)**

### 4.4 Pool C — Color & Text (Layer 2.7–2.8) — ~4 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T11 | **Implement `AppColorScheme`** — `final class AppColorScheme` dengan fields `primary`, `onPrimary`, `white`, `grey50`–`grey900`, `deepTeal`, `teal`, `green`, `darkRed`, `blue`, `purple`, `orange`, status colors. **Pakai `Color` const constructor** (bukan static fields) untuk konsistensi dengan `AppThemeData` aggregate. `const AppColorScheme.light()` + `.dark()` constructors. | `lib/framework/theme/app_color_scheme.dart` (new) | 1.5h | Day 3 |
| T11a | Unit test: light scheme fields + dark scheme fields + equality | `test/framework/theme/app_color_scheme_test.dart` (new) | 0.5h | Day 3 |
| T12 | **Implement `AppTextStyleSet`** — `final class AppTextStyleSet` dengan 9 TextStyle fields (port dari `AppTextTheme`): `headlineLarge/Medium/Small`, `titleLarge`, `bodyLarge/Medium/Small`, `labelLarge/Medium/Small`. `const AppTextStyleSet.standard()` factory (default Inter + Poppins). | `lib/framework/theme/app_text_style_set.dart` (new) | 1.5h | Day 3 |
| T12a | Unit test: each TextStyle + font family + size + weight verify | `test/framework/theme/app_text_style_set_test.dart` (new) | 0.5h | Day 3 |
| T12b | Commit: `feat(framework): C1 pool C — AppColorScheme + AppTextStyleSet` | — | 0.1h | Day 3 |

**Subtotal Pool C: 4.1 jam (~2 token class, ~2 test file, ~20 test cases)**

### 4.5 Pool D — Aggregate & Scope (Layer 2.9–2.11) — ~4.5 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T13 | **Implement `AppComponentTheme`** — `final class AppComponentTheme` immutable, agregat dari `AppRadius`, `AppBorder`, `AppShadow` untuk component patterns. Field: `buttonRadius = AppRadius.md`, `inputBorderWidth = AppBorder.thin`, `cardShadow = AppShadow.sm`, dll. `const AppComponentTheme.standard()` factory. | `lib/framework/theme/app_component_theme.dart` (new) | 1h | Day 3 |
| T13a | Unit test | `test/framework/theme/app_component_theme_test.dart` (new) | 0.5h | Day 3 |
| T14 | **Implement `AppThemeData`** — `final class AppThemeData` immutable root aggregate. Fields: `brightness`, `colorScheme`, `textStyles`, `spacing`, `radius`, `border`, `shadow`, `motion`, `iconTheme`, `component`. `const AppThemeData.light()` + `.dark()` factories. `copyWith` method. `==` + `hashCode` untuk testing. | `lib/framework/theme/app_theme_data.dart` (new) | 1h | Day 3-4 |
| T14a | Unit test: factory + equality + copyWith | `test/framework/theme/app_theme_data_test.dart` (new) | 0.5h | Day 4 |
| T15 | **Implement `AppThemeScope`** — `class AppThemeScope extends InheritedWidget` dengan `final AppThemeData data`. Static `AppThemeData.of(BuildContext)` + `maybeOf`. `updateShouldNotify` return `old.data != data`. | `lib/framework/theme/app_theme_scope.dart` (new) | 1h | Day 4 |
| T15a | Unit test: lookup + update notify behavior (test dengan 2 AppThemeScope berbeda di tree) | `test/framework/theme/app_theme_scope_test.dart` (new) | 0.5h | Day 4 |
| T15b | Commit: `feat(framework): C1 pool D — AppComponentTheme + AppThemeData + AppThemeScope` | — | 0.1h | Day 4 |

**Subtotal Pool D: 4.6 jam (~3 token class, ~3 test file, ~12 test cases)**

### 4.6 Pool E — Backward Compat Facade (Q3 Decision) — ~2.5 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T16 | **Refactor `app_theme.dart`** — convert static color const jadi facade delegating ke `AppThemeData.light().colors`. Contoh: `static Color get primary => AppThemeData.light().colorScheme.primary;`. **PENTING:** signature `AppTheme.primary` (static getter) tetap, tidak ada breaking change. `AppTheme.light` (ThemeData) **di-deprecate** dengan `@Deprecated('Use AppThemeData.light() — will be removed in P11')` annotation, tapi tidak dihapus. | `lib/core/theme/app_theme.dart` (modify) | 1h | Day 4 |
| T17 | **Refactor `app_text_theme.dart`** — convert static TextStyle const jadi facade delegating ke `AppThemeData.light().textStyles`. `AppTextTheme.textTheme` (Material TextTheme) **di-deprecate** dengan annotation. | `lib/core/theme/app_text_theme.dart` (modify) | 1h | Day 4 |
| T18 | **Verify zero callsite change** — `grep -r "AppTheme\." lib/` + `grep -r "AppTextTheme\." lib/` sebelum dan sesudah refactor — signature harus identik. `flutter analyze` harus 0 issues. | — | 0.3h | Day 4 |
| T18a | Commit: `refactor(theme): C1 pool E — facade delegation preserving static API` | — | 0.1h | Day 4 |

**Subtotal Pool E: 2.4 jam**

### 4.7 Pool F — Root Integration Prep (P0.5) — ~1.5 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T19 | **Wrap `MaterialApp.router` di `main.dart` dengan `AppThemeScope`** — tambahkan `AppThemeScope(data: AppThemeData.light(), child: MaterialApp.router(...))` sebagai wrapper. **NO behavior change** — `MaterialApp` masih dipakai (akan diganti `HPApp` di P9/C5). | `lib/main.dart` (modify) | 0.5h | Day 5 |
| T20 | **Update `AGENTS.md`** — tambah section "## UI Framework" di bawah section existing. Isi: link ke ADR 014, status C1 selesai, list `HP*` widget yang akan datang, reminder bahwa untuk kode BARU di feature, gunakan `HP*` widget jika sudah ready. | `AGENTS.md` (modify) | 0.5h | Day 5 |
| T21 | **Update `docs/progress/sprint_roadmap.md`** — tambah row Sprint C1 di section "Sprint B+". Placeholder: `C2–C9` di-list dengan tema singkat. | `docs/progress/sprint_roadmap.md` (modify) | 0.3h | Day 5 |
| T21a | Commit: `docs(framework): C1 pool F — root prep + AGENTS.md + roadmap` | — | 0.1h | Day 5 |

**Subtotal Pool F: 1.4 jam**

### 4.8 Pool G — Closing & Verification — ~2 jam

| # | Task | File Target | Estimasi | Sprint Day |
|---|---|---|:---:|:---:|
| T22 | **Visual parity check** — render `HomePage`, `LoginPage`, `DoctorSearchPage` di debug mode + screenshot. Bandingkan dengan baseline (Sprint B1). **Wajib:** tidak ada diff pixel. | manual test | 1h | Day 5 |
| T23 | `flutter analyze` — verify 0 issues (production + test) | — | 0.1h | Day 5 |
| T24 | `flutter test` — verify all 320 B1 test + ~15 C1 test pass, exit code 0 | — | 0.3h | Day 5 |
| T25 | `flutter build apk --debug` — verify build sukses, no warning | — | 0.2h | Day 5 |
| T26 | Final commit + sprint review document update | `docs/audits/sprint_c1_audit.md` (close section) | 0.3h | Day 5 |
| T26a | Tag release: `git tag sprint-c1-complete` | — | 0.1h | Day 5 |

**Subtotal Pool G: 2 jam**

### 4.9 Total Estimation

| Pool | Task Count | Estimasi |
|---|:---:|:---:|
| Pool 0 — Setup | 2 | 1.5 jam |
| Pool A — Foundation | 5 (T3, T4, T4a-d) | 1.9 jam |
| Pool B — Basic Tokens | 13 (T5–T10 + a/b variants) | 5.7 jam |
| Pool C — Color & Text | 5 (T11, T12 + a/b) | 4.1 jam |
| Pool D — Aggregate | 5 (T13, T14, T15 + a/b) | 4.6 jam |
| Pool E — Facade | 4 (T16, T17, T18, T18a) | 2.4 jam |
| Pool F — Root Prep | 4 (T19, T20, T21, T21a) | 1.4 jam |
| Pool G — Closing | 6 (T22, T23, T24, T25, T26, T26a) | 2.0 jam |
| **Total** | **~26 task + 12 commit** | **~22 jam** |

Sprint C1 = **5 hari × ~4.5 jam/hari** (sprint ringan karena additive-only, no feature code change).

---

## 5. Weekly Schedule (5 Working Days)

| Day | Date | Pool 0 + A | Pool B | Pool C + D | Pool E + F | Commit Target |
|---|:---:|---|---|---|---|---|
| **1** | [TBD] | T1, T2, T3, T4, T4a-d | T5, T5a, T6, T6a | — | — | `feat(framework): C1 pool A+B.1+B.2 — foundation + spacing + radius` |
| **2** | [TBD] | — | T7, T7a, T8, T8a, T9, T9a, T10, T10a, T10b | — | — | `feat(framework): C1 pool B.3-B.6 — border + shadow + motion + icon` |
| **3** | [TBD] | — | — | T11, T11a, T12, T12a, T12b, T13, T13a | — | `feat(framework): C1 pool C+D.1 — color + text + component` |
| **4** | [TBD] | — | — | T14, T14a, T15, T15a, T15b | T16, T17, T18, T18a | `feat(framework): C1 pool D.2+E — aggregate + facade` |
| **5** | [TBD] | — | — | — | T19, T20, T21, T21a, T22, T23, T24, T25, T26, T26a | `feat(framework): C1 complete + visual parity verified` |

### Timeline Visual

```
Sprint C1: UI Framework Foundation + Theme Tokens
Day:    1   │  2   │  3        │  4           │  5
Theme:  F+B  │  B   │  C+D.1    │  D.2+E       │  F+G
         ↑   │  ↑   │   ↑       │    ↑         │   ↑
       Fnd+Sp Rad+Border  Color+Comp  Data+Scope  Doc+QA
       +Rad  +Shad+Mtn  +Text+Comp   +Facade     +Close
       1.9h  3h        4.1h         4.6h         3.4h
```

Keterangan:
- **F** = Foundation (type aliases, zero runtime)
- **B** = Basic tokens (spacing, radius, border, shadow, motion, icon)
- **C** = Color + Text scheme
- **D** = Component + Data aggregate + Scope
- **E** = Backward compat facade
- **F (Pool)** = Root prep + docs
- **G** = Closing + visual parity

---

## 6. Architecture Decisions

### 6.1 AD-1: Layer 1 Foundation = Type Aliases Only (Zero Runtime)

**Decision:** `AppFoundation` adalah re-export `package:flutter/painting.dart` subset — TIDAK ada class baru, TIDAK ada logic. Hanya type aliases untuk dokumentasi.

**Rationale:**
- Type aliases tidak menambah byte ke compiled code.
- Mempermudah IDE auto-complete untuk developer baru ("oh, `AppFoundation.Color` → dart:ui Color").
- Future-proof: ketika Flutter punya API baru (mis. `Path` widget baru), bisa di-add ke re-export tanpa breaking change.
- Layer 1 jadi "documentation layer" yang berdiri sendiri, tidak ada risk.

**Alternative considered:** Buat wrapper class `HpColor extends Color`. **Rejected** — tidak ada value, hanya overhead, dan color object sudah const-final.

### 6.2 AD-2: Layer 2 Token = Immutable Value Object, Const Constructors

**Decision:** Semua token class (`AppSpacing`, `AppRadius`, `AppBorder`, `AppShadow`, `AppMotion`, `AppIconTheme`, `AppColorScheme`, `AppTextStyleSet`, `AppComponentTheme`, `AppThemeData`) immutable dengan `const` constructor. Basic tokens (`AppSpacing`, `AppRadius`, `AppBorder`, `AppMotion`) pakai **static const fields** (seperti `AppTheme` existing). Aggregate tokens (`AppColorScheme` dst.) pakai **final class dengan const constructor + named factories** (`const AppColorScheme.light()`).

**Rationale:**
- Static const untuk value primitif (double, Color, Duration) → zero allocation, langsung `AppSpacing.md`.
- Final class + const constructor untuk aggregate → bisa di-compare dengan `==`, di-copy dengan `copyWith`, dan dipakai sebagai `InheritedWidget` value.
- `AppThemeData.light()` adalah `const` factory — setiap kali dipanggil return instance yang sama (canonical).
- Konsisten dengan Dart best practice untuk design token.

**Alternative considered:** Semua class static (seperti `AppTheme`). **Rejected** — aggregate (`AppThemeData`) butuh `==` + `copyWith` + `InheritedWidget` integration, tidak bisa static-only.

### 6.3 AD-3: Backward Compat via Facade Static Getter (Q3 Decision)

**Decision:** `AppTheme.primary`, `AppTheme.grey50`, `AppTextTheme.bodyMedium`, dll **TETAP** static getter, bukan `static const` (refactor dari const ke getter). Internal delegate ke `AppThemeData.light().colors.primary` / `AppTextStyleSet.standard().bodyMedium`.

**Rationale:**
- Q3 resolved decision (Juli 2026): "Pertahankan sebagai facade read-only sampai P12".
- 240+ call site existing tidak boleh berubah. Facade preserving signature = zero callsite change.
- Performance: getter indirection cost = ~1 nanosecond, tidak measurable. Trade-off worth it.
- `const` context (e.g., `const TextStyle(color: AppTheme.primary)`) akan **error** karena getter bukan const. **Solusi:** Sediakan `static const Color _primaryConst = Color(0xff1C2A3A);` private + `static Color get primary => _primaryConst;` public getter. Const context preserved.

**Detailed Pattern:**
```dart
abstract final class AppTheme {
  // Private const fields (preserved for const context)
  static const Color _primaryConst = Color(0xff1C2A3A);
  // ... other 24 const fields ...

  // Public getter (facade delegating to AppThemeData)
  static Color get primary => _primaryConst;
  // Implementation: untuk basic token (grey*), bisa juga
  // static Color get grey50 => AppThemeData.light().colorScheme.grey50;
  // — both work karena `AppColorScheme.grey50` adalah const field

  // DEPRECATED (P9 + P11 removal)
  @Deprecated('Use AppThemeData.light() — will be removed in P11')
  static ThemeData get light => FlexThemeData.light(/* ... */);
}
```

**Catatan:** `AppTheme.light` (ThemeData Material) di-deprecate (annotation) tapi TIDAK dihapus sampai P11. `AppTheme.dark` similarly. Meminimalkan diff.

### 6.4 AD-4: `AppThemeScope` Pakai `InheritedWidget` (Bukan `Provider` atau `InheritedModel`)

**Decision:** `AppThemeScope` extends `InheritedWidget` standard. `updateShouldNotify` return `old.data != data`. `AppThemeData.of(context)` baca via `context.dependOnInheritedWidgetOfExactType<AppThemeScope>()`.

**Rationale:**
- `InheritedWidget` adalah built-in Flutter, no dependency.
- `AppThemeData` jarang berubah (saat ini cuma light/dark, tidak ada runtime toggle), jadi `InheritedModel` (yang granularity per-field) over-engineering.
- `Provider` dependency tambahan — saat ini `provider: ^6.1.5+1` ada di pubspec tapi **hanya dipakai** oleh `OnboardingNotifier` (ChangeNotifier pattern). Pakai `Provider` untuk theme = coupling ke `Provider` — saat migrasi ke pure widget nanti, akan jadi masalah.
- `InheritedWidget` adalah pattern standar untuk design token di Flutter (lihat Material's own `Theme`).

**Alternative considered:** `InheritedNotifier<AppThemeData>` dengan `ValueNotifier<AppThemeData>`. **Rejected** — over-engineering untuk use case C1 (static light/dark). Mungkin relevan untuk C7 (Dark Mode Strategy ADR 020) di kemudian hari.

### 6.5 AD-5: Token Values 1:1 Port dari `AppTheme` Existing

**Decision:** Semua value di `AppColorScheme` (warna), `AppTextStyleSet` (TextStyle), dan token lain di-port 1:1 dari `AppTheme`/`AppTextTheme` static const existing. **TIDAK** ada redesign visual di C1.

**Rationale:**
- C1 = **foundation**, bukan **redesign**. Tujuan: setup infrastruktur token, BUKAN ubah look & feel.
- Visual parity DoD (§3 Goal 4) memaksa 1:1 port.
- Redesain bisa di fase C7 (Dark Mode Strategy) atau sprint khusus nanti.

**Source of truth untuk port:**
- Colors: `lib/core/theme/app_theme.dart:21-69` (25+ Color const).
- Text styles: `lib/core/theme/app_text_theme.dart:23-80` (9 TextStyle const + 2 base style).
- Spacing: implicit dari `EdgeInsets.all(12)`, `padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)`, dll di seluruh codebase → grep + audit untuk definisi 8 size variant.
- Radius: implicit dari `BorderRadius.circular(8)`, `BorderRadius.circular(12)`, dll → 6 size variant.
- Shadow: implicit dari `BoxShadow` di beberapa widget → 5 elevation level (none, sm, md, lg, xl).

**Catatan audit T1** wajib memetakan semua implicit token ini sebelum Pool B dimulai, agar 1:1 port akurat.

### 6.6 AD-6: Framework Test Diizinkan (Pengecualian Terbatas ADR Non-Goal 8)

**Decision:** Sprint C1 **membuat test baru** untuk kode framework yang baru dibuat (`AppSpacing`, `AppRadius`, `AppThemeData`, dll). Total ~15 test cases untuk 11 token class. Ini adalah **pengecualian terbatas** terhadap ADR 014 Non-Goal 8 ("Tidak membuat test baru di fase ini").

**Rationale:**
- ADR Non-Goal 8 diturunkan untuk mencegah **scope creep ke feature existing** (mis. test untuk `Scaffold`, `MaterialApp`, widget existing). Sprint B1 sudah on-track untuk itu.
- Kode framework baru (token class) **adalah kode baru** yang **harus di-test** untuk dianggap production-ready. Test untuk token class sama esensialnya dengan test untuk entity baru.
- Test untuk `AppSpacing.xs == 4` itu **satu baris code** — effort minimal, benefit maksimal (jika ada perubahan inkonsisten di kemudian hari, test langsung fail).
- 15 test cases untuk 22 jam sprint = ~1 test per 1.5 jam. Margin aman.

**Boundary jelas:**
- ✅ **Boleh:** Test untuk class baru di `lib/framework/`.
- ❌ **Tidak boleh:** Test untuk class existing (`AppTheme`, `AppTextTheme` static const), test untuk widget existing (`Scaffold`, `AppBar`), test untuk migrated feature (defer ke P10).

### 6.7 AD-7: `MaterialApp` Tetap Dipakai Sampai P9

**Decision:** `lib/main.dart` di C1 HANYA menambah `AppThemeScope` wrapper di luar `MaterialApp.router`. `MaterialApp` itu sendiri **TIDAK diganti** sampai Sprint C5 (P9 Root Widget).

**Rationale:**
- Migrasi `MaterialApp` → `HPApp` (custom `WidgetsApp`) adalah effort besar (1-2 sprint sendiri). Butuh `localizationsDelegates` stub, `pageRouteBuilder` custom, default `textStyle`, dll.
- Sprint C1 fokus token infrastructure. UI behavior (page transition, dialog animation, snackbar) tetap Material sampai C5.
- `AppThemeScope` di luar `MaterialApp` = `AppThemeData` tersedia di seluruh subtree, siap dipakai widget `HP*` Layer 3+ di C2+.
- **Zero behavior change** karena `AppThemeScope` cuma nempel di tree, tidak affect rendering. `MaterialApp` masih supply `ThemeData` Material sendiri.

**Code pattern (illustrative, bukan implementasi):**
```dart
// lib/main.dart (after T19)
runApp(
  AppThemeScope(
    data: AppThemeData.light(),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  // ... unchanged, masih return MaterialApp.router
}
```

### 6.8 AD-8: `flex_color_scheme` Tetap Dipakai Sampai P11

**Decision:** `flex_color_scheme: ^8.4.0` di `pubspec.yaml` **TIDAK dihapus** di C1. Masih dipakai untuk `FlexThemeData.light/dark` di `app_theme.dart` (yang sekarang menjadi facade).

**Rationale:**
- Q4 resolved decision (Juli 2026): "Hapus di P11 (setelah semua fitur dimigrasi + visual parity confirmed)".
- Di C1, `FlexThemeData` masih dipakai untuk `AppTheme.light` (ThemeData Material) yang masih di-pass ke `MaterialApp` (di P9 nanti dihapus).
- Hapus `flex_color_scheme` sebelum `MaterialApp` dihapus = breaking change (ThemeData hilang). Tidak worth risk di C1.

**Track:** Ticketed di Sprint C8 (P11) backlog.

### 6.9 AD-9: `AppTheme.light` (ThemeData) Di-Deprecate, Tidak Dihapus

**Decision:** `AppTheme.light` dan `AppTheme.dark` (ThemeData Material) di-mark dengan `@Deprecated('Use AppThemeData.light() — will be removed in P11')` annotation. **TIDAK dihapus** di C1.

**Rationale:**
- Q3 decision: "Pertahankan sebagai facade sampai P12". `ThemeData` adalah Material-specific, secara teknis **bukan** bagian dari `HP*` framework — tapi masih dipakai `MaterialApp` sampai P9.
- Deprecated annotation = IDE warning untuk developer yang panggil `AppTheme.light` → arahkan ke `AppThemeData.light()`. Visual continuity preserved sampai P11.
- P11 nanti hapus `flex_color_scheme` + `AppTheme.light/dark` + `MaterialApp` bersamaan (atomic change).

---

## 7. Definition of Done — Sprint C1

### 7.1 Per-Item DoD

Setiap task T1–T26 harus memenuhi:
- [ ] File di lokasi sesuai Section 4 (Pool assignment)
- [ ] Production code (`lib/framework/`) dan test code (`test/framework/`) menggunakan path mirror
- [ ] Token class immutable (`final` field, `const` constructor, `==` + `hashCode` jika applicable)
- [ ] Unit test untuk setiap token class (minimal 1 test per class)
- [ ] `flutter analyze` 0 issues
- [ ] `flutter test test/path/to/test_file.dart` exit code 0
- [ ] Tidak ada `print()` / `debugPrint()` di production code
- [ ] Tidak ada import `package:flutter/material.dart` di `lib/framework/`
- [ ] Conventional commit message: `feat(framework):`, `test(framework):`, `refactor(theme):`, `docs(framework):`

### 7.2 Sprint C1 Global DoD

- [ ] **Pool 0**: T1–T2 selesai (audit + directory setup)
- [ ] **Pool A**: T3–T4d selesai (Foundation layer + test)
- [ ] **Pool B**: T5–T10b selesai (6 basic token class + test)
- [ ] **Pool C**: T11–T12b selesai (ColorScheme + TextStyleSet + test)
- [ ] **Pool D**: T13–T15b selesai (ComponentTheme + ThemeData + ThemeScope + test)
- [ ] **Pool E**: T16–T18a selesai (Facade refactor + verify)
- [ ] **Pool F**: T19–T21a selesai (Root prep + docs)
- [ ] **Pool G**: T22–T26a selesai (Visual parity + closing)
- [ ] `lib/framework/foundation/app_foundation.dart` exist
- [ ] `lib/framework/theme/` punya 11 file token class
- [ ] `lib/framework/hp.dart` barrel export minimal Foundation + Theme
- [ ] `lib/core/theme/app_theme.dart` masih exist dengan `AppTheme.primary` dll = facade delegating
- [ ] `lib/core/theme/app_text_theme.dart` masih exist dengan `AppTextTheme.bodyMedium` dll = facade delegating
- [ ] `lib/main.dart` wrap `MaterialApp.router` dengan `AppThemeScope`
- [ ] `AGENTS.md` punya section "UI Framework" dengan link ADR 014
- [ ] `docs/progress/sprint_roadmap.md` punya row Sprint C1
- [ ] `flutter analyze` exit code 0
- [ ] `flutter test` exit code 0 — semua 320 B1 test + ~15 C1 test pass
- [ ] `flutter build apk --debug` sukses
- [ ] Visual parity: HomePage, LoginPage, DoctorSearchPage tidak ada diff pixel
- [ ] Conventional commit messages untuk semua perubahan

### 7.3 Sprint C1 NOT DoD (Explicit)

- ❌ Widget `HP*` Layer 3+ (Primitives, Interaction, Layout, Navigation, Input, Feedback, Components) — Sprint C2–C5
- ❌ `HPApp` root widget (ganti `MaterialApp`) — Sprint C5 (P9)
- ❌ Migrasi `Scaffold`/`AppBar`/widget apapun di feature — Sprint C6+ (P10)
- ❌ Hapus `flex_color_scheme` — Sprint C8 (P11)
- ❌ Hapus `AppTheme.light/dark` (ThemeData Material) — Sprint C8 (P11)
- ❌ Hapus `lib/widgets/` legacy — Sprint C9 (P12)
- ❌ Migrasi `TimeOfDay` Material dari domain — ADR 016
- ❌ Custom lint `avoid_material_import` — ADR 018
- ❌ Setup dark mode penuh — Sprint C7 (ADR 020)
- ❌ Localization/i18n — Sprint C8 (ADR 021)
- ❌ Widget test untuk framework widget — Sprint B2 / C2+ (setelah Layer 3 siap)

---

## 8. Risiko & Mitigasi

| # | Risiko | Probabilitas | Dampak | Severity | Mitigasi |
|---|---|:---:|---|:---:|---|
| **R1** | **Audit token value salah** — implicit spacing/radius dari codebase tidak terpetakan akurat di T1 | 🟡 Medium | Visual change | 🔴 Critical | T1 audit wajib list semua `EdgeInsets`, `BorderRadius.circular`, `BoxShadow` call site. Cross-check 3 sample page (Home, Login, Doctor) post-implementation. |
| **R2** | **Facade getter `const` context error** — getter bukan const, call site `const TextStyle(color: AppTheme.primary)` jadi error | 🟡 Medium | Build break | 🔴 Critical | AD-3 pattern: private `_primaryConst` static const + public getter. Const context preserved via private field. Test di T18 verify zero build error. |
| **R3** | **Aggregate `AppThemeData` `==` tidak stabil** — Color equality mungkin flakey di runtime | 🟢 Low | Test flakey | 🟡 Medium | `AppColorScheme` `==` compare all 25+ field. Test deterministic. Jika flakey, override `==` di `AppThemeData` level saja. |
| **R4** | **Import conflict antara `AppFoundation.Color` dan `dart:ui` Color** | 🟢 Low | Compile error | 🟡 Medium | `AppFoundation` adalah re-export — `AppFoundation.Color` resolve ke `dart:ui.Color` tanpa conflict. `import 'package:health_pal/framework/foundation/app_foundation.dart' show Color;` di setiap file framework. |
| **R5** | **Visual diff tidak terdeteksi manual** — T22 human-check bisa miss subtle change | 🟡 Medium | Visual regression | 🟡 Medium | Pakai 3 page representatif (Home, Login, Doctor) yang sudah sering di-test. Side-by-side screenshot comparison. Jika ragu, defer visual parity ke C2 (low priority — facade returning same value = no diff in theory). |
| **R6** | **Scope creep ke widget baru** — devs tempted bikin `HpButton` di C1 | 🟡 High | Schedule slip | 🔴 Critical | AD tegas: C1 = token only. Widget di C2+. Sprint review reject PR yang introduce widget Layer 3+. |
| **R7** | **AGENTS.md update konflik dengan existing section** — "Sprint 1 — Testing Policy" masih ada, ditambah "UI Framework" = potentially confusing | 🟢 Low | Confusion | 🟢 Low | T20 update `AGENTS.md` dengan 2 perubahan: (1) remove/clarify "Sprint 1 — Testing Policy" jadi "Sprint 1 Closed — testing allowed sejak Sprint B1+", (2) tambah section "UI Framework" dengan link ADR 014. |
| **R8** | **Sprint B1 belum sepenuhnya closed** saat C1 mulai | 🟢 Low | Dependency fail | 🟡 Medium | C1 kick-off TIDAK boleh sebelum Sprint B1 closing report published. Jika B1 mundur, C1 mundur proporsional. |
| **R9** | **Test pattern di B1 tidak match pattern C1** — B1 pakai `mockito`/`bloc_test`, C1 pure unit test untuk token | 🟢 Low | Inconsistency | 🟢 Low | C1 test pure: `expect(AppSpacing.md, 12);` — no mock. Pattern jelas berbeda (data layer pakai mock, token layer direct assert). Tidak konflik. |
| **R10** | **Visual parity check terlalu subjektif** | 🟡 Medium | DoD fail subjective | 🟡 Medium | T22 wajib: ambil screenshot pre-C1 (simpan di `docs/audits/sprint_c1_visual_baseline.png`) + post-C1 (simpan di `docs/audits/sprint_c1_visual_after.png`). Diff tool opsional. Manual review OK jika tidak ada feature code change. |
| **R11** | **`AppThemeScope` di luar `MaterialApp` menyebabkan lookup conflict** — Material `Theme` juga InheritedWidget, urutan baca penting | 🟢 Low | Theme confusion | 🟡 Medium | `AppThemeScope` di parent (lebih luar), `MaterialApp` di child. `AppThemeData.of(context)` baca scope terluar. `Theme.of(context)` masih baca `MaterialApp` sendiri. Tidak konflik, dua lookup berbeda. |
| **R12** | **Performa regression** — facade getter + InheritedWidget lookup menambah overhead per build | 🟢 Low | Performa | 🟢 Low | Getter cost ~1ns, `InheritedWidget.dependOnInheritedWidgetOfExactType` di-cache Flutter. Tidak measurable di 60fps render. |

---

## 9. Deferred to Sprint C2+

| # | Item | Sumber | Alasan Defer |
|---|---|---|---|
| 1 | **Widget `HP*` Layer 3 (Primitives)** — `HPText`, `HPIcon`, `HPContainer`, `HPImage`, `HPDivider`, `HPCard`, `HPBadge`, `HPChip`, `HPAvatar`, `HPListTile`, `HPDialog` | ADR 014 §9.2 P2 | Sprint C1 = token only. Widget butuh Layer 2 siap (AppThemeData) → C1 selesai → C2 baru. |
| 2 | **Widget `HP*` Layer 4 (Interaction)** — `HPGestureDetector`, `HPInkRipple`, `HPFocusable`, `HPDraggable`, `HPTapRegion` | ADR 014 §9.2 P3 | Butuh Layer 3 primitives untuk compose. |
| 3 | **Widget `HP*` Layer 5 (Layout)** — `HPScaffold`, `HPListView`, `HPGridView`, `HPSafeArea`, `HPScrollView`, `HPColumn`, `HPRow`, `HPStack`, `HPPadding`, `HPAspectRatio` | ADR 014 §9.2 P4 | Butuh Layer 3+4. **Sertakan `LegacyScaffold` adapter.** |
| 4 | **Widget `HP*` Layer 6 (Navigation)** — `HPAppBar`, `HPTabBar`, `HPBottomNavBar`, `HPDrawer`, `HPBackButton` | ADR 014 §9.2 P5 | Butuh Layer 5 layout. **Sertakan `LegacyAppBar` adapter.** |
| 5 | **Widget `HP*` Layer 7 (Input)** — `HPTextField`, `HPPasswordField`, `HPPinField`, `HPCheckbox`, `HPRadio`, `HPSwitch`, `HPSlider`, `HPDatePicker`, `HPTimePicker`, `HPDropdown` | ADR 014 §9.2 P6 | Reuse `AppInputField`/`AppForm`/`AppDatePickerDialog` existing. Butuh Layer 2-6. **Sertakan `LegacyTextFormField`/`LegacyForm` adapter.** |
| 6 | **Widget `HP*` Layer 8 (Feedback)** — `HPSnackbar`, `HPToast`, `HPTooltip`, `HPProgressIndicator`, `HPSkeleton` | ADR 014 §9.2 P7 | Butuh Layer 3-7. **Sertakan `LegacyScaffoldMessenger` adapter.** |
| 7 | **Widget `HP*` Layer 9 (Components)** — `HPDoctorCard`, `HPAppointmentCard`, `HPBannerCarousel`, `HPHomeScaffold`, `HPProfileSection`, `HPBookingSection` | ADR 014 §9.2 P8 | Butuh semua layer 3-8. |
| 8 | **`HPApp` root widget** — ganti `MaterialApp.router` di `main.dart` | ADR 014 §9.2 P9 | Butuh Layer 9 components. Extend `WidgetsApp`, custom `pageRouteBuilder`, `localizationsDelegates` stub. Effort 1-2 sprint. |
| 9 | **Adapter `LegacyScaffold`/`LegacyAppBar`/`LegacyFilledButton`/dll** | ADR 014 §8.7 | Butuh widget target untuk adapter (circular). |
| 10 | **Per-Feature Migration (P10)** — Auth → Home → Doctor → Booking → Profile → Loc → Settings → Onboarding | ADR 014 §9.3 | Butuh widget Layer 3-9 siap. Estimasi 1 sprint per 2-3 fitur. |
| 11 | **Pubspec Cleanup (P11)** — hapus `flex_color_scheme`, hapus `DefaultMaterialLocalizations.delegate`, hapus `uses-material-design` | ADR 014 §9.2 P11, Q4 | Butuh semua fitur migrated (P10 selesai). |
| 12 | **Legacy Deprecation (P12)** — `@Deprecated` annotation di `lib/widgets/`, linter warning, hapus total | ADR 014 §9.2 P12, Q7 | Butuh P11 selesai + 1 sprint stabil. |
| 13 | **Domain Value Object Standardization (ADR 016)** — `AppTimeOfDay`, `AppDate`, `AppDateTime`, hapus `TimeOfDay` Material | ADR 016 (TBD), Q5 | Bisa paralel dengan C2+ (independent dari UI framework). |
| 14 | **Custom Lint Rules (ADR 018)** — `avoid_material_import`, `no_cupertino_import`, `layer_dependency_check` | ADR 018 (TBD) | Butuh custom_lint package + Layer 1+2 siap → C1 selesai → setup di C6. |
| 15 | **Dark Mode Strategy (ADR 020)** — `AppTheme.dark` dipakai di `MaterialApp`/`HPApp` | ADR 020 (TBD) | Bisa di C7 setelah `HPApp` siap (C5). |
| 16 | **Localization & i18n (ADR 021)** — `AppLocalizations`, multi-locale support, `DefaultMaterialLocalizations` stub di `HPApp` | ADR 021 (TBD) | Butuh `HPApp` siap (C5) + plugin audit selesai. |
| 17 | **Accessibility Audit (ADR 022)** — Semantics, FocusTraversal, screen reader untuk semua `HP*` widget | ADR 022 (TBD) | Butuh widget Layer 3-9 siap (C5). |
| 18 | **Widget test untuk framework widget** — `HPButton`, `HPTextField`, dll dengan golden test | Sprint B2 / C2+ | Butuh widget Layer 3+ siap. |
| 19 | **Visual regression test (golden file)** untuk `HP*` widget | — | v2.0. Butuh baseline image comparison. |
| 20 | **`AppIcons` registry → `AppIconTheme` integration** | — | Saat ini `AppIcons` static const Iconsax. Migrasi ke `AppIconTheme.colorResolver(BuildContext, Color?)` lebih deep — bisa di C2 bersama Layer 3. |

---

## 10. Migration Strategy — Token Port

### 10.1 Source of Truth Audit (T1)

T1 sprint audit memetakan SEMUA token value yang akan di-port. Output: `docs/audits/sprint_c1_audit.md` dengan tabel:

| Token Category | Existing Source | New Class | Value Source |
|---|---|---|---|
| Primary color | `AppTheme.primary` | `AppColorScheme.primary` | `Color(0xff1C2A3A)` |
| Grey scale | `AppTheme.grey50..900` | `AppColorScheme.grey50..900` | hex dari existing |
| Status colors | `AppTheme.statusPendingBg/Text` dll | `AppColorScheme.statusPendingBg/Text` | hex dari existing |
| Headline | `AppTextTheme.headlineLarge` | `AppTextStyleSet.headlineLarge` | `_baseInter.copyWith(fontSize: 20, fontWeight: bold)` |
| Body | `AppTextTheme.bodyMedium` | `AppTextStyleSet.bodyMedium` | `_baseInter.copyWith(fontSize: 16, fontWeight: w600)` |
| Spacing sm | `EdgeInsets.symmetric(horizontal: 16)` (grep count) | `AppSpacing.lg = 16` | audit + define |
| Radius md | `BorderRadius.circular(8)` (grep count) | `AppRadius.md = Radius.circular(8)` | audit + define |
| Shadow sm | `BoxShadow(blurRadius: 10, ...)` (grep count) | `AppShadow.sm` | audit + define |
| ... | ... | ... | ... |

### 10.2 Port Order (Bottom-Up)

Migrasi token dari paling dasar ke paling aggregate:

1. **AppSpacing**, **AppRadius**, **AppBorder** (basic numeric, no dependency) → T5–T7
2. **AppShadow** (depends on Color constant) → T8
3. **AppMotion** (Duration + Curve, no dependency) → T9
4. **AppIconTheme** (size + Color resolver, depends on AppColorScheme) → T10
5. **AppColorScheme** (Color const, depends on no token) → T11
6. **AppTextStyleSet** (TextStyle, depends on `TextStyle` from dart:ui) → T12
7. **AppComponentTheme** (depends on basic tokens) → T13
8. **AppThemeData** (aggregate, depends on all above) → T14
9. **AppThemeScope** (depends on AppThemeData) → T15

### 10.3 Backward Compat Refactor Pattern (T16–T17)

**Step 1: Preserve private const fields (untuk const context)**

```dart
abstract final class AppTheme {
  // Private const — preserve untuk const context call site
  static const Color _primaryConst = Color(0xff1C2A3A);
  static const Color _onPrimaryConst = Color(0xFFFFFFFF);
  static const Color _whiteConst = Color(0xFFFFFFFF);
  // ... 22 more const Color fields ...

  // Public getter — facade delegating
  static Color get primary => _primaryConst;
  static Color get onPrimary => _onPrimaryConst;
  static Color get white => _whiteConst;
  // ... 22 more getters ...
}
```

**Step 2: Test const context preservation**

```dart
// Test di T18a atau integration test
const textStyle = TextStyle(color: AppTheme.primary); // MUST compile
expect(textStyle.color, const Color(0xff1C2A3A));
```

**Step 3: Untuk `AppTextTheme.textTheme` (Material TextTheme), deprecate**

```dart
abstract final class AppTextTheme {
  // ... static getter untuk bodyMedium dll ...

  @Deprecated('Use AppThemeData.light().textStyles — will be removed in P11')
  static TextTheme get textTheme => TextTheme(
    headlineLarge: headlineLarge,
    // ... 8 more ...
  );
}
```

### 10.4 Visual Parity Verification (T22)

**Pre-C1 baseline (T1 audit):**
- `docs/audits/sprint_c1_visual_baseline_home.png` — screenshot HomePage
- `docs/audits/sprint_c1_visual_baseline_login.png` — screenshot LoginPage
- `docs/audits/sprint_c1_visual_baseline_doctor.png` — screenshot DoctorSearchPage

**Post-C1 verification (T22):**
- `docs/audits/sprint_c1_visual_after_home.png`
- `docs/audits/sprint_c1_visual_after_login.png`
- `docs/audits/sprint_c1_visual_after_doctor.png`

**Diff check:** manual side-by-side. Tools opsional: ImageMagick `compare -metric AE baseline.png after.png diff.png`.

**Expected diff: 0 pixel** (karena facade returning identical value).

---

## 11. Sprint Ceremonies

### 11.1 Daily Standup (15 menit, 09:00 WIB)

Format: Kemarin / Hari ini / Blockers. Asinkron via Slack/Discord (tim kecil).

### 11.2 Mid-Sprint Check (Day 3 EOD)

Cek progress:
- Pool A selesai 100%? (kritis — type aliases ringan tapi harus siap sebelum Pool B)
- Pool B selesai ≥ 50%? (basic token = fondasi untuk Pool C/D)
- Jika Pool B < 30% di Day 3 → potong scope Pool C/D (skip `AppComponentTheme` defer ke C2, atau skip visual parity T22).

### 11.3 Sprint Review (Day 5, 14:00 WIB)

Demo:
- `lib/framework/` structure — 12 file baru (11 token + 1 foundation)
- `AppThemeData.light().colorScheme.primary` di DartPad — return `Color(0xff1C2A3A)` (sama dengan `AppTheme.primary`)
- `flutter analyze` 0 issues
- `flutter test` exit 0 — 320 B1 + 15 C1 tests
- Visual parity screenshot 3 page (baseline vs after — 0 diff)
- `AGENTS.md` section baru + `sprint_roadmap.md` Sprint C1 row

### 11.4 Sprint Retrospective (Day 5, 15:30 WIB)

Format: What went well / What didn't / Action items.

**Prediksi retrospective:**
- What went well: 22 jam sprint ringan, additive-only, zero regression. Foundation + 11 token class siap.
- What didn't: mungkin visual parity manual check makan waktu. Mungkin `const context` preservation tricky di T16.
- Action items: Sprint C2 bisa mulai dengan aman (Layer 3 widget).

### 11.5 Sprint C2 Planning (Day 5, 16:30 WIB)

Input: Sprint C1 DoD checklist + visual parity verified.
Output: Sprint C2 backlog — `HP*` widget Layer 3 (Primitives) + Layer 4 (Interaction) per ADR 014 §9.2 P2+P3.

---

## 12. Score Card Template

### Sprint C1 Self-Score (akan diisi Day 5)

| Aspek | Target | Actual | Verdict |
|---|---|---|---|
| **Pool 0 selesai** | 2/2 (T1, T2) | ?/2 | 🟢/🟡/🔴 |
| **Pool A selesai** | Foundation + test (T3, T4, T4a-d) | ?/5 | 🟢/🟡/🔴 |
| **Pool B selesai** | 6 basic token + test (T5–T10b) | ?/13 | 🟢/🟡/🔴 |
| **Pool C selesai** | ColorScheme + TextStyleSet (T11–T12b) | ?/5 | 🟢/🟡/🔴 |
| **Pool D selesai** | Component + Data + Scope (T13–T15b) | ?/5 | 🟢/🟡/🔴 |
| **Pool E selesai** | Facade refactor (T16–T18a) | ?/4 | 🟢/🟡/🔴 |
| **Pool F selesai** | Root prep + docs (T19–T21a) | ?/4 | 🟢/🟡/🔴 |
| **Pool G selesai** | Closing (T22–T26a) | ?/6 | 🟢/🟡/🔴 |
| **Total task** | ~26 task + 12 commit | ? | 🟢/🟡/🔴 |
| **Token class count** | 11 (Spacing, Radius, Border, Shadow, Motion, IconTheme, ColorScheme, TextStyleSet, ComponentTheme, ThemeData, ThemeScope) | ?/11 | 🟢/🟡/🔴 |
| **Test file baru** | ~12 (1 per token class + 1 foundation) | ?/12 | 🟢/🟡/🔴 |
| **Test cases baru** | ~15 | ? | 🟢/🟡/🔴 |
| **B1 tests masih pass** | 320/320 | ?/320 | 🟢/🟡/🔴 |
| **flutter analyze** | 0 issues | ? | 🟢/🟡/🔴 |
| **flutter test** | 0 failures | ? | 🟢/🟡/🔴 |
| **flutter build apk** | sukses | ? | 🟢/🟡/🔴 |
| **Visual parity** | 3 page no diff | ?/3 | 🟢/🟡/🔴 |
| **Call site change** | 0 (zero) | ? | 🟢/🟡/🔴 |
| **Total jam** | ≤ 22 jam | ? jam | 🟢/🟡/🔴 |

### Definition of Success

🟢 **SUCCESS** — Pool 0+A+B+C+D+E+F+G 100% + visual parity 3/3 + call site 0 change + 0 regression B1 tests
🟡 **PARTIAL** — Pool 0+A+B+C+D 100% + Pool E+F+G sebagian + visual parity 2/3 + 0 regression B1 tests
🔴 **FAIL** — Pool A+B < 100% (fondasi token tidak dibangun) ATAU ada regression B1 tests ATAU call site berubah

---

## Lampiran A — File Touch List (Predicted)

### Files Created (C1 = ~13 new files)

```
docs/audits/sprint_c1_audit.md                                         (T1 — new audit doc)
docs/audits/sprint_c1_visual_baseline_home.png                        (T22 — baseline screenshot)
docs/audits/sprint_c1_visual_baseline_login.png                       (T22)
docs/audits/sprint_c1_visual_baseline_doctor.png                      (T22)
docs/audits/sprint_c1_visual_after_home.png                           (T22 — verification)
docs/audits/sprint_c1_visual_after_login.png                          (T22)
docs/audits/sprint_c1_visual_after_doctor.png                         (T22)

lib/framework/hp.dart                                                  (T2 — barrel export)
lib/framework/foundation/app_foundation.dart                           (T3)
lib/framework/theme/app_spacing.dart                                  (T5)
lib/framework/theme/app_radius.dart                                   (T6)
lib/framework/theme/app_border.dart                                   (T7)
lib/framework/theme/app_shadow.dart                                   (T8)
lib/framework/theme/app_motion.dart                                   (T9)
lib/framework/theme/app_icon_theme.dart                               (T10)
lib/framework/theme/app_color_scheme.dart                             (T11)
lib/framework/theme/app_text_style_set.dart                           (T12)
lib/framework/theme/app_component_theme.dart                          (T13)
lib/framework/theme/app_theme_data.dart                               (T14)
lib/framework/theme/app_theme_scope.dart                              (T15)

test/framework/foundation/app_foundation_test.dart                    (T4)
test/framework/theme/app_spacing_test.dart                            (T5a)
test/framework/theme/app_radius_test.dart                             (T6a)
test/framework/theme/app_border_test.dart                              (T7a)
test/framework/theme/app_shadow_test.dart                              (T8a)
test/framework/theme/app_motion_test.dart                              (T9a)
test/framework/theme/app_icon_theme_test.dart                          (T10a)
test/framework/theme/app_color_scheme_test.dart                       (T11a)
test/framework/theme/app_text_style_set_test.dart                     (T12a)
test/framework/theme/app_component_theme_test.dart                    (T13a)
test/framework/theme/app_theme_data_test.dart                         (T14a)
test/framework/theme/app_theme_scope_test.dart                        (T15a)
```

### Files Modified (C1 = 4 modified files)

```
lib/core/theme/app_theme.dart                                          (T16 — facade refactor)
lib/core/theme/app_text_theme.dart                                     (T17 — facade refactor)
lib/main.dart                                                          (T19 — wrap with AppThemeScope)
AGENTS.md                                                              (T20 — add UI Framework section)
docs/progress/sprint_roadmap.md                                        (T21 — add Sprint C1 row)
```

### File Counts

| Kategori | Count |
|---|---:|
| New lib/framework files | 12 (1 barrel + 1 foundation + 10 token + 1 scope) |
| New test/framework files | 12 (1 per lib file) |
| New docs/audits files | 1 audit + 6 screenshot |
| Modified lib files | 2 (app_theme, app_text_theme) + 1 (main.dart) |
| Modified docs files | 2 (AGENTS.md, sprint_roadmap.md) |
| **Total new** | **31** |
| **Total modified** | **5** |
| **Grand total** | **36 file** |

---

## Lampiran B — Token Value Audit (Contoh untuk T1)

> **Catatan:** Nilai final akan didefinisikan di T1 sprint audit. Berikut estimasi placeholder.

### B.1 Spacing (dari grep `EdgeInsets` di seluruh codebase)

| Variant | Value (px) | Sample usage |
|---|:---:|---|
| `xs` | 4 | `SizedBox(height: 4)`, `spacing: 4` di Row/Column |
| `sm` | 8 | `SizedBox(height: 8)`, `EdgeInsets.symmetric(vertical: 8)` |
| `md` | 12 | `EdgeInsets.all(12)`, `spacing: 12` di Card |
| `lg` | 16 | `EdgeInsets.symmetric(horizontal: 16)`, `padding: const EdgeInsets.all(16)` |
| `xl` | 20 | `padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)` |
| `2xl` | 24 | `Padding(padding: const EdgeInsets.fromLTRB(24, 16, 24, 0))` di HomePage |
| `3xl` | 32 | `Padding(padding: const EdgeInsets.all(32))` di LoginPage logo |
| `4xl` | 40 | `Padding(padding: const EdgeInsets.fromLTRB(40, 32, 40, 32))` di OnboardingPage |

### B.2 Radius (dari grep `BorderRadius.circular`)

| Variant | Value (px) | Sample usage |
|---|:---:|---|
| `none` | 0 | `BorderRadius.zero` (rare) |
| `sm` | 4 | — |
| `md` | 8 | `BorderRadius.circular(8)` di `inputDecorationTheme`, `LightOutlineButton` |
| `lg` | 12 | `BorderRadius.circular(12)` di `CardContainer`, `DoctorCard` |
| `xl` | 16 | `BorderRadius.circular(16)` di `AppLoadingDialog`, `AppCustomDialog` |
| `pill` | 9999 | `BorderRadius.circular(42)` di `LightFilledButton` (button pill) |

### B.3 Color (dari `AppTheme` existing — direct port)

| Name | Hex | Existing |
|---|:---:|---|
| `primary` | `0xff1C2A3A` | `AppTheme.primary` |
| `onPrimary` | `0xFFFFFFFF` | `AppTheme.onPrimary` |
| `white` | `0xFFFFFFFF` | `AppTheme.white` |
| `grey50` | `0xFFF9FAFB` | `AppTheme.grey50` |
| ... | ... | ... |

(Semua 25+ color const di-port 1:1.)

### B.4 TextStyle (dari `AppTextTheme` existing — direct port)

| Name | fontSize | fontWeight | fontFamily |
|---|:---:|:---:|---|
| `headlineLarge` | 20 | bold | Inter |
| `headlineMedium` | 18 | bold | Inter |
| `headlineSmall` | 16 | bold | Inter |
| `titleLarge` | 14 | bold | Inter |
| `bodyLarge` | 18 | w400 | Inter |
| `bodyMedium` | 16 | w600 | Inter |
| `bodySmall` | 14 | w400 | Inter |
| `labelLarge` | 14 | w500 | Inter |
| `labelMedium` | 12 | w500 | Poppins |
| `labelSmall` | 12 | w400 | Poppins |

(Semua 9 TextStyle const di-port 1:1.)

---

*Disusun oleh Tech Lead (MiniMax-M3) · Juli 2026 · v1.0*

**Status:** 📋 **PLAN READY — menunggu approval & kick-off setelah Sprint B1 closing**
