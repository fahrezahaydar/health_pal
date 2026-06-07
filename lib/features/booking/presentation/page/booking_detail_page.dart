import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({required this.appointmentId, super.key});
  final String appointmentId;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Booking $appointmentId', style: AppTextTheme.bodyLarge));
  }
}
