import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

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
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.location), label: 'Loc'),
          BottomNavigationBarItem(icon: Icon(Iconsax.calendar), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}
