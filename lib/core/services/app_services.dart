import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/domain/entity/user_entity.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../enums/app_status.dart';
import '../network/result.dart';
import 'shared_prefs.dart';

/// Pengendali status global aplikasi.
///
/// Alur status (sumber kebenaran = sesi Supabase + is_profile_complete):
///   loading → onboarding → unauthenticated ─┬─→ profileIncomplete → authenticated
///                                          │             ↑
///                                          │   (sign up) │
///                                          └─────────────┘
///                                          ↓ (session expired)
///                                       unauthenticated
///
/// Dipakai oleh GoRouter sebagai `refreshListenable` — setiap perubahan
/// status memicu router re-evaluasi redirect.
@lazySingleton
class AppServices extends ChangeNotifier {
  final SharedPrefService prefs;
  final SupabaseClient _supabaseClient;
  final AuthRepository _authRepository;

  AppServices(this.prefs, this._supabaseClient, this._authRepository);

  AppStatus _status = AppStatus.loading;
  AppStatus get status => _status;

  /// Inisialisasi awal — dipanggil SEBELUM runApp().
  ///
  /// Keputusan routing:
  /// 1. onboarding flag di SharedPreferences     → onboarding
  /// 2. Supabase currentSession == null            → unauthenticated
  /// 3. Supabase session.isExpired                 → force logout (→ unauthenticated)
  /// 4. user.isProfileComplete == false            → profileIncomplete
  /// 5. else                                       → authenticated
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

    await _setStatusFromProfile();
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
        // Fetch profile untuk tentukan status — JANGAN langsung
        // authenticated (lihat BUG-001-B: sign-up baru bisa
        // is_profile_complete = false).
        // ignore: discarded_futures
        _setStatusFromProfile();
        break;

      default:
        // initialSession / userUpdated / passwordRecovery /
        // mfaChallengeVerified / userDeleted: no-op.
        break;
    }
  }

  /// Fetch profil user via [AuthRepository.getCurrentUser] dan set status
  /// berdasarkan `isProfileComplete`.
  ///
  /// - `Success(user)` dengan `isProfileComplete = true`  → authenticated
  /// - `Success(user)` dengan `isProfileComplete = false` → profileIncomplete
  /// - `Failure` (network/cache miss)                     → authenticated
  ///   (session Supabase valid; defer profile check ke API call berikutnya)
  Future<void> _setStatusFromProfile() async {
    final result = await _authRepository.getCurrentUser();
    switch (result) {
      case Success<UserEntity>(:final data):
        _updateStatus(
          data.isProfileComplete
              ? AppStatus.authenticated
              : AppStatus.profileIncomplete,
        );
      case Failure<UserEntity>():
        _updateStatus(AppStatus.authenticated);
    }
  }

  /// Dipanggil dari `CreateProfilePage` listener setelah profile disimpan
  /// dengan `is_profile_complete: true` di DB. Transisi
  /// `profileIncomplete` → `authenticated` dan trigger router refresh.
  void markProfileComplete() {
    if (_status == AppStatus.profileIncomplete) {
      _updateStatus(AppStatus.authenticated);
    }
  }

  /// Set status ke [AppStatus.profileIncomplete].
  ///
  /// Dipanggil dari `SignUpPage` listener sebagai safety belt sebelum
  /// `context.go(createProfile)`. Idealnya status sudah diset oleh
  /// `_setStatusFromProfile()` di event handler async, tapi explicit
  /// call di sini memastikan tidak ada celah waktu di mana status
  /// masih `unauthenticated` saat user navigate (misalnya via deep
  /// link ke /home). Idempotent: jika status sudah `profileIncomplete`,
  /// call ini no-op.
  void setProfileIncomplete() {
    _updateStatus(AppStatus.profileIncomplete);
  }

  Future<void> completeOnboarding() async {
    await prefs.setOnboardingDone(true);
    _updateStatus(AppStatus.unauthenticated);
  }

  /// Set status ke [AppStatus.authenticated] dan simpan cache hint.
  ///
  /// Dipanggil dari `LoginPage` listener setelah sign-in dengan profile
  /// lengkap. TIDAK dipanggil untuk profile incomplete (lihat FIX-5)
  /// karena akan konflik dengan `_setStatusFromProfile()` di event
  /// handler yang lebih authoritative.
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
