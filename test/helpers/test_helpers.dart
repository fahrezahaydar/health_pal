// test/helpers/test_helpers.dart
//
// Shared helper utilities untuk semua test di health_pal.
// Berisi: factory untuk Entity/Model, helper untuk BLoC/Cubit, dan
// common matcher functions.
//
// Referensi: docs/tdd/10-testing.md §7 (Test Organization)

import 'package:health_pal/core/enums/booking_status.dart';
import 'package:health_pal/core/enums/gender.dart';
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
  static UserEntity mockUser({
    String? id,
    String? email,
    String? fullName,
    Gender? gender,
  }) {
    return UserEntity(
      id: id ?? 'user-test-123',
      email: email ?? 'test@example.com',
      fullName: fullName ?? 'Test User',
      gender: gender ?? Gender.male,
      nickname: 'Tester',
      photoUrl: null,
      dateOfBirth: DateTime(1990, 1, 1),
    );
  }

  // ── Banner (Home) ──
  static BannerEntity mockBanner({
    String? id,
    String? title,
    String? imageUrl,
    int? displayOrder,
  }) {
    return BannerEntity(
      id: id ?? 'banner-test-1',
      title: title ?? 'Test Promo',
      imageUrl: imageUrl ?? 'https://example.com/banner.jpg',
      actionUrl: null,
      displayOrder: displayOrder ?? 1,
      isActive: true,
      startsAt: null,
      endsAt: null,
    );
  }

  // ── Specialization (Home) ──
  static SpecializationEntity mockSpecialization({
    String? id,
    String? name,
  }) {
    return SpecializationEntity(
      id: id ?? 'spec-test-1',
      name: name ?? 'Umum',
      iconUrl: 'https://example.com/icon.png',
    );
  }

  // ── Upcoming Appointment (Home) ──
  static UpcomingAppointmentEntity? mockUpcoming({
    bool isNull = false,
  }) {
    if (isNull) return null;
    return UpcomingAppointmentEntity(
      id: 'appt-test-1',
      patientId: 'user-test-123',
      doctorId: 'doc-test-1',
      slotId: 'slot-test-1',
      status: BookingStatus.upcoming,
      complaintNote: 'Sakit kepala',
      consultationFeeSnapshot: 150000.0,
      bookedAt: DateTime(2026, 6, 1),
      confirmedAt: DateTime(2026, 6, 2),
      completedAt: null,
      cancelledAt: null,
      doctorName: 'dr. Test',
      doctorPhotoUrl: null,
      doctorSpecializationName: 'Umum',
      slotDate: DateTime(2026, 6, 15),
      slotStartHour: 9,
      slotStartMinute: 0,
      slotEndHour: 9,
      slotEndMinute: 30,
    );
  }

  // ── User Profile (Home) ──
  static UserProfileEntity mockUserProfile({
    String? id,
    String? nickname,
    bool? isProfileComplete,
  }) {
    return UserProfileEntity(
      id: id ?? 'profile-test-1',
      authId: 'user-test-123',
      fullName: 'Test User',
      nickname: nickname ?? 'Tester',
      avatarUrl: null,
      dateOfBirth: DateTime(1990, 1, 1),
      gender: Gender.male,
      notifReminderEnabled: true,
      isProfileComplete: isProfileComplete ?? true,
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
Future<void> waitForLoading({Duration duration = const Duration(milliseconds: 100)}) {
  return Future<void>.delayed(duration);
}
