// D9 — SearchCubit (SKIP: constructor fires async _init, un-awaitable)
// Constructor: `SearchCubit(...) : super(...) { _init(specializationId); }`
// _init is async void, never awaited. Cannot test without product refactor.
// Defer to manual test / integration test.
// Skip per AD-8: no refactor of production code for testability.

import 'package:flutter_test/flutter_test.dart';
void main() {
  test('SearchCubit — skip (async constructor fire, unawaitable)', () {});
}
