// test/helpers/mocks.dart
//
// Generated mock untuk semua Repository & DataSource di health_pal.
// Dijalankan sekali via: dart run build_runner build --force-jit
//
// Referensi: docs/tdd/10-testing.md §6 (Mock Strategy)
// Sprint B1 — T2: extend dengan 17 mock class tambahan (Booking/Loc/Profile
// Repository + DataSource + 7 Use Case + OnboardingNotifier deps).
//
// Total mock class: 11 (existing) + 17 (new) = 28 mock class.
//
// File ini berisi:
// - @GenerateNiceMocks untuk Auth (3) + Home (3) + Doctor (5) + Booking (5)
//   + Loc (2) + Profile (2) + Settings (1) + Use Case tambahan (7) = 28 mocks
// - Export helper class untuk akses cepat di test

import 'package:mockito/annotations.dart';

import 'package:health_pal/core/services/app_services.dart';
import 'package:health_pal/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:health_pal/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart';
import 'package:health_pal/features/booking/data/datasource/booking_remote_datasource.dart';
import 'package:health_pal/features/booking/domain/repository/booking_repository.dart';
import 'package:health_pal/features/booking/domain/usecase/cancel_appointment_usecase.dart';
import 'package:health_pal/features/booking/domain/usecase/create_appointment_usecase.dart';
import 'package:health_pal/features/booking/domain/usecase/get_appointment_detail_usecase.dart';
import 'package:health_pal/features/booking/domain/usecase/get_appointment_history_usecase.dart';
import 'package:health_pal/features/doctor/data/datasource/doctor_remote_datasource.dart';
import 'package:health_pal/features/doctor/domain/repository/doctor_repository.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_detail_usecase.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_slots_usecase.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctors_usecase.dart';
import 'package:health_pal/features/home/data/datasource/home_local_datasource.dart';
import 'package:health_pal/features/home/data/datasource/home_remote_datasource.dart';
import 'package:health_pal/features/home/domain/repository/home_repository.dart';
import 'package:health_pal/features/loc/data/datasource/loc_remote_datasource.dart';
import 'package:health_pal/features/loc/domain/repository/loc_repository.dart';
import 'package:health_pal/features/loc/domain/usecase/get_nearby_clinics_usecase.dart';
import 'package:health_pal/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:health_pal/features/profile/domain/repository/profile_repository.dart';
import 'package:health_pal/features/profile/domain/usecase/get_favorites_usecase.dart';
import 'package:health_pal/features/profile/domain/usecase/get_notifications_usecase.dart';
import 'package:health_pal/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:health_pal/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:health_pal/features/settings/domain/repository/settings_repository.dart';

@GenerateNiceMocks([
  // ── Auth (3 mocks) ──
  MockSpec<AuthRepository>(),
  MockSpec<AuthRemoteDataSource>(),
  MockSpec<AuthLocalDataSource>(),

  // ── Home (4 mocks) ──
  MockSpec<HomeRepository>(),
  MockSpec<HomeRemoteDataSource>(),
  MockSpec<HomeLocalDataSource>(),

  // ── Doctor (5 mocks) ──
  MockSpec<DoctorRepository>(),
  MockSpec<DoctorRemoteDataSource>(),
  MockSpec<GetDoctorsUseCase>(),
  MockSpec<GetDoctorDetailUseCase>(),
  MockSpec<GetDoctorSlotsUseCase>(),

  // ── Booking (5 mocks) ──
  MockSpec<BookingRepository>(),
  MockSpec<BookingRemoteDataSource>(),
  MockSpec<GetAppointmentHistoryUseCase>(),
  MockSpec<GetAppointmentDetailUseCase>(),
  MockSpec<CreateAppointmentUseCase>(),
  MockSpec<CancelAppointmentUseCase>(),

  // ── Loc (2 mocks) ──
  MockSpec<LocRepository>(),
  MockSpec<LocRemoteDataSource>(),

  // ── Profile (5 mocks) ──
  MockSpec<ProfileRepository>(),
  MockSpec<ProfileRemoteDataSource>(),
  MockSpec<GetProfileUseCase>(),
  MockSpec<UpdateProfileUseCase>(),
  MockSpec<GetNotificationsUseCase>(),
  MockSpec<GetFavoritesUseCase>(),

  // ── Settings (1 mock) ──
  MockSpec<SettingsRepository>(),

  // ── Cross-cutting (3 mocks) ──
  MockSpec<GetNearbyClinicsUseCase>(), // Loc
  MockSpec<AppServices>(), // Onboarding + Repository (logout callback)
])
void main() {}
