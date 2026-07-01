// E2 — CacheService (SharedPreferences wrapper)
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_pal/core/services/cache_service.dart';

void main() {
  late CacheService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    service = CacheService(await SharedPreferences.getInstance());
  });

  test('setString and getString roundtrip', () async {
    await service.setString('key1', 'value1');
    expect(service.getString('key1'), 'value1');
  });

  test('getString returns null for missing key', () {
    expect(service.getString('nonexistent'), isNull);
  });

  test('clear removes all data', () async {
    await service.setString('k1', 'v1');
    await service.setString('k2', 'v2');
    await service.clear();
    expect(service.getString('k1'), isNull);
    expect(service.getString('k2'), isNull);
  });

  test('setJson and getJson roundtrip', () async {
    final data = {'name': 'test', 'count': 123};
    await service.setJson('json-key', data);
    expect(service.getJson('json-key'), data);
  });

  test('setBool and getBool roundtrip', () async {
    await service.setBool('flag', true);
    expect(service.getBool('flag'), isTrue);
  });

  test('remove deletes a key', () async {
    await service.setString('del-key', 'value');
    await service.remove('del-key');
    expect(service.getString('del-key'), isNull);
  });
}
