import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/shared/app_network_image.dart';
import '../../../../widgets/shared/avatar_initials.dart';
import '../../../auth/domain/entity/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    this.onEditAvatar,
  });

  final UserEntity user;
  final VoidCallback? onEditAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.grey200, width: 2),
              ),
              child: ClipOval(
                child: user.avatarUrl != null
                    ? AppNetworkImage(
                        imageUrl: user.avatarUrl,
                        width: 80,
                        height: 80,
                        iconData: Icons.person,
                        iconSize: 32,
                      )
                    : AvatarInitials(name: user.fullName, size: 80),
              ),
            ),
            if (onEditAvatar != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditAvatar,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      AppIcons.edit,
                      size: 16,
                      color: AppTheme.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(user.fullName, style: AppTextTheme.titleLarge),
        if (user.phoneNumber != null) ...[
          const SizedBox(height: 4),
          Text(
            user.phoneNumber!,
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
          ),
        ],
      ],
    );
  }
}
