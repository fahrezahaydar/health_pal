import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notifications', style: AppTextTheme.bodyLarge));
  }
}
