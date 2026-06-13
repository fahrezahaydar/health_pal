// lib/features/profile/presentation/page/notification_page.dart
//
// Halaman daftar notifikasi user. Per API §8.1 — fetch dari
// `notifications` table, tampilkan dalam list dengan timestamp relative.
//
// Pola: Stateless wrapper (BlocProvider) + view (UI).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_latest/iconsax_latest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entity/notification_entity.dart';
import '../bloc/notification/notification_cubit.dart';
import '../bloc/notification/notification_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationCubit>(
      create: (_) {
        // Sama dengan booking history: pakai auth.currentUser.id
        // (RLS di Supabase handle mapping ke profile_id).
        final userId = getIt<SupabaseClient>().auth.currentUser?.id ?? '';
        return getIt<NotificationCubit>()..loadNotifications(userId);
      },
      child: Scaffold(
        backgroundColor: AppTheme.grey50,
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Iconsax.arrowLeft01, color: AppTheme.grey900),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Notifications', style: AppTextTheme.titleLarge),
        ),
        body: BlocBuilder<NotificationCubit, NotificationListState>(
          builder: (context, state) {
            return switch (state) {
              NotificationInitial() || NotificationLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              NotificationLoaded(:final notifications)
                  when notifications.isEmpty =>
                _emptyState(),
              NotificationLoaded(:final notifications) => _list(notifications),
              NotificationError(:final message) => _errorState(
                context,
                message,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _list(List<NotificationEntity> notifications) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final n = notifications[index];
        return _NotificationCard(notification: n);
      },
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.notification, size: 80, color: AppTheme.grey300),
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

  Widget _errorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.warning2, size: 64, color: AppTheme.darkRed),
            const SizedBox(height: 16),
            Text('Gagal memuat notifikasi', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                final userId =
                    getIt<SupabaseClient>().auth.currentUser?.id ?? '';
                context.read<NotificationCubit>().loadNotifications(userId);
              },
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationEntity notification;

  IconData get _typeIcon => switch (notification.type) {
    'booking_confirmed' => Iconsax.tickCircle,
    'reminder_h1' => Iconsax.clock,
    'booking_cancelled' => Iconsax.closeCircle,
    _ => Iconsax.notification,
  };

  Color get _typeColor => switch (notification.type) {
    'booking_confirmed' => AppTheme.green,
    'reminder_h1' => AppTheme.primary,
    'booking_cancelled' => AppTheme.darkRed,
    _ => AppTheme.grey500,
  };

  String get _relativeTime {
    final now = DateTime.now();
    final diff = now.difference(notification.sentAt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead ? AppTheme.white : AppTheme.paleBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon ──
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _typeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon, size: 22, color: _typeColor),
          ),
          const SizedBox(width: 12),
          // ── Content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTextTheme.bodyLarge.copyWith(
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _relativeTime,
                      style: AppTextTheme.labelSmall.copyWith(
                        color: AppTheme.grey500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppTheme.grey700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
