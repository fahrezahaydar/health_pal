import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:health_pal/widgets/badge/app_badge.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/light_icon_button.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key, required this.nickname});

  final String nickname;

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
            icon: const AppBadge(
              count: 5,
              child: Icon(
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
