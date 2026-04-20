import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPrefService {
  final SharedPreferences _prefs;
  SharedPrefService(this._prefs);

  static const _onboardingKey = 'onboarding_done';
  static const _loginKey = 'is_logged_in';

  bool get isOnboardingDone =>
      _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingDone(bool value) =>
      _prefs.setBool(_onboardingKey, value);

  bool get isLoggedIn =>
      _prefs.getBool(_loginKey) ?? false;

  Future<void> setLoggedIn(bool value) =>
      _prefs.setBool(_loginKey, value);
}