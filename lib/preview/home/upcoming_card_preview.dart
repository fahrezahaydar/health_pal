import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../core/enums/booking_status.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/home/domain/entity/upcoming_appointment_entity.dart';
import '../../../features/home/presentation/widget/upcoming_card.dart';

// Sprint 2 — A3: slotDate (DateTime?), slotStart/slotEnd (TimeOfDay?)
// bukan String lagi. Preview harus pakai type yang sesuai.
// Catatan: `_mockUpcoming` tidak `const` karena `DateTime(2024,1,15)`
// non-const (runtime-evaluated), dan `_mockSlotStart`/`_mockSlotEnd`
// pakai `const TimeOfDay` yang const-constructible tapi di sini
// disatukan lewat variable.
// Sprint 2 — A5: status sekarang BookingStatus enum (bukan String).
final UpcomingAppointmentEntity _mockUpcoming = UpcomingAppointmentEntity(
  id: 'appt-1',
  doctorName: 'Dr. Budi Santoso',
  doctorPhoto: 'https://picsum.photos/200?random=1',
  clinicName: 'Klinik Sehat',
  specializationName: 'General',
  slotDate: DateTime(2024, 1, 15),
  slotStart: const TimeOfDay(hour: 9, minute: 0),
  slotEnd: const TimeOfDay(hour: 9, minute: 30),
  status: BookingStatus.pending,
);

@Preview(name: 'Upcoming Default', group: 'Upcoming Card')
Widget previewUpcomingDefault() {
  return _PreviewScaffold(child: UpcomingCard(upcoming: _mockUpcoming));
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
