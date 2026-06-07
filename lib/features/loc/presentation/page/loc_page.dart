import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class LocPage extends StatelessWidget {
  const LocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Location Search', style: AppTextTheme.bodyLarge));
  }
}
