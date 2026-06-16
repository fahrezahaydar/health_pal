// Sprint 3 — S3.4: Implementasi SettingsRepository.
// Data layer — satu-satunya layer yang menyentuh SupabaseClient + SharedPrefService.
// Ini memastikan presentation layer (SettingsCubit) tidak bergantung langsung
// ke package:supabase_flutter (fix K3 — sama seperti A4 di Home).

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/cache_service.dart';
import '../../../../../core/services/shared_prefs.dart';
import '../../../../features/home/data/datasource/home_local_datasource.dart';
import '../../domain/repository/settings_repository.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SupabaseClient _supabase;
  final SharedPrefService _prefs;
  final CacheService _cache;
  final HomeLocalDataSource _homeLocal;

  SettingsRepositoryImpl(
    this._supabase,
    this._prefs,
    this._cache,
    this._homeLocal,
  );

  @override
  String? getEmail() =>
      _supabase.auth.currentSession?.user.email;

  @override
  bool isNotifEnabled() => _prefs.isNotifEnabled;

  @override
  Future<void> setNotifEnabled(bool value) =>
      _prefs.setNotifEnabled(value);

  @override
  Future<void> clearCache() => _homeLocal.clearAll();

  @override
  Future<void> clearLocalData() async {
    await _cache.clear();
    await _homeLocal.clearAll();
  }
}
