import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../enums/app_status.dart';
import 'shared_prefs.dart';

/// Pengendali status global aplikasi.
///
/// Alur status (sumber kebenaran = sesi Supabase):
///   loading → onboarding → unauthenticated → authenticated
///                                              ↓ (session expired)
///                                       unauthenticated
///
/// Dipakai oleh GoRouter sebagai `refreshListenable` — setiap perubahan
/// status memicu router re-evaluasi redirect.
@lazySingleton
class AppServices extends ChangeNotifier {
  final SharedPrefService prefs;
  final SupabaseClient _supabaseClient;

  AppServices(this.prefs, this._supabaseClient);

  AppStatus _status = AppStatus.loading;
  AppStatus get status => _status;

  /// Inisialisasi awal — dipanggil SEBELUM runApp().
  ///
  /// Keputusan routing:
  /// 1. onboarding flag di SharedPreferences → masih di onboarding page
  /// 2. Supabase currentSession == null         → unauthenticated
  /// 3. Supabase session.isExpired              → force logout
  /// 4. else                                    → authenticated
  Future<void> init() async {
    _supabaseClient.auth.onAuthStateChange.listen(_onAuthStateChange);

    if (!prefs.isOnboardingDone) {
      _updateStatus(AppStatus.onboarding);
      return;
    }

    final session = _supabaseClient.auth.currentSession;
    if (session == null) {
      _updateStatus(AppStatus.unauthenticated);
      return;
    }

    if (session.isExpired) {
      await _handleSessionExpired();
      return;
    }

    _updateStatus(AppStatus.authenticated);
  }

  void _onAuthStateChange(AuthState data) {
    switch (data.event) {
      case AuthChangeEvent.signedOut:
        // Trigger lebih awal: status = unauthenticated, bersihkan cache.
        // Idempotent terhadap logout() / _handleSessionExpired() yang
        // mungkin dipanggil dari caller yang sama.
        _updateStatus(AppStatus.unauthenticated);
        // ignore: discarded_futures
        prefs.clearAuth();
        break;

      case AuthChangeEvent.tokenRefreshed:
        // Sesi masih valid, trigger router refresh agar
        // redirect re-evaluasi expiry.
        notifyListeners();
        break;

      case AuthChangeEvent.signedIn:
        if (_status != AppStatus.authenticated) {
          _updateStatus(AppStatus.authenticated);
        }
        break;

      default:
        break;
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
    try {
      await _supabaseClient.auth.signOut();
    } catch (_) {
      // best-effort
    }
    await prefs.clearAuth();
    _updateStatus(AppStatus.unauthenticated);
  }

  /// Dipanggil saat sesi Supabase terdeteksi expired (di init() awal
  /// atau dari global error handler). Sign out + bersihkan cache lokal.
  Future<void> _handleSessionExpired() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (_) {
      // best-effort
    }
    await prefs.clearAuth();
    _updateStatus(AppStatus.unauthenticated);
  }

  void _updateStatus(AppStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }
}
