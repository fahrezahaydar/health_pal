import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_pal/widgets/badge/app_badge.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/light_icon_button.dart';
import '../../../../widgets/shared/profile_avatar.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({
    super.key,
    required this.nickname,
    this.avatarUrl,
    this.unreadCount = 0,
  });

  final String nickname;
  // Sprint 2 — C4: avatarUrl dari UserProfile (nullable). Jika null,
  // tampilkan CircleAvatar fallback dengan inisial pertama nickname.
  final String? avatarUrl;
  // Sprint 2 — A8: unreadCount dari NotificationCubit (was hardcoded 5).
  // Jika 0, AppBadge tidak muncul (hidden per _show == false).
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Sprint 2 — C4: Profile photo di Greeting.
          // CircleAvatar 48x48. Jika avatarUrl null, fallback ke inisial
          // pertama nickname. Tidak pakai Material CircleAvatar —
          // menggunakan ClipOval + Container + Image.network manual.
          ProfileAvatar(nickname: nickname, avatarUrl: avatarUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Halo, ${nickname.isNotEmpty ? nickname : ''}',
              style: AppTextTheme.headlineSmall,
            ),
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


