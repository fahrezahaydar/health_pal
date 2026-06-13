// test/helpers/mocks.dart
//
// Generated mock untuk semua Repository & DataSource di health_pal.
// Dijalankan sekali via: dart run build_runner build --force-jit
//
// Referensi: docs/tdd/10-testing.md §6 (Mock Strategy)
//
// File ini berisi:
// - @GenerateNiceMocks untuk Auth (3) + Home (3) + Doctor (5) = 11 mocks
// - Export helper class untuk akses cepat di test

import 'package:mockito/annotations.dart';

import 'package:health_pal/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:health_pal/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart';
import 'package:health_pal/features/doctor/data/datasource/doctor_remote_datasource.dart';
import 'package:health_pal/features/doctor/domain/repository/doctor_repository.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_detail_usecase.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_slots_usecase.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctors_usecase.dart';
import 'package:health_pal/features/home/data/datasource/home_local_datasource.dart';
import 'package:health_pal/features/home/data/datasource/home_remote_datasource.dart';
import 'package:health_pal/features/home/domain/repository/home_repository.dart';

@GenerateNiceMocks([
  // ── Auth (3 mocks) ──
  MockSpec<AuthRepository>(),
  MockSpec<AuthRemoteDataSource>(),
  MockSpec<AuthLocalDataSource>(),

  // ── Home (3 mocks) ──
  MockSpec<HomeRepository>(),
  MockSpec<HomeRemoteDataSource>(),
  MockSpec<HomeLocalDataSource>(),

  // ── Doctor (5 mocks) ──
  MockSpec<DoctorRepository>(),
  MockSpec<DoctorRemoteDataSource>(),
  MockSpec<GetDoctorsUseCase>(),
  MockSpec<GetDoctorDetailUseCase>(),
  MockSpec<GetDoctorSlotsUseCase>(),
])
void main() {}
