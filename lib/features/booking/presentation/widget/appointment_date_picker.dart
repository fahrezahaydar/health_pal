import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';

class AppointmentDatePicker extends StatelessWidget {
  const AppointmentDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.single,
          firstDate: now,
          lastDate: now.add(const Duration(days: 30)),
          currentDate: selectedDate,
          firstDayOfWeek: 0,
          weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
          controlsHeight: 48,
          controlsTextStyle: AppTextTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
          disableModePicker: true,
          modePickerTextHandler:
              ({required DateTime monthDate, bool? isMonthPicker}) {
                if (isMonthPicker == true) return null;
                return '';
              },
          dayTextStyle: AppTextTheme.bodyMedium,
          selectedDayTextStyle: AppTextTheme.bodyMedium.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
          selectedDayHighlightColor: AppTheme.primary,
          todayTextStyle: AppTextTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
          weekdayLabelTextStyle: AppTextTheme.bodySmall.copyWith(
            color: AppTheme.grey500,
            fontWeight: FontWeight.w600,
          ),
          dayBuilder:
              ({
                required DateTime date,
                TextStyle? textStyle,
                BoxDecoration? decoration,
                bool? isSelected,
                bool? isDisabled,
                bool? isToday,
              }) {
                final isWeekend =
                    date.weekday == DateTime.saturday ||
                    date.weekday == DateTime.sunday;
                final dayStyle = isWeekend
                    ? AppTextTheme.bodyMedium.copyWith(color: AppTheme.grey300)
                    : AppTextTheme.bodyMedium.copyWith(
                        color: AppTheme.grey500,
                        fontWeight: FontWeight.bold,
                      );
                return Container(
                  alignment: Alignment.center,
                  decoration: isSelected == true
                      ? BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Text(
                    '${date.day}',
                    style: isSelected == true
                        ? AppTextTheme.bodyMedium.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                          )
                        : dayStyle,
                  ),
                );
              },
        ),
        value: [selectedDate],
        onValueChanged: (dates) {
          if (dates.isNotEmpty) {
            onDateSelected(dates.first);
          }
        },
      ),
    );
  }
}
