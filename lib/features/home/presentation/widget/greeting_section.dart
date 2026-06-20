import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_pal/widgets/badge/app_badge.dart';

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
    this.action = const [],
  });

  final String nickname;
  // Sprint 2 — C4: avatarUrl dari UserProfile (nullable). Jika null,
  // tampilkan CircleAvatar fallback dengan inisial pertama nickname.
  final String? avatarUrl;

  final List<Widget> action;

  @override
  Widget build(BuildContext context) {
    return Row(
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

        ...action,
      ],
    );
  }
}
