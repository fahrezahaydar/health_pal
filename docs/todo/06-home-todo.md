# Home Dashboard — Task Breakdown

> Referensi: `docs/wireframe/06-home.md`, `docs/user_flow/USER_FLOW.md` §5.1, `docs/api_contract/api_contract_health_pal.md`, `docs/tdd/12-task-breakdown.md` Fase 4, `docs/tdd/04-state-management.md`, `docs/tdd/05-data-layer.md`

## Ringkasan Analisis

### Wireframe Layout (06-home.md)
```
┌──────────────────────────────────────┐
│ Halo, {nickname}!          🔔 Notif  │  ← GreetingSection
│                                      │
│ ┌── Search Bar ───────────────────┐ │
│ │ 🔍 Search doctor, treatment... │ │
│ └─────────────────────────────────┘ │
│                                      │
│ ┌───── Banner Carousel ───────────┐ │
│ │ Image + CTA (auto-scroll 5s)    │ │
│ └─────────────────────────────────┘ │
│          ● ○ ○  (indicator)         │
│                                      │
│ Upcoming Treatment                   │
│ ┌── UpcomingCard ─────────────────┐ │
│ │ Dr. Budi, Dental Cleaning,       │ │
│ │ 15 Jun 2026 • 09:00,            │ │
│ │ Klinik Sehat Bersama            │ │
│ └─────────────────────────────────┘ │
│                                      │
│ Categories                 See All   │
│ ┌──── ──── ──── ──── ────────┐     │
│ │ 🦷 ❤️  🫁  🩺              │     │  ← 2×4 Grid
│ │ Dent Cardio Pulmo General  │     │
│ │ 🧠 🫃  🧪  💉              │     │
│ │ Neuro Gastro Lab Vaccine   │     │
│ └────────────────────────────┘     │
│                                      │
│ Nearby Medical Centers     See All   │
│ ┌────────┐ ┌────────┐               │  ← Horizontal list
│ │ Clinic │ │ Hospital│               │     (deferred — Fase 9)
│ └────────┘ └────────┘               │
│                                      │
│────── Bottom Nav (StatefulShell) ────│
│ Home | Explore | Booking | Profile   │
└──────────────────────────────────────┘
```

### User Flow (USER_FLOW.md §5.1)
| Trigger | Route | Aksi |
|---|---|---|
| Tap search bar / kategori | `/doctor/search?q=...` | Push ke DoctorSearchPage |
| Tap banner CTA | `banner.action_url` | Push ke target |
| Tap upcoming card | `/booking-history/:appointmentId` | Push ke BookingDetailPage |
| Tap category | `/doctor/search?specialization={id}` | Push dengan filter |
| Tap notification bell | `/profile/notifications` | Push ke NotificationPage |
| Pull-to-refresh | — | Reload semua section |
| Tap "Book Appointment" (empty state) | `/doctor/search` | Push |

### API Endpoints
| Data | Endpoint | Cache |
|---|---|---|
| Banners | `GET /rest/v1/banners?is_active=eq.true&...&order=display_order.asc` | 5 menit |
| Upcoming appointments | `GET /rest/v1/appointments?patient_id=eq.{id}&select=*,doctors(...),doctor_slots(...)&order=created_at.desc&limit=1` | Remote only |
| Specializations | `GET /rest/v1/specializations?select=*&order=name.asc` | 7 hari |
| User profile (greeting) | `GET /rest/v1/user_profiles?auth_id=eq.{uid}&select=*` | — |

### Dependensi
- **SupabaseClient** — sudah di DI
- **Supabase Auth session** — sudah (Fase 2 selesai)
- **Connectivity** — `connectivity_plus` sudah di pubspec
- **skeletonizer** — sudah di pubspec (reuse production widgets via `Skeletonizer(enabled:..., child:...)`). **shimmer: ^3.0.0 resmi DEPRECATED** per ADR Skeletonizer.

### Catatan Penting
1. **Nearby Medical Centers** — documented di `docs/todo/08-facility-todo.md`. PostgreSQL function `get_nearby_clinics` (Haversine), dependencies: `geolocator` + `google_maps_flutter`. Implementasi sebelum Push Notification (Fase 10).
2. **HomePage** — sudah pakai MultiBlocProvider 4 cubits, orchestrate load async: banners + specializations langsung, profile → dpt profileId → upcoming.
3. **Route `/home`** — sudah terdaftar sebagai Branch 0 StatefulShellRoute.
4. **BlocSelector** — tiap widget pakai `BlocSelector` biar hanya rebuild sesuai data yang dibutuhkan.
5. **Belum ada test** — folder `test/` tidak ada.

---

## Status Checklist

| Blok | Task | Status |
|---|---|---|
| **A** | **Data Layer (Models)** | **✅ Selesai** |
| A.1 | BannerEntity | ✅ |
| A.2 | BannerModel | ✅ |
| A.3 | UpcomingAppointmentEntity | ✅ |
| A.4 | UpcomingAppointmentModel | ✅ |
| A.5 | SpecializationEntity | ✅ |
| A.6 | SpecializationModel | ✅ |
| **B** | **Domain Layer (Repository + Use Cases)** | **✅ Selesai** |
| B.1 | HomeRepository interface | ✅ |
| B.2 | HomeRemoteDataSource | ✅ |
| B.3 | HomeLocalDataSource | ✅ |
| B.4 | HomeRepositoryImpl | ✅ |
| B.5 | GetBannersUseCase | ✅ |
| B.6 | GetUpcomingAppointmentUseCase | ✅ |
| B.7 | GetSpecializationsUseCase | ✅ |
| **C** | **Presentation Layer (Cubits + Widgets)** | **✅ Selesai** |
| C.1 | GreetingCubit + GreetingState | ✅ |
| C.2 | BannerCubit + BannerState | ✅ |
| C.3 | SpecializationCubit + SpecializationState | ✅ |
| C.4 | UpcomingCubit + UpcomingState | ✅ |
| C.5 | GreetingSection widget | ✅ |
| C.6 | BannerCarousel widget | ✅ |
| C.7 | UpcomingCard widget | ✅ |
| C.8 | QuickCategories widget | ✅ |
| C.9 | Rebuild HomePage (MultiBlocProvider) | ✅ |
| C.10 | DI Registration + flutter analyze | ✅ |
| **D** | **Refinements (Ditunda)** | **⏸️ Ditunda** |
| D.1 | Nearby Medical Centers | 📋 [08-facility-todo.md](08-facility-todo.md) — documented, awaiting implementation |
| D.2 | SearchBar → /doctor/search | ⏸️ |
| D.3 | Skeletonizer loader (reuse production widgets — NO dedicated skeleton files) | ⏸️ |
| D.4 | Pull-to-refresh | ⏸️ |

---

## Task Breakdown

### Blok A: Data Layer (Models)

| # | Task | File | Keterangan |
|---|---|---|---|
| A.1 | `BannerEntity` | `home/domain/entity/banner_entity.dart` | `id`, `title`, `imageUrl`, `actionUrl`, `displayOrder` |
| A.2 | `BannerModel` | `home/data/model/banner_model.dart` | fromJson/toJson + toEntity/fromEntity |
| A.3 | `UpcomingAppointmentEntity` | `home/domain/entity/upcoming_appointment_entity.dart` | `id`, `doctorName`, `doctorPhoto`, `clinicName`, `specializationName`, `slotDate`, `slotStart`, `slotEnd`, `status` |
| A.4 | `UpcomingAppointmentModel` | `home/data/model/upcoming_appointment_model.dart` | fromJson nested: `doctors{full_name,photo_url,clinics{name},specializations{name}}` + `doctor_slots{slot_date,slot_start,slot_end}` |
| A.5 | `SpecializationEntity` | `home/domain/entity/specialization_entity.dart` | `id`, `name`, `iconUrl` |
| A.6 | `SpecializationModel` | `home/data/model/specialization_model.dart` | fromJson/toJson + toEntity/fromEntity |

### Blok B: Domain Layer (Repository + Use Cases)

| # | Task | File | Keterangan |
|---|---|---|---|
| B.1 | `HomeRepository` interface | `home/domain/repository/home_repository.dart` | `getBanners()`, `getUpcoming(profileId)`, `getSpecializations()`, `getUserProfile(authId)` |
| B.2 | `HomeRemoteDataSource` | `home/data/datasource/home_remote_datasource.dart` | 4 method Supabase calls — @injectable |
| B.3 | `HomeLocalDataSource` | `home/data/datasource/home_local_datasource.dart` | Cache banners (5min), specializations (7 hari) di SharedPref |
| B.4 | `HomeRepositoryImpl` | `home/data/repository/home_repository_impl.dart` | Remote-first + cache fallback. @Injectable(as: HomeRepository) |
| B.5 | `GetBannersUseCase` | `home/domain/usecase/get_banners_usecase.dart` | @injectable |
| B.6 | `GetUpcomingAppointmentUseCase` | `home/domain/usecase/get_upcoming_appointment_usecase.dart` | @injectable |
| B.7 | `GetSpecializationsUseCase` | `home/domain/usecase/get_specializations_usecase.dart` | @injectable |

### Blok C: Presentation Layer (Cubits + Widgets)

| # | Task | File | Keterangan |
|---|---|---|---|
| C.1 | `GreetingCubit` + `GreetingState` | `home/presentation/bloc/greeting/` | **Sealed state**: `Initial`, `Loading`, `Loaded(nickname)`, `Error`. Pakai `GetUserProfileUseCase`. Return `profileId`. |
| C.2 | `BannerCubit` + `BannerState` | `home/presentation/bloc/banner/` | **Sealed state**: `Initial`, `Loading`, `Loaded(banners)`, `Error`. Pakai `GetBannersUseCase`. |
| C.3 | `SpecializationCubit` + `SpecializationState` | `home/presentation/bloc/specialization/` | **Sealed state**: `Initial`, `Loading`, `Loaded(specializations)`, `Error`. Pakai `GetSpecializationsUseCase`. |
| C.4 | `UpcomingCubit` + `UpcomingState` | `home/presentation/bloc/upcoming/` | **Sealed state**: `Initial`, `Loading`, `Loaded(upcoming?)`, `Error`. Pakai `GetUpcomingAppointmentUseCase`. |
| C.5 | `GreetingSection` widget | `home/presentation/widget/greeting_section.dart` | "Halo, {nickname}!" + bell 🔔 → `/profile/notifications`. BlocSelector: `.nickname`. |
| C.6 | `BannerCarousel` widget | `home/presentation/widget/banner_carousel.dart` | PageView + auto-scroll 5s + indicator dots. BlocSelector: `.banners`. |
| C.7 | `UpcomingCard` widget | `home/presentation/widget/upcoming_card.dart` | Card + empty state + CTA. BlocSelector: `.upcoming`. |
| C.8 | `QuickCategories` widget | `home/presentation/widget/quick_categories.dart` | Grid 2×4. BlocSelector: `.specializations`. Tap → `/doctor/search?specialization={id}` |
| C.9 | Rebuild `HomePage` | `home/presentation/page/home_page.dart` | MultiBlocProvider 4 cubits + orchestrate load. Load profile dulu → dpt profileId → trigger upcoming. |
| C.10 | DI Registration + `flutter analyze` | `core/di/` | `dart run build_runner build --force-jit`, 0 errors 0 warnings |

### Blok D: Refinements (Ditunda)

| # | Task | Prioritas | Catatan |
|---|---|---|---|
| D.1 | Nearby Medical Centers | **Low** | Butuh edge function + google_maps_flutter (Fase 9) |
| D.2 | SearchBar → /doctor/search | **Medium** | Search widget di home_page.dart |
| D.3 | Skeletonizer loader | **Medium** | Pakai `skeletonizer: ^1.4.0` — reuse production widgets via `Skeletonizer(enabled: ..., child: ...)`. shimmer DEPRECATED. |
| D.4 | Pull-to-refresh | **Medium** | RefreshIndicator reload semua section |

---

## Sequencing (Urutan Eksekusi)

```
A.1-A.6 ✅ (Models) → B.1-B.7 ✅ (Repo + Use Cases) → C.1-C.4 ✅ (4 Cubits) → C.5-C.8 (Widgets) → C.9 (HomePage) → C.10 (DI + Analyze)
```
