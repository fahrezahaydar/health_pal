import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/indicators/dots_indicator.dart';
import '../../domain/entity/banner_entity.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key, required this.banners});

  final List<BannerEntity> banners;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Sprint 2 — E1: pindah dari addPostFrameCallback di build() ke
    // initState + didUpdateWidget. Build bisa dipanggil multiple times
    // (parent rebuild, state change, Skeletonizer enabled toggle),
    // tiap kali addPostFrameCallback baru ditambahkan — menyebabkan
    // multiple timer racing. initState hanya sekali, didUpdateWidget
    // handle perubahan banner count (skeleton → real data).
    _startAutoScroll(widget.banners.length);
  }

  @override
  void didUpdateWidget(BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners.length != widget.banners.length) {
      _currentPage = 0;
      _startAutoScroll(widget.banners.length);
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll(int itemCount) {
    _autoScrollTimer?.cancel();
    if (itemCount <= 1) return;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % itemCount;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return _BannerCard(banner: banner);
            },
          ),
        ),
        const SizedBox(height: 8),
        DotsIndicator(
          count: banners.length,
          currentIndex: _currentPage,
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});

  final BannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final url = banner.actionUrl;
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
          image: banner.imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(banner.imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: banner.imageUrl == null
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.gallery, size: 32, color: AppTheme.grey400),
                    const SizedBox(height: 8),
                    Text(
                      banner.title,
                      style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey600),
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


