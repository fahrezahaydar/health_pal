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
- **Shimmer** — sudah di pubspec (buat skeleton loader)

### Catatan Penting
1. **Nearby Medical Centers** — `doctors-by-location` edge function belum dibuat, `google_maps_flutter` didefer ke Fase 9. Bagian ini bisa di-skip dulu atau pakai data dummy.
2. **HomePage saat ini** — masih stub (`Center(child: Text('Home Page'))`) dengan `MaterialApp` yang salah.
3. **Route `/home`** — sudah terdaftar sebagai Branch 0 StatefulShellRoute.
4. **Belum ada test** — folder `test/` tidak ada.

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
| **C** | **Presentation Layer (Cubit + Widgets)** | **🔄 On Going** |
| C.1 | HomeCubit + HomeState | ⬜ |
| C.2 | GreetingSection widget | ⬜ |
| C.3 | BannerCarousel widget | ⬜ |
| C.4 | UpcomingCard widget | ⬜ |
| C.5 | QuickCategories widget | ⬜ |
| C.6 | Rebuild HomePage | ⬜ |
| C.7 | DI Registration + flutter analyze | ⬜ |
| **D** | **Refinements (Ditunda)** | **⏸️ Ditunda** |
| D.1 | Nearby Medical Centers | ⏸️ |
| D.2 | SearchBar → /doctor/search | ⏸️ |
| D.3 | Shimmer/skeleton loader | ⏸️ |
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

### Blok C: Presentation Layer (Cubit + Widgets)

| # | Task | File | Keterangan |
|---|---|---|---|
| C.1 | `HomeCubit` + `HomeState` | `home/presentation/bloc/home_cubit.dart` | Load paralel (banners + upcoming + specializations + profile). State: `banners`, `upcoming`, `specializations`, `nickname`, `isLoading`, `error`. |
| C.2 | `GreetingSection` widget | `home/presentation/widget/greeting_section.dart` | "Halo, {nickname}!" + bell 🔔 → `/profile/notifications` |
| C.3 | `BannerCarousel` widget | `home/presentation/widget/banner_carousel.dart` | PageView + auto-scroll 5s + indicator dots |
| C.4 | `UpcomingCard` widget | `home/presentation/widget/upcoming_card.dart` | Card + empty state "No upcoming treatment" + CTA |
| C.5 | `QuickCategories` widget | `home/presentation/widget/quick_categories.dart` | Grid 2×4 specialization. Tap → `/doctor/search?specialization={id}` |
| C.6 | Rebuild `HomePage` | `home/presentation/page/home_page.dart` | Komposisi semua widget, hapus `MaterialApp` stub |
| C.7 | DI Registration + `flutter analyze` | `core/di/` | `dart run build_runner build`, 0 errors 0 warnings |

### Blok D: Refinements (Ditunda)

| # | Task | Prioritas | Catatan |
|---|---|---|---|
| D.1 | Nearby Medical Centers | **Low** | Butuh edge function + google_maps_flutter (Fase 9) |
| D.2 | SearchBar → /doctor/search | **Medium** | Search widget di home_page.dart |
| D.3 | Shimmer/skeleton loader | **Medium** | Pakai shimmer: ^3.0.0 |
| D.4 | Pull-to-refresh | **Medium** | RefreshIndicator reload semua section |

---

## Sequencing (Urutan Eksekusi)

```
A.1-A.6 ✅ (Models) → B.1-B.4 (Data + Domain) → B.5-B.7 (Use Cases) → C.1 (Cubit) → C.2-C.5 (Widgets) → C.6 (HomePage) → C.7 (DI + Analyze)
```
