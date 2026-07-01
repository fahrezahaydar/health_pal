// D10-D19 — Batch cubit/bloc tests
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/result.dart';
import 'package:health_pal/features/auth/domain/entity/user_entity.dart';
import 'package:health_pal/features/booking/domain/entity/appointment_entity.dart';
import 'package:health_pal/features/booking/domain/usecase/create_appointment_usecase.dart';
import 'package:health_pal/features/booking/domain/usecase/get_appointment_detail_usecase.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_slots_usecase.dart';
import 'package:health_pal/features/booking/domain/usecase/get_appointment_history_usecase.dart';
import 'package:health_pal/features/booking/domain/usecase/cancel_appointment_usecase.dart';
import 'package:health_pal/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:health_pal/features/booking/presentation/bloc/booking/booking_event.dart';
import 'package:health_pal/features/booking/presentation/bloc/detail/booking_detail_cubit.dart';
import 'package:health_pal/features/booking/presentation/bloc/detail/booking_detail_state.dart';
import 'package:health_pal/features/booking/presentation/bloc/history/booking_history_cubit.dart';
import 'package:health_pal/features/booking/presentation/bloc/history/booking_history_state.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_slot_entity.dart';
import 'package:health_pal/features/doctor/domain/entity/doctor_schedule_entity.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_detail_usecase.dart';
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_schedules_usecase.dart';
import 'package:health_pal/features/doctor/presentation/bloc/doctor_detail/doctor_detail_cubit.dart';
import 'package:health_pal/features/doctor/presentation/bloc/doctor_detail/doctor_detail_state.dart';
import 'package:health_pal/features/profile/domain/entity/notification_entity.dart';
import 'package:health_pal/features/profile/domain/usecase/get_favorites_usecase.dart';
import 'package:health_pal/features/profile/domain/usecase/get_notifications_usecase.dart';
import 'package:health_pal/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:health_pal/features/profile/domain/usecase/update_profile_usecase.dart'; // includes UploadAvatarUseCase
import 'package:health_pal/features/profile/presentation/bloc/favorite/favorite_cubit.dart';
import 'package:health_pal/features/profile/presentation/bloc/favorite/favorite_state.dart';
import 'package:health_pal/features/profile/presentation/bloc/notification/notification_cubit.dart';
import 'package:health_pal/features/profile/presentation/bloc/notification/notification_state.dart';
import 'package:health_pal/features/profile/presentation/bloc/profile/profile_cubit.dart';
import 'package:health_pal/features/profile/presentation/bloc/profile/profile_state.dart';
import 'package:health_pal/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart';
import 'package:health_pal/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart';
import 'package:health_pal/features/settings/domain/repository/settings_repository.dart';
import 'package:health_pal/features/settings/presentation/bloc/settings/settings_cubit.dart';
import 'package:health_pal/features/settings/presentation/bloc/settings/settings_state.dart';
import 'package:health_pal/core/services/app_services.dart';

class _MD extends Mock implements GetDoctorDetailUseCase {}
class _MDS extends Mock implements GetDoctorSchedulesUseCase {}
class _MCA extends Mock implements CreateAppointmentUseCase {}
class _MGSlots extends Mock implements GetDoctorSlotsUseCase {}
class _MGD extends Mock implements GetAppointmentDetailUseCase {}
class _MCC extends Mock implements CancelAppointmentUseCase {}
class _MGH extends Mock implements GetAppointmentHistoryUseCase {}
class _MGPR extends Mock implements GetProfileUseCase {}
class _MUP extends Mock implements UpdateProfileUseCase {}
class _MUpload extends Mock implements UploadAvatarUseCase {}
class _MGN extends Mock implements GetNotificationsUseCase {}
class _MGF extends Mock implements GetFavoritesUseCase {}
class _MGR extends Mock implements SettingsRepository {}
class _MAppServices extends Mock implements AppServices {}

void main() {
  group('D10 DoctorDetailCubit', () {
    test('loadDetail success', () async {
      final d = _MD(); final s = _MDS(); final c = DoctorDetailCubit(d, s);
      when(() => d('d1')).thenAnswer((_) async => const Success(DoctorEntity(id:'d',clinicId:'c',specializationId:'s',fullName:'Dr',experienceYears:0,consultationFee:0)));
      when(() => s('d1')).thenAnswer((_) async => const Success(<DoctorScheduleEntity>[]));
      await c.loadDetail('d1');
      expect(c.state, isA<DoctorDetailLoaded>());
      c.close();
    });
    test('loadDetail error', () async {
      final d = _MD(); final s = _MDS(); final c = DoctorDetailCubit(d, s);
      when(() => d('d1')).thenAnswer((_) async => const Failure(FailureCode.serverError, 'err'));
      await c.loadDetail('d1');
      expect(c.state, isA<DoctorDetailError>());
      c.close();
    });
  });

  group('D11 BookingBloc', () {
    test('create success', () async {
      final slots = _MGSlots(); final create = _MCA();
      final b = BookingBloc(slots, create);
      when(() => slots(any(), any())).thenAnswer((_) async => const Success(<DoctorSlotEntity>[]));
      when(() => create(doctorId: any(named:'doctorId'), slotId: any(named:'slotId'), complaintNote: any(named:'complaintNote')))
          .thenAnswer((_) async => const Success(AppointmentEntity(id:'a',patientId:'p',doctorId:'d',slotId:'s',status:'pending',consultationFeeSnapshot:0)));
      b.add(const BookingInitialized(doctorId:'d1'));
      await Future.delayed(const Duration(milliseconds: 50));
      // Set slot + submit
      b.add(const BookingSlotSelected(slotId:'s1'));
      await Future.delayed(Duration.zero);
      b.add(const BookingSubmitted());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(b.state.isSubmitting, isFalse);
      b.close();
    });
  });

  group('D12 BookingDetailCubit', () {
    test('loadDetail success', () async {
      final g = _MGD(); final cc = _MCC(); final cubit = BookingDetailCubit(g, cc);
      when(() => g(patientId:any(named:'patientId'), appointmentId:any(named:'appointmentId')))
          .thenAnswer((_) async => const Success(AppointmentEntity(id:'a',patientId:'p',doctorId:'d',slotId:'s',status:'pending',consultationFeeSnapshot:0)));
      await cubit.loadDetail(patientId:'p1', appointmentId:'a1');
      expect(cubit.state, isA<BookingDetailLoaded>());
      cubit.close();
    });
  });

  group('D13 BookingHistoryCubit', () {
    test('loadHistory success', () async {
      final u = _MGH(); final c = BookingHistoryCubit(u);
      when(() => u(patientId:any(named:'patientId'), status:any(named:'status'), limit:any(named:'limit'), offset:any(named:'offset')))
          .thenAnswer((_) async => const Success(<AppointmentEntity>[]));
      await c.loadHistory('p1');
      expect(c.state, isA<BookingHistoryLoaded>());
      c.close();
    });
    test('loadHistory error', () async {
      final u = _MGH(); final c = BookingHistoryCubit(u);
      when(() => u(patientId:any(named:'patientId'), status:any(named:'status'), limit:any(named:'limit'), offset:any(named:'offset')))
          .thenAnswer((_) async => const Failure(FailureCode.serverError, 'err'));
      await c.loadHistory('p1');
      expect(c.state, isA<BookingHistoryError>());
      c.close();
    });
  });

  group('D14 LocCubit (skip — needs geolocator platform mock)', () {
    test('placeholder', () {});
  });

  group('D15 ProfileCubit (BUG-002-FIX-3)', () {
    test('loadProfile success', () async {
      final u = _MGPR(); final a = _MAppServices(); final c = ProfileCubit(u, a);
      when(() => u()).thenAnswer((_) async => const Success(UserEntity(id:'u',authId:'a',fullName:'T',email:'e@e.com')));
      await c.loadProfile();
      expect(c.state, isA<ProfileLoaded>());
      c.close();
    });
    test('loadProfile error (BUG-002-FIX-3)', () async {
      final u = _MGPR(); final a = _MAppServices(); final c = ProfileCubit(u, a);
      when(() => u()).thenAnswer((_) async => const Failure(FailureCode.serverError, 'err'));
      await c.loadProfile();
      expect(c.state, isA<ProfileError>());
      c.close();
    });
  });

  group('D16 EditProfileCubit', () {
    test('initial state', () {
      final g = _MGPR(); final u = _MUP(); final a = _MUpload();
      final c = EditProfileCubit(g, u, a);
      expect(c.state, isA<EditProfileInitial>());
      c.close();
    });
  });

  group('D17 NotificationCubit', () {
    test('load success', () async {
      final u = _MGN(); final c = NotificationCubit(u);
      when(() => u(userId:any(named:'userId'))).thenAnswer((_) async => const Success(<NotificationEntity>[]));
      await c.loadNotifications('u1');
      expect(c.state, isA<NotificationLoaded>());
      c.close();
    });
  });

  group('D18 FavoriteCubit', () {
    test('load success', () async {
      final u = _MGF(); final c = FavoriteCubit(u);
      when(() => u()).thenAnswer((_) async => const Success(<DoctorEntity>[]));
      await c.loadFavorites();
      expect(c.state, isA<FavoriteLoaded>());
      c.close();
    });
  });

  group('D19 SettingsCubit', () {
    test('loadSettings success', () async {
      final r = _MGR(); final a = _MAppServices(); final c = SettingsCubit(r, a);
      when(() => r.isNotifEnabled()).thenReturn(true);
      await c.loadSettings();
      expect(c.state, isA<SettingsLoaded>());
      c.close();
    });
  });
}
