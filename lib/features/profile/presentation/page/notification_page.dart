// lib/features/profile/presentation/page/notification_page.dart
//
// Halaman Notification Inbox. Per API §8.1.
// - AppBar: title + unread count badge + "Tandai semua dibaca" action
// - ListView NotificationCard (unread highlighted dengan paleBlue background)
// - Pull to refresh
// - Empty state
//
// Pola: Stateless wrapper (BlocProvider) + StatefulWidget view.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../domain/entity/notification_entity.dart';
import '../bloc/notification/notification_cubit.dart';
import '../bloc/notification/notification_state.dart';
import '../../../../widgets/card/notification_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationCubit>(
      create: (_) {
        final userId = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
        return getIt<NotificationCubit>()..loadNotifications(userId);
      },
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack, color: AppTheme.grey900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BlocBuilder<NotificationCubit, NotificationListState>(
          builder: (context, state) {
            final unread = state is NotificationLoaded ? state.unreadCount : 0;
            return Row(
              children: [
                const Text('Notifikasi'),
                if (unread > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$unread',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationListState>(
            builder: (context, state) {
              if (state is! NotificationLoaded || state.unreadCount == 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () =>
                    context.read<NotificationCubit>().markAllAsRead(),
                child: const Text('Tandai semua'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationListState>(
        builder: (context, state) {
          return switch (state) {
            NotificationInitial() || NotificationLoading() =>
              const Skeletonizer(enabled: true, child: _NotificationSkeleton()),
            NotificationLoaded(:final notifications)
                when notifications.isEmpty =>
              _emptyState(),
            NotificationLoaded(:final notifications) => _list(
              context,
              notifications,
            ),
            NotificationError(:final message) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ErrorSection(
                message: message,
                onRetry: () {
                  final uid =
                      getIt<SupabaseClient>().auth.currentUser?.id ?? '';
                  context.read<NotificationCubit>().loadNotifications(uid);
                },
              ),
            ),
          };
        },
      ),
    );
  }

  Widget _list(BuildContext context, List<NotificationEntity> notifications) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
        await context.read<NotificationCubit>().loadNotifications(userId);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notifications[index];
          return NotificationCard(
            notification: n,
            onTap: () async {
              // 1. Mark as read (optimistic)
              if (!n.isRead) {
                await context.read<NotificationCubit>().markAsRead(n.id);
              }
              // 2. Deep link navigation
              if (!context.mounted) return;
              final payload = FcmService.parseNotificationPayload({
                'type': n.type,
                'appointment_id': n.appointmentId,
              });
              if (payload['appointmentId'] != null ||
                  payload['type'] != 'general') {
                handleNotificationNavigation(context, payload);
              }
            },
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              AppIcons.notification,
              size: 80,
              color: AppTheme.grey300,
            ),
            const SizedBox(height: 16),
            Text('Belum ada notifikasi', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Notifikasi booking dan reminder akan muncul di sini',
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSkeleton extends StatelessWidget {
  const _NotificationSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppTheme.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
