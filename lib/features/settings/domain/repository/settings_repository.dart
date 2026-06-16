// Sprint 3 — S3.4: Data layer untuk Settings.
// Memisahkan akses Supabase dan SharedPrefs dari presentation layer.

abstract class SettingsRepository {
  String? getEmail();

  bool isNotifEnabled();

  Future<void> setNotifEnabled(bool value, {String? authId});

  Future<void> clearCache();

  Future<void> clearLocalData();

  String? getEmergencyPhone();

  Future<void> setEmergencyPhone(String phone);
}
