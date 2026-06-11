import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_constants.dart';
import '../enums/app_status.dart';
import 'shared_prefs.dart';

@lazySingleton
class AppServices extends ChangeNotifier {
  final SharedPrefService prefs;
  final SupabaseClient _supabaseClient;

  AppServices(this.prefs, this._supabaseClient);

  AppStatus _status = AppStatus.loading;
  AppStatus get status => _status;

  Future<void> init() async {
    _supabaseClient.auth.onAuthStateChange.listen(_onAuthStateChange);

    final onboardingDone = prefs.isOnboardingDone;
    final isLoggedIn = prefs.isLoggedIn;

    if (!onboardingDone) {
      _updateStatus(AppStatus.onboarding);
      return;
    }

    if (isLoggedIn) {
      if (_isSessionExpired()) {
        await _forceLogout('Sesi habis, silakan login ulang');
        return;
      }
      _updateStatus(AppStatus.authenticated);
    } else {
      _updateStatus(AppStatus.unauthenticated);
    }
  }

  bool _isSessionExpired() {
    final loginTime = prefs.loginTimestamp;
    if (loginTime == null) return true;
    final elapsed =
        DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(loginTime));
    return elapsed > appSessionDuration;
  }

  void _onAuthStateChange(AuthState event) {
    if (event.event == AuthChangeEvent.signedOut) {
      if (_status == AppStatus.authenticated) {
        _updateStatus(AppStatus.unauthenticated);
      }
    }
  }

  Future<void> completeOnboarding() async {
    await prefs.setOnboardingDone(true);
    _updateStatus(AppStatus.unauthenticated);
  }

  Future<void> login() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setLoggedIn(true);
    await prefs.setLoginTimestamp(now);
    _updateStatus(AppStatus.authenticated);
  }

  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
    await _forceLogout(null);
  }

  Future<void> _forceLogout(String? message) async {
    await prefs.clearAuth();
    _updateStatus(AppStatus.unauthenticated);
  }

  void _updateStatus(AppStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }

}
