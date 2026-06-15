import 'package:flutter/widgets.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A circular profile avatar displaying a network photo or fallback initials.
///
/// If [avatarUrl] is non-null, renders the image in a 48x48 [ClipOval].
/// On load error or when [avatarUrl] is null, shows the first character
/// of [nickname] uppercased on a tinted primary background.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.nickname,
    this.avatarUrl,
  });

  final String nickname;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 48,
        height: 48,
        child: avatarUrl != null
            ? Image.network(
                avatarUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildFallback(),
              )
            : _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: 48,
      height: 48,
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
