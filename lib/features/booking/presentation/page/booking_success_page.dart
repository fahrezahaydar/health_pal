import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_text_theme.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Booking Success', style: AppTextTheme.bodyLarge));
  }
}
