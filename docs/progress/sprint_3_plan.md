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

**Last Updated:** 16 Juni 2026 (Sprint 3 Planned)
**Overall:** 0 tasks (0%)

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|---------|--------|--------|---------|
| S3.1 | Sprint Opening Audit — settings_audit.md | 4h | ⬜ Not Started | — | Day 1-2 |
| S3.2 | Skeletonizer untuk loading state Settings | 2h | ⬜ Not Started | — | Per AD-6, reuse production widget |
| S3.3 | ErrorSection untuk error state Settings | 1h | ⬜ Not Started | — | Reuse dari Sprint 2 C6 |
| S3.4 | Refactor SettingsCubit — data layer | 3h | ⬜ Not Started | — | Build repo + datasource (current: direct SupabaseClient + SharedPref) |
| S3.5 | Implement "Data & Cache" section | 2h | ⬜ Not Started | — | Wireframe 18 §Data & Cache — Hapus Cache, Hapus Data Lokal |
| S3.6 | Implement "Telepon Darurat" field | 1h | ⬜ Not Started | — | Wireframe 18 catatan kaki |
| S3.7 | Help & Support page — audit + polish | 2h | ⬜ Not Started | — | FAQ, Contact cards |
| S3.8 | Terms & Conditions page — audit + polish | 1h | ⬜ Not Started | — | Static content verification |
| S3.9 | No Internet page — audit + polish | 2h | ⬜ Not Started | — | Cubit/state pattern (current: inline connectivity_plus) |
| S3.10 | Icon consistency pass (iconsax → Material + TODO) | 2h | ⬜ Not Started | — | Per Icon Convention Sprint 2+ |

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

#### S3.1 Sprint Opening Audit (4h)

Buat `docs/progress/settings_audit.md` dengan template `home_page_audit.md`:
- 15 sections (Executive Summary, Wireframe vs Code, PRD vs Code, API vs Code, ERD vs Code, User Flow vs Code, TDD Compliance x 6, Bug Catalog, TODO, Score Card)
- Verifikasi pra-audit findings F1-F10
- Identifikasi temuan baru di luar F1-F10
- Output: todo list untuk Sprint 3

**Files:**
- `docs/progress/settings_audit.md` (new)

#### S3.2 Skeletonizer untuk Loading State (2h)

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

#### S3.3 ErrorSection untuk Error State (1h)

Replace custom error widget di Settings page dengan `ErrorSection` dari `lib/widgets/loader/error_section.dart`:
- Tambah padding/context yang sesuai
- Hapus custom error state widget

**Pattern:**
```dart
SettingsError(:final message) => ErrorSection(
  message: message,
  onRetry: () => context.read<SettingsCubit>().loadSettings(),
),
```

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)

#### S3.4 Refactor SettingsCubit — Data Layer (3h)

**Problem:** `SettingsCubit` injects `SharedPrefService` + `SupabaseClient`. Ini melanggar TDD 01 §3.3 (presentation tidak boleh langsung akses data layer).

**Fix:** Buat data/domain layer untuk Settings:
1. `SettingsRepository` abstract (`lib/features/settings/domain/repository/settings_repository.dart`)
2. `SettingsRepositoryImpl` (`lib/features/settings/data/repository/settings_repository_impl.dart`)
3. Pindahkan SharedPrefService + SupabaseClient logic ke repository
4. SettingsCubit inject SettingsRepository (bukan SharedPrefService + SupabaseClient langsung)
5. Run build_runner untuk DI regeneration

**Alternative (lightweight):** Pakai `AppServices` sebagai single source of truth untuk authId dan operasi terkait user — sama seperti fix A4 di Home.

**Files:**
- `lib/features/settings/domain/repository/settings_repository.dart` (new)
- `lib/features/settings/data/repository/settings_repository_impl.dart` (new)
- `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` (modify)
- DI config (auto-regenerated)

#### S3.5 Implement "Data & Cache" Section (2h)

**Wireframe:** 18-settings.md §"Data & Cache"

**Feature spec:**
- "Hapus Cache" — clear all SharedPreferences cache (cache banner, specialization, profile)
- "Hapus Data Lokal" — clear semua local data termasuk FCM token (user tetap login, next sync akan re-create token)

**Implementation:**
1. Tambah 2 `MenuItemTile` di Settings page (antara Preferensi dan Aplikasi section)
2. "Hapus Cache" → `CacheService.clearAll()` (existing method dari Sprint 2 B5/B6)
3. "Hapus Data Lokal" → `HomeLocalDataSource.clearAll()` + `CacheService.clearAll()` + `SharedPrefService.clear()`
4. Konfirmasi dialog sebelum eksekusi (reuse `AppConfirmDialog`)
5. Snackbar sukses setelah selesai

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)
- `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` (modify — tambah method)

#### S3.6 Implement "Telepon Darurat" Field (1h)

**Wireframe:** 18-settings.md catatan kaki

**Feature spec:**
- Settings page footer: "Anda dapat menambahkan nomor telepon darurat" + icon telepon
- Tap → input dialog (masukkan nomor telepon)
- Simpan ke `user_profiles.emergency_phone` (ERD — perlu verifikasi field exists)

**ERD check:** Cek `docs/erd/erd_healh_pal.md` — field `emergency_phone` di `user_profiles`?

**Note:** Jika field ERD belum ada, butuh SQL migration. Jika tidak, bisa simpan di SharedPreferences sebagai temporary solution.

**Files:**
- `lib/features/settings/presentation/page/settings_page.dart` (modify)
- `lib/features/settings/presentation/bloc/settings/settings_cubit.dart` (modify — tambah method)

#### S3.7 Help & Support — Audit + Polish (2h)

**Wireframe:** 19-help-support.md

**Verifikasi:**
- FAQ item sesuai wireframe?
- Email: `support@healthpal.app` — routing valid?
- Telepon: `021-12345678` — routing valid?
- `url_launcher` call sudah pakai error handling?

**Polish:**
- Tambah Skeletonizer untuk loading state (jika ada)
- Error handling untuk `_launchUrl` (current: `await canLaunchUrl` + `await launchUrl` tanpa try-catch)

**Files:**
- `lib/features/settings/presentation/page/help_support_page.dart` (modify)

#### S3.8 Terms & Conditions — Audit + Polish (1h)

**Wireframe:** 20-tnc.md

**Verifikasi:**
- Semua section (6 item) ada?
- Tanggal "Terakhir diperbarui: Juni 2026" — update ke tanggal aktual
- Layout konsisten dengan wireframe?

**Files:**
- `lib/features/settings/presentation/page/terms_and_conditions_page.dart` (modify)

#### S3.9 No Internet Page — Audit + Polish (2h)

**Wireframe:** 21-no-internet.md

**Problem:** `Connectivity().checkConnectivity()` langsung dipanggil di widget (StatefulWidget dengan state internal).

**Fix:**
1. Buat `NoInternetCubit` (opsional — atau jadikan stateless dengan callback)
2. Pindahkan logika connectivity ke cubit
3. Handle loading state (saat checking)
4. Handle error state (connectivity gagal)
5. Skeletonizer? Halaman ini tidak streaming data, jadi skeleton tidak terlalu relevan.

**Alternative:** Simplify — tetap StatefulWidget tapi refactor retry logic ke method yang lebih clean. Tidak perlu cubit untuk halaman sesederhana ini.

**Files:**
- `lib/features/settings/presentation/page/no_internet_page.dart` (modify)

#### S3.10 Icon Consistency Pass (2h)

**Problem:** Settings pages menggunakan `iconsax_latest` langsung. Per Icon Convention:
- New code → Material Icons + `// TODO: change to iconsax`
- Existing Iconsax code → jangan diubah

**Approach:**
- Settings page: ganti `Iconsax.*` → `Icons.*` + TODO comment
- Help & Support page: ganti `Iconsax.*` → `Icons.*` + TODO comment
- Terms & Conditions page: ganti `Iconsax.*` → `Icons.*` + TODO comment
- No Internet page: ganti `Iconsax.*` → `Icons.*` + TODO comment
- Hapus import `iconsax_latest` jika semua icon sudah diganti

---

## 3. Timeline

| Day | Tasks | Detail |
|:---:|-------|--------|
| Day 1 | S3.1 — Audit | `settings_audit.md` — verifikasi F1-F10 + temuan baru |
| Day 2 | S3.1 — Audit (lanjutan) | Finalisasi audit doc, publish, alignment tim |
| Day 3 | S3.4 — Refactor data layer | SettingsRepository + impl, DI regen |
| Day 4 | S3.2 + S3.3 — Skeletonizer + ErrorSection | Polish loading/error states |
| Day 5 | S3.5 — Data & Cache section | Implementasi section baru |
| Day 6 | S3.6 — Telepon Darurat | Input dialog + save |
| Day 7 | S3.7 + S3.8 — Help + TnC polish | Audit findings fix |
| Day 8 | S3.9 — No Internet refactor | Connectivity logic cleanup |
| Day 9 | S3.10 — Icon consistency | Iconsax → Material + TODO |
| Day 10 | Buffer + Flutter analyze + Commit | Final QA, 0 issues |

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

**Status:** 📋 **PLAN READY — menunggu kick-off Sprint 3**

**Next Actions:**
1. `git add docs/` + commit
2. Mulai Day 1: Sprint Opening Audit → `settings_audit.md`
