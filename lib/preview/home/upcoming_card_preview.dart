import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/home/domain/entity/upcoming_appointment_entity.dart';
import '../../../features/home/presentation/widget/upcoming_card.dart';

const _mockUpcoming = UpcomingAppointmentEntity(
  id: 'appt-1',
  doctorName: 'Dr. Budi Santoso',
  doctorPhoto: 'https://picsum.photos/200?random=1',
  clinicName: 'Klinik Sehat',
  specializationName: 'General',
  slotDate: '2024-01-15',
  slotStart: '09:00',
  slotEnd: '09:30',
  status: 'pending',
);

@Preview(name: 'Upcoming Default', group: 'Upcoming Card')
Widget previewUpcomingDefault() {
  return const _PreviewScaffold(child: UpcomingCard(upcoming: _mockUpcoming));
}

@Preview(name: 'Upcoming Empty', group: 'Upcoming Card')
Widget previewUpcomingEmpty() {
  return const _PreviewScaffold(child: UpcomingCard(upcoming: null));
}

class _PreviewScaffold extends StatelessWidget {
  const _PreviewScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppTheme.white,
      ),
      home: Scaffold(body: SafeArea(child: child)),
    );
  }
}
