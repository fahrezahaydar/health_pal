import 'package:flutter/widgets.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/di/locator.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/button/primary_button.dart';
import '../bloc/onboarding_notifier.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<Map<String, String>> data = [
    {
      'image': 'assets/onboarding-1.png',
      'title': 'Meet Doctors Online',
      'description':
          'Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.',
    },
    {
      'image': 'assets/onboarding-2.png',
      'title': 'Connect with Specialists',
      'description':
          'Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.',
    },
    {
      'image': 'assets/onboarding-3.png',
      'title': 'Thousands of Online Specialists',
      'description':
          'Explore a Vast Array of Online Medical Specialists, Offering an Extensive Range of Expertise Tailored to Your Healthcare Needs.',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔥 PRECACHE IMAGE
    for (var item in data) {
      precacheImage(AssetImage(item['image']!), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OnboardingNotifier>(),
      child: Consumer<OnboardingNotifier>(
        builder: (context, vm, _) {
          return SafeArea(
            child: Column(
              children: [
                /// IMAGE
                Expanded(
                  child: PageView(
                    controller: vm.controller,
                    onPageChanged: vm.onPageChanged,
                    children: data.map((item) {
                      return Image.asset(
                        item['image']!,
                        fit: BoxFit.fitHeight,
                        gaplessPlayback: true,
                      );
                    }).toList(),
                  ),
                ),

                /// CONTENT
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 32, 40, 32),
                  child: Column(
                    spacing: 24,
                    children: [
                      Column(
                        spacing: 16,
                        children: [
                          Text(
                            data[vm.currentIndex]['title']!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.grey700,
                            ),
                          ),
                          AutoSizeText(
                            data[vm.currentIndex]['description']!,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.bodySmall.copyWith(
                              color: AppTheme.grey500,
                            ),
                          ),
                        ],
                      ),

                      /// BUTTON
                      LightFilledButton(
                        onTap: () => vm.nextPage(context, data.length),
                        label: 'Next',
                      ),

                      /// INDICATOR
                      SmoothPageIndicator(
                        controller: vm.controller,
                        count: data.length,
                        effect: const ExpandingDotsEffect(
                          expansionFactor: 4,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 6,
                          activeDotColor: AppTheme.primary,
                          dotColor: Color(0xff9B9B9B),
                        ),
                      ),

                      /// SKIP
                      GestureDetector(
                        onTap: () => vm.skip(context),
                        child: Text(
                          'Skip',
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppTheme.grey500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
