// Sprint 3 — S3.4: hapus ketergantungan langsung ke SupabaseClient.
// Sekarang via SettingsRepository (data layer). Sama seperti fix A4 di Home.
//
// SettingsCubit untuk Settings page.
// - loadSettings() → ambil preferensi dari SettingsRepository + AppServices
// - toggleNotification(bool) → simpan via repository
// - toggleDarkMode(bool) → stub (tidak save, hanya update state)
// - logout() → delegate ke AppServices

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/services/app_services.dart';
import '../../../domain/repository/settings_repository.dart';
import 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  final AppServices _appServices;

  SettingsCubit(this._repository, this._appServices)
      : super(const SettingsInitial());

  Future<void> loadSettings() async {
    emit(const SettingsLoading());
    try {
      emit(SettingsLoaded(
        notifEnabled: _repository.isNotifEnabled(),
        darkMode: false,
        email: _repository.getEmail() ?? '',
      ));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> toggleNotification(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;
    emit(current.copyWith(notifEnabled: value));
    await _repository.setNotifEnabled(value);
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
