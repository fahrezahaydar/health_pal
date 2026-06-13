// lib/features/doctor/presentation/widget/slot_availability_text.dart
//
// Widget per SS#10: tampilkan "Tersedia X slot untuk 7 hari ke depan"
// (atau "Belum ada slot" jika 0). TIDAK ADA date picker.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class SlotAvailabilityText extends StatelessWidget {
  const SlotAvailabilityText({
    super.key,
    required this.availableCount,
    this.daysAhead = 7,
  });

  final int availableCount;
  final int daysAhead;

  @override
  Widget build(BuildContext context) {
    final hasSlots = availableCount > 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasSlots ? AppTheme.paleGreen : AppTheme.grey100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasSlots ? AppTheme.green : AppTheme.grey200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: hasSlots ? AppTheme.deepTeal : AppTheme.grey500,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasSlots
                  ? 'Tersedia $availableCount slot untuk $daysAhead hari ke depan'
                  : 'Belum ada slot untuk $daysAhead hari ke depan',
              style: AppTextTheme.bodyMedium.copyWith(
                color: hasSlots ? AppTheme.deepTeal : AppTheme.grey500,
                fontWeight: hasSlots ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
