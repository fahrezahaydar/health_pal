// test/flutter_test_config.dart
//
// Global test configuration untuk seluruh test suite health_pal.
// Dipanggil otomatis oleh flutter test sebelum semua test berjalan.
//
// Referensi: docs/tdd/10-testing.md §2.3 (test config pattern)

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global test setup — dipanggil sekali per test runner.
Future<void> testExecutable([FutureOr<void> Function()? testMain]) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // 1. Setup timezone & locale untuk date formatting tests
  await initializeDateFormatting('id_ID', null);

  // 2. Initialize SharedPreferences dengan empty mock values.
  // Tanpa ini, semua test yang baca/tulis SharedPreferences akan crash.
  SharedPreferences.setMockInitialValues(<String, Object>{});

  // 3. Panggil testMain jika ada (default behavior)
  await testMain?.call();
}
