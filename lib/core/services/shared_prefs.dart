import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPrefService {
  final SharedPreferences _prefs;
  SharedPrefService(this._prefs);

  static const _onboardingKey = 'onboarding_done';
  static const _loginKey = 'is_logged_in';
  static const _notifEnabledKey = 'notif_enabled';

  // -- Onboarding
  bool get isOnboardingDone =>
      _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingDone(bool value) =>
      _prefs.setBool(_onboardingKey, value);

  // -- Login flag (cache hint — sumber kebenaran ada di Supabase session)
  bool get isLoggedIn =>
      _prefs.getBool(_loginKey) ?? false;

  Future<void> setLoggedIn(bool value) =>
      _prefs.setBool(_loginKey, value);

  // -- Bulk clear auth
  Future<void> clearAuth() async {
    await setLoggedIn(false);
  }

  // -- Notification preference (default: true)
  bool get isNotifEnabled =>
      _prefs.getBool(_notifEnabledKey) ?? true;

  Future<void> setNotifEnabled(bool value) =>
      _prefs.setBool(_notifEnabledKey, value);
}
