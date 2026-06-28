// lib/features/booking/presentation/page/book_appointment_page.dart
//
// Halaman Book Appointment. TANGGAL adalah input dari page ini (per SS#10
// v1.0.1) — tidak menerima `selectedDate` dari Doctor Detail.
//
// Per wireframe 10-book-appointment.md:
// - Doctor Summary (passed via extra)
// - Date picker (date ADA di sini)
// - Slot grid (chips)
// - Notes input (optional, max 300 chars)
// - Fee summary card
// - Konfirmasi button → buka bottom sheet → submit
//
// Pola (sama dengan doctor_page.dart):
// - BookAppointmentPage: StatelessWidget (BlocProvider only)
// - BookAppointmentView: StatefulWidget (logic + UI)

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/network/json_converters.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/loader/dot_loader.dart';
import '../bloc/booking/booking_bloc.dart';
import '../bloc/booking/booking_event.dart';
import '../bloc/booking/booking_state.dart';
import '../../../../widgets/card/booking_summary_card.dart';

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    // Extract extra params (passed via GoRouter).
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final doctorName = extra?['doctorName'] as String? ?? 'Dokter';
    final consultationFee =
        (extra?['consultationFee'] as num?)?.toDouble() ?? 0;
    final suggestedSlotId = extra?['suggestedSlotId'] as String?;

    return BlocProvider<BookingBloc>(
      create: (_) =>
          getIt<BookingBloc>()..add(BookingInitialized(doctorId: doctorId)),
      child: BookAppointmentView(
        doctorId: doctorId,
        doctorName: doctorName,
        consultationFee: consultationFee,
        suggestedSlotId: suggestedSlotId,
      ),
    );
  }
}

class BookAppointmentView extends StatefulWidget {
  const BookAppointmentView({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.consultationFee,
    this.suggestedSlotId,
  });

  final String doctorId;
  final String doctorName;
  final double consultationFee;
  final String? suggestedSlotId;

  @override
  State<BookAppointmentView> createState() => BookAppointmentViewState();
}

class BookAppointmentViewState extends State<BookAppointmentView> {
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _notesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    context.read<BookingBloc>().add(BookingDateSelected(date));
  }

  void _showConfirmationSheet({
    required String startTime,
    required String endTime,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BookingSummaryCard(
                doctorName: widget.doctorName,
                specializationName: 'Konsultasi',
                date: _selectedDate!,
                startTime: startTime,
                endTime: endTime,
                fee: widget.consultationFee,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: LightFilledButton(
                  label: 'Konfirmasi Booking',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.read<BookingBloc>().add(
                      BookingSubmitted(
                        complaintNote: _notesController.text.trim().isEmpty
                            ? null
                            : _notesController.text.trim(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listenWhen: (prev, curr) =>
          prev.createdAppointment == null && curr.createdAppointment != null,
      listener: (context, state) {
        final created = state.createdAppointment;
        if (created == null) return;
        context.push(RoutePaths.bookingSuccess, extra: created);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.grey50,
          appBar: AppBar(
            backgroundColor: AppTheme.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.grey900),
              onPressed: () => context.pop(),
            ),
            title: Text('Book Appointment', style: AppTextTheme.headlineLarge),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _datePickerRow(),
                const SizedBox(height: 16),
                _slotSection(state),
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ErrorSection(message: state.errorMessage!),
                  ),
                const SizedBox(height: 16),
                _notesField(),
                const SizedBox(height: 16),
                _feeSummaryCard(),
                const SizedBox(height: 16),
                _confirmButton(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _datePickerRow() {
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
          currentDate: _selectedDate,
          firstDayOfWeek: 0,
          weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
          controlsHeight: 48,
          disableModePicker: true,
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
                        fontWeight: .bold,
                      );
                if (isSelected == true) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  child: Text('${date.day}', style: dayStyle),
                );
              },
        ),
        value: [_selectedDate],
        onValueChanged: (dates) {
          if (dates.isNotEmpty) {
            _onDateSelected(dates.first);
          }
        },
      ),
    );
  }

  Widget _slotSection(BookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pilih Slot Waktu', style: AppTextTheme.titleLarge),
        const SizedBox(height: 8),
        if (state.isLoadingSlots)
          const Skeletonizer(
            enabled: true,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(label: Text('09:00'), selected: false),
                ChoiceChip(label: Text('09:30'), selected: false),
                ChoiceChip(label: Text('10:00'), selected: false),
              ],
            ),
          )
        else if (state.availableSlots.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.grey200),
            ),
            child: Center(
              child: Text(
                'Tidak ada slot tersedia untuk tanggal ini',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.availableSlots.map<Widget>((slot) {
              final slotId = slot['id'] as String;
              final start = slot['startTime'] as String;
              final end = slot['endTime'] as String;
              final isSelected = state.selectedSlotId == slotId;
              return ChoiceChip(
                label: Text('$start - $end'),
                selected: isSelected,
                onSelected: (_) {
                  context.read<BookingBloc>().add(
                    BookingSlotSelected(
                      slotId: slotId,
                      startTime: start,
                      endTime: end,
                    ),
                  );
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _notesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Catatan Keluhan', style: AppTextTheme.titleLarge),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 4,
          maxLength: 300,
          decoration: InputDecoration(
            hintText: 'Ceritakan keluhanmu...',
            filled: true,
            fillColor: AppTheme.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.grey200),
            ),
            counterText: '${_notesController.text.length}/300',
          ),
        ),
      ],
    );
  }

  Widget _feeSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Row(
        children: [
          const Icon(Icons.payments, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Biaya Konsultasi', style: AppTextTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(widget.consultationFee),
                  style: AppTextTheme.titleLarge.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '⚠️ Pembayaran dilakukan langsung di klinik',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmButton(BookingState state) {
    if (state.isSubmitting) {
      return const Center(child: DotLoader());
    }
    return LightFilledButton(
      label: 'Konfirmasi Booking',
      onTap: state.canSubmit
          ? () => _showConfirmationSheet(
              startTime: state.slotStartTime ?? '',
              endTime: state.slotEndTime ?? '',
            )
          : null,
    );
  }
}
