import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A circular profile avatar displaying a network photo or fallback initials.
///
/// If [avatarUrl] is non-null, renders the image in a 48x48 [ClipOval].
/// On load error or when [avatarUrl] is null, shows the first character
/// of [nickname] uppercased on a tinted primary background.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.nickname, this.avatarUrl});

  final String nickname;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 42,
        height: 42,
        color: AppTheme.grey100,
        alignment: Alignment.center,
        child: avatarUrl != null
            ? CachedNetworkImage(
                imageUrl: avatarUrl!,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                placeholder: (_, _) => const SizedBox.shrink(),
                errorWidget: (_, _, _) => _buildFallback(context),
              )
            : _buildFallback(context),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      color: AppTheme.primary.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Text(
        nickname.isNotEmpty ? nickname[0].toUpperCase() : '?',
        style: AppTextTheme.titleLarge.copyWith(
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
