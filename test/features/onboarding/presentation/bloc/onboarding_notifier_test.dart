// E1 — OnboardingNotifier (ChangeNotifier)
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health_pal/core/services/app_services.dart';
import 'package:health_pal/features/onboarding/presentation/bloc/onboarding_notifier.dart';

class _MApp extends Mock implements AppServices {}
void main() {
  group('OnboardingNotifier', () {
    test('onPageChanged changes currentIndex and notifies', () {
      final a = _MApp(); final n = OnboardingNotifier(a);
      var notified = false;
      n.addListener(() { notified = true; });
      n.onPageChanged(2);
      expect(n.currentIndex, 2);
      expect(notified, isTrue);
      n.dispose();
    });

    test('initial index is 0', () {
      final a = _MApp(); final n = OnboardingNotifier(a);
      expect(n.currentIndex, 0);
      n.dispose();
    });
  });
}
