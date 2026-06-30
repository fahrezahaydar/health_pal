import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../widgets/card/appointment_card.dart';
import '../../../../widgets/loader/dot_loader.dart';
import '../../domain/entity/appointment_entity.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({
    super.key,
    this.controller,
    required this.appointments,
    this.onTap,
    this.onCancel,
    this.onReBook,
  });
  final ScrollController? controller;
  final List<AppointmentEntity> appointments;
  final Function(BuildContext context, AppointmentEntity appt)? onTap;
  final Function(BuildContext context, AppointmentEntity appt)? onCancel;
  final Function(BuildContext context, AppointmentEntity appt)? onReBook;

  static Widget skeleton() {
    return Skeletonizer(
      child: AppointmentList(
        appointments: List.generate(8, (index) {
          return AppointmentEntity.mock();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= appointments.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: DotLoader()),
          );
        }
        final appt = appointments[index];
        return Skeleton.unite(
          child: AppointmentCard(
            appointment: appt,
            onTap: () => onTap?.call(context, appt),
            onCancel: () => onCancel?.call(context, appt),
            onReBook: () => onReBook?.call(context, appt),
          ),
        );
      },
    );
  }
}
