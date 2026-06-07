import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('No Internet', style: AppTextTheme.bodyLarge));
  }
}
