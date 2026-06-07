import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Terms & Conditions', style: AppTextTheme.bodyLarge));
  }
}
