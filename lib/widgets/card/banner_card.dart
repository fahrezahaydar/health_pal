import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/home/domain/entity/banner_entity.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key, this.url, this.imageUrl, required this.title});

  final String? url;
  final String? imageUrl;
  final String title;

  factory BannerCard.fromEntity(BannerEntity entity) {
    return BannerCard(
      url: entity.actionUrl,
      imageUrl: entity.imageUrl,
      title: entity.title,
    );
  }
  factory BannerCard.skeleton() {
    return const BannerCard(url: null, imageUrl: null, title: 'Loading...');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final url = this.url;
        // Sprint 2 — E2: validasi scheme URL. Hanya izinkan http/https
        // (eksternal) atau / (internal route). Blokir javascript://,
        // data://, atau scheme berbahaya lainnya.
        if (url != null &&
            (url.startsWith('http://') ||
                url.startsWith('https://') ||
                url.startsWith('/'))) {
          context.push(url);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.grey200,
          borderRadius: BorderRadius.circular(12),
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: imageUrl == null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      AppIcons.gallery,
                      size: 32,
                      color: AppTheme.grey400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: AppTextTheme.bodySmall.copyWith(
                        color: AppTheme.grey600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
