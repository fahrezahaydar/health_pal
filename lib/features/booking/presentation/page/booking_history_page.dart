// lib/features/booking/presentation/page/booking_history_page.dart
//
// Halaman Booking History dengan TabBar 5 status. Per wireframe 12.
// Tab: Semua | Pending | Upcoming | Completed | Cancelled
//
// Pola: Stateless wrapper (BlocProvider) + view (UI dengan TabController).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/shared/empty_state_view.dart';
import '../bloc/history/booking_history_cubit.dart';
import '../bloc/history/booking_history_state.dart';
import '../widget/appointment_card.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
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
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final status = _tabs[_tabController.index].$2;
    context.read<BookingHistoryCubit>().filterByStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingHistoryCubit>(
      create: (_) {
        // patientId di-derive dari auth user (sama dengan home greeting).
        final patientId =
            getIt<SupabaseClient>().auth.currentUser?.id ?? '';
        return getIt<BookingHistoryCubit>()..loadHistory(patientId);
      },
      child: Scaffold(
        backgroundColor: AppTheme.grey50,
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          title: Text('Booking History', style: AppTextTheme.titleLarge),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.grey500,
            indicatorColor: AppTheme.primary,
            tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((_) => _tabContent()).toList(),
        ),
      ),
    );
  }

  Widget _tabContent() {
    return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () =>
              context.read<BookingHistoryCubit>().refresh(),
          child: switch (state) {
            BookingHistoryInitial() ||
            BookingHistoryLoading() =>
              const Center(child: CircularProgressIndicator()),
            BookingHistoryLoaded(:final appointments) when appointments.isEmpty =>
              const EmptyStateView(
                icon: Icons.calendar_today,
                message: 'Tidak ada appointment',
                hint: 'Booking pertamamu akan muncul di sini',
              ),
            BookingHistoryLoaded(:final appointments) => _list(appointments),
            BookingHistoryError(:final message) => _errorState(message),
          },
        );
      },
    );
  }

  Widget _list(List appointments) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appt = appointments[index];
        return AppointmentCard(
          appointment: appt,
          onTap: () => context.push(
            RoutePaths.bookingDetail.replaceAll(':appointmentId', appt.id),
            extra: appt,
          ),
        );
      },
    );
  }

  Widget _errorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.darkRed,
            ),
            const SizedBox(height: 16),
            Text('Gagal memuat riwayat', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.read<BookingHistoryCubit>().refresh(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
