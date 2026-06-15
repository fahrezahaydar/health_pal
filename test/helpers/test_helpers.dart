// test/helpers/test_helpers.dart
//
// Shared helper utilities untuk semua test di health_pal.
// Berisi: factory untuk Entity, helper untuk BLoC/Cubit, dan
// common matcher functions.
//
// PENTING: Constructor signature HARUS match dengan entity class asli.
// Selalu rujuk ke file entity saat menulis factory.

import 'package:flutter/material.dart' show TimeOfDay;

import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/home/domain/entity/banner_entity.dart';
import 'package:health_pal/features/home/domain/entity/specialization_entity.dart';
import 'package:health_pal/features/home/domain/entity/upcoming_appointment_entity.dart';
import 'package:health_pal/features/home/domain/entity/user_profile_entity.dart';

// ══════════════════════════════════════════════════════════════════
//   ENTITY FACTORIES
//   Pakai pattern: TestData.entityName({overrides})
// ══════════════════════════════════════════════════════════════════

class TestData {
  TestData._();

  // ── User (Auth) ──
  // Signature HARUS match UserEntity constructor di
  // lib/features/auth/domain/entity/user_entity.dart
  static UserEntity mockUser({
    String? id,
    String? authId,
    String? email,
    String? fullName,
    String? nickname,
    String? gender,
    bool? isProfileComplete,
  }) {
    return UserEntity(
      id: id ?? 'user-test-123',
      authId: authId ?? 'auth-test-123',
      email: email ?? 'test@example.com',
      fullName: fullName ?? 'Test User',
      nickname: nickname,
      avatarUrl: null,
      dateOfBirth: DateTime(1990, 1, 1),
      gender: gender,
      isProfileComplete: isProfileComplete ?? false,
    );
  }

  // ── Banner (Home) ──
  static BannerEntity mockBanner({
    String? id,
    String? title,
    String? imageUrl,
    int? displayOrder,
  }) {
    return const BannerEntity(
      id: 'banner-test-1',
      title: 'Test Promo',
    );
  }

  // ── Specialization (Home) ──
  static SpecializationEntity mockSpecialization({
    String? id,
    String? name,
    String? iconUrl,
  }) {
    return const SpecializationEntity(
      id: 'spec-test-1',
      name: 'Umum',
    );
  }

  // ── Upcoming Appointment (Home) ──
  // Sprint 2 — A3: slotDate (DateTime?), slotStart/slotEnd (TimeOfDay?)
  // (was String, per TDD 05 §3.2 + json_converters.dart). Test factory
  // harus match entity signature.
  static UpcomingAppointmentEntity? mockUpcoming({bool isNull = false}) {
    if (isNull) return null;
    return UpcomingAppointmentEntity(
      id: 'appt-test-1',
      doctorName: 'dr. Test',
      clinicName: 'Klinik Test',
      specializationName: 'Umum',
      slotDate: DateTime(2026, 6, 15),
      slotStart: const TimeOfDay(hour: 9, minute: 0),
      slotEnd: const TimeOfDay(hour: 9, minute: 30),
      status: 'upcoming',
    );
  }

  // ── User Profile (Home) — minimal entity ──
  static UserProfileEntity mockUserProfile({
    String? id,
    String? nickname,
  }) {
    return UserProfileEntity(
      id: id ?? 'profile-test-1',
      nickname: nickname ?? 'Tester',
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//   HELPER FUNCTIONS
// ══════════════════════════════════════════════════════════════════

/// Wait untuk Future microtask selesai (untuk debouncer / stream testing).
Future<void> waitForMicrotasks() async {
  await Future<void>.delayed(Duration.zero);
}

/// Wait untuk durasi spesifik (untuk loading state).
Future<void> waitForLoading({
  Duration duration = const Duration(milliseconds: 100),
}) {
  return Future<void>.delayed(duration);
}
