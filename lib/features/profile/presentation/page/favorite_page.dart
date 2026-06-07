import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Favorite', style: AppTextTheme.bodyLarge));
  }
}
