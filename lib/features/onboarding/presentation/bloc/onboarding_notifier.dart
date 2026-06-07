import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/services/app_services.dart';

@injectable
class OnboardingNotifier extends ChangeNotifier {
  final AppServices appServices;

  OnboardingNotifier(this.appServices);
  final PageController controller = PageController();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage(BuildContext context, int totalPage) {
    if (_currentIndex < totalPage - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      appServices.completeOnboarding();
      context.go(RoutePaths.signIn);
    }
  }

  void skip(BuildContext context) {
    appServices.completeOnboarding();
    context.go(RoutePaths.signIn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
