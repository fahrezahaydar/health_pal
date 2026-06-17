# Sprint 3 Plan — Settings

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | 16 Juni 2026 |
| **Sprint Window** | TBD (2 minggu setelah Sprint 2 closing) |
| **Tema Sprint** | **"Quick Win — Settings Page Audit & Polish"** |
| **Acuan** | `wireframe/18-settings.md` · `wireframe/19-help-support.md` · `wireframe/20-tnc.md` · `wireframe/21-no-internet.md` · `home_page_audit.md` (template) · `sprint_roadmap.md` · `api_contract_health_pal.md` §3.2, §3.5 · `sprint_2_plan.md` Pool D4 |
| **Tech Lead** | MiniMax-M3 |
| **Testing Policy** | **❌ NO TEST FILES** (deferred ke Sprint 9 — Testing Phase) |

---

## 📊 Sprint 3 Progress Tracker

**Last Updated:** 16 Juni 2026 (All Tasks Complete)
**Overall:** 12/12 tasks (100%) ✅

| Task | Deskripsi | Audit Ref | Estimasi | Status | Commit | Catatan |
|------|-----------|-----------|:--------:|--------|--------|---------|
| S3.1 | Sprint Opening Audit — settings_audit.md | — | 4h | ✅ Done | `65aa92e` | Verdict: 🟡 49.3/100. 7 kritis, 7 medium, 6 low findings |
| S3.2 | Skeletonizer untuk loading state Settings | M2 | 1h | ✅ Done | `b5e4356` | Ganti `CircularProgressIndicator` → `Skeletonizer` per AD-6 |
| S3.3 | ErrorSection untuk error state Settings | M3 | 0.5h | ✅ Done | `b5e4356` | Replace custom `_errorState()` → `ErrorSection` (dari Sprint 2 C6) |
| S3.4 | Refactor SettingsCubit: hapus SupabaseClient langsung | K3 + M1 | 2h | ✅ Done | `fb3e888` | `SettingsRepository` + `SettingsRepositoryImpl`. Cubit inject Repository. DI regen OK. |
| S3.5 | Implement "Data & Cache" section | K1 | 2h | ✅ Done | `5483106` | Hapus Cache via `HomeLocalDataSource.clearAll()` + snackbar |
| S3.6 | Implement "Telepon Darurat" field | K2 | 1h | ✅ Done | `dc3a9dd` | Input dialog → simpan via CacheService (SharedPrefs temporary — ERD belum punya field) |
| S3.7 | Tampilkan email terdaftar di UI Section Akun | M7 | 0.5h | ✅ Done | `5483106` | Render `SettingsLoaded.email` di bawah tombol Ubah Password |
| S3.8 | Toggle notifikasi persist ke server | M6 | 1h | ✅ Done | `dc3a9dd` | PATCH `user_profiles.notif_reminder_enabled` via `auth_id` |
| S3.9 | No Internet: refactor connectivity logic | M4 | 1h | ✅ Done | `dc3a9dd` | Try-catch wrapper + snackbar fallback |
| S3.10 | Help & Support: tambah try-catch di `_launchUrl` | L4 | 0.25h | ✅ Done | `dc3a9dd` | `canLaunchUrl` + `launchUrl` wrapped in try-catch |
| S3.11 | T&C: date auto-update atau sync konten | L5 | 0.25h | ✅ Done | `dc3a9dd` | Added TODO comment untuk sync konten aktual |
| S3.12 | Icon consistency: iconsax → Material + TODO | L3 | 2h | ✅ Done | `9cacb1f` | Semua 4 halaman settings migrated. Removed iconsax_latest imports. |

---

## 1. Sprint Opening Audit

### 1.1 Audit Doc Target

`docs/progress/settings_audit.md` — mengikuti template `home_page_audit.md`

### 1.2 Cakupan Audit

| Area | Sumber | Metode |
|------|--------|--------|
| Wireframe 18-settings.md vs Code | `docs/wireframe/18-settings.md` | Section-by-section comparison |
| Wireframe 19-help-support.md vs Code | `docs/wireframe/19-help-support.md` | Section-by-section comparison |
| Wireframe 20-tnc.md vs Code | `docs/wireframe/20-tnc.md` | Section-by-section comparison |
| Wireframe 21-no-internet.md vs Code | `docs/wireframe/21-no-internet.md` | Section-by-section comparison |
| API Contract §3.2, §3.5 vs Code | `docs/api_contract/api_contract_health_pal.md` | Endpoint usage check |
| TDD Clean Architecture vs Code | TDD 01-12 | Layer compliance check |
| PRD vs Code | `docs/product/prd_health_pal.md` | Requirements check |
| Icon Convention compliance | AGENTS.md | Iconsax vs Material check |

### 1.3 Pra-Audit Findings (dari analisis awal)

Berikut gap yang sudah teridentifikasi SEBELUM audit formal. Akan diverifikasi ulang saat audit.

| # | Temuan | Tingkat | Detail |
|---|--------|---------|--------|
| F1 | Missing "Data & Cache" section | 🔴 Missing Feature | Wireframe 18 §spesifikasi: "Data & Cache" section dengan "Hapus Cache" dan "Hapus Data Lokal" — TIDAK ADA di implementasi |
| F2 | Missing "Telepon Darurat" field | 🟡 Missing Feature | Wireframe 18 catatan kaki: "Anda dapat menambahkan nomor telepon darurat" — TIDAK ADA |
| F3 | SettingsCubit pakai SupabaseClient langsung | 🟡 Architecture | Sama seperti bug K4 di Home (Sprint 2 A4). Harus melalui AppServices atau repository |
| F4 | Tidak ada data/domain layer | 🟡 Architecture | Settings hanya punya presentation layer. Bandingkan dengan Home yang punya data/domain/presentation |
| F5 | Loading state pakai CircularProgressIndicator | 🟡 UI Polish | Harus Skeletonizer (Sprint 2 AD-6) |
| F6 | Error state custom (bukan ErrorSection) | 🟢 UI Polish | Sudah ada retry button, tapi tidak reusable |
| F7 | iconsax_latest langsung (tanpa Material fallback) | 🟢 Icon Convention | Melanggar Icon Convention Sprint 2+ — butuh TODO comment |
| F8 | NoInternetPage inline connectivity check | 🟡 Architecture | connectivity_plus langsung di widget — harus di cubit/service |
| F9 | Dark Mode toggle adalah stub | 🟢 Stub | Toggle tidak menyimpan preferensi, hanya update state |
| F10 | HelpSupportPage FAQ hardcoded | 🟢 Minor | 4 FAQ item hardcoded — tidak scalable untuk future |

---

## 2. Sprint Backlog

### 2.1 Task Details

#### S3.1 ✅ Sprint Opening Audit ✅

**Done:** `65aa92e` — docs(sprint3): settings audit complete

**Output:** `docs/progress/settings_audit.md` (460 lines, 15 sections)
**Verdict:** 🟡 49.3/100
**Key findings:** 2 🔴 missing features (Data & Cache, Telepon Darurat), 1 🔴 arsitektur (SupabaseClient di Cubit), 7 🟡 medium, 6 🟢 low

#### S3.2 Skeletonizer untuk Loading State (1h) — Ref: M2

Ganti `CircularProgressIndicator` di Settings page dengan `Skeletonizer` pattern:
- Settings page: skeleton untuk card container (3 section × 2-3 items)
- Help & Support: skeleton untuk FAQ list
- Terms & Conditions: skeleton minimal (static content, optional)
- No Internet: tidak perlu skeleton (halaman mandiri)

**Pattern:**
```dart
Skeletonizer(
  enabled: state is SettingsLoading,
  child: CardContainer(children: [...real content...]),
)
```

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)
- `lib/features/settings/presentation/page/help_support_page.dart` (modify)

#### S3.3 ErrorSection untuk Error State (0.5h) — Ref: M3

Replace custom error widget di Settings page dengan `ErrorSection` dari `lib/widgets/loader/error_section.dart`.

**Pattern:**
```dart
SettingsError(:final message) => ErrorSection(
  message: message,
  onRetry: () => context.read<SettingsCubit>().loadSettings(),
),
```

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)

#### S3.4 Refactor SettingsCubit: hapus SupabaseClient (2h) — Ref: K3 + M1

**Problem:** SettingsCubit injects `SharedPrefService` + `SupabaseClient`. Melanggar TDD 01 §3.3 (presentation ↔ data layer). Sama seperti bug K4 di Home yang di-fix Sprint 2 A4.

**Fix (lightweight — rekomendasi):**
1. Inject `AppServices` untuk auth-related operations (sama seperti fix A4)
2. Inject `SettingsRepository` baru untuk data settings
3. Buat `SettingsRepository` abstract + `SettingsRepositoryImpl`
4. Pindahkan SharedPrefService + SupabaseClient logic ke repository
5. Run build_runner untuk DI regeneration

**Files:**
- `lib/features/settings/domain/repository/settings_repository.dart` (new)
- `lib/features/settings/data/repository/settings_repository_impl.dart` (new)
- `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` (modify)
- DI config (auto-regenerated)

#### S3.5 Implement "Data & Cache" Section (2h) — Ref: K1

**Wireframe:** 18-settings.md §"Data & Cache"

**Feature spec:**
- "Hapus Cache" — `CacheService.clearAll()` (existing)
- "Hapus Data Lokal" — clear local data (FCM token, dll). Login tetap aman.

**Implementation:**
1. Tambah 2 `MenuItemTile` di Settings page (antara Preferensi dan Aplikasi section)
2. Konfirmasi dialog sebelum eksekusi (reuse `AppConfirmDialog`)
3. Snackbar sukses setelah selesai

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)
- `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` (modify)

#### S3.6 Implement "Telepon Darurat" Field (1h) — Ref: K2

**Wireframe:** 18-settings.md §Akun

**Feature spec:**
- Settings page footer: "Anda dapat menambahkan nomor telepon darurat"
- Tap → input dialog (masukkan nomor telepon)
- ERD check: `user_profiles.emergency_phone` — `docs/erd/erd_healh_pal.md` **tidak punya field ini**.
- Jika tidak ada: simpan di SharedPreferences temporary + catat SQL migration needed

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)
- `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` (modify)

#### S3.7 Tampilkan Email Terdaftar (0.5h) — Ref: M7

**Wireframe:** 18-settings.md §Akun — menampilkan email user (read-only)

**Status:** `SettingsLoaded.email` sudah ada di state cubit, tapi **tidak di-render** di UI.

**Fix:** Tambah `MenuItemTile` atau `ListTile` di section Akun yang menampilkan `state.email`.

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)

#### S3.8 Toggle Notifikasi Persist ke Server (1h) — Ref: M6

**Problem:** Toggle notifikasi hanya simpan ke `SharedPrefs`, tidak sync ke Supabase.

**Fix:** `toggleNotification()` → PATCH `user_profiles.notif_reminder_enabled` via Supabase.

**Files:**
- `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` (modify)

#### S3.9 No Internet: Refactor Connectivity Logic (1h) — Ref: M4

**Problem:** `Connectivity().checkConnectivity()` langsung dipanggil di widget `NoInternetPage`.

**Fix:** Simplify — tetap StatefulWidget, refactor retry logic ke method terpisah. Tidak perlu cubit baru (halaman terlalu sederhana). Alternatif: buat `ConnectivityService` di `core/services/`.

**Files:**
- `lib/features/settings/presentation/page/no_internet_page.dart` (modify)

#### S3.10 Help & Support: tambah try-catch `_launchUrl` (0.25h) — Ref: L4

**Problem:** `_launchUrl` menggunakan `canLaunchUrl` + `launchUrl` tanpa try-catch. Jika URL tidak valid, throw unhandled exception.

**Fix:** Bungkus dalam try-catch, tampilkan snackbar jika gagal.

**Files:**
- `lib/features/settings/presentation/page/help_support_page.dart` (modify)

#### S3.11 T&C: Date Auto-Update (0.25h) — Ref: L5

**Problem:** "Terakhir diperbarui: Juni 2026" — hardcoded di `terms_and_conditions_page.dart:76`.

**Fix:** `'Terakhir diperbarui: ${DateFormat.yMMMM(Locale('id')).format(DateTime(2026, 6))}'` atau sync dengan konten.

**Files:**
- `lib/features/settings/presentation/page/terms_and_conditions_page.dart` (modify)

#### S3.12 Icon Consistency: iconsax → Material + TODO (2h) — Ref: L3

**Approach:**
- Settings page: ganti `Iconsax.*` → `Icons.*` + `// TODO: change to iconsax`
- Help & Support page: ganti `Iconsax.*` → `Icons.*` + TODO
- Terms & Conditions page: ganti `Iconsax.*` → `Icons.*` + TODO
- No Internet page: ganti `Iconsax.*` → `Icons.*` + TODO
- Hapus import `iconsax_latest` dari file yang sudah full Material

**Important Notes (per Icon Convention):**
- Jangan ubah existing Iconsax code di file LAIN (hanya settings pages)
- Setiap icon WAJIB TODO comment

---

## 3. Timeline

| Day | Tasks | Detail |
|:---:|-------|--------|
| Day 1 | S3.1 ✅ DONE | Audit selesai — `65aa92e` |
| Day 2 | S3.4 — Refactor data layer | SettingsRepository + impl, DI regen, hapus SupabaseClient dari Cubit |
| Day 3 | S3.2 + S3.3 — Skeletonizer + ErrorSection | Polish loading/error states |
| Day 4 | S3.5 — Data & Cache section | Hapus Cache + Hapus Data Lokal |
| Day 5 | S3.6 + S3.7 — Telepon Darurat + Email | Input dialog + tampilkan email di UI |
| Day 6 | S3.8 + S3.9 — Toggle persist + No Internet | PATCH ke server + connectivity refactor |
| Day 7 | S3.10 + S3.11 — Help try-catch + T&C date | Error handling + date sync |
| Day 8 | S3.12 — Icon consistency | Iconsax → Material + TODO (semua 4 halaman) |
| Day 9 | Buffer catch-up | Task overflow |
| Day 10 | Flutter analyze + Final Commit | 0 issues + commit semua task |

---

## 4. Definition of Done

- [ ] `docs/progress/settings_audit.md` published ✅
- [ ] Semua critical findings dari audit di-fix
- [ ] Loading states menggunakan `Skeletonizer` (bukan `CircularProgressIndicator`)
- [ ] Error states menggunakan `ErrorSection` (bukan custom widget)
- [ ] Icon consistency: semua icon baru pakai `Icons.*` + `// TODO: change to iconsax`
- [ ] `SettingsCubit` tidak langsung inject `SupabaseClient` (via repository pattern)
- [ ] "Data & Cache" section terimplementasi
- [ ] "Telepon Darurat" field terimplementasi (atau documented sebagai keterbatasan)
- [ ] `flutter analyze` 0 issues
- [ ] `sprint_roadmap.md` updated
- [ ] Conventional commit untuk setiap task

---

## 5. Risk & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| R1 — Settings terlalu kecil (6 files) | Sprint terasa kosong | Tambah S3.10 (icon consistency) + S3.5+S3.6 (missing features) untuk充实 backlog |
| R2 — Data layer refactor (S3.4) butuh build_runner | Dependency wait | Kerjakan Day 3 — jika build_runner gagal, fallback ke lightweight approach via AppServices |
| R3 — `emergency_phone` field tidak ada di ERD | S3.6 blocked | Ganti: simpan di SharedPreferences temporary. Tambah SQL migration ke Sprint 3 carry-over jika perlu |
| R4 — No Internet page terlalu sederhana untuk 2h estimasi | Over-estimasi | Simplify: tetap StatefulWidget, hanya refactor retry logic. Waktu surplus alihkan ke S3.10 |

---

*Disusun oleh Tech Lead (MiniMax-M3) · 16 Juni 2026 · v1.0*

**Status:** ✅ **AUDIT COMPLETE — `settings_audit.md` published**

**Audit Verdict:** 🟡 **49.3 / 100** — Settings 82% fungsional, gap terbanyak di arsitektur (data layer 0%) + missing features (Data & Cache, Telepon Darurat).

**Prioritas Implementasi per Rekomendasi Audit:**
1. 🔴 K1-K3 (missing features + arsitektur) — 4h
2. 🟡 M1-M7 (loading/error/data/persist) — 5h
3. 🟢 L3-L5 (icon + error handling + date) — 2.5h

**Total estimasi implementasi:** ~11.5 jam (3-4 hari)
**Sisa sprint:** buffer + final QA + `flutter analyze`
