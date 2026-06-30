// lib/features/booking/presentation/page/booking_history_page.dart
//
// Halaman Booking History dengan TabBar 5 status. Per wireframe 12.
// Tab: Semua | Pending | Upcoming | Completed | Cancelled
//
// Pola: Stateless wrapper (BlocProvider) + view (UI dengan TabController).
// Page membuat Cubit dan provide ke child; View adalah child yang
// mengakses Cubit via context (karena View di-DALAM BlocProvider).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/network/result.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/services/app_services.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/empty_state_view.dart';
import '../../domain/usecase/cancel_appointment_usecase.dart';
import '../bloc/history/booking_history_cubit.dart';
import '../bloc/history/booking_history_state.dart';
import '../widget/appointment_list.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingHistoryCubit>(
      create: (ctx) {
        final cubit = getIt<BookingHistoryCubit>();
        getIt<AppServices>().getCurrentProfileId().then((pid) {
          cubit.loadHistory(pid ?? '');
        });
        return cubit;
      },
      child: const BookingHistoryView(),
    );
  }
}

class BookingHistoryView extends StatefulWidget {
  const BookingHistoryView({super.key});

  @override
  State<BookingHistoryView> createState() => _BookingHistoryViewState();
}

class _BookingHistoryViewState extends State<BookingHistoryView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _scrollController = ScrollController();
  static const _tabs = [
    ('Semua', null),
    ('Pending', 'pending'),
    ('Upcoming', 'upcoming'),
    ('Completed', 'completed'),
    ('Cancelled', 'cancelled'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BookingHistoryCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final status = _tabs[_tabController.index].$2;
    context.read<BookingHistoryCubit>().filterByStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        centerTitle: true,
        title: Text('My Bookings', style: AppTextTheme.headlineLarge),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.grey500,
          indicatorColor: AppTheme.primary,
          labelStyle: AppTextTheme.headlineSmall,
          tabAlignment: TabAlignment.start,
          unselectedLabelStyle: AppTextTheme.headlineSmall,
          tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
        ),
      ),
      body: BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<BookingHistoryCubit>().refresh(),
            child: switch (state) {
              BookingHistoryLoaded(:final appointments)
                  when appointments.isEmpty =>
                const EmptyStateView(
                  icon: AppIcons.calendarToday,
                  message: 'Tidak ada appointment',
                  hint: 'Booking pertamamu akan muncul di sini',
                ),
              BookingHistoryLoaded(:final appointments) => AppointmentList(
                controller: _scrollController,
                appointments: appointments,
                onTap: (context, appt) => context.push(
                  RoutePaths.bookingDetail.replaceAll(
                    ':appointmentId',
                    appt.id,
                  ),
                  extra: appt,
                ),
                onCancel: (context, appt) async {
                  final useCase = getIt<CancelAppointmentUseCase>();
                  final result = await useCase(appointmentId: appt.id);
                  switch (result) {
                    case Success():
                      if (context.mounted) {
                        context.read<BookingHistoryCubit>().refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Appointment dibatalkan'),
                          ),
                        );
                      }
                    case Failure(:final message):
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                  }
                },
                onReBook: (context, appt) => context.push(
                  RoutePaths.bookAppointment.replaceAll(
                    ':doctorId',
                    appt.doctorId,
                  ),
                  extra: {
                    'doctorId': appt.doctorId,
                    'doctorName': appt.doctorName,
                    'consultationFee': appt.consultationFeeSnapshot,
                  },
                ),
              ),
              BookingHistoryError(:final message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: ErrorSection(
                  message: message,
                  onRetry: () => context.read<BookingHistoryCubit>().refresh(),
                ),
              ),
              _ => AppointmentList.skeleton(),
            },
          );
        },
      ),
    );
  }
}
