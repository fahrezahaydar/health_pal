import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

@injectable
class AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs);

  static const _userKey = 'auth_user';

  Future<void> cacheUser(UserModel user) {
    return _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserModel? getCachedUser() {
    final data = _prefs.getString(_userKey);
    if (data == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() => _prefs.remove(_userKey);
}
