import 'package:flutter/material.dart';

class OnboardingNotifier extends ChangeNotifier {
  final PageController controller = PageController();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage(int totalPage) {
    if (_currentIndex < totalPage - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // TODO: selesai onboarding
    }
  }

  void skip() {
    // TODO: navigate ke home
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
