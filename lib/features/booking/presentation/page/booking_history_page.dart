// lib/features/booking/presentation/page/booking_history_page.dart
//
// Halaman Booking History dengan TabBar 5 status. Per wireframe 12.
// Tab: Semua | Pending | Upcoming | Completed | Cancelled
//
// Pola: Stateless wrapper (BlocProvider) + view (UI dengan TabController).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/services/app_services.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/loader/dot_loader.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/empty_state_view.dart';
import '../bloc/history/booking_history_cubit.dart';
import '../bloc/history/booking_history_state.dart';
import '../../../../widgets/card/appointment_card.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
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
    return BlocProvider<BookingHistoryCubit>(
      create: (ctx) {
        final cubit = getIt<BookingHistoryCubit>();
        getIt<AppServices>().getCurrentProfileId().then((pid) {
          cubit.loadHistory(pid ?? '');
        });
        return cubit;
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
          onRefresh: () => context.read<BookingHistoryCubit>().refresh(),
          child: switch (state) {
            BookingHistoryInitial() || BookingHistoryLoading() =>
              const Skeletonizer(enabled: true, child: _ListSkeletonContent()),
            BookingHistoryLoaded(:final appointments)
                when appointments.isEmpty =>
              const EmptyStateView(
                icon: AppIcons.calendarToday,
                message: 'Tidak ada appointment',
                hint: 'Booking pertamamu akan muncul di sini',
              ),
            BookingHistoryLoaded(:final appointments, :final hasMore) => _list(
              appointments,
              hasMore,
            ),
            BookingHistoryError(:final message) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ErrorSection(
                message: message,
                onRetry: () => context.read<BookingHistoryCubit>().refresh(),
              ),
            ),
          },
        );
      },
    );
  }

  Widget _list(List appointments, bool hasMore) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length + (hasMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= appointments.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: DotLoader()),
          );
        }
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
}

class _ListSkeletonContent extends StatelessWidget {
  const _ListSkeletonContent();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const SizedBox(
        height: 80,
        child: Card(child: ListTile(title: Text('Loading'))),
      ),
    );
  }
}
