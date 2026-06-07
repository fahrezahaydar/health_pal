import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Help & Support', style: AppTextTheme.bodyLarge));
  }
}
