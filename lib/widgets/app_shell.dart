import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  List<IconData> get icons => [
    AppIcons.home,
    AppIcons.location,
    AppIcons.calendar2,
    AppIcons.user,
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          children: List.generate(4, (index) {
            final selected = index == navigationShell.currentIndex;
            return InkWell(
              onTap: () => navigationShell.goBranch(index),
              borderRadius: BorderRadius.circular(100),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: selected
                      ? cs.surfaceContainerHighest
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icons[index],
                  color: selected ? cs.primary : cs.inversePrimary,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
