import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/shared/app_network_image.dart';
import '../../../../widgets/shared/avatar_initials.dart';
import '../../../auth/domain/entity/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user, this.onEditAvatar});

  final UserEntity user;
  final VoidCallback? onEditAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipOval(
              child: user.avatarUrl != null
                  ? AppNetworkImage(
                      imageUrl: user.avatarUrl,
                      width: 160,
                      height: 160,
                      iconData: Icons.person,
                      iconSize: 64,
                    )
                  : AvatarInitials(
                      name: user.fullName,
                      size: 160,
                      textStyle: const TextStyle(fontSize: 32),
                    ),
            ),
            if (onEditAvatar != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Skeleton.ignore(
                  child: GestureDetector(
                    onTap: onEditAvatar,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        AppIcons.edit,
                        size: 20,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(user.fullName, style: AppTextTheme.headlineSmall),
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
