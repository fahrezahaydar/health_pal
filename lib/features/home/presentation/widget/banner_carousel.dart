import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../widgets/card/banner_card.dart';
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

    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return BannerCard.fromEntity(banner);
            },
          ),
        ),
        Positioned(
          bottom: 8,
          child: DotsIndicator(
            count: banners.length,
            currentIndex: _currentPage,
            currentColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

class BannerCarouselLoading extends StatelessWidget {
  const BannerCarouselLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: BannerCarousel(banners: BannerEntity.mock()),
    );
  }
}
