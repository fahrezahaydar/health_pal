import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs =>
      SharedPreferences.getInstance();

  SupabaseClient get supabaseClient => Supabase.instance.client;
}