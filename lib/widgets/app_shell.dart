import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return NavigationShell(consumer: navigationShell);
  }
}

class NavigationShell extends StatelessWidget {
  const NavigationShell({required this.consumer, super.key});
  final StatefulNavigationShell consumer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: consumer,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: consumer.currentIndex,
        onTap: (index) => consumer.goBranch(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.grey400,
        selectedLabelStyle: AppTextTheme.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextTheme.labelSmall.copyWith(
          color: AppTheme.grey400,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(AppIcons.location), label: 'Loc'),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.calendar),
            label: 'History',
          ),
          BottomNavigationBarItem(icon: Icon(AppIcons.user), label: 'Profile'),
        ],
      ),
    );
  }
}
