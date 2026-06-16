// Sprint 3 — S3.4: Implementasi SettingsRepository.
// Data layer — satu-satunya layer yang menyentuh SupabaseClient + SharedPrefService.
// Ini memastikan presentation layer (SettingsCubit) tidak bergantung langsung
// ke package:supabase_flutter (fix K3 — sama seperti A4 di Home).

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/shared_prefs.dart';
import '../../domain/repository/settings_repository.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SupabaseClient _supabase;
  final SharedPrefService _prefs;

  SettingsRepositoryImpl(this._supabase, this._prefs);

  @override
  String? getEmail() =>
      _supabase.auth.currentSession?.user.email;

  @override
  bool isNotifEnabled() => _prefs.isNotifEnabled;

  @override
  Future<void> setNotifEnabled(bool value) =>
      _prefs.setNotifEnabled(value);
}
