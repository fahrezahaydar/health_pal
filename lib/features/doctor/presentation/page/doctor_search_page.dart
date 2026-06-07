import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class DoctorSearchPage extends StatelessWidget {
  const DoctorSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Doctor Search', style: AppTextTheme.bodyLarge));
  }
}
