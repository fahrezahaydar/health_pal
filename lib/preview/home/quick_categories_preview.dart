import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/home/domain/entity/specialization_entity.dart';
import '../../../features/home/presentation/widget/quick_categories.dart';

const _mockSpecializations = [
  SpecializationEntity(
    id: 'sp-1',
    name: 'General',
    iconUrl: 'https://picsum.photos/100?random=1',
  ),
  SpecializationEntity(
    id: 'sp-2',
    name: 'Dental',
    iconUrl: 'https://picsum.photos/100?random=2',
  ),
  SpecializationEntity(
    id: 'sp-3',
    name: 'Cardiology',
    iconUrl: 'https://picsum.photos/100?random=3',
  ),
  SpecializationEntity(id: 'sp-4', name: 'Neurology', iconUrl: null),
  SpecializationEntity(id: 'sp-5', name: 'Pulmonary', iconUrl: null),
  SpecializationEntity(id: 'sp-6', name: 'Laboratory', iconUrl: null),
  SpecializationEntity(id: 'sp-7', name: 'Vaccination', iconUrl: null),
  SpecializationEntity(id: 'sp-8', name: 'Gastroenterology', iconUrl: null),
];

@Preview(
  name: 'Categories Default',
  group: 'Quick Categories',
  size: Size(390, 844),
)
Widget previewCategoriesDefault() {
  return const _PreviewScaffold(
    child: QuickCategories(specializations: _mockSpecializations),
  );
}

@Preview(
  name: 'Categories Empty',
  group: 'Quick Categories',
  size: Size(390, 844),
)
Widget previewCategoriesEmpty() {
  return const _PreviewScaffold(child: QuickCategories(specializations: []));
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
