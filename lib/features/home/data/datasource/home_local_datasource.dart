import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../core/services/cache_service.dart';
import '../model/banner_model.dart';
import '../model/specialization_model.dart';
import '../model/user_profile_model.dart';

@lazySingleton
class HomeLocalDataSource {
  final CacheService _cache;

  HomeLocalDataSource(this._cache);

  // ---------------------------------------------------------------------------
  // Banners (TTL: 5 menit)
  // ---------------------------------------------------------------------------
  static const _bannersKey = 'home_banners';
  static const _bannersTimeKey = 'home_banners_time';
  static const _bannersTtl = Duration(minutes: 5);

  Future<void> cacheBanners(List<BannerModel> banners) async {
    final json = banners.map((b) => b.toJson()).toList();
    await _cache.setString(_bannersKey, jsonEncode(json));
    await _cache.setInt(_bannersTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  List<BannerModel>? getCachedBanners() {
    final cached = _cache.getString(_bannersKey);
    final savedAt = _cache.getInt(_bannersTimeKey);
    if (cached == null || savedAt == null) return null;

    final age = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(savedAt));
    if (age > _bannersTtl) return null;

    final list = jsonDecode(cached) as List;
    return list
        .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Specializations (TTL: 7 hari)
  // ---------------------------------------------------------------------------
  static const _specsKey = 'home_specializations';
  static const _specsTimeKey = 'home_specializations_time';
  static const _specsTtl = Duration(days: 7);

  Future<void> cacheSpecializations(
      List<SpecializationModel> specializations) async {
    final json = specializations.map((s) => s.toJson()).toList();
    await _cache.setString(_specsKey, jsonEncode(json));
    await _cache.setInt(
        _specsTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  List<SpecializationModel>? getCachedSpecializations() {
    final cached = _cache.getString(_specsKey);
    final savedAt = _cache.getInt(_specsTimeKey);
    if (cached == null || savedAt == null) return null;

    final age = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(savedAt));
    if (age > _specsTtl) return null;

    final list = jsonDecode(cached) as List;
    return list
        .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // User Profile (TTL: 5 menit)
  // ---------------------------------------------------------------------------
  static const _profileKey = 'home_user_profile';
  static const _profileTimeKey = 'home_user_profile_time';
  static const _profileTtl = Duration(minutes: 5);

  Future<void> cacheUserProfile(UserProfileModel profile) async {
    await _cache.setJson(_profileKey, profile.toJson());
    await _cache.setInt(
        _profileTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  UserProfileModel? getCachedUserProfile() {
    final savedAt = _cache.getInt(_profileTimeKey);
    if (savedAt == null) return null;

    final age = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(savedAt));
    if (age > _profileTtl) return null;

    final raw = _cache.getJson(_profileKey);
    if (raw == null) return null;
    return UserProfileModel.fromJson(raw);
  }

  Future<void> clearAll() async {
    await _cache.remove(_bannersKey);
    await _cache.remove(_bannersTimeKey);
    await _cache.remove(_specsKey);
    await _cache.remove(_specsTimeKey);
    await _cache.remove(_profileKey);
    await _cache.remove(_profileTimeKey);
  }
}
