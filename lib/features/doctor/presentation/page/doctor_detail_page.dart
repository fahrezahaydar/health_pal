import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({required this.doctorId, super.key});
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Doctor $doctorId', style: AppTextTheme.bodyLarge));
  }
}
