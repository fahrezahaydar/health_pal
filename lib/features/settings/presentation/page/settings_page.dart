import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings', style: AppTextTheme.bodyLarge));
  }
}
