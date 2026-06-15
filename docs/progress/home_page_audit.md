# Home Page — Audit Komprehensif

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal Audit** | 15 Juni 2026 |
| **Auditor** | Tech Lead (MiniMax-M3) |
| **Cakupan** | Home Page (`/home` — Branch 0 StatefulShellRoute) |
| **Acuan Dokumen** | wireframe/06-home.md · prd_health_pal.md · erd_healh_pal.md · api_contract_health_pal.md · USER_FLOW.md · TDD 01–12 · sprint_progress.md |
| **Tujuan** | Membandingkan **state of the docs** ↔ **state of the code** · mengidentifikasi gap, deviation, bug tersembunyi, dan TODO actionable untuk Sprint 2 |

---

## Daftar Isi

1. [Ringkasan Eksekutif](#1-ringkasan-eksekutif)
2. [Wireframe vs Implementasi](#2-wireframe-vs-implementasi)
3. [PRD vs Implementasi](#3-prd-vs-implementasi)
4. [API Contract vs Implementasi](#4-api-contract-vs-implementasi)
5. [ERD vs Implementasi](#5-erd-vs-implementasi)
6. [User Flow vs Implementasi](#6-user-flow-vs-implementasi)
7. [TDD Arsitektur vs Implementasi](#7-tdd-arsitektur-vs-implementasi)
8. [TDD State Management vs Implementasi](#8-tdd-state-management-vs-implementasi)
9. [TDD Data Layer vs Implementasi](#9-tdd-data-layer-vs-implementasi)
10. [TDD Routing vs Implementasi](#10-tdd-routing-vs-implementasi)
11. [TDD Caching vs Implementasi](#11-tdd-caching-vs-implementasi)
12. [TDD Error Handling vs Implementasi](#12-tdd-error-handling-vs-implementasi)
13. [Deviation & Bug Catalog](#13-deviation--bug-catalog)
14. [TODO Sprint 2 (Actionable)](#14-todo-sprint-2-actionable)
15. [Score Card](#15-score-card)

---

## 1. Ringkasan Eksekutif

### 1.1 Verdict

🟡 **HOME PAGE 80% LENGKAP** — fondasi Clean Architecture solid (25 file, 4 cubit, 4 widget, 4 entity, 4 model, 4 use case, 1 repo, 2 datasource), tetapi **2 section UI hilang** (Search Bar, Nearby Medical Centers), **3 behavior PRD-mandated tidak ada** (Skeleton loader, Pull-to-refresh, Profile Photo di Greeting), dan ada **3 deviation API** (notably `getUpcoming` filter/order), **1 hardcoded value** (notification count=5), **1 route parameter mismatch** (`:bookingId` vs `:appointmentId`), dan **1 status enum unsafe cast** (`BookingStatus.values.firstWhere`).

### 1.2 Skor Per Aspek

| # | Aspek Audit | Skor | Status |
|---|---|:---:|:---:|
| 1 | Wireframe coverage (7 section) | **4/7 (57%)** | 🟡 |
| 2 | PRD §6.2 requirement coverage | **4/5 (80%)** | 🟢 |
| 3 | API Contract alignment (4 endpoint) | **2/4 full + 1 partial** | 🟡 |
| 4 | ERD mapping (4 entity) | **3.5/4** | 🟢 |
| 5 | User Flow §5.1 navigation (6 trigger) | **4/6 (67%)** | 🟡 |
| 6 | TDD Clean Architecture compliance | **95%** | 🟢 |
| 7 | TDD State Management (sealed + pattern) | **100%** | 🟢 |
| 8 | TDD Data Layer (freezed + JsonKey) | **30%** | 🔴 |
| 9 | TDD Routing (branch 0 + app shell) | **100%** | 🟢 |
| 10 | TDD Caching (banner 5m, spec 7d) | **75%** | 🟡 |
| 11 | TDD Error Handling (Result + ErrorHandler) | **85%** | 🟢 |
| 12 | Pull-to-refresh | **0%** | 🔴 |
| 13 | Skeleton / Shimmer loader | **0%** | 🔴 |
| 14 | Code quality (`flutter analyze`) | **0 issue** | 🟢 |
| 15 | Defensive routing (BUG-001/FIX-7) | **100%** | 🟢 |
| | **Rata-rata** | **~77 / 100** | **🟡** |

### 1.3 Visual Heatmap

```
WIREFRAME         ██████░░  57%  🟡
PRD §6.2          ████████  80%  🟢
API CONTRACT      ██████░░  65%  🟡
ERD               ███████▌  88%  🟢
USER FLOW         ██████░░  67%  🟡
ARCHITECTURE      █████████ 95%  🟢
STATE MGMT        ██████████ 100% 🟢
DATA LAYER        ███░░░░░░ 30%  🔴
ROUTING           ██████████ 100% 🟢
CACHING           ███████▌░ 75%  🟡
ERROR HANDLING    ████████▌ 85%  🟢
──────────────────────────────────
TOTAL             ███████▌░ ~77% 🟡
```

### 1.4 Yang Sudah Benar

✅ Clean Architecture 3-lapis (Data / Domain / Presentation) lengkap per TDD 01.
✅ Dependency rule遵守: Presentation → Domain ← Data; tidak ada import silang.
✅ DI pakai `injectable` + `get_it`; `dart run build_runner build --force-jit` sukses.
✅ 4 Cubit dengan sealed state pattern sesuai TDD 04 §3 (`Initial / Loading / Loaded / Error`).
✅ `BlocSelector` di HomePage untuk granular rebuild per section (sesuai 06-home-todo.md §6.4).
✅ `MultiBlocProvider` orchestrate load: `GreetingCubit` → emit `profileId` → trigger `UpcomingCubit.loadUpcoming()`.
✅ `BlocListener` di HomePage implement FIX-7 (redirect ke CreateProfile jika `isProfileComplete=false`).
✅ Cache fallback untuk Banners (TTL 5 menit) & Specializations (TTL 7 hari) sesuai TDD 08.
✅ `getBanners` query sudah benar: filter `is_active`, range `starts_at`/`ends_at`, order `display_order.asc`.
✅ Route `/home` terdaftar di Branch 0 `StatefulShellRoute.indexedStack` dengan benar.
✅ Bottom Navigation 4 tab (Home/Loc/History/Profile) dengan Iconsax icons.
✅ Distinct state `GreetingNoProfile` memisahkan "no profile row" dari network error — defense-in-depth.
✅ `BookingStatus` enum dipakai di UpcomingCard untuk render StatusBadge (bukan hardcoded string).
✅ `flutter analyze` 0 issues.
✅ Self-contained error handling di `ErrorHandler` (catches PostgrestException, AuthException, TimeoutException, SocketException, StorageException).

### 1.5 Yang Harus Diperbaiki (Ringkas)

🔴 **KRITIS:**
1. **Search Bar tidak ada** di HomePage — wireframe 06 §2 + PRD §6.2 + User Flow §5.1 + TDD 12 §4.18 semua mensyaratkan. **Implementasi tidak ada sama sekali.**
2. **getUpcoming query deviation** — implementasi pakai `neq('status','completed').neq('status','cancelled').order('created_at',desc)` tapi API Contract §6.5 spec: `status=in.(pending,upcoming).order=doctor_slots.slot_date.asc`. **Mengubah semantic "upcoming"** (sort by `created_at` bukan by date slot).
3. **Slot date/time disimpan sebagai `String`** di `UpcomingAppointmentEntity` — TDD 05 §3.2 + §3.6 menentukan `@DateOnlyJsonConverter()` → `DateTime` & `@TimeOnlyJsonConverter()` → `TimeOfDay`. Hard untuk format di UI.

🟡 **MEDIUM:**
4. **Notification count hardcoded `5`** di GreetingSection line 30.
5. **Route mismatch** `/booking-history/:bookingId` (route_paths.dart) vs `/booking-history/:appointmentId` (TDD 02 §4.3 + User Flow §5.1) — bug yang sudah diidentifikasi sprint_progress.md.
6. **BookingStatus.firstWhere unsafe** di UpcomingCard line 41-44 — fallback ke `pending` tanpa warning. Gunakan `@JsonValue` enum mapping.
7. **Home Models TIDAK pakai `@freezed` + `@JsonKey`** — semua 4 model (Banner/Specialization/Upcoming/UserProfile) pakai manual `fromJson/toJson`. Doctor dan Booking pakai freezed. Inkonsisten dengan TDD 05 §3.4.
8. **Nearby Medical Centers hilang** — wireframe 06 §6 + TDD 12 Fase 9.5 semuanya schedule, implementasi deferred. Butuh `get_nearby_clinics` RPC (sudah ada di API §5.5 + ERD §8).
9. **Empty state copy inkonsisten** — wireframe 06 §"Empty State" + PRD §6.2 pakai "Cari Dokter", kode pakai "Book Appointment" (UpcomingCard line 173).

🟢 **LOW:**
10. **No pull-to-refresh** — wireframe 06 §"Pull To Refresh" + TDD 12 §4 (tidak eksplisit disebut tapi implicit di fase).
11. **No skeleton/shimmer** — TDD 12 §4.17 menyebutkan, deferred.
12. **Quick Categories icon hardcoded** — `_getIcon(name)` di QuickCategories line 110-121 fallback ke `Iconsax.user` untuk hampir semua kategori.
13. **User profile tidak di-cache** — TDD 08 §2 menentukan cache session, implementasi selalu remote.
14. **Cache key naming deviation** — TDD 08 §3 contoh: `${key}_saved_at`, implementasi: `${key}_time`.
15. **Result.code type deviation** — TDD 01 §4.3 + TDD 06 §3: `code: FailureCode` (enum); implementasi: `code: String` (`FailureCode.name`).
16. **HomeLocalDataSource `@injectable`** — tanpa scope annotation, default-nya `factory`. Seharusnya `@lazySingleton` karena `SharedPreferences` singleton.

---

## 2. Wireframe vs Implementasi

### 2.1 Section-by-Section Matrix (docs/wireframe/06-home.md)

| # | Section | Wireframe Spec | Implementation | File | Status |
|---|---|---|---|---|:---:|
| 1 | **Greeting Header** | "Halo, Andi!" + 🔔 notif | `GreetingSection` di `home_page.dart:83-91` | `lib/features/home/presentation/widget/greeting_section.dart` | ✅ |
| 2 | **Search Bar** | "🔍 Search doctor, treatment..." | **TIDAK ADA** | — | ❌ |
| 3 | **Promo Carousel** | Image + indicator dots, auto-scroll 5s | `BannerCarousel` (PageView + 5s timer) | `lib/features/home/presentation/widget/banner_carousel.dart` | ✅ |
| 4 | **Upcoming Treatment** | Card + [View Detail] | `UpcomingCard` (`_AppointmentCard` + `_EmptyState`) | `lib/features/home/presentation/widget/upcoming_card.dart` | ✅ |
| 5 | **Categories** | 2×4 grid (8 kategori) + "See All" | `QuickCategories` GridView (4 cols, dynamic count) | `lib/features/home/presentation/widget/quick_categories.dart` | ✅ |
| 6 | **Nearby Medical Centers** | Horizontal list + cover image | **TIDAK ADA** (deferred per `06-home-todo.md` §D.1) | — | ❌ |
| 7 | **Bottom Navigation** | 4 tab (Home/Loc/Booking/Profile) | `AppShell` + `NavigationShell` | `lib/widgets/app_shell.dart` | ✅ |

**Coverage: 4/7 (57%)**

### 2.2 Empty State Comparison

| Empty State | Wireframe Spec | Implementation | Status |
|---|---|---|:---:|
| No Upcoming Treatment | "No upcoming treatment found." + CTA "Cari Dokter" | UpcomingCard line 160 `"No upcoming treatment found."` + line 173 `"Book Appointment"` | 🟡 Copy mismatch |
| No Banner | "section banner disembunyikan" (PRD §6.2) | `BannerCarousel.build` line 49 `if (banners.isEmpty) return SizedBox.shrink()` | ✅ |
| No Specialization | (tidak dispesifikkan) | `QuickCategories.build` line 17 `if (specializations.isEmpty) return SizedBox.shrink()` | 🟢 Implicit |

### 2.3 Section Spec Detail

#### Section 1 — Greeting Header (✅)

| Wireframe Aspek | Implementation | Verdict |
|---|---|:---:|
| "Halo, {nickname}!" | `greeting_section.dart:24` `'Halo, ${nickname.isNotEmpty ? nickname : ''}'` | ✅ |
| 🔔 Notif icon | `greeting_section.dart:30-35` `LightIconButton` + `AppBadge` | ✅ |
| Tap notif → `/profile/notifications` | `greeting_section.dart:28` `context.push(RoutePaths.notificationSettings)` (= `/profile/notifications`) | ✅ |
| Foto profil kecil di kanan atas (PRD §6.2) | **TIDAK ADA** — hanya bell icon tanpa avatar | 🟡 PRD mismatch |
| Notification badge dengan count | `AppBadge(count: 5)` — **hardcoded 5** | 🔴 BUG |

#### Section 3 — Promo Carousel (✅ dengan catatan)

| Wireframe Aspek | Implementation | Verdict |
|---|---|:---:|
| Auto scroll 5 detik | `banner_carousel.dart:35` `Timer.periodic(Duration(seconds: 5), ...)` | ✅ |
| Swipeable | `PageView.builder` | ✅ |
| Indicator dots | `_DotsIndicator` widget | ✅ |
| Clickable | `_BannerCard.onTap` → `context.push(banner.actionUrl!)` | ✅ |
| `GET /banners` | `home_remote_datasource.dart:15-28` | ✅ |
| Filter `is_active=true` + range `starts_at`/`ends_at` + order `display_order.asc` | `home_remote_datasource.dart:18-23` | ✅ Sesuai API Contract §7.1 |
| Action URL `healthpal://...` deep link | `banner.actionUrl` di-push langsung via `context.push` | ✅ (tapi tidak ada validasi URL scheme) |

#### Section 4 — Upcoming Treatment (🟡)

| Wireframe Aspek | Implementation | Verdict |
|---|---|:---:|
| Doctor Name | `upcoming_card.dart:68` `Text(appointment.doctorName)` | ✅ |
| Specialization / Treatment | `upcoming_card.dart:70-75` `Text(appointment.specializationName)` | ✅ |
| Date & Time `📅 15 Jun 2026 • 09:00` | `upcoming_card.dart:79` `'${appointment.slotDate} • ${appointment.slotStart}'` | 🟡 Raw string (bukan formatted) |
| Facility Name `🏥 Klinik Sehat Bersama` | `upcoming_card.dart:84` | ✅ |
| Status badge | `StatusBadge` widget | ✅ |
| Tap card → `/booking-history/:appointmentId` | `upcoming_card.dart:49-51` `RoutePaths.bookingDetail.replaceAll(':bookingId', appointment.id)` | 🟡 Path param mismatch |
| Empty state + CTA "Cari Dokter" | `_EmptyState` dengan tombol "Book Appointment" | 🟡 Copy mismatch |

#### Section 5 — Categories (✅ dengan catatan)

| Wireframe Aspek | Implementation | Verdict |
|---|---|:---:|
| 2 rows × 4 columns | `crossAxisCount: 4` (GridView) | ✅ Layout 4 cols; rows dinamis |
| 8 initial categories (Dentistry, Cardio, Pulmo, General, Neuro, Gastro, Lab, Vaccine) | `QuickCategories` consume dari `GetSpecializationsUseCase` (DB-driven) | ✅ Sesuai data master |
| Tap category → `/search?specialization={id}` | `quick_categories.dart:66-68` `'${RoutePaths.doctorSearch}?specialization=${specialization.id}'` | ✅ |
| "See All" → `/search` | `quick_categories.dart:29` `context.push(RoutePaths.doctorSearch)` | ✅ |
| Icon emoji per kategori | Hardcoded `_getIcon(name)` fallback ke `Iconsax.user` | 🟡 Most fallback to user icon |

#### Section 6 — Nearby Medical Centers (❌)

| Wireframe Aspek | Implementation | Verdict |
|---|---|:---:|
| Horizontal list | TIDAK ADA | ❌ |
| Cover image + Facility Name + Distance + Rating | TIDAK ADA | ❌ |
| `GET /facilities/nearby` (lat/lng/radius) | TIDAK ADA — RPC `get_nearby_clinics` tidak dipanggil | ❌ |
| Tap card → `/facilities/:id` | TIDAK ADA — route tidak ada | ❌ |
| "See All" → `/facilities` | TIDAK ADA | ❌ |

> **Catatan:** `docs/todo/06-home-todo.md` §D.1 memang menandai ini "Ditunda" dan di-link ke `08-facility-todo.md`. `sprint_progress.md` §"Final Scoreboard" menulis Home 100% tapi `08-facility-todo.md` baru di-commit `cfec420` untuk Loc tab (bukan untuk Home Nearby).

### 2.4 Loading State

| Wireframe Spec | Implementation | Verdict |
|---|---|:---:|
| Order: Greeting → Banner → Upcoming → Categories → Nearby | HomePage orchestrate via `MultiBlocProvider` (4 cubit) dengan trigger `UpcomingCubit.loadUpcoming()` di dalam `BlocListener<GreetingCubit>` saat `GreetingLoaded` | ✅ |
| Setiap section pakai skeleton loader secara independen | TIDAK ADA — pakai `SizedBox.shrink()` atau `BlocSelector` returning default empty/null saat loading | 🔴 TDD 12 §4.17 menyebutkan shimmer/skeleton, **deferred** |

### 2.5 Pull To Refresh

| Wireframe Spec | Implementation | Verdict |
|---|---|:---:|
| Refresh: Greeting + Banner + Upcoming + Categories + Nearby | TIDAK ADA `RefreshIndicator` di `HomePage` | 🔴 Wireframe eksplisit |

---

## 3. PRD vs Implementasi

### 3.1 PRD §6.2 Home Screen Requirements

| Elemen | PRD Requirement | Implementation | Status |
|---|---|---|:---:|
| **Greeting** | "Halo, {nickname}!" + foto profil kecil di kanan atas | "Halo, {nickname}!" + bell icon (bukan foto profil) | 🟡 Partial |
| **Search Bar** | Input teks → navigasi ke hasil pencarian dokter (nama/spesialisasi) | TIDAK ADA | ❌ |
| **Banner Promo** | Horizontal scroll carousel; data dari tabel `banners`; tap → detail/URL | `BannerCarousel` dengan auto-scroll + tap → `actionUrl` | ✅ |
| **Upcoming Appointment** | Card appointment terdekat milik user (Pending/Upcoming); tap → detail booking | `UpcomingCard` dengan card + empty state + tap ke `bookingDetail` | ✅ |
| **Quick Categories** *(opsional v1.1)* | Grid ikon spesialisasi sebagai shortcut ke Loc tab | `QuickCategories` diimplementasikan | ✅ (above PRD scope) |
| **Edge case — no upcoming** | Tampilkan empty state dengan CTA "Cari Dokter" | Empty state ada, tapi CTA = "Book Appointment" | 🟡 Copy mismatch |
| **Edge case — no banner** | Section banner disembunyikan | `BannerCarousel` return `SizedBox.shrink()` jika list empty | ✅ |

**Coverage: 4/5 (80%)** — Search Bar hilang, 2 copy mismatches.

### 3.2 PRD §7 Alur Booking (Happy Path)

```text
[Home / Loc Tab] → [Cari Dokter] → ... → [Booking Berhasil] → [Kembali ke Home (tampil upcoming card)]
```

**Verifikasi path kembali ke Home:**

| Step | Implementation | Status |
|---|---|:---:|
| Setelah booking berhasil, `upcoming` card muncul di Home | Tergantung `UpcomingCubit.loadUpcoming()` re-trigger. Saat ini **tidak ada listener** yang re-fetch upcoming setelah booking success. | 🟡 Manual pull-to-refresh needed (yang juga belum ada) |

### 3.3 PRD §11 Non-Functional Requirements

| Requirement | Implementation | Verdict |
|---|---|:---:|
| Load time halaman utama < 2 detik pada 4G | 4 cubit independent + parallel query. `await` di `MultiBlocProvider` create. Tidak ada measurement aktual. | 🟡 Tidak diukur |
| Offline cached data + indikator | Cache fallback di Repository untuk banner + spec. **TIDAK ADA indikator "data mungkin tidak terbaru"** di UI. | 🟡 Partial |
| Aksesibilitas: tombol ≥ 48x48dp | `GreetingSection` bell button via `LightIconButton` (perlu verifikasi size); grid items 56x56 icon container; "See All" Text tanpa padding khusus | 🟡 Tidak diaudit |

### 3.4 PRD §8 Status Appointment Mapping

| PRD Status Enum | Kode Value | BookingStatus enum (lib/core/enums/booking_status.dart) | Status |
|---|---|---|:---:|
| Pending | `pending` | `pending` | ✅ |
| Upcoming | `upcoming` | `upcoming` | ✅ |
| Completed | `completed` | `completed` | ✅ |
| Cancelled | `cancelled` | `cancelled` | ✅ |

---

## 4. API Contract vs Implementasi

### 4.1 Endpoint Coverage Matrix (docs/api_contract/api_contract_health_pal.md)

| API | Spec Section | Implementation Method | File:Line | Verdict |
|---|---|---|---|:---:|
| `GET /banners` | §7.1 | `HomeRemoteDataSource.fetchBanners()` | `home_remote_datasource.dart:15-28` | ✅ |
| `GET /specializations?order=name.asc` | §4.1 | `HomeRemoteDataSource.fetchSpecializations()` | `home_remote_datasource.dart:46-55` | ✅ |
| `GET /user_profiles?auth_id=eq.{uid}` | §3.1 | `HomeRemoteDataSource.fetchUserProfile(authId)` | `home_remote_datasource.dart:57-66` | ✅ |
| `GET /appointments?status=in.(pending,upcoming)&...` | §6.5 | `HomeRemoteDataSource.fetchUpcoming(profileId)` | `home_remote_datasource.dart:30-44` | 🔴 **DEVIATION** |
| `POST /rest/v1/rpc/get_nearby_clinics` | §5.5 | TIDAK ADA | — | ❌ Missing (deferred) |

### 4.2 Detail Deviation — `getUpcoming`

**API Contract §6.5 spec:**

```http
GET /rest/v1/appointments
  ?patient_id=eq.<profile_id>
  &status=in.(pending,upcoming)                    ← filter
  &select=*,doctors(...),doctor_slots(...)
  &order=doctor_slots.slot_date.asc               ← sort by slot date ASC
  &limit=1
```

**Implementation (`home_remote_datasource.dart:30-44`):**

```dart
final result = await _client
    .from('appointments')
    .select('*, doctors(id, full_name, photo_url, clinics(name), specializations(name)), doctor_slots(slot_date, slot_start, slot_end)')
    .eq('patient_id', profileId)
    .neq('status', 'completed')                   // ❌ NOT spec
    .neq('status', 'cancelled')                   // ❌ NOT spec
    .order('created_at', ascending: false)        // ❌ Wrong sort
    .limit(1)
    .maybeSingle();
```

| Aspect | API Spec | Implementation | Impact |
|---|---|---|---|
| Filter | `status=in.(pending,upcoming)` | `neq('completed') + neq('cancelled')` | 🟡 Equivalent secara set, tapi query lebih lebar (mengecualikan completed & cancelled). Boleh, tapi tidak spec-compliant. |
| Order | `doctor_slots.slot_date.asc` | `created_at, ascending: false` | 🔴 **Mengubah semantic "upcoming"** — sort by `created_at` DESC artinya appointment baru dibuat muncul duluan, BUKAN appointment dengan tanggal slot terdekat. |
| Limit | 1 | 1 | ✅ |
| Select | include doctors.clinics + specializations + doctor_slots | `doctors(id, full_name, photo_url, clinics(name), specializations(name)), doctor_slots(slot_date, slot_start, slot_end)` | 🟡 Missing `experience_years` dan `rating_*` di doctors (tidak dipakai di entity, OK). Tapi `doctors.id` TIDAK di-select (meskipun di Home tidak dipakai). |

**Root cause:** Spec menyebutkan "order by nested column `doctor_slots.slot_date` via JOIN PostgREST" — kemungkinan author implementasi tidak yakin syntax-nya benar (lihat note di API Contract §6.5: "ordering di atas memerlukan alias PostgREST — jika gagal, fallback: order di Flutter side"). Fallback juga belum diimplementasi.

### 4.3 Endpoint `getBanners` (✅)

```dart
final now = DateTime.now().toIso8601String();
final result = await _client
    .from('banners')
    .select()
    .eq('is_active', true)
    .or('starts_at.is.null,starts_at.lte.$now')     // ✅ sesuai §7.1
    .or('ends_at.is.null,ends_at.gte.$now')         // ✅ sesuai §7.1
    .order('display_order', ascending: true);       // ✅ sesuai §7.1
```

**Verdict:** 100% compliant dengan API Contract §7.1.

### 4.4 Endpoint `fetchSpecializations` (✅)

```dart
.from('specializations').select().order('name', ascending: true)
```

Sesuai API §4.1 (RLS public, dengan optional auth header). ✅

### 4.5 Endpoint `fetchUserProfile` (✅ dengan catatan)

```dart
.from('user_profiles').select().eq('auth_id', authId).maybeSingle();
```

| Aspect | API Spec §3.1 | Implementation | Verdict |
|---|---|---|:---:|
| Path | `/rest/v1/user_profiles?auth_id=eq.<auth_uid>&select=*` | Sama | ✅ |
| `maybeSingle()` vs array first | Response array, ambil `[0]` | `.maybeSingle()` langsung object | 🟢 Lebih clean |
| Auth required | Ya (Bearer token) | Default pakai SupabaseClient.currentSession | ✅ |

### 4.6 Missing Endpoint — `get_nearby_clinics`

Sesuai wireframe 06 §6 + ERD §8 + API Contract §5.5 + TDD 12 Fase 9.5, endpoint ini harus dipanggil dari Home untuk "Nearby Medical Centers". Status: **belum diimplementasi** (deferred per 06-home-todo.md §D.1 → 08-facility-todo.md).

---

## 5. ERD vs Implementasi

### 5.1 Entity Coverage (docs/erd/erd_healh_pal.md)

| ERD Table | Home Entity | Field Mapping | Verdict |
|---|---|---|:---:|
| `user_profiles` | `UserProfileEntity` | `id`, `nickname`, `is_profile_complete` | 🟡 Partial (lihat 5.2) |
| `banners` | `BannerEntity` | `id`, `title`, `image_url`, `action_url`, `display_order` (+ `is_active`, `starts_at`, `ends_at` di-filter query, tidak di entity) | ✅ |
| `appointments` + `doctors` + `clinics` + `specializations` + `doctor_slots` | `UpcomingAppointmentEntity` | Flattened: `doctorName`, `doctorPhoto`, `clinicName`, `specializationName`, `slotDate`, `slotStart`, `slotEnd`, `status` | ✅ (lihat 5.3) |
| `specializations` | `SpecializationEntity` | `id`, `name`, `icon_url` | ✅ |

### 5.2 Detail — `user_profiles` Mapping

**ERD §2.2 spec** (field untuk greeting):

| ERD Field | Type | Nullable | Home Entity Field | Verdict |
|---|---|---|:---:|
| `id` | UUID PK | No | `id: String` | ✅ |
| `nickname` | TEXT | Yes | `nickname: String` | ✅ |
| `is_profile_complete` | BOOLEAN | No (default false) | `isProfileComplete: bool` (default false) | ✅ |
| `full_name` | TEXT | No | **TIDAK di entity Home**, tapi dipakai sebagai fallback di `UserProfileModel.fromJson` line 17 | 🟡 Implicit fallback |
| `avatar_url` | TEXT | Yes | **TIDAK di entity Home** (tidak dipakai di GreetingSection) | 🟡 PRD §6.2 minta foto profil kecil → field dibutuhkan |
| `auth_id` | UUID FK | No | **TIDAK di entity Home** (dikirim sebagai param `authId` ke `getUserProfile(authId)`) | ✅ |
| `date_of_birth` | DATE | Yes | TIDAK di-load | 🟢 Tidak relevan untuk greeting |
| `gender` | TEXT | No | TIDAK di-load | 🟢 Tidak relevan untuk greeting |
| `notif_reminder_enabled` | BOOLEAN | No | TIDAK di-load | 🟢 Tidak relevan untuk greeting |

**Catatan:** Field `is_profile_complete` di Home entity dipakai untuk guard `AppServices.setProfileIncomplete()` jika false (lihat `home_page.dart:67-69`). Ini sudah benar sesuai BUG-001-FIX-7 pattern.

### 5.3 Detail — `appointments` Nested Mapping

**API Contract §6.5 response shape:**

```json
{
  "id": "...",
  "doctors": {
    "id": "...",
    "full_name": "dr. Budi Santoso, Sp.PD",
    "photo_url": "...",
    "specializations": { "name": "Penyakit Dalam", "icon_url": "..." },
    "clinics": { "id": "...", "name": "Klinik Sehat Bersama", "address": "...", "phone": "..." }
  },
  "doctor_slots": {
    "slot_date": "2026-06-15",
    "slot_start": "09:00:00",
    "slot_end": "09:30:00"
  },
  "status": "upcoming"
}
```

**Entity `UpcomingAppointmentEntity` fields:**

| Source | Field | Type | Verdict |
|---|---|---|:---:|
| `doctors.full_name` | `doctorName: String` | String | ✅ |
| `doctors.photo_url` | `doctorPhoto: String?` | String? | ✅ |
| `doctors.clinics.name` | `clinicName: String` | String | ✅ |
| `doctors.specializations.name` | `specializationName: String` | String | ✅ |
| `doctor_slots.slot_date` | `slotDate: String` | **String** | 🔴 Seharusnya `DateTime` per TDD 05 §3.2 |
| `doctor_slots.slot_start` | `slotStart: String` | **String** | 🔴 Seharusnya `TimeOfDay` per TDD 05 §3.2 |
| `doctor_slots.slot_end` | `slotEnd: String` | **String** | 🔴 Seharusnya `TimeOfDay` per TDD 05 §3.2 |
| `status` | `status: String` | **String** | 🟡 Seharusnya `BookingStatus` enum per TDD 05 §3.1 |
| `appointments.id` | `id: String` | String | ✅ |

**Dampak:** UI render raw string `slotDate` dan `slotStart` di `upcoming_card.dart:79` → output bisa `"2026-06-15 • 09:00:00"`. Tidak match wireframe spec `"15 Jun 2026 • 09:00"`. Butuh formatter + converter.

### 5.4 RLS Alignment (ERD §6)

| Tabel | Policy | Home Query Compliance |
|---|---|:---:|
| `user_profiles` | SELECT: `auth.uid() = auth_id` | `eq('auth_id', authId)` + RLS handles ✅ |
| `banners` | SELECT public, filter `is_active` + date range | `eq('is_active', true)` + date range ✅ |
| `appointments` | SELECT: `auth.uid() = (patient via auth_id)` | `eq('patient_id', profileId)` + RLS ✅ |
| `specializations` | SELECT public | (no auth filter) ✅ |

---

## 6. User Flow vs Implementasi

### 6.1 Navigation Triggers (docs/user_flow/USER_FLOW.md §5.1)

| Trigger | Spec Route | Implementation Route | Verdict |
|---|---|---|:---:|
| Tap search bar | `/doctor/search` | **TIDAK ADA** (search bar tidak ada) | ❌ |
| Tap notif bell (Home) | `/profile/notifications` | `greeting_section.dart:28` `RoutePaths.notificationSettings` = `/profile/notifications` | ✅ |
| Tap upcoming card | `/booking-history/:appointmentId` | `upcoming_card.dart:50` `RoutePaths.bookingDetail` = `/booking-history/:bookingId` (param name mismatch) | 🟡 Path mismatch (functionally works) |
| Tap category | `/doctor/search?specialization={id}` | `quick_categories.dart:66-68` `${RoutePaths.doctorSearch}?specialization=${id}` | ✅ |
| Tap "See All" categories | `/doctor/search` | `quick_categories.dart:29` `RoutePaths.doctorSearch` | ✅ |
| Tap "Book Appointment" empty state | `/doctor/search` | `upcoming_card.dart:165` `RoutePaths.doctorSearch` | ✅ |
| Tap banner CTA | `banner.action_url` | `banner_carousel.dart:88-90` `context.push(banner.actionUrl!)` | ✅ |
| Pull-to-refresh | Reload semua section | **TIDAK ADA** | ❌ |
| Offline | `/no-internet` | (tidak dihandle di Home — global snackbar) | 🟢 Spec §5.1 hanya menyebut di page lain |

**Coverage: 4/6 active triggers (67%)** + 1 path mismatch.

### 6.2 Path Parameter Bug — Cross-Document

| Document | Spec | Implementation | Status |
|---|---|---|:---:|
| `tutorials/tdd/02-folder-structure.md` §4.3 | `static const bookingDetail = '/booking-history/:appointmentId';` | — | Spec: `:appointmentId` |
| `tutorials/tdd/03-routing-design.md` §1 + §8 | `/booking-history/:appointmentId` | — | Spec: `:appointmentId` |
| `docs/user_flow/USER_FLOW.md` §5.1 | `/booking-history/:appointmentId` | — | Spec: `:appointmentId` |
| `docs/audit/cto_executive_summary.md` SS Showstopper | — | — | — |
| `lib/core/router/app_router.dart:224` | — | `path: '/booking-history/:appointmentId'` | ✅ GoRoute pakai `:appointmentId` |
| `lib/core/router/route_paths.dart:22` | — | `static const bookingDetail = '/booking-history/:bookingId';` | 🔴 **MISMATCH** |
| `lib/features/home/presentation/widget/upcoming_card.dart:50` | — | `RoutePaths.bookingDetail.replaceAll(':bookingId', appointment.id)` | 🟡 replaceAll jadi workaround |

**Bug ini sudah diidentifikasi di `sprint_progress.md` §"Action items untuk Sprint 2" #3:** "Refactor RoutePaths agar konsisten (`:appointmentId` everywhere)." **Belum diperbaiki.**

### 6.3 Notification Navigation (app_router.dart:291-318)

`handleNotificationNavigation()` di app_router.dart handle FCM deep link. Untuk Home-related:
- `general` / default → `context.push(RoutePaths.notificationSettings)` = `/profile/notifications` ✅
- `booking_*` + `appointmentId` → `context.push('/booking-history/$appointmentId')` (hardcoded, bukan `RoutePaths.bookingDetail` — minor inkonsistensi tapi functionally works)

---

## 7. TDD Arsitektur vs Implementasi

### 7.1 Clean Architecture Layers (TDD 01 §1-2)

```
Presentation → Domain ← Data
```

**Verification per file:**

| Layer | File | Compliance | Verdict |
|---|---|---|:---:|
| Presentation | `home_page.dart` | Import dari `domain/entity/*` + `presentation/bloc/*` + `presentation/widget/*`. TIDAK import `data/`. | ✅ |
| Presentation | `*_cubit.dart` | Import `domain/entity/*` + `domain/usecase/*` + `core/network/result.dart`. TIDAK import `data/`. | ✅ |
| Presentation | `*_state.dart` | Import `domain/entity/*`. Pure Dart sealed class. | ✅ |
| Domain | `*_entity.dart` | Pure Dart + `equatable`. Zero Flutter / Supabase. | ✅ |
| Domain | `home_repository.dart` | Abstract class with `Result<T>` return. | ✅ |
| Domain | `*_usecase.dart` | `@injectable` constructor + `call()`. | ✅ |
| Data | `home_repository_impl.dart` | `@Injectable(as: HomeRepository)`. Import `domain/repository/*` + `data/datasource/*`. | ✅ |
| Data | `home_remote_datasource.dart` | `@injectable` + Supabase calls. | ✅ |
| Data | `home_local_datasource.dart` | `@injectable` + SharedPreferences. | 🟡 Should be `@lazySingleton` |
| Data | `*_model.dart` | Manual `fromJson/toJson` (deviation — see §9) | 🟡 |

**Compliance: 95%**

### 7.2 Dependency Rule (TDD 01 §3.3)

| Rule | Implementation | Verdict |
|---|---|:---:|
| Presentation → Domain ✅ | All cubits/pages import domain only | ✅ |
| Presentation → Data ❌ | HomePage `home_page.dart:6` import `package:supabase_flutter/supabase_flutter.dart` untuk `auth.currentUser?.id` | 🔴 **VIOLATION** |
| Domain → Data ❌ | Entities pure Dart | ✅ |
| Data → Domain ✅ | All models extend entity via `toEntity()` | ✅ |

**Violation detail di `home_page.dart:33`:**
```dart
final authId = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
```

HomePage (Presentation) langsung pakai `SupabaseClient` (data layer concern). Seharusnya:
- Opsi A: `AppServices.currentAuthId` getter
- Opsi B: Inject `SupabaseClient` ke `GreetingCubit` constructor
- Opsi C: `HomePage` baca dari `AppServices.instance`

### 7.3 Folder Structure (TDD 02 §1)

**TDD spec:**
```
features/home/
├── data/
│   ├── datasource/
│   │   ├── banner_datasource.dart
│   │   └── upcoming_datasource.dart
│   ├── model/
│   │   ├── banner_model.dart
│   │   └── upcoming_appointment_model.dart
│   └── repository/home_repository_impl.dart
├── domain/
│   ├── entity/
│   │   ├── banner_entity.dart
│   │   └── upcoming_appointment_entity.dart
│   ├── repository/home_repository.dart
│   └── usecase/
│       ├── get_banners_usecase.dart
│       ├── get_upcoming_usecase.dart
│       └── get_specializations_usecase.dart
└── presentation/
    ├── bloc/home_cubit.dart
    ├── page/home_page.dart
    └── widget/
        ├── greeting_section.dart
        ├── banner_carousel.dart
        ├── upcoming_card.dart
        └── quick_categories.dart
```

**Implementation actual:**
```
features/home/
├── data/
│   ├── datasource/
│   │   ├── home_local_datasource.dart       ← single (not split)
│   │   └── home_remote_datasource.dart      ← single (not split)
│   ├── model/
│   │   ├── banner_model.dart
│   │   ├── specialization_model.dart        ← ada (tidak di TDD spec; specializations di-spec di doctor)
│   │   ├── upcoming_appointment_model.dart
│   │   └── user_profile_model.dart          ← ada (tidak di TDD spec; profile di-spec di profile feature)
│   └── repository/home_repository_impl.dart
├── domain/
│   ├── entity/
│   │   ├── banner_entity.dart
│   │   ├── specialization_entity.dart       ← ada
│   │   ├── upcoming_appointment_entity.dart
│   │   └── user_profile_entity.dart         ← ada
│   ├── repository/home_repository.dart
│   └── usecase/                             ← 4 use cases (tidak 3)
│       ├── get_banners_usecase.dart
│       ├── get_specializations_usecase.dart
│       ├── get_upcoming_appointment_usecase.dart
│       └── get_user_profile_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── home_bloc_index.dart             ← file re-export (TDD tidak spec)
    │   ├── banner/{cubit,state}.dart
    │   ├── greeting/{cubit,state}.dart
    │   ├── specialization/{cubit,state}.dart
    │   └── upcoming/{cubit,state}.dart
    ├── page/home_page.dart
    └── widget/
        ├── banner_carousel.dart
        ├── greeting_section.dart
        ├── quick_categories.dart
        └── upcoming_card.dart
```

**Verdict:** Struktur inti match. Beberapa deviation:
1. ✅ Tambah `specialization` dan `user_profile` di Home (sebelumnya di-spec di feature lain)
2. ✅ Single `home_remote_datasource.dart` vs split `banner_datasource` + `upcoming_datasource`
3. ✅ 4 cubit terpisah vs TDD §4.6 single `HomeCubit`
4. ✅ Tambah `home_bloc_index.dart` (re-export helper)
5. ✅ Tambah 1 use case `get_user_profile_usecase`

**Catatan:** TDD §4.6 secara eksplisit menyebut "HomeCubit (Cubit, 3 method: loadBanners, loadUpcoming, refresh)". Implementasi memilih 4 cubit terpisah untuk granular state management — **deviation yang sah** karena lebih scalable dan pattern ini dipakai Doctor (SearchCubit + DoctorDetailCubit).

---

## 8. TDD State Management vs Implementasi

### 8.1 Sealed State Pattern (TDD 04 §3)

**TDD spec per cubit:**
```dart
sealed class HomeState { ... }
class HomeInitial extends HomeState { ... }
class HomeLoading extends HomeState { ... }
class HomeLoaded extends HomeState { ... }
class HomeError extends HomeState { ... }
```

**Implementation per cubit (4 cubits):**

| Cubit | Sealed Base | Initial | Loading | Loaded | Error | Extra |
|---|---|---|---|---|---|---|
| `GreetingCubit` | ✅ `GreetingState` | ✅ | ✅ | ✅ `GreetingLoaded(nickname, profileId, isProfileComplete)` | ✅ `GreetingError` | ✅ `GreetingNoProfile` |
| `BannerCubit` | ✅ `BannerState` | ✅ | ✅ | ✅ `BannerLoaded(banners)` | ✅ `BannerError` | — |
| `SpecializationCubit` | ✅ `SpecializationState` | ✅ | ✅ | ✅ `SpecializationLoaded(specs)` | ✅ `SpecializationError` | — |
| `UpcomingCubit` | ✅ `UpcomingState` | ✅ | ✅ | ✅ `UpcomingLoaded(upcoming?)` | ✅ `UpcomingError` | — |

**Verdict: 100% compliant** dengan TDD 04 §3 state pattern.

### 8.2 State Method per Cubit (TDD 04 §4.6)

| Spec | Implementation | Verdict |
|---|---|:---:|
| `GreetingCubit.loadProfile(authId) → Future<String?>` | `greeting_cubit.dart:16` return `String?` (profileId) | ✅ |
| `BannerCubit.loadBanners()` | `banner_cubit.dart:15` | ✅ |
| `SpecializationCubit.loadSpecs()` | `specialization_cubit.dart:15` `loadSpecializations()` (nama method berbeda tapi equivalent) | 🟢 |
| `UpcomingCubit.loadUpcoming(profileId)` | `upcoming_cubit.dart:15` | ✅ |

### 8.3 Data Loading Flow (TDD 04 §4.6)

**TDD spec:**
```
HomePage orchestrate via MultiBlocProvider:
  GreetingCubit.loadProfile(authId)  → GreetingLoaded(nickname) → return profileId
  BannerCubit.loadBanners()          → BannerLoaded(banners)
  SpecializationCubit.loadSpecs()    → SpecializationLoaded(specializations)
  UpcomingCubit.loadUpcoming(pid)    → UpcomingLoaded(upcoming?)
```

**Implementation di `home_page.dart:29-46`:**
```dart
return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) {
        final authId = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
        return getIt<GreetingCubit>()..loadProfile(authId);  // ✅ fire-and-forget
      },
    ),
    BlocProvider(create: (context) => getIt<BannerCubit>()..loadBanners()),
    BlocProvider(create: (context) => getIt<SpecializationCubit>()..loadSpecializations()),
    BlocProvider(create: (context) => getIt<UpcomingCubit>()),  // ← no initial load
  ],
  child: const _HomePageBody(),
);
```

**Plus `BlocListener` di `home_page.dart:56-80`:**
```dart
BlocListener<GreetingCubit, GreetingState>(
  listener: (context, state) {
    if (state is GreetingLoaded) {
      if (state.profileId.isNotEmpty) {
        context.read<UpcomingCubit>().loadUpcoming(state.profileId);  // ✅ chained
      }
      // FIX-7 guard
      if (!state.isProfileComplete) {
        GetIt.instance<AppServices>().setProfileIncomplete();
      }
    } else if (state is GreetingNoProfile) {
      GetIt.instance<AppServices>().setProfileIncomplete();
    }
  },
  ...
)
```

**Verdict: 100% compliant** dengan TDD 04 §4.6 flow + extra FIX-7 enhancement.

### 8.4 GreetingNoProfile — Custom State

TDD 04 §4.6 tidak menyebut `GreetingNoProfile` state. State ini tambahan **di luar spec** untuk support BUG-001 fix.

**Justifikasi code (`greeting_cubit.dart:28-36`):**
> "FIX-7 enhancement: bedakan 'no profile' (notFound) dari error lain (network/timeout). Hanya no-profile yang trigger guard redirect; error lain dibiarkan stay di Home agar user bisa retry"

**Verdict:** 🟢 Acceptable deviation — defense-in-depth pattern.

### 8.5 BookingStatus Mapping (lib/core/enums/booking_status.dart)

TDD 04 tidak eksplisit, tapi TDD 05 §3.1:
```dart
enum BookingStatus {
  @JsonValue('pending') pending,
  @JsonValue('upcoming') upcoming,
  @JsonValue('completed') completed,
  @JsonValue('cancelled') cancelled,
}
```

**Implementation `lib/core/enums/booking_status.dart`:**
```dart
enum BookingStatus { pending, upcoming, completed, cancelled }
```

**Verdict:** Missing `@JsonValue` annotations. Saat ini aman karena usage di `upcoming_card.dart:41-44`:
```dart
BookingStatus get _status => BookingStatus.values.firstWhere(
  (e) => e.name == appointment.status,  // ← string match by name
  orElse: () => BookingStatus.pending,
);
```

🟡 **Bug latent:** Jika server kirim `BookingStatus` baru (mis. `rescheduled`) di masa depan, fallback ke `pending` tanpa warning. Lebih baik pakai `@JsonValue` + custom converter.

---

## 9. TDD Data Layer vs Implementasi

### 9.1 Model Pattern: `@freezed` + `@JsonKey` (TDD 05 §3.0)

**TDD spec (KRITIS):**
> "Mapping strategy: **Per-field `@JsonKey(name: 'snake_case')`**. Code generation: `@freezed` + `@JsonSerializable`. Snake fallback: ❌ Tidak pakai `FieldRename.snake` global."

**Implementation — Home Models semua MANUAL:**

| Model | File | Pattern | Verdict |
|---|---|---|:---:|
| `BannerModel` | `home/data/model/banner_model.dart` | Manual `fromJson` + `toJson` (no @JsonKey) | 🔴 |
| `SpecializationModel` | `home/data/model/specialization_model.dart` | Manual | 🔴 |
| `UpcomingAppointmentModel` | `home/data/model/upcoming_appointment_model.dart` | Manual | 🔴 |
| `UserProfileModel` | `home/data/model/user_profile_model.dart` | Manual | 🔴 |
| `DoctorModel` (referensi) | `doctor/data/model/doctor_model.dart` | `@freezed` + `@JsonKey` | ✅ (per TDD) |
| `AppointmentModel` (referensi) | `booking/data/model/appointment_model.dart` | `@freezed` + `@JsonKey` | ✅ (per TDD) |

**Dampak:** Inkonsisten. Plus, snake_case di-handle manual di setiap `fromJson` (lihat `banner_model.dart:22-25`). Error-prone.

### 9.2 Date/Time Converters (TDD 05 §3.2)

**TDD spec:**
> "Custom converter per type (date-only, time-only, ISO 8601)."
> - `@DateOnlyJsonConverter()` untuk `slot_date`, `date_of_birth`, `banner.starts_at`
> - `@TimeOnlyJsonConverter()` untuk `slot_start`, `slot_end`

**Implementation:**

| Field | TDD Spec | Implementation | Verdict |
|---|---|---|:---:|
| `slot_date` (UpcomingAppointmentModel) | `@DateOnlyJsonConverter() DateTime` | `String` raw | 🔴 |
| `slot_start` | `@TimeOnlyJsonConverter() TimeOfDay` | `String` raw | 🔴 |
| `slot_end` | `@TimeOnlyJsonConverter() TimeOfDay` | `String` raw | 🔴 |
| `banner.starts_at` / `ends_at` | DateTime | (filtered in query, not loaded to entity) | 🟢 OK |

### 9.3 JsonConverters File (TDD 05 §3.2)

**TDD spec:** `lib/core/network/json_converters.dart`

**Implementation:** File ada (`lib/core/network/json_converters.dart` per `sprint_progress.md` §6) — tapi tidak dipakai oleh Home Models karena mereka manual.

### 9.4 DataSource Strategy (TDD 05 §4.1)

**TDD spec — Cache Strategy:**

| Data | Strategy | Cache Duration |
|---|---|---|
| Specializations | Cache first | 7 hari |
| Banners | Remote first | 5 menit |
| Doctor list | Remote only | — |
| Slots | Remote only | — |
| User profile | Remote first | Session |

**Implementation:**

| Method | Strategy | TTL | Verdict |
|---|---|---|:---:|
| `getBanners()` | Remote first + cache fallback | 5 menit | ✅ Sesuai |
| `getSpecializations()` | Remote first + cache fallback | 7 hari | ✅ Sesuai (TDD bilang cache first, implementasi remote first — deviation minor tapi lebih correct untuk "data mungkin tidak terbaru") |
| `getUpcoming()` | Remote only | — | ✅ Sesuai |
| `getUserProfile()` | Remote only | — | 🔴 TDD spec: "Remote first + Session cache". Implementasi selalu remote. |

**Verdict: 75% compliant** dengan TDD 08 caching matrix.

### 9.5 Repository Implementation Pattern (TDD 05 §2.2)

**TDD spec example:**
```dart
@override
Future<Result<List<BannerEntity>>> getBanners() async {
  try {
    final remote = await _remote.getBanners();
    await _local.cacheBanners(remote);
    return Success(remote);
  } on NetworkException {
    final cached = await _local.getCachedBanners();
    if (cached != null) return Success(cached);
    return Failure(FailureCode.networkError, '...');
  }
}
```

**Implementation di `home_repository_impl.dart:22-35`:**
```dart
@override
Future<Result<List<BannerEntity>>> getBanners() async {
  try {
    final remote = await _remote.fetchBanners();
    await _local.cacheBanners(remote);
    return Result.success(remote.map((m) => m.toEntity()).toList());
  } catch (e) {                                    // ✅ catch-all, bukan on NetworkException
    final cached = _local.getCachedBanners();
    if (cached != null) {
      return Result.success(cached.map((m) => m.toEntity()).toList());
    }
    return Result.failure(const ErrorHandler().map(e));
  }
}
```

**Verdict: 95% compliant** — pattern sesuai, error mapping via `ErrorHandler.map()` (bukan inline mapping). TDD example lebih sederhana.

### 9.6 DI Registration (TDD 07 §5)

**TDD spec untuk Home:**

| Type | Annotation | Spec |
|---|---|---|
| `HomeRepository` (impl) | `@lazySingleton` | ✅ Implementation: `@Injectable(as: HomeRepository)` (default = lazySingleton) |
| `GetBannersUseCase` | `@injectable` | ✅ |
| `GetUpcomingUseCase` | `@injectable` | ✅ (name slightly different: `get_upcoming_appointment_usecase.dart`) |
| `GetSpecializationsUseCase` | `@injectable` | ✅ |
| `GetUserProfileUseCase` | `@injectable` | ✅ (extra, not in TDD list) |
| `HomeRemoteDataSource` | `@injectable` | ✅ |
| `HomeLocalDataSource` | `@injectable` | 🟡 Should be `@lazySingleton` (see below) |
| `HomeCubit` | `@factory` | N/A — implementation uses 4 cubits (deviation) |
| `GreetingCubit`, `BannerCubit`, `SpecializationCubit`, `UpcomingCubit` | `@injectable` (default factory) | ✅ |

**`HomeLocalDataSource` Lifecycle Bug:**

`home_local_datasource.dart:9-10`:
```dart
@injectable
class HomeLocalDataSource {
  final SharedPreferences _prefs;  // ← @singleton via register_module.dart
  ...
}
```

`@injectable` default = `@factory` (new instance per inject). Tapi `SharedPreferences` adalah `@singleton` (dari `register_module.dart`). Setiap `HomeLocalDataSource` baru akan hold reference ke `SharedPreferences` yang sama — functionally aman, tapi **boros memory** karena instance baru tiap kali di-resolve.

Sebaiknya `@lazySingleton` karena stateless (cuma wraps `SharedPreferences`).

---

## 10. TDD Routing vs Implementasi

### 10.1 Branch 0 — Home (TDD 03 §2.1)

**TDD spec:**
```
StatefulShellRoute.indexedStack
├── Branch 0: /home  → HomePage  ✅
├── Branch 1: /loc   → LocPage
├── Branch 2: /booking-history → BookingHistoryPage
└── Branch 3: /profile → ProfilePage
```

**Implementation `app_router.dart:146-187`:** ✅ 100% match. Branch 0 = HomePage, path `/home`.

### 10.2 AppShell (TDD 03 §2.2)

**TDD spec example:**
```dart
Scaffold(
  body: navigationShell,
  bottomNavigationBar: BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
      ...
    ],
  ),
);
```

**Implementation `lib/widgets/app_shell.dart`:**
- `AppShell` → `NavigationShell` wrapper
- Scaffold body = `consumer` (= navigationShell) ✅
- BottomNavigationBar 4 item dengan Iconsax icons ✅
- Tab labels: Home, **Loc**, History, Profile ✅
- `type: BottomNavigationBarType.fixed` ✅
- `selectedItemColor: AppTheme.primary` ✅
- `unselectedItemColor: AppTheme.grey400` ✅

**Verdict: 100% compliant** (lebih baik dari TDD example dengan color customization).

### 10.3 Redirect Guard (TDD 03 §3.2 + BUG-001)

**TDD spec untuk authenticated state:**
```dart
case AppStatus.authenticated:
  return (isAuthRoute || loc == '/onboarding') ? '/home' : null;
```

**Implementation `app_router.dart:93-97`:**
```dart
if (status == AppStatus.authenticated) {
  final isOnAuthOrOnboarding = loc == RoutePaths.onboarding || isOnAuthRoute;
  if (isOnAuthOrOnboarding) return RoutePaths.home;
  return null;
}
```

**Verdict: 100% compliant** + extra `profileIncomplete` state (per `app_status.dart:14-19`) untuk handle BUG-001 fix.

### 10.4 Edge Case Routes

| TDD Spec Route | Implementation Path | File:Line | Verdict |
|---|---|---|:---:|
| `/home` | `/home` | `app_router.dart:153` | ✅ |
| `/doctor/search` (push) | `/doctor/search` | `app_router.dart:193` | ✅ |
| `/doctor/:doctorId` (push) | `/doctor/:doctorId` | `app_router.dart:198` | ✅ |
| `/booking-history/:appointmentId` | `/booking-history/:appointmentId` | `app_router.dart:224` | ✅ |
| `/profile/notifications` | `/profile/notifications` | `app_router.dart:245` | ✅ |
| `/no-internet` | `/no-internet` | `app_router.dart:269` | ✅ |

---

## 11. TDD Caching vs Implementasi

### 11.1 Cache Matrix (TDD 08 §2)

| Data | TDD Spec | Implementation | Verdict |
|---|---|---|:---:|
| Onboarding status | Permanent, SharedPref | N/A di Home | 🟢 |
| Auth session | Until expiry, Supabase SDK | N/A | 🟢 |
| User profile | Session, SharedPref | **TIDAK di-cache** | 🔴 |
| Specializations | 7 hari, SharedPref JSON | 7 hari, SharedPref JSON | ✅ |
| Banners | 5 menit, SharedPref JSON | 5 menit, SharedPref JSON | ✅ |
| Doctor list | No cache | N/A | 🟢 |
| Slots | No cache | N/A | 🟢 |
| Appointments | No cache | N/A | 🟢 |

### 11.2 Cache Implementation (TDD 08 §3)

**TDD spec pattern:**
```dart
Future<void> setWithTtl(String key, String value, Duration maxAge) async {
  await _prefs.setString(key, value);
  await _prefs.setString('${key}_saved_at', DateTime.now().toIso8601String());
}
```

**Implementation `home_local_datasource.dart:25-26, 54-55`:**
```dart
await _prefs.setString(_bannersKey, jsonEncode(json));
await _prefs.setInt(_bannersTimeKey, DateTime.now().millisecondsSinceEpoch);
//                                  ^^^                 ^^^
//                                "time" suffix     int millis (bukan ISO string)
```

| Aspect | TDD Spec | Implementation | Verdict |
|---|---|---|:---:|
| Suffix naming | `${key}_saved_at` | `${key}_time` | 🟡 Naming deviation |
| Format | `DateTime.toIso8601String()` | `millisecondsSinceEpoch` (int) | 🟡 Different format |
| Functional | Parse with `DateTime.parse()` | Parse with `DateTime.fromMillisecondsSinceEpoch()` | 🟡 Works, different |

**Verdict: functionally compliant, naming deviates.** TDD tidak strict soal format, hanya TTL logic.

### 11.3 CacheService Singleton (TDD 08 §3)

**TDD spec:** `core/services/cache_service.dart` dengan `@lazySingleton`.

**Implementation:** `lib/core/services/cache_service.dart` exists (per `sprint_progress.md` §6). Home feature **tidak pakai** `CacheService` — implement ulang inline di `HomeLocalDataSource`. Inkonsistensi (ada 2 pattern cache di codebase).

**Verdict:** 🟡 Duplikasi pattern. Sebaiknya `HomeLocalDataSource` pakai `CacheService` generic.

### 11.4 Cache Invalidation (TDD 08 §4)

| TDD Trigger | Implementation | Verdict |
|---|---|:---:|
| User logout | (not implemented in HomeLocalDataSource) | 🟡 |
| Pull to refresh | (no pull-to-refresh) | N/A |
| Booking berhasil | (UpcomingCubit only reloads on GreetingLoaded trigger) | 🟡 |
| Appointment dibatalkan | (no listener) | 🟡 |
| `clearAll()` method | `home_local_datasource.dart:74-79` exists | ✅ |

---

## 12. TDD Error Handling vs Implementasi

### 12.1 Result Pattern (TDD 01 §4.3 + TDD 06)

**TDD spec:**
```dart
sealed class Result<T> { ... }
final class Success<T> extends Result<T> { final T data; ... }
final class Failure<T> extends Result<T> {
  final FailureCode code;
  final String message;
  final int? statusCode;
  ...
}
```

**Implementation `lib/core/network/result.dart:3-23`:**
```dart
sealed class Result<T> { ... }
final class Success<T> extends Result<T> { final T data; ... }
final class Failure<T> extends Result<T> {
  const Failure(this.code, this.message, [this.exception]);
  final String code;        // ← 🔴 String, bukan FailureCode enum
  final String message;
  final Object? exception;
}
```

| Aspect | TDD Spec | Implementation | Verdict |
|---|---|---|:---:|
| Sealed | ✅ | ✅ | ✅ |
| Success<T> | ✅ | ✅ | ✅ |
| Failure<T> | ✅ | ✅ | ✅ |
| `code: FailureCode` enum | ✅ | 🔴 `code: String` (= `FailureCode.name`) | 🔴 |
| `message: String` | ✅ | ✅ | ✅ |
| `statusCode: int?` | ✅ | ❌ TIDAK ADA | 🔴 |
| `exception: Object?` | ❌ | ✅ (extra) | 🟢 |

**Dampak:** GreetingCubit perlu `code == FailureCode.notFound.name` (greeting_cubit.dart:32) — string comparison. TDD expectation: `code == FailureCode.notFound` (enum compare). Lebih aman + type-safe pakai enum.

### 12.2 ApiException (TDD 06 §2.2)

**TDD spec:**
```dart
class ApiException implements Exception {
  final int statusCode;
  final String code;       // 'SLOT_ALREADY_BOOKED', etc
  final String message;
  final Map<String, dynamic>? details;
  ...
}
```

**Implementation `lib/core/network/api_exception.dart:3-18`:**
```dart
class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.response,
  });

  final FailureCode code;   // ← enum, bukan String
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? response;
  ...
}
```

**Verdict:** Lebih baik dari TDD (pakai enum). Tapi TDD tidak update. Inkonsistensi: ApiException pakai `FailureCode` (enum), tapi `Result.Failure.code` pakai `String`. Konversi di `result.dart:9`: `Failure(e.code.name, e.message, e)` — copy `.name` ke String.

**Rekomendasi:** Ubah `Result.Failure.code` ke `FailureCode` enum (back to TDD spec), update `HomeRepositoryImpl` yang return `Result.failure(const ApiException(...))` untuk handle accordingly.

### 12.3 ErrorHandler (TDD 01 §7.3 + TDD 06 §3)

**TDD spec pattern:**
```dart
class ErrorHandler {
  static Failure mapToFailure(Object error) {
    return switch (error) {
      ApiException(:final code, :final message) => ...,
      NetworkException _ => Failure(networkError, '...'),
      _ => Failure(unknown, '...'),
    };
  }
}
```

**Implementation `lib/core/network/error_handler.dart`:**
- `const ErrorHandler()` constructor (bukan static)
- `map(Object error)` returns `ApiException` (bukan `Failure`)
- Handles: PostgrestException, AuthException, StorageException, TimeoutException, SocketException, HttpException
- Status code mapping per type

**Verdict: 85% compliant** — covers more exception types than TDD, but returns ApiException not Failure (deviation). TDD §3 (ErrorHandler.handleWithAuthCheck) **NOT implemented** (no auto-logout on 401).

### 12.4 Global Error Handler dengan Auth Check (TDD 06 §3)

**TDD spec:**
```dart
static Future<Failure> handleWithAuthCheck(
  Object error,
  AppServices appServices,
) async {
  final failure = handle(error);
  if (failure.code == FailureCode.unauthorized) {
    await appServices.logout();
  }
  return failure;
}
```

**Implementation:** TIDAK ADA method `handleWithAuthCheck()`. Implikasi: 401 dari Supabase tidak auto-logout. Manual handling diperlukan di setiap Cubit (yang saat ini TIDAK dilakukan — Cubit hanya emit Error state, tidak trigger logout).

**Verdict: 🔴 Missing.** Risk: token expired silently → user bingung kenapa data tidak update.

### 12.5 Retry Strategy (TDD 06 §6)

**TDD spec:** `withRetry<T>` dengan exponential backoff untuk network error.

**Implementation:** TIDAK ADA.

**Verdict: 🔴 Missing.**

### 12.6 Error State Handling di Home Cubits

| Cubit | Handles Failure? | Verdict |
|---|---|:---:|
| `GreetingCubit` | `case Failure<UserProfileEntity>(:final code):` → emit GreetingNoProfile/GreetingError | ✅ |
| `BannerCubit` | `case Failure<List<BannerEntity>>(): emit(BannerError)` | ✅ |
| `SpecializationCubit` | `case Failure<List<SpecializationEntity>>(): emit(SpecializationError)` | ✅ |
| `UpcomingCubit` | `case Failure<UpcomingAppointmentEntity?>(): emit(UpcomingError)` | ✅ |

Tapi TIDAK ADA widget yang consume `*Error` state. `BlocSelector` hanya extract data dari `*Loaded`, fallback ke default saat state lain. **Error ditampilkan secara implisit** (tidak ada). 🟡 UX issue.

---

## 13. Deviation & Bug Catalog

### 13.1 Kritis (🔴 Blocker / Bug)

| # | Issue | File | Severity | Impact |
|---|---|---|:---:|---|
| K1 | **Search Bar tidak ada** | `home_page.dart` (missing) | 🔴 | PRD §6.2 + Wireframe 06 §2 + User Flow §5.1 + TDD 12 §4.18 semua mensyaratkan. User tidak bisa cari dokter dari Home. |
| K2 | **`getUpcoming` order wrong** | `home_remote_datasource.dart:38` | 🔴 | Order by `created_at DESC` bukan `doctor_slots.slot_date ASC`. Appointment baru dibuat akan muncul duluan, bukan yang tanggal slot-nya paling dekat. Mengubah semantic "upcoming". |
| K3 | **Slot date/time sebagai String** | `upcoming_appointment_entity.dart:9-11` | 🔴 | UI render raw `"2026-06-15 • 09:00:00"`. Tidak match wireframe spec `"15 Jun 2026 • 09:00"`. Butuh `DateTime` + `TimeOfDay` + formatter. |
| K4 | **Homepage import `supabase_flutter` langsung** | `home_page.dart:6, 33` | 🔴 | Violation TDD 01 §3.3 dependency rule. Presentation layer tahu data layer concern. |

### 13.2 Medium (🟡 Functional Issue)

| # | Issue | File | Severity | Impact |
|---|---|---|:---:|---|
| M1 | **Notification count hardcoded 5** | `greeting_section.dart:30` | 🟡 | Badge selalu 5, tidak sync dengan inbox. |
| M2 | **Route `:bookingId` vs `:appointmentId` mismatch** | `route_paths.dart:22` | 🟡 | Path param naming tidak konsisten. UpcomingCard workaround pakai `replaceAll`. |
| M3 | **`BookingStatus.firstWhere` unsafe fallback** | `upcoming_card.dart:41-44` | 🟡 | Fallback ke `pending` tanpa warning jika server kirim value baru. Pakai `@JsonValue` enum mapping. |
| M4 | **Home Models tidak pakai `@freezed`** | `home/data/model/*.dart` (4 files) | 🟡 | Inkonsisten dengan Doctor/Booking. Manual `fromJson/toJson` + no `@JsonKey`. |
| M5 | **Nearby Medical Centers hilang** | (deferred per `06-home-todo.md` §D.1) | 🟡 | Wireframe 06 §6 + ERD §8 + API §5.5 + TDD 12 Fase 9.5 schedule, tapi belum diimplementasi. |
| M6 | **Empty state CTA copy mismatch** | `upcoming_card.dart:173` | 🟡 | Wireframe/PRD: "Cari Dokter". Code: "Book Appointment". |
| M7 | **Result.Failure.code type: String** | `result.dart:18` | 🟡 | TDD 01 §4.3 spec: `FailureCode` enum. Cubit pakai `FailureCode.notFound.name` workaround. |
| M8 | **HomeLocalDataSource @injectable (factory)** | `home_local_datasource.dart:9` | 🟡 | Stateless wrapper, seharusnya `@lazySingleton`. |
| M9 | **Quick Categories icon hardcoded fallback** | `quick_categories.dart:110-121` | 🟡 | 6 dari 8 kategori fallback ke `Iconsax.user`. Butuh icon mapping table atau pakai `icon_url` dari DB. |
| M10 | **User profile tidak di-cache** | (no cache impl) | 🟡 | TDD 08 §2 spec: session cache. Setiap buka Home selalu remote call. |
| M11 | **Cache key naming deviation** | `home_local_datasource.dart:19, 47` | 🟡 | TDD 08 §3: `${key}_saved_at`. Implementation: `${key}_time`. |
| M12 | **CacheService tidak dipakai oleh Home** | (duplication) | 🟡 | `CacheService` generic exists di `core/services/`, Home punya impl sendiri. |
| M13 | **HomeLocalDataSource cache invalidation incomplete** | `home_local_datasource.dart:74-79` | 🟡 | `clearAll()` ada tapi tidak dipanggil dari logout/booking flow. |
| M14 | **No error UI untuk `*Error` states** | `home_page.dart` BlocSelector | 🟡 | Error emitted tapi tidak ada snackbar/dialog/retry. User silent failure. |
| M15 | **ErrorHandler tidak auto-logout on 401** | (missing `handleWithAuthCheck`) | 🟡 | Token expired silent. |
| M16 | **No retry policy** | (missing `withRetry`) | 🟡 | Transient network error langsung fail. |
| M17 | **Bottom nav "History" pakai `Iconsax.calendar`** | `app_shell.dart:41` | 🟡 | PRD icon untuk History = `📋`. Saat ini pakai `calendar` (lebih cocok untuk "Booking" mungkin). Minor. |

### 13.3 Low (🟢 Polish)

| # | Issue | File | Severity | Impact |
|---|---|---|:---:|---|
| L1 | **No pull-to-refresh** | (missing `RefreshIndicator`) | 🟢 | Wireframe 06 §"Pull To Refresh" eksplisit. |
| L2 | **No skeleton/shimmer loader** | (deferred) | 🟢 | TDD 12 §4.17. Saat ini `SizedBox.shrink()` saat loading — blank. |
| L3 | **No profile photo di Greeting** | `greeting_section.dart` | 🟢 | PRD §6.2 minta "foto profil kecil di kanan atas". Saat ini hanya bell. |
| L4 | **`GreetingCubit` tidak di-inject `SupabaseClient`** | `greeting_cubit.dart` | 🟢 | Auth id disupply dari HomePage (violation). Sebaiknya Cubit inject Supabase. |
| L5 | **Notification route pakai hardcoded path** | `app_router.dart:310, 312, 317` | 🟢 | Beberapa pakai `RoutePaths.xxx`, beberapa hardcoded `/booking-history/...`. |
| L6 | **`home_bloc_index.dart` redundant re-export** | `home/presentation/bloc/home_bloc_index.dart` | 🟢 | TDD tidak spec. File ini hanya re-export, bisa dihapus atau dipakai untuk barrel pattern. |
| L7 | **Empty banner placeholder icon `Iconsax.gallery`** | `banner_carousel.dart:111` | 🟢 | Hardcoded icon saat image null. Bisa lebih variatif. |
| L8 | **Banner `actionUrl` tidak ada validasi scheme** | `banner_carousel.dart:89` | 🟢 | `context.push(banner.actionUrl!)` — bisa navigate ke URL eksternal tanpa validasi `http://` vs internal. |
| L9 | **4 cubit instead of 1 HomeCubit** | TDD 04 §4.6 vs impl | 🟢 | TDD sebut 1 HomeCubit. Implementation pakai 4 cubit. Deviation yang sah. |
| L10 | **BookingStatus enum tidak pakai `@JsonValue`** | `booking_status.dart:1-6` | 🟢 | Aman saat ini karena pakai `BookingStatus.values.firstWhere(...name)`. Future-proof issue. |
| L11 | **GreetingBlocListener guard double-fire risk** | `home_page.dart:67-69` | 🟢 | `setProfileIncomplete` idempotent (per doc), tapi `notifyListeners()` di AppServices bisa trigger router redirect re-evaluasi. Monitor performance. |
| L12 | **`WidgetsBinding.instance.addPostFrameCallback` di build** | `banner_carousel.dart:51-53` | 🟢 | Anti-pattern: side-effect di build. `_startAutoScroll` di-dispatch tiap rebuild. |

---

## 14. TODO Sprint 2 (Actionable)

### 14.1 P0 (Wajib sebelum release)

| # | Task | File Target | Estimasi | Owner |
|---|---|---|---|---|
| 1 | **Tambah Search Bar widget** di HomePage (di bawah GreetingSection, di atas BannerCarousel) | `home_page.dart` + `lib/features/home/presentation/widget/search_bar.dart` (new) | 4 jam | Frontend |
| 2 | **Fix `getUpcoming` order** jadi `order=doctor_slots.slot_date.asc` atau fallback sort di Dart | `home_remote_datasource.dart:30-44` | 1 jam | Backend/Frontend |
| 3 | **Convert slot date/time ke `DateTime` + `TimeOfDay`** dengan `@DateOnlyJsonConverter` + `@TimeOnlyJsonConverter`; update formatter untuk UI | `upcoming_appointment_model.dart` + `date_formatter.dart` | 3 jam | Frontend |
| 4 | **Fix `BookingStatus.firstWhere` unsafe fallback** → pakai `@JsonValue` + converter | `booking_status.dart` + `upcoming_appointment_model.dart` + `upcoming_card.dart` | 1 jam | Frontend |
| 5 | **Fix route path param mismatch** `:bookingId` → `:appointmentId` di `route_paths.dart` | `route_paths.dart:22` | 15 menit | Frontend |

### 14.2 P1 (Sprint 2, Sprint 3)

| # | Task | File Target | Estimasi | Owner |
|---|---|---|---|---|
| 6 | **Refactor Home Models** ke `@freezed` + `@JsonKey` per-field | 4 files di `home/data/model/` | 4 jam | Frontend |
| 7 | **Implement Nearby Medical Centers** section dengan `get_nearby_clinics` RPC | `home/data/model/clinic_model.dart` (new) + `home/data/datasource/home_remote_datasource.dart` + `home/domain/usecase/get_nearby_clinics_usecase.dart` (new) + `NearbyFacilities` widget (new) + 1 cubit (new) + `facility_detail_page.dart` (new) | 16 jam (per TDD 12 Fase 9.5) | Frontend + Backend |
| 8 | **Add pull-to-refresh** dengan `RefreshIndicator` di HomePage | `home_page.dart` | 2 jam | Frontend |
| 9 | **Add skeleton/shimmer loader** per section | 4 widget files | 4 jam | Frontend |
| 10 | **Fix HomePage import SupabaseClient** violation: inject via `GreetingCubit` atau `AppServices` | `home_page.dart` + `greeting_cubit.dart` | 1 jam | Frontend |
| 11 | **Notification count dari API** (replace hardcoded 5) | `greeting_section.dart` + butuh endpoint | 2 jam | Frontend + Backend |
| 12 | **Empty state CTA copy** "Book Appointment" → "Cari Dokter" | `upcoming_card.dart:173` | 5 menit | Frontend |
| 13 | **Cache user profile** (TDD 08 §2 compliance) | `home_local_datasource.dart` | 1 jam | Frontend |
| 14 | **Use `CacheService` generic** instead of `HomeLocalDataSource` impl ulang | refactor 2 files | 2 jam | Frontend |
| 15 | **`HomeLocalDataSource` `@lazySingleton`** | `home_local_datasource.dart:9` | 5 menit | Frontend |
| 16 | **`Result.Failure.code` ke enum `FailureCode`** (TDD 01 compliance) | `result.dart` + 4 usecase files | 2 jam | Frontend |
| 17 | **Profile photo di Greeting** (PRD §6.2 compliance) | `greeting_section.dart` + `user_profile_entity.dart` add `photoUrl` | 2 jam | Frontend |
| 18 | **Implement `ErrorHandler.handleWithAuthCheck`** + wire to repositories | `error_handler.dart` + 4 repositories | 3 jam | Frontend |
| 19 | **Implement `withRetry`** + apply to Home remote calls | `lib/core/utils/retry.dart` (new) + 4 use cases | 3 jam | Frontend |

### 14.3 P2 (Backlog / Polish)

| # | Task | Estimasi |
|---|---|---|
| 20 | Error UI untuk `*Error` states (snackbar/dialog/retry) | 3 jam |
| 21 | Quick Categories icon mapping table (lookup by name) atau pakai `icon_url` exclusively | 2 jam |
| 22 | Validate `banner.actionUrl` scheme (http:// vs internal) | 1 jam |
| 23 | Fix `WidgetsBinding.instance.addPostFrameCallback` anti-pattern di BannerCarousel | 1 jam |
| 24 | Cache invalidation hook (logout, booking success, appointment cancel) | 2 jam |
| 25 | Use `RoutePaths.bookingDetail` di `app_router.dart:310, 312` (instead of hardcoded path) | 15 menit |
| 26 | Audit & fix Bottom Navigation icon (`Iconsax.calendar` vs `Iconsax.clipboard`?) | 30 menit |
| 27 | `GreetingBlocListener` refactor — extract guard logic ke `GreetingCubit` | 2 jam |
| 28 | Add `home_bloc_index.dart` rationale comment atau hapus jika tidak terpakai | 15 menit |
| 29 | Move `home_bloc_index.dart` ke barrel pattern atau hapus | 15 menit |
| 30 | Add unit + widget tests untuk Home (TDD 10 §5: 5 unit + 2 widget) | 12 jam |

### 14.4 Definition of Done — Home Page Fix

- [ ] K1 (Search Bar) implemented
- [ ] K2 (`getUpcoming` order) fixed
- [ ] K3 (slot date/time typing) fixed
- [ ] K4 (Supabase import violation) fixed
- [ ] M1 (notification count from API) implemented
- [ ] M2 (route path) fixed
- [ ] M3 (BookingStatus mapping) fixed
- [ ] M4 (freezed refactor) done
- [ ] M6 (empty state copy) fixed
- [ ] M16 (retry policy) implemented
- [ ] M14 (error UI) implemented
- [ ] L1 (pull-to-refresh) implemented
- [ ] L2 (skeleton loader) implemented
- [ ] `flutter analyze` 0 issues
- [ ] M5 (Nearby Medical Centers) implemented per TDD 12 Fase 9.5
- [ ] Minimal smoke test: Home → Search → Doctor Detail → Book → Home shows upcoming

---

## 15. Score Card

### 15.1 Per-Feature Score (Tech Lead Verdict)

| Kategori | Nilai | Verdict |
|---|:---:|:---:|
| **Functional Completeness** (vs wireframe) | 57% | 🟡 |
| **PRD Compliance** (§6.2 + edge cases) | 80% | 🟢 |
| **API Compliance** (4 endpoints) | 75% | 🟡 |
| **Architecture Compliance** (Clean Arch + DI) | 95% | 🟢 |
| **Code Quality** (lint + analyze) | 100% | 🟢 |
| **Test Coverage** | 0% | 🔴 (per AGENTS.md deferred) |
| **Documentation Sync** (sprint_progress.md) | 90% | 🟢 (sprint_progress klaim 100%, audit finds 80%) |
| **Defensive Programming** (BUG-001/FIX-7) | 100% | 🟢 |
| **Performance** (4 cubit parallel + cache) | 90% | 🟢 |
| **Total Weighted** | **~77%** | **🟡** |

### 15.2 Sprint 1 Status Update

`sprint_progress.md` §"Final Scoreboard" mengklaim Home = ✅ 100%. Audit ini merevisi:

> **Home feature: 🟡 80% COMPLETE** — solid foundation + 4 of 6 wireframe sections + 4 of 5 PRD requirements + 2 of 4 full API endpoints + 100% Clean Arch compliance. **2 section UI hilang (Search Bar, Nearby Medical Centers), 3 behavior PRD-mandated hilang (Skeleton, Pull-to-Refresh, Profile Photo), 4 critical bugs (slot date typing, getUpcoming order, Supabase import, route param mismatch).**

### 15.3 Rekomendasi

1. **Jangan claim Home 100% di sprint berikutnya** sampai K1-K4 + M1-M6 selesai.
2. **Block Sprint 2 release** sampai M5 (Nearby Medical Centers) selesai per TDD 12 Fase 9.5.
3. **Mulai test layer** (TDD 10 §5) paralel dengan fix — minimal smoke test untuk K1-K4.
4. **Update `sprint_progress.md` ke v1.4** dengan audit ini sebagai referensi.
5. **Hold Sprint 1 "CLOSED" status** sampai issue Kritis + Medium terselesaikan.
6. **Schedule architecture review** untuk K4 (Supabase import) — pattern ini mungkin replicate di fitur lain.

---

## Lampiran A — File yang Diaudit (28 files)

### Reference Documents (15 files)
- `docs/wireframe/06-home.md` ✅
- `docs/product/prd_health_pal.md` ✅
- `docs/erd/erd_healh_pal.md` ✅
- `docs/user_flow/USER_FLOW.md` ✅
- `docs/api_contract/api_contract_health_pal.md` ✅
- `docs/progress/sprint_progress.md` ✅
- `docs/audit/cto_executive_summary.md` ✅
- `docs/todo/06-home-todo.md` ✅
- `docs/tdd/01-arsitektur.md` ✅
- `docs/tdd/02-folder-structure.md` ✅
- `docs/tdd/03-routing-design.md` ✅
- `docs/tdd/04-state-management.md` ✅
- `docs/tdd/05-data-layer.md` ✅
- `docs/tdd/06-api-error-handling.md` ✅
- `docs/tdd/07-di-graph.md` ✅
- `docs/tdd/08-caching.md` ✅
- `docs/tdd/09-push-notification.md` ✅
- `docs/tdd/10-testing.md` ✅
- `docs/tdd/11-security-env.md` ✅
- `docs/tdd/12-task-breakdown.md` ✅

### Implementation Files (19 files)
- `lib/features/home/data/datasource/home_local_datasource.dart` ✅
- `lib/features/home/data/datasource/home_remote_datasource.dart` ✅
- `lib/features/home/data/model/banner_model.dart` ✅
- `lib/features/home/data/model/specialization_model.dart` ✅
- `lib/features/home/data/model/upcoming_appointment_model.dart` ✅
- `lib/features/home/data/model/user_profile_model.dart` ✅
- `lib/features/home/data/repository/home_repository_impl.dart` ✅
- `lib/features/home/domain/entity/banner_entity.dart` ✅
- `lib/features/home/domain/entity/specialization_entity.dart` ✅
- `lib/features/home/domain/entity/upcoming_appointment_entity.dart` ✅
- `lib/features/home/domain/entity/user_profile_entity.dart` ✅
- `lib/features/home/domain/repository/home_repository.dart` ✅
- `lib/features/home/domain/usecase/get_banners_usecase.dart` ✅
- `lib/features/home/domain/usecase/get_specializations_usecase.dart` ✅
- `lib/features/home/domain/usecase/get_upcoming_appointment_usecase.dart` ✅
- `lib/features/home/domain/usecase/get_user_profile_usecase.dart` ✅
- `lib/features/home/presentation/bloc/home_bloc_index.dart` ✅
- `lib/features/home/presentation/bloc/banner/{banner_cubit,banner_state}.dart` ✅
- `lib/features/home/presentation/bloc/greeting/{greeting_cubit,greeting_state}.dart` ✅
- `lib/features/home/presentation/bloc/specialization/{specialization_cubit,specialization_state}.dart` ✅
- `lib/features/home/presentation/bloc/upcoming/{upcoming_cubit,upcoming_state}.dart` ✅
- `lib/features/home/presentation/page/home_page.dart` ✅
- `lib/features/home/presentation/widget/banner_carousel.dart` ✅
- `lib/features/home/presentation/widget/greeting_section.dart` ✅
- `lib/features/home/presentation/widget/quick_categories.dart` ✅
- `lib/features/home/presentation/widget/upcoming_card.dart` ✅
- `lib/core/router/route_paths.dart` ✅
- `lib/core/router/app_router.dart` ✅
- `lib/core/network/{result,api_exception,error_handler}.dart` ✅
- `lib/core/enums/{app_status,booking_status,failure_code}.dart` ✅
- `lib/core/services/app_services.dart` ✅
- `lib/widgets/app_shell.dart` ✅
- `lib/preview/home/*_preview.dart` (4 files) ✅

### Excluded From Audit
- `lib/features/doctor/**` (referensi cross-cutting)
- `lib/features/booking/**` (referensi cross-cutting)
- `lib/features/auth/**` (referensi cross-cutting)
- `lib/features/loc/**` (referensi cross-cutting)
- `lib/features/profile/**` (referensi cross-cutting)
- `lib/features/settings/**` (tidak terkait Home)
- `lib/core/{theme,utils,di,constants}/*` (tidak terkait Home logic)

---

## Lampiran B — Cross-Reference Index

| Concept | Wireframe | PRD | ERD | API | User Flow | TDD |
|---|---|---|---|---|---|---|
| Greeting + nickname | 06 §1 | §6.2 | `user_profiles` | §3.1, §3.5 | §5.1 (bell) | §4.6, §4.13 |
| Search Bar | 06 §2 | §6.2 | — | §5.1 | §5.1 | §4.18 (Fase 4) |
| Banner Carousel | 06 §3 | §6.2 | `banners` | §7.1 | §5.1 (banner CTA) | §3.4 §2 |
| Upcoming Treatment | 06 §4 | §6.2 | `appointments` + `doctors` + `doctor_slots` | §6.5 | §5.1 (card tap) | §3.4, §4 |
| Categories | 06 §5 | §6.2 (opsional) | `specializations` | §4.1 | §5.1 (category tap) | §3.4 §2 |
| Nearby Medical | 06 §6 | — | `clinics` | §5.5 | — | Fase 9.5 |
| Bottom Nav | 06 (footer) | §5 | — | — | §5 | §3 §2.2 |
| Pull to Refresh | 06 §"Pull" | — | — | — | §5.1 | §12 §4 |
| Skeleton Loader | 06 §"Loading" | — | — | — | — | §12 §4.17 |
| Empty State | 06 §"Empty" | §6.2 | — | — | — | — |
| BUG-001/FIX-7 Guard | — | — | — | — | — | — (custom) |

---

*Disusun oleh Tech Lead (MiniMax-M3) · 15 Juni 2026 · v1.0*

**Status:** ✅ AUDIT COMPLETE — File ini tinggal dibaca dan di-acknowledge. Tidak ada kode yang diubah. Sprint 2 planning dapat mengacu ke TODO §14 sebagai backlog utama.
