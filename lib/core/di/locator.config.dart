// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

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
import 'package:health_pal/features/auth/domain/usecase/sign_up_usecase.dart'
    as _i722;
import 'package:health_pal/features/auth/presentation/bloc/create_profile/create_profile_cubit.dart'
    as _i730;
import 'package:health_pal/features/auth/presentation/bloc/forget_password/forget_password_state.dart'
    as _i1000;
import 'package:health_pal/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart'
    as _i685;
import 'package:health_pal/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart'
    as _i245;
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
import 'package:health_pal/features/home/presentation/bloc/specialization/specialization_cubit.dart'
    as _i244;
import 'package:health_pal/features/home/presentation/bloc/upcoming/upcoming_cubit.dart'
    as _i272;
import 'package:health_pal/features/onboarding/presentation/bloc/onboarding_notifier.dart'
    as _i913;
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
    gh.factory<_i735.AuthLocalDataSource>(
      () => _i735.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i444.HomeLocalDataSource>(
      () => _i444.HomeLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i861.CacheService>(
      () => _i861.CacheService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i167.SharedPrefService>(
      () => _i167.SharedPrefService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i357.FcmService>(
      () => _i357.FcmService(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i605.AppServices>(
      () => _i605.AppServices(
        gh<_i167.SharedPrefService>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i829.AuthRemoteDataSource>(
      () => _i829.AuthRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i556.HomeRemoteDataSource>(
      () => _i556.HomeRemoteDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i934.AppRouter>(
      () => _i934.AppRouter(gh<_i605.AppServices>()),
    );
    gh.factory<_i613.AuthRepository>(
      () => _i733.AuthRepositoryImpl(
        gh<_i829.AuthRemoteDataSource>(),
        gh<_i735.AuthLocalDataSource>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i913.OnboardingNotifier>(
      () => _i913.OnboardingNotifier(gh<_i605.AppServices>()),
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
    gh.factory<_i722.SignUpUseCase>(
      () => _i722.SignUpUseCase(gh<_i613.AuthRepository>()),
    );
    gh.factory<_i196.HomeRepository>(
      () => _i716.HomeRepositoryImpl(
        gh<_i556.HomeRemoteDataSource>(),
        gh<_i444.HomeLocalDataSource>(),
      ),
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
    gh.factory<_i244.SpecializationCubit>(
      () => _i244.SpecializationCubit(gh<_i262.GetSpecializationsUseCase>()),
    );
    gh.factory<_i1000.ForgotPasswordCubit>(
      () => _i1000.ForgotPasswordCubit(gh<_i957.ForgotPasswordUseCase>()),
    );
    gh.factory<_i245.SignUpBloc>(
      () => _i245.SignUpBloc(gh<_i722.SignUpUseCase>()),
    );
    gh.factory<_i15.BannerCubit>(
      () => _i15.BannerCubit(gh<_i446.GetBannersUseCase>()),
    );
    gh.factory<_i272.UpcomingCubit>(
      () => _i272.UpcomingCubit(gh<_i987.GetUpcomingAppointmentUseCase>()),
    );
    gh.factory<_i685.SignInBloc>(
      () => _i685.SignInBloc(gh<_i930.LoginWithEmailUseCase>()),
    );
    gh.factory<_i365.GreetingCubit>(
      () => _i365.GreetingCubit(gh<_i511.GetUserProfileUseCase>()),
    );
    gh.factory<_i730.CreateProfileCubit>(
      () => _i730.CreateProfileCubit(gh<_i961.CreateProfileUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i131.RegisterModule {}
