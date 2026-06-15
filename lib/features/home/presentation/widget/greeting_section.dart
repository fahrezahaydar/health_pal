import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:health_pal/widgets/badge/app_badge.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/light_icon_button.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({
    super.key,
    required this.nickname,
    this.unreadCount = 0,
  });

  final String nickname;
  // Sprint 2 — A8: unreadCount dari NotificationCubit (was hardcoded 5).
  // Jika 0, AppBadge tidak muncul (hidden per _show == false).
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Halo, ${nickname.isNotEmpty ? nickname : ''}',
            style: AppTextTheme.headlineSmall,
          ),
          LightIconButton(
            onTap: () => context.push(RoutePaths.notificationSettings),
            icon: AppBadge(
              // sprint 2 — A8: count dari parameter, null jika 0 agar badge hidden
              count: unreadCount > 0 ? unreadCount : null,
              child: const Icon(
                Iconsax.notificationBingStyle5,
                color: AppTheme.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
