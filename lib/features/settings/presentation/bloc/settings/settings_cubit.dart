// lib/features/settings/presentation/bloc/settings/settings_cubit.dart
//
// Cubit untuk Settings page.
// - loadSettings() → ambil preferensi dari SharedPrefService + email dari Supabase
// - toggleNotification(bool) → simpan ke SharedPrefs
// - toggleDarkMode(bool) → stub (tidak save, hanya update state)
// - logout() → delegate ke AppServices

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/services/app_services.dart';
import '../../../../../core/services/shared_prefs.dart';
import 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SharedPrefService _prefs;
  final AppServices _appServices;
  final SupabaseClient _supabase;

  SettingsCubit(this._prefs, this._appServices, this._supabase)
      : super(const SettingsInitial());

  Future<void> loadSettings() async {
    emit(const SettingsLoading());
    try {
      final email = _supabase.auth.currentSession?.user.email ?? '';
      final notifEnabled = _prefs.isNotifEnabled;
      emit(SettingsLoaded(
        notifEnabled: notifEnabled,
        darkMode: false,
        email: email,
      ));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> toggleNotification(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;
    emit(current.copyWith(notifEnabled: value));
    await _prefs.setNotifEnabled(value);
  }

  /// Stub: dark mode belum di-implement (v2). Hanya update state.
  void toggleDarkMode(bool value) {
    final current = state;
    if (current is! SettingsLoaded) return;
    emit(current.copyWith(darkMode: value));
  }

  Future<void> logout() async {
    await _appServices.logout();
  }
}
