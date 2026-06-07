import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({required this.doctorId, super.key});
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Book $doctorId', style: AppTextTheme.bodyLarge));
  }
}
