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
    gh.lazySingleton<_i357.FcmService>(
      () => _i357.FcmService(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i861.CacheService>(
      () => _i861.CacheService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i167.SharedPrefService>(
      () => _i167.SharedPrefService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i605.AppServices>(
      () => _i605.AppServices(gh<_i167.SharedPrefService>()),
    );
    gh.lazySingleton<_i934.AppRouter>(
      () => _i934.AppRouter(gh<_i605.AppServices>()),
    );
    gh.factory<_i913.OnboardingNotifier>(
      () => _i913.OnboardingNotifier(gh<_i605.AppServices>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i131.RegisterModule {}
