// test/features/settings/data/repository/settings_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:health_pal/core/services/cache_service.dart';
import 'package:health_pal/core/services/shared_prefs.dart';
import 'package:health_pal/features/home/data/datasource/home_local_datasource.dart';
import 'package:health_pal/features/settings/data/repository/settings_repository_impl.dart';

class MockSupabase extends Mock implements SupabaseClient {}
class MockPrefs extends Mock implements SharedPrefService {}
class MockCache extends Mock implements CacheService {}
class MockHomeLocal extends Mock implements HomeLocalDataSource {}

void main() {
  late MockSupabase supabase;
  late MockPrefs prefs;
  late MockCache cache;
  late MockHomeLocal homeLocal;
  late SettingsRepositoryImpl repo;

  setUp(() {
    supabase = MockSupabase();
    prefs = MockPrefs();
    cache = MockCache();
    homeLocal = MockHomeLocal();
    repo = SettingsRepositoryImpl(supabase, prefs, cache, homeLocal);
  });

  group('isNotifEnabled', () {
    test('reads from SharedPrefs', () {
      when(() => prefs.isNotifEnabled).thenReturn(true);
      expect(repo.isNotifEnabled(), isTrue);

      when(() => prefs.isNotifEnabled).thenReturn(false);
      expect(repo.isNotifEnabled(), isFalse);
    });
  });

  group('clearCache', () {
    test('delegates to HomeLocalDataSource', () async {
      when(() => homeLocal.clearAll()).thenAnswer((_) async {});

      await repo.clearCache();
      verify(() => homeLocal.clearAll()).called(1);
    });
  });

  group('clearLocalData', () {
    test('clears both cache and homeLocal', () async {
      when(() => cache.clear()).thenAnswer((_) async {});
      when(() => homeLocal.clearAll()).thenAnswer((_) async {});

      await repo.clearLocalData();
      verify(() => cache.clear()).called(1);
      verify(() => homeLocal.clearAll()).called(1);
    });
  });

  group('getEmergencyPhone / setEmergencyPhone', () {
    test('get returns null when not set', () {
      when(() => cache.getString('emergency_phone')).thenReturn(null);
      expect(repo.getEmergencyPhone(), isNull);
    });

    test('get returns stored value', () {
      when(() => cache.getString('emergency_phone')).thenReturn('08123456789');
      expect(repo.getEmergencyPhone(), '08123456789');
    });

    test('set stores value', () async {
      when(() => cache.setString('emergency_phone', '08123456789'))
          .thenAnswer((_) async {});

      await repo.setEmergencyPhone('08123456789');
      verify(() => cache.setString('emergency_phone', '08123456789')).called(1);
    });
  });

  group('getEmail (needs SupabaseClient)', () {
    test('returns null when no session', () {
      final auth = MockGoTrue();
      when(() => supabase.auth).thenReturn(auth);
      when(() => auth.currentSession).thenReturn(null);

      expect(repo.getEmail(), isNull);
    });
  });
}

class MockGoTrue extends Mock implements GoTrueClient {}
