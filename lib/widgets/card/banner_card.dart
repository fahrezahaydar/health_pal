import 'package:cached_network_image/cached_network_image.dart';
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
        decoration: BoxDecoration(
          color: AppTheme.grey200,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => const SizedBox.shrink(),
                errorWidget: (_, _, _) => const SizedBox.shrink(),
              ),
            if (imageUrl == null)
              Padding(
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
              ),
          ],
        ),
      ),
    );
  }
}
