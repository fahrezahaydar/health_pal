/// Status global aplikasi — sumber kebenaran routing.
///
/// Alur transisi:
///   loading → onboarding → unauthenticated → profileIncomplete → authenticated
///                                                ↑                    ↓
///                                                └────── (sign up) ───┘
///
/// - [loading]            : inisialisasi awal (sebelum [init] selesai)
/// - [onboarding]         : user baru pertama kali install
/// - [unauthenticated]    : tidak ada sesi Supabase / sesi expired
/// - [profileIncomplete]  : user sudah sign-in tapi `user_profiles.is_profile_complete = false`
///                          (sign-up baru, atau sign-in user lama yang belum lengkapi profil)
/// - [authenticated]      : sesi valid + profil lengkap
enum AppStatus {
  loading,
  onboarding,
  unauthenticated,
  profileIncomplete,
  authenticated,
}
