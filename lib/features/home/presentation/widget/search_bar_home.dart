import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

/// Search Bar widget untuk Home Page.
///
/// **Sprint 2 — Task A1** (per `docs/progress/sprint_2_plan.md`):
/// - Stateless, non-editable (readOnly) sesuai AD-1.
/// - Tap → `context.push(RoutePaths.doctorSearch)`.
/// - Logic search (debounce, query, filter) tetap di `DoctorSearchPage`
///   (per TDD 12 Fase 5).
/// - Styling konsisten dengan `AppTheme` (grey100 background, grey500 hint).
/// - Placeholder Bahasa Indonesia: "Cari dokter, klinik, atau spesialisasi...".
///
/// **Reference:**
/// - `docs/wireframe/06-home.md` §2 (Search Bar section)
/// - `docs/product/prd_health_pal.md` §6.2 (Home Screen requirements)
/// - `docs/progress/home_page_audit.md` §13.1 K1 (critical bug — Search Bar missing)
///
/// **Posisi di Home Page:** di bawah `GreetingSection`, di atas `BannerCarousel`.
class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(RoutePaths.doctorSearch),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Row(
          spacing: 12,
          children: [
            const Icon(
              AppIcons.searchNormal,
              size: 20,
              color: AppTheme.grey500,
            ),
            Expanded(
              child: Text(
                'Cari dokter, klinik, atau spesialisasi...',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(AppIcons.filter, size: 18, color: AppTheme.grey400),
          ],
        ),
      ),
    );
  }
}
