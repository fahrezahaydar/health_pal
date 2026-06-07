import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Booking History', style: AppTextTheme.bodyLarge));
  }
}
