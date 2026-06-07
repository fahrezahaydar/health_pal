import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Edit Profile', style: AppTextTheme.bodyLarge));
  }
}
