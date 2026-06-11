import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/home/domain/entity/banner_entity.dart';
import '../../../features/home/presentation/widget/banner_carousel.dart';

const _mockBanners = [
  BannerEntity(
    id: 'banner-1',
    title: 'Health Checkup',
    imageUrl: 'https://picsum.photos/800/400?random=1',
    actionUrl: '/promo/1',
    displayOrder: 1,
  ),
  BannerEntity(
    id: 'banner-2',
    title: 'Dental Care',
    imageUrl: 'https://picsum.photos/800/400?random=2',
    actionUrl: '/promo/2',
    displayOrder: 2,
  ),
  BannerEntity(
    id: 'banner-3',
    title: 'Special Offer',
    imageUrl: 'https://picsum.photos/800/400?random=3',
    actionUrl: null,
    displayOrder: 3,
  ),
];

const _singleBanner = BannerEntity(
  id: 'banner-1',
  title: 'Health Checkup',
  imageUrl: 'https://picsum.photos/800/400?random=1',
  actionUrl: '/promo/1',
  displayOrder: 1,
);

@Preview(name: 'Banner Default', group: 'Banner Carousel', size: Size(390, 400))
Widget previewBannerDefault() {
  return const _PreviewScaffold(child: BannerCarousel(banners: _mockBanners));
}

@Preview(name: 'Banner Loading', group: 'Banner Carousel', size: Size(390, 400))
Widget previewBannerLoading() {
  return const _PreviewScaffold(child: BannerCarousel(banners: []));
}

@Preview(name: 'Banner Empty', group: 'Banner Carousel', size: Size(390, 400))
Widget previewBannerEmpty() {
  return const _PreviewScaffold(child: BannerCarousel(banners: []));
}

@Preview(name: 'Banner Single', group: 'Banner Carousel', size: Size(390, 400))
Widget previewBannerSingle() {
  return const _PreviewScaffold(
    child: BannerCarousel(banners: [_singleBanner]),
  );
}

class _PreviewScaffold extends StatelessWidget {
  const _PreviewScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppTheme.white,
      ),
      home: Scaffold(body: SafeArea(child: child)),
    );
  }
}
