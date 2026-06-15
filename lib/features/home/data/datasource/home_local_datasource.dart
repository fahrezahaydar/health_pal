import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/banner_model.dart';
import '../model/specialization_model.dart';

@lazySingleton
class HomeLocalDataSource {
  final SharedPreferences _prefs;

  HomeLocalDataSource(this._prefs);

  // ---------------------------------------------------------------------------
  // Banners (TTL: 5 menit)
  // ---------------------------------------------------------------------------
  static const _bannersKey = 'home_banners';
  static const _bannersTimeKey = 'home_banners_time';
  static const _bannersTtl = Duration(minutes: 5);

  Future<void> cacheBanners(List<BannerModel> banners) async {
    final json = banners.map((b) => b.toJson()).toList();
    await _prefs.setString(_bannersKey, jsonEncode(json));
    await _prefs.setInt(
        _bannersTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  List<BannerModel>? getCachedBanners() {
    final cached = _prefs.getString(_bannersKey);
    final savedAt = _prefs.getInt(_bannersTimeKey);
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
    await _prefs.setString(_specsKey, jsonEncode(json));
    await _prefs.setInt(
        _specsTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  List<SpecializationModel>? getCachedSpecializations() {
    final cached = _prefs.getString(_specsKey);
    final savedAt = _prefs.getInt(_specsTimeKey);
    if (cached == null || savedAt == null) return null;

    final age = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(savedAt));
    if (age > _specsTtl) return null;

    final list = jsonDecode(cached) as List;
    return list
        .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearAll() async {
    await _prefs.remove(_bannersKey);
    await _prefs.remove(_bannersTimeKey);
    await _prefs.remove(_specsKey);
    await _prefs.remove(_specsTimeKey);
  }
}
