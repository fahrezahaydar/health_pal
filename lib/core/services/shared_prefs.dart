import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPrefService {
  final SharedPreferences _prefs;
  SharedPrefService(this._prefs);

  static const _onboardingKey = 'onboarding_done';
  static const _loginKey = 'is_logged_in';
  static const _loginTimeKey = 'login_timestamp';

  // -- Onboarding
  bool get isOnboardingDone =>
      _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingDone(bool value) =>
      _prefs.setBool(_onboardingKey, value);

  // -- Login flag
  bool get isLoggedIn =>
      _prefs.getBool(_loginKey) ?? false;

  Future<void> setLoggedIn(bool value) =>
      _prefs.setBool(_loginKey, value);

  // -- Login timestamp (epoch millis)
  int? get loginTimestamp {
    final raw = _prefs.getInt(_loginTimeKey);
    return raw;
  }

  Future<void> setLoginTimestamp(int millis) =>
      _prefs.setInt(_loginTimeKey, millis);

  Future<void> clearLoginTimestamp() =>
      _prefs.remove(_loginTimeKey);

  // -- Bulk clear auth
  Future<void> clearAuth() async {
    await setLoggedIn(false);
    await clearLoginTimestamp();
  }
}
