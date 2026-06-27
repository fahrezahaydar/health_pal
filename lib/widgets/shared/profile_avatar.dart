import 'package:flutter/material.dart';

import 'app_network_image.dart';
import 'avatar_initials.dart';

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
      child: avatarUrl != null
          ? AppNetworkImage(
              imageUrl: avatarUrl,
              width: 42,
              height: 42,
              iconData: Icons.person,
              iconSize: 18,
            )
          : AvatarInitials(
              name: nickname,
              size: 42,
            ),
    );
  }
}
