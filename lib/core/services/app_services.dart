import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import '../enums/app_status.dart';
import 'shared_prefs.dart';

@lazySingleton
class AppServices extends ChangeNotifier {
  final SharedPrefService prefs;

  AppServices(this.prefs);

  // Private state variable
  AppStatus _status = AppStatus.loading;

  // Getter to access status
  AppStatus get status => _status;

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final onboardingDone = prefs.isOnboardingDone;
    final isLoggedIn = prefs.isLoggedIn;

    if (!onboardingDone) {
      _updateStatus(AppStatus.onboarding);
    } else if (!isLoggedIn) {
      _updateStatus(AppStatus.unauthenticated);
    } else {
      _updateStatus(AppStatus.authenticated);
    }
  }

  Future<void> completeOnboarding() async {
    await prefs.setOnboardingDone(true);
    _updateStatus(AppStatus.unauthenticated);
  }

  Future<void> login() async {
    await prefs.setLoggedIn(true);
    _updateStatus(AppStatus.authenticated);
  }

  Future<void> logout() async {
    await prefs.setLoggedIn(false);
    _updateStatus(AppStatus.unauthenticated);
  }

  // Internal helper to change state and notify listeners
  void _updateStatus(AppStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners(); // This is what triggers GoRouter to refresh
  }
}