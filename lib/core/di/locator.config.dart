// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:health_pal/core/di/register_module.dart' as _i131;
import 'package:health_pal/core/router/app_router.dart' as _i934;
import 'package:health_pal/core/services/app_services.dart' as _i605;
import 'package:health_pal/core/services/cache_service.dart' as _i861;
import 'package:health_pal/core/services/fcm_service.dart' as _i357;
import 'package:health_pal/core/services/shared_prefs.dart' as _i167;
import 'package:health_pal/features/auth/data/datasource/auth_local_datasource.dart'
    as _i735;
import 'package:health_pal/features/auth/data/datasource/auth_remote_datasource.dart'
    as _i829;
import 'package:health_pal/features/auth/data/repository/auth_repository_impl.dart'
    as _i733;
import 'package:health_pal/features/auth/domain/repository/auth_repository.dart'
    as _i613;
import 'package:health_pal/features/auth/domain/usecase/create_profile_usecase.dart'
    as _i961;
import 'package:health_pal/features/auth/domain/usecase/forgot_password_usecase.dart'
    as _i957;
import 'package:health_pal/features/auth/domain/usecase/login_with_email_usecase.dart'
    as _i930;
import 'package:health_pal/features/auth/domain/usecase/register_and_create_profile_usecase.dart'
    as _i630;
import 'package:health_pal/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart'
    as _i730;
import 'package:health_pal/features/auth/presentation/bloc/forget_password/forget_password_state.dart'
    as _i1000;
import 'package:health_pal/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart'
    as _i544;
import 'package:health_pal/features/booking/data/datasource/booking_remote_datasource.dart'
    as _i482;
import 'package:health_pal/features/booking/data/repository/booking_repository_impl.dart'
    as _i79;
import 'package:health_pal/features/booking/domain/repository/booking_repository.dart'
    as _i163;
import 'package:health_pal/features/booking/domain/usecase/cancel_appointment_usecase.dart'
    as _i269;
import 'package:health_pal/features/booking/domain/usecase/create_appointment_usecase.dart'
    as _i149;
import 'package:health_pal/features/booking/domain/usecase/get_appointment_detail_usecase.dart'
    as _i597;
import 'package:health_pal/features/booking/domain/usecase/get_appointment_history_usecase.dart'
    as _i990;
import 'package:health_pal/features/booking/presentation/bloc/booking/booking_bloc.dart'
    as _i856;
import 'package:health_pal/features/booking/presentation/bloc/detail/booking_detail_cubit.dart'
    as _i851;
import 'package:health_pal/features/booking/presentation/bloc/history/booking_history_cubit.dart'
    as _i248;
import 'package:health_pal/features/doctor/data/datasource/doctor_remote_datasource.dart'
    as _i158;
import 'package:health_pal/features/doctor/data/repository/doctor_repository_impl.dart'
    as _i112;
import 'package:health_pal/features/doctor/domain/repository/doctor_repository.dart'
    as _i506;
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_detail_usecase.dart'
    as _i430;
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_schedules_usecase.dart'
    as _i1002;
import 'package:health_pal/features/doctor/domain/usecase/get_doctor_slots_usecase.dart'
    as _i151;
import 'package:health_pal/features/doctor/domain/usecase/get_doctors_usecase.dart'
    as _i146;
import 'package:health_pal/features/doctor/presentation/bloc/doctor_detail/doctor_detail_cubit.dart'
    as _i469;
import 'package:health_pal/features/doctor/presentation/bloc/search/search_cubit.dart'
    as _i401;
import 'package:health_pal/features/home/data/datasource/home_local_datasource.dart'
    as _i444;
import 'package:health_pal/features/home/data/datasource/home_remote_datasource.dart'
    as _i556;
import 'package:health_pal/features/home/data/repository/home_repository_impl.dart'
    as _i716;
import 'package:health_pal/features/home/domain/repository/home_repository.dart'
    as _i196;
import 'package:health_pal/features/home/domain/usecase/get_banners_usecase.dart'
    as _i446;
import 'package:health_pal/features/home/domain/usecase/get_specializations_usecase.dart'
    as _i262;
import 'package:health_pal/features/home/domain/usecase/get_upcoming_appointment_usecase.dart'
    as _i987;
import 'package:health_pal/features/home/domain/usecase/get_user_profile_usecase.dart'
    as _i511;
import 'package:health_pal/features/home/presentation/bloc/banner/banner_cubit.dart'
    as _i15;
import 'package:health_pal/features/home/presentation/bloc/greeting/greeting_cubit.dart'
    as _i365;
import 'package:health_pal/features/home/presentation/bloc/nearby/nearby_cubit.dart'
    as _i1068;
import 'package:health_pal/features/home/presentation/bloc/specialization/specialization_cubit.dart'
    as _i244;
import 'package:health_pal/features/home/presentation/bloc/upcoming/upcoming_cubit.dart'
    as _i272;
import 'package:health_pal/features/loc/data/datasource/loc_remote_datasource.dart'
    as _i1038;
import 'package:health_pal/features/loc/data/repository/loc_repository_impl.dart'
    as _i191;
import 'package:health_pal/features/loc/domain/repository/loc_repository.dart'
    as _i754;
import 'package:health_pal/features/loc/domain/usecase/get_nearby_clinics_usecase.dart'
    as _i995;
import 'package:health_pal/features/loc/presentation/bloc/loc_cubit.dart'
    as _i481;
import 'package:health_pal/features/onboarding/presentation/bloc/onboarding_notifier.dart'
    as _i913;
import 'package:health_pal/features/profile/data/datasource/profile_remote_datasource.dart'
    as _i340;
import 'package:health_pal/features/profile/data/repository/profile_repository_impl.dart'
    as _i85;
import 'package:health_pal/features/profile/domain/repository/profile_repository.dart'
    as _i572;
import 'package:health_pal/features/profile/domain/usecase/get_favorites_usecase.dart'
    as _i204;
import 'package:health_pal/features/profile/domain/usecase/get_notifications_usecase.dart'
    as _i411;
import 'package:health_pal/features/profile/domain/usecase/get_profile_usecase.dart'
    as _i399;
import 'package:health_pal/features/profile/domain/usecase/update_profile_usecase.dart'
    as _i289;
import 'package:health_pal/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart'
    as _i830;
import 'package:health_pal/features/profile/presentation/bloc/favorite/favorite_cubit.dart'
    as _i311;
import 'package:health_pal/features/profile/presentation/bloc/notification/notification_cubit.dart'
    as _i372;
import 'package:health_pal/features/profile/presentation/bloc/profile/profile_cubit.dart'
    as _i516;
import 'package:health_pal/features/settings/data/repository/settings_repository_impl.dart'
    as _i42;
import 'package:health_pal/features/settings/domain/repository/settings_repository.dart'
    as _i768;
import 'package:health_pal/features/settings/presentation/bloc/settings/settings_cubit.dart'
    as _i1053;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i357.FcmService>(
      () => _i357.FcmService(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i829.AuthRemoteDataSource>(
      () => _i829.AuthRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i482.BookingRemoteDataSource>(
      () => _i482.BookingRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i158.DoctorRemoteDataSource>(
      () => _i158.DoctorRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i556.HomeRemoteDataSource>(
      () => _i556.HomeRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i1038.LocRemoteDataSource>(
      () => _i1038.LocRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i340.ProfileRemoteDataSource>(
      () => _i340.ProfileRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i735.AuthLocalDataSource>(
      () => _i735.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i861.CacheService>(
      () => _i861.CacheService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i167.SharedPrefService>(
      () => _i167.SharedPrefService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i163.BookingRepository>(
      () => _i79.BookingRepositoryImpl(gh<_i482.BookingRemoteDataSource>()),
    );
    gh.factory<_i613.AuthRepository>(
      () => _i733.AuthRepositoryImpl(
        gh<_i829.AuthRemoteDataSource>(),
        gh<_i735.AuthLocalDataSource>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i506.DoctorRepository>(
      () => _i112.DoctorRepositoryImpl(gh<_i158.DoctorRemoteDataSource>()),
    );
    gh.lazySingleton<_i444.HomeLocalDataSource>(
      () => _i444.HomeLocalDataSource(gh<_i861.CacheService>()),
    );
    gh.factory<_i768.SettingsRepository>(
      () => _i42.SettingsRepositoryImpl(
        gh<_i454.SupabaseClient>(),
        gh<_i167.SharedPrefService>(),
        gh<_i861.CacheService>(),
        gh<_i444.HomeLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i605.AppServices>(
      () => _i605.AppServices(
        gh<_i167.SharedPrefService>(),
        gh<_i454.SupabaseClient>(),
        gh<_i613.AuthRepository>(),
        gh<_i444.HomeLocalDataSource>(),
      ),
    );
    gh.factory<_i572.ProfileRepository>(
      () => _i85.ProfileRepositoryImpl(gh<_i340.ProfileRemoteDataSource>()),
    );
    gh.factory<_i754.LocRepository>(
      () => _i191.LocRepositoryImpl(gh<_i1038.LocRemoteDataSource>()),
    );
    gh.factory<_i913.OnboardingNotifier>(
      () => _i913.OnboardingNotifier(gh<_i605.AppServices>()),
    );
    gh.lazySingleton<_i934.AppRouter>(
      () => _i934.AppRouter(gh<_i605.AppServices>()),
    );
    gh.factory<_i204.GetFavoritesUseCase>(
      () => _i204.GetFavoritesUseCase(gh<_i572.ProfileRepository>()),
    );
    gh.factory<_i411.GetNotificationsUseCase>(
      () => _i411.GetNotificationsUseCase(gh<_i572.ProfileRepository>()),
    );
    gh.factory<_i411.MarkNotificationAsReadUseCase>(
      () => _i411.MarkNotificationAsReadUseCase(gh<_i572.ProfileRepository>()),
    );
    gh.factory<_i399.GetProfileUseCase>(
      () => _i399.GetProfileUseCase(gh<_i572.ProfileRepository>()),
    );
    gh.factory<_i289.UpdateProfileUseCase>(
      () => _i289.UpdateProfileUseCase(gh<_i572.ProfileRepository>()),
    );
    gh.factory<_i289.UploadAvatarUseCase>(
      () => _i289.UploadAvatarUseCase(gh<_i572.ProfileRepository>()),
    );
    gh.factory<_i430.GetDoctorDetailUseCase>(
      () => _i430.GetDoctorDetailUseCase(gh<_i506.DoctorRepository>()),
    );
    gh.factory<_i1002.GetDoctorSchedulesUseCase>(
      () => _i1002.GetDoctorSchedulesUseCase(gh<_i506.DoctorRepository>()),
    );
    gh.factory<_i151.GetDoctorSlotsUseCase>(
      () => _i151.GetDoctorSlotsUseCase(gh<_i506.DoctorRepository>()),
    );
    gh.factory<_i146.GetDoctorsUseCase>(
      () => _i146.GetDoctorsUseCase(gh<_i506.DoctorRepository>()),
    );
    gh.factory<_i269.CancelAppointmentUseCase>(
      () => _i269.CancelAppointmentUseCase(gh<_i163.BookingRepository>()),
    );
    gh.factory<_i149.CreateAppointmentUseCase>(
      () => _i149.CreateAppointmentUseCase(gh<_i163.BookingRepository>()),
    );
    gh.factory<_i597.GetAppointmentDetailUseCase>(
      () => _i597.GetAppointmentDetailUseCase(gh<_i163.BookingRepository>()),
    );
    gh.factory<_i990.GetAppointmentHistoryUseCase>(
      () => _i990.GetAppointmentHistoryUseCase(gh<_i163.BookingRepository>()),
    );
    gh.factory<_i856.BookingBloc>(
      () => _i856.BookingBloc(
        gh<_i151.GetDoctorSlotsUseCase>(),
        gh<_i149.CreateAppointmentUseCase>(),
      ),
    );
    gh.factory<_i372.NotificationCubit>(
      () => _i372.NotificationCubit(gh<_i411.GetNotificationsUseCase>()),
    );
    gh.factory<_i995.GetNearbyClinicsUseCase>(
      () => _i995.GetNearbyClinicsUseCase(gh<_i754.LocRepository>()),
    );
    gh.factory<_i830.EditProfileCubit>(
      () => _i830.EditProfileCubit(
        gh<_i399.GetProfileUseCase>(),
        gh<_i289.UpdateProfileUseCase>(),
        gh<_i289.UploadAvatarUseCase>(),
      ),
    );
    gh.factory<_i196.HomeRepository>(
      () => _i716.HomeRepositoryImpl(
        gh<_i556.HomeRemoteDataSource>(),
        gh<_i444.HomeLocalDataSource>(),
        gh<_i605.AppServices>(),
      ),
    );
    gh.factory<_i851.BookingDetailCubit>(
      () => _i851.BookingDetailCubit(
        gh<_i597.GetAppointmentDetailUseCase>(),
        gh<_i269.CancelAppointmentUseCase>(),
      ),
    );
    gh.factory<_i961.CreateProfileUseCase>(
      () => _i961.CreateProfileUseCase(gh<_i613.AuthRepository>()),
    );
    gh.factory<_i957.ForgotPasswordUseCase>(
      () => _i957.ForgotPasswordUseCase(gh<_i613.AuthRepository>()),
    );
    gh.factory<_i930.LoginWithEmailUseCase>(
      () => _i930.LoginWithEmailUseCase(gh<_i613.AuthRepository>()),
    );
    gh.factory<_i630.RegisterAndCreateProfileUseCase>(
      () => _i630.RegisterAndCreateProfileUseCase(gh<_i613.AuthRepository>()),
    );
    gh.factory<_i544.SignInCubit>(
      () => _i544.SignInCubit(gh<_i930.LoginWithEmailUseCase>()),
    );
    gh.factory<_i1053.SettingsCubit>(
      () => _i1053.SettingsCubit(
        gh<_i768.SettingsRepository>(),
        gh<_i605.AppServices>(),
      ),
    );
    gh.factory<_i469.DoctorDetailCubit>(
      () => _i469.DoctorDetailCubit(
        gh<_i430.GetDoctorDetailUseCase>(),
        gh<_i1002.GetDoctorSchedulesUseCase>(),
      ),
    );
    gh.factory<_i516.ProfileCubit>(
      () => _i516.ProfileCubit(
        gh<_i399.GetProfileUseCase>(),
        gh<_i605.AppServices>(),
      ),
    );
    gh.factoryParam<_i730.CreateProfileCubit, _i730.CreateProfileArgs, dynamic>(
      (args, _) => _i730.CreateProfileCubit(
        gh<_i630.RegisterAndCreateProfileUseCase>(),
        gh<_i961.CreateProfileUseCase>(),
        args,
      ),
    );
    gh.factory<_i1000.ForgotPasswordCubit>(
      () => _i1000.ForgotPasswordCubit(gh<_i957.ForgotPasswordUseCase>()),
    );
    gh.factory<_i248.BookingHistoryCubit>(
      () => _i248.BookingHistoryCubit(gh<_i990.GetAppointmentHistoryUseCase>()),
    );
    gh.factory<_i446.GetBannersUseCase>(
      () => _i446.GetBannersUseCase(gh<_i196.HomeRepository>()),
    );
    gh.factory<_i262.GetSpecializationsUseCase>(
      () => _i262.GetSpecializationsUseCase(gh<_i196.HomeRepository>()),
    );
    gh.factory<_i987.GetUpcomingAppointmentUseCase>(
      () => _i987.GetUpcomingAppointmentUseCase(gh<_i196.HomeRepository>()),
    );
    gh.factory<_i511.GetUserProfileUseCase>(
      () => _i511.GetUserProfileUseCase(gh<_i196.HomeRepository>()),
    );
    gh.factory<_i1068.NearbyCubit>(
      () => _i1068.NearbyCubit(gh<_i995.GetNearbyClinicsUseCase>()),
    );
    gh.factory<_i481.LocCubit>(
      () => _i481.LocCubit(gh<_i995.GetNearbyClinicsUseCase>()),
    );
    gh.factory<_i311.FavoriteCubit>(
      () => _i311.FavoriteCubit(gh<_i204.GetFavoritesUseCase>()),
    );
    gh.factoryParam<_i401.SearchCubit, String?, dynamic>(
      (specializationId, _) => _i401.SearchCubit(
        gh<_i146.GetDoctorsUseCase>(),
        gh<_i262.GetSpecializationsUseCase>(),
        specializationId,
      ),
    );
    gh.factory<_i244.SpecializationCubit>(
      () => _i244.SpecializationCubit(gh<_i262.GetSpecializationsUseCase>()),
    );
    gh.factory<_i15.BannerCubit>(
      () => _i15.BannerCubit(gh<_i446.GetBannersUseCase>()),
    );
    gh.factory<_i272.UpcomingCubit>(
      () => _i272.UpcomingCubit(gh<_i987.GetUpcomingAppointmentUseCase>()),
    );
    gh.factory<_i365.GreetingCubit>(
      () => _i365.GreetingCubit(gh<_i511.GetUserProfileUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i131.RegisterModule {}
