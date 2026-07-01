# ADR 014: HealthPalAppBar — Centralized AppBar Component

| Field | Detail |
|---|---|
| **Status** | 🔧 Proposed |
| **Tanggal** | 1 Juli 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | UI (14 page files), widget (new `HealthPalAppBar`), import changes (material.dart → widgets.dart), icon consistency fixes (Icons.arrow_back → AppIcons.arrowBack), AGENTS.md compliance (No Material rule) |
| **Supersedes** | Inline `AppBar(...)` di 14 pages |

---

## 1. Konteks

### 1.1 Audit AppBar — 1 Juli 2026

Audit sistematis terhadap seluruh penggunaan `AppBar` di repository menemukan:

| Metrik | Temuan |
|---|---|
| **Total `AppBar(` usage** | 14 — semuanya inline di `Scaffold.appBar` |
| **SliverAppBar** | 0 |
| **Custom AppBar / PreferredSizeWidget** | 0 |
| **Unique variant patterns** | 7 (Root, Standard, Back Only, With Action, With TabBar, Dynamic Title+Action, Counter Title) |
| **Files importing `material.dart`** | 14/14 🔴 — semua melanggar AGENTS.md "No Material package" rule |
| **Icon inconsistency** | 4 files pakai `Icons.arrow_back` (Material) + 2 files pakai default back button — tidak ada TODO comment per Icon Convention |
| **Duplikasi kode** | 14x definisi `backgroundColor: AppTheme.white`, `elevation: 0`, `centerTitle: true` |

### 1.2 Masalah yang Diselesaikan

| # | Masalah | Akar Masalah |
|---|---------|-------------|
| M1 | **14 duplikasi AppBar config** — setiap page define AppBar sendiri dengan properti yang 90% sama (backgroundColor white, elevation 0, centerTitle true, leading back button, AppIcons.arrowBack) | Tidak ada reusable widget |
| M2 | **AGENTS.md violation** — semua page import `package:flutter/material.dart` hanya untuk AppBar; padahal "No Material package — use raw Flutter widgets only" | Tidak ada alternatif non-Material untuk AppBar |
| M3 | **Icon inconsistency** — 4 files pakai Material `Icons.arrow_back` (booking_detail, book_appointment, doctor_detail, doctor_search) + 2 files pakai default back button, vs 6 files yang sudah pakai `AppIcons.arrowBack` | Tidak ada centralized leading |
| M4 | **Material icon tanpa TODO comment** — semua `Icons.arrow_back` usage tidak punya `// TODO: change to iconsax` per Icon Convention Sprint 2+ | Icon convention tidak teraudit untuk AppBar |
| M5 | **Perubahan style spread** — jika ingin ganti backgroundColor, elevation, atau leading icon, harus edit 14 file | Tidak ada single source of truth |

### 1.3 Kondisi Saat Ini per Page

| No | Page | Import | Leading | Title Icon Convention | backgroundColor | Elevation |
|:---:|------|:------:|:-------:|:---------------------:|:--------------:|:---------:|
| 1 | `create_profile_page.dart` | material | ✅ `AppIcons.arrowBack` | N/A | default | default |
| 2 | `icon_page.dart` | material | default back | N/A | default | default |
| 3 | `booking_detail_page.dart` | material | ❌ `Icons.arrow_back` | N/A | ✅ white | ✅ 0 |
| 4 | `booking_history_page.dart` | material | default back | N/A | ✅ white | ✅ 0 |
| 5 | `book_appointment_page.dart` | material | ❌ `Icons.arrow_back` | N/A | ✅ white | ✅ 0 |
| 6 | `doctor_detail_page.dart` | material | ❌ `Icons.arrow_back` | N/A | ✅ white | ✅ 0 |
| 7 | `doctor_search_page.dart` | material | ❌ `Icons.arrow_back` | N/A | ✅ white | ✅ 0 |
| 8 | `edit_profile_page.dart` | material | ✅ `AppIcons.arrowBack` | N/A | ✅ white | ✅ 0 |
| 9 | `favorite_page.dart` | material | ✅ `AppIcons.arrowBack` | N/A | ✅ white | ✅ 0 |
| 10 | `notification_page.dart` | material | ✅ `AppIcons.arrowBack` | N/A | ✅ white | ✅ 0 |
| 11 | `profile_page.dart` | material | N/A (root) | N/A | ✅ white | ✅ 0 |
| 12 | `help_support_page.dart` | material | ✅ `AppIcons.arrowBack` | N/A | ✅ white | ✅ 0 |
| 13 | `settings_page.dart` | material | N/A (root) | N/A | ✅ white | ✅ 0 |
| 14 | `terms_and_conditions_page.dart` | material | ✅ `AppIcons.arrowBack` | N/A | ✅ white | ✅ 0 |

**Legend:** ❌ = Melanggar Icon Convention, ✅ = Compliant, N/A = Not applicable

---

## 2. Opsi yang Dipertimbangkan

### 2A: Tidak berbuat apa-apa (Status Quo)

Biarkan 14 inline AppBar seperti sekarang.

**Pro:**
- Zero effort
- No regression risk

**Kontra:**
- 🔴 Melanggar AGENTS.md — semua `package:flutter/material.dart` import tetap ada
- 🔴 4 Material `Icons.arrow_back` tanpa TODO tetap ada
- 🔴 Perubahan style (mis. ganti backgroundColor) butuh edit 14 file
- 🔴 No single source of truth

**Verdict:** ❌ **Tidak direkomendasikan** — melanggar aturan project yang sudah disepakati.

### 2B: Buat HealthPalAppBar sebagai StatefulWidget + PreferredSizeWidget (DIUSULKAN)

Buat custom widget `HealthPalAppBar` yang:
- `extends StatelessWidget implements PreferredSizeWidget`
- Import dari `package:flutter/widgets.dart` (BUKAN material.dart)
- Render `Container` dengan height fixed + title + leading + actions + bottom
- Auto-detect leading visibility via `Navigator.canPop(context)`

**Pro:**
- ✅ Single source of truth — 14 file jadi 1 widget
- ✅ AGENTS.md compliance — semua page bisa ganti import ke `widgets.dart`
- ✅ Icon consistency — leading otomatis `AppIcons.arrowBack`
- ✅ Mudah di-maintain — perubahan style di 1 tempat
- ✅ StatelessWidget — zero state management overhead

**Kontra:**
- ❌ Perlu migrasi 14 file (tapi mechanical — AppBar block diganti 1 baris)
- ❌ `PreferredSizeWidget` butuh `preferredSize` getter — hardcode height
- ❌ `Navigator.canPop(context)` butuh `BuildContext` — harus di build method

**Verdict:** ✅ **Diusulkan**

### 2C: Buat Extension Method on Scaffold

Buat extension method `Scaffold.withAppBar(...)` yang wrap AppBar config default.

**Pro:**
- Minimal code change — cukup tambah `.withAppBar(...)` di existing Scaffold

**Kontra:**
- 🔴 Extension method tidak bisa implement `PreferredSizeWidget` — tetap butuh AppBar di balik layar
- 🔴 Tidak solve AGENTS.md violation — masih butuh `material.dart` import untuk AppBar
- 🔴 Lebih kompleks secara konsep (extension method vs widget)

**Verdict:** ❌ Tidak direkomendasikan — tidak solve root problem.

---

## 3. Keputusan

### 3.1 Arsitektur

✅ **Pilih Opsi 2B: `HealthPalAppBar` sebagai `StatelessWidget implements PreferredSizeWidget`**

```dart
// lib/widgets/app_bar/health_pal_app_bar.dart

import 'package:flutter/widgets.dart';

// TIDAK import 'package:flutter/material.dart' — AGENTS.md compliance.

class HealthPalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HealthPalAppBar({...});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Implementasi:
    // - Container dengan backgroundColor + elevation (via BoxShadow)
    // - Row: [leading, Expanded(title), actions]
    // - bottom: Optional preferredSize widget (TabBar)
    // - height: kToolbarHeight + (bottom?.preferredSize.height ?? 0)
  }
}
```

### 3.2 Preferred Size

✅ **Fixed height = `kToolbarHeight` (56.0) + optional bottom height**

- `kToolbarHeight` = 56.0 (konstanta dari Flutter — nilai ini konsisten dengan Material AppBar)
- Jika ada `bottom:` widget, total height = 56.0 + `bottom.preferredSize.height`
- Tidak perlu configurable per page — semua AppBar saat ini pakai ukuran default

**Rationale:**
- Semua 14 page saat ini pakai default Material AppBar height = 56.0
- `booking_history_page.dart` punya `TabBar` bottom — height = 56.0 + TabBar preferredSize
- Konsisten dengan existing layout (tidak ada page yang custom height)

### 3.3 Leading (Back Button) Behavior

✅ **Auto-detect via `Navigator.canPop(context)`**

```dart
Widget? _buildLeading(BuildContext context) {
  if (!showBack) return null;
  if (!Navigator.canPop(context)) return const SizedBox.shrink();
  return IconButton(
    onPressed: () => Navigator.of(context).pop(),
    icon: const Icon(AppIcons.arrowBack, size: 24),
  );
}
```

**Rationale:**
- Root/tab pages (Profile, Settings) cukup set `showBack: false` — explicit, no magic
- Non-root pages: auto-detect via `Navigator.canPop()` — jadi jika page dipanggil dari modal/navigator stack, back button muncul otomatis
- Fallback ke `SizedBox.shrink()` jika tidak bisa pop — layout tetap rapi
- Icon: `AppIcons.arrowBack` (bukan `Icons.arrow_back`) — konsisten dengan Icon Convention
- Warna: `AppTheme.grey900` — sama dengan mayoritas existing pages

### 3.4 AGENTS.md Compliance Migration

Setelah `HealthPalAppBar` diimplementasi, semua 14 page akan:

1. Ganti `import 'package:flutter/material.dart'` → `import 'package:flutter/widgets.dart'`
2. Ganti `AppBar(...)` inline → `HealthPalAppBar(...)` component
3. **Jika masih ada widget lain yang butuh Material** (Scaffold, dll) — tetap import material.
   **Jika hanya AppBar yang butuh Material** — boleh ganti ke widgets.dart saja.

> **Catatan:** `Scaffold` berasal dari `package:flutter/material.dart`. Jadi page yang pakai `Scaffold` WAJIB import `material.dart`. Keputusan ini tidak bisa dihindari karena `Scaffold` adalah Material widget.
>
> **Alternatif:** Jika ingin menghilangkan material.dart sepenuhnya, perlu ganti `Scaffold` dengan `Column`/`CustomScrollView` — terlalu besar untuk scope ADR ini. Untuk saat ini, **target minimal: AppBar widget TIDAK bergantung pada material.dart**. Page-level import bisa tetap material.dart jika masih butuh Scaffold/Button/etc.

### 3.5 Icon Consistency Enforcement

- `HealthPalAppBar` **WAJIB** pakai `AppIcons.arrowBack` sebagai default leading
- Action icon di `actions:` diserahkan ke page (tidak dipaksa)
- `AppIcons` sudah include ikon yang relevan: `arrowBack`, `close`, `search`, `share`, `favorite` (via `Iconsax.heart` atau Material fallback)

### 3.6 Special Case Handling

| Special Case | Mekanisme | Contoh |
|---|---|---|
| **TabBar (booking_history)** | `bottom:` parameter → `HealthPalAppBar(bottom: TabBar(...))` | Page pass TabBar sebagai bottom. HealthPalAppBar render di bawah Container |
| **Dynamic title + badge (notification)** | `title:` parameter → widget | Page build `Row(text + badge)` dan pass sebagai `title:` |
| **Conditional action (notification)** | `actions:` parameter → list widget | Page pass `BlocBuilder` sebagai action |
| **Favorite toggle (doctor_detail)** | `actions:` parameter → list widget | Page pass `IconButton` dengan toggle favorite |
| **Counter title (icon_page)** | `title:` parameter → widget | Page pass `Text('App Icons (${icons.length})')` |
| **No title (create_profile)** | `title:` → null / `showBack: true` saja | Title baris dikosongkan |

---

## 4. Konsekuensi

### Positif

1. **14 → 1** — maintenance surface area berkurang dari 14 file ke 1 widget
2. **AGENTS.md compliance sebagian** — HealthPalAppBar sendiri pure widgets.dart (tidak import material). Page-level import masih perlu material.dart untuk Scaffold.
3. **Icon consistency terjamin** — semua back button otomatis `AppIcons.arrowBack`
4. **Perubahan style cepat** — ganti backgroundColor/elevation/leading icon di 1 tempat
5. **Back button behavior terstandarisasi** — auto-detect + fallback
6. **Mudah ditambah variant baru** — cukup tambah parameter di HealthPalAppBar

### Negatif

1. **Migrasi 14 page** — butuh ~2-3 jam untuk mechanical replacement
2. **`icon_page.dart`** — dev tool, mungkin tidak perlu dimigrasi (bisa skip)
3. **Regression risk** — setiap page yang diubah appBar-nya perlu manual test
4. **`Navigator.canPop()`** — behavior bisa berbeda dengan explicit `onPressed: () => context.pop()` yang dipakai beberapa page saat ini. Perlu verifikasi tidak ada page yang butuh `context.pop()` vs `Navigator.of(context).pop()`.
5. **Scaffold tetap dari material.dart** — tidak bisa 100% AGENTS.md compliant tanpa ganti Scaffold juga (out of scope ADR ini)

### Tabel Risiko

| Risiko | Probabilitas | Dampak | Mitigasi |
|--------|:-----------:|:------:|----------|
| R1: Navigator.canPop() berbeda dengan explicit context.pop() di 1-2 page | 🟢 Low | 🟡 Medium | Smoke test setiap page setelah migrasi. Fallback: `showBack` explicit parameter override |
| R2: TabBar bottom height mismatch | 🟡 Medium | 🟡 Medium | Test booking_history_page.dart — pastikan TabBar masih muncul + scrollable |
| R3: icon_page.dart (dev tool) tidak perlu migrasi | 🟢 Low | 🟢 Low | Skip icon_page dari migration scope |
| R4: Page masih import material.dart untuk widget lain (Scaffold, Button, dll) | 🟡 High | 🟢 Low | Change `material.dart` → `widgets.dart` + add import untuk widget spesifik yang dibutuhkan (jika ada). Atau biarkan `material.dart` jika banyak widget Material lain. |

---

## 5. Alternatif yang Tidak Dipilih

| Alternatif | Alasan Tidak Dipilih |
|---|---|
| **Wrapper widget yang wrap Material AppBar** (delegasi) | Tidak solve AGENTS.md — masih bergantung pada Material AppBar internal |
| **Gunakan `CupertinoNavigationBar`** | Tidak konsisten dengan theme Android-first |
| **Build zero-scaffold architecture** (ganti Scaffold dengan Column/Stack) | Terlalu besar — akan refactor 50+ page. Scope creep. |
| **Code generation** untuk AppBar | Overkill — component sederhana, tidak perlu codegen |

---

## 6. Implementation Plan

| Step | Task | File Target | Estimasi | Dependencies |
|:----:|------|-------------|:--------:|-------------|
| 1 | Create `HealthPalAppBar` widget | `lib/widgets/app_bar/health_pal_app_bar.dart` (new) | 1h | None |
| 2 | Migrate root/tab pages (profile, settings) — `showBack: false` | 2 files | 0.3h | Step 1 |
| 3 | Migrate standard pages (edit_profile, favorite, help, terms) — `showBack: true` | 4 files | 0.4h | Step 1 |
| 4 | Migrate booking pages (detail, history, book_appointment) — + fix `Icons.arrow_back` | 3 files | 0.4h | Step 1 |
| 5 | Migrate doctor pages (detail, search) — + fix `Icons.arrow_back` + favorite action | 2 files | 0.3h | Step 1 |
| 6 | Migrate auth pages (create_profile, icon_page) — skip icon_page | 1 file | 0.2h | Step 1 |
| 7 | Migrate notification_page (dynamic title + action) | 1 file | 0.3h | Step 1 |
| 8 | Fix imports: material.dart → widgets.dart (if applicable) | 14 files | 0.5h | Step 2-7 |
| 9 | Add TODO comments untuk action icons yang masih Material fallback | 2 files (doctor, notification) | 0.1h | Step 5, 7 |
| 10 | `flutter analyze` + fix issues | — | 0.2h | Step 9 |
| 11 | Smoke test 14 pages (visual + back button behavior) | — | 0.5h | Step 10 |

**Total estimasi: ~4.2 jam**

---

## 7. Kriteria Penerimaan

- [ ] `HealthPalAppBar` di `lib/widgets/app_bar/` — pure `widgets.dart` import (tidak `material.dart`)
- [ ] Implement `PreferredSizeWidget` dengan `preferredSize` yang benar (56.0 + optional bottom)
- [ ] Back button default: `AppIcons.arrowBack` (bukan `Icons.arrow_back`)
- [ ] `showBack: false` → leading hidden (untuk root pages)
- [ ] `Navigator.canPop()` auto-detect untuk leading visibility
- [ ] Semua 14 page migrated ke `HealthPalAppBar` (kecuali icon_page — dev tool)
- [ ] 4 files dengan `Icons.arrow_back` diganti ke `AppIcons.arrowBack` + TODO comment
- [ ] `flutter analyze` 0 issues
- [ ] Smoke test: back button behavior di setiap page konsisten

---

## 8. Referensi

- Wireframe: `docs/wireframe/23-health-pal-app-bar.md` — v1.0 (new)
- ADR 001: Skeletonizer — loading standard (referensi)
- ADR 008: Standard Placeholder Widgets (referensi untuk reusable widget pattern)
- ADR 012: Appointment Card Redesign (referensi untuk komponen library pattern)
- AGENTS.md §"Icon Convention" — TODO comment requirement
- AGENTS.md §"No Material package" — project rule
- Existing AppBar audit: `docs/todo/sprint-b1-unit-testing/` — scan results
- `lib/core/theme/app_icons.dart` — icon yang tersedia
- `lib/core/theme/app_theme.dart` — warna yang tersedia
- Existing AppBar di 14 page files (lihat §1.3)

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi Accepted setelah disetujui, menjadi Superseded jika ADR baru menggantikan keputusan ini.*
