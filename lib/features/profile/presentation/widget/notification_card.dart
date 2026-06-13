// lib/features/profile/presentation/widget/notification_card.dart
//
// Card reusable untuk menampilkan 1 notifikasi di Notification Inbox page.
// - Unread indicator (dot biru di kiri, atau paleBlue background)
// - Type-aware icon
// - Title + body + relative timestamp
// - onTap → mark as read + optional deep link navigation

import 'package:flutter/material.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entity/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback? onTap;

  IconData get _typeIcon => switch (notification.type) {
        'booking_confirmed' => Iconsax.tickCircle,
        'booking_cancelled' => Iconsax.closeCircle,
        'reminder_h1' => Iconsax.clock,
        'booking_reminder' => Iconsax.clock,
        _ => Iconsax.notification,
      };

  Color get _typeColor => switch (notification.type) {
        'booking_confirmed' => AppTheme.green,
        'booking_cancelled' => AppTheme.darkRed,
        'reminder_h1' || 'booking_reminder' => AppTheme.primary,
        _ => AppTheme.grey500,
      };

  /// Relative time (Baru saja / Xm / Xh / Xd / Xw).
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
    final isUnread = !notification.isRead;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnread ? AppTheme.paleBlue : AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type icon ──
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
                      // Unread dot
                      if (isUnread) ...[
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6, top: 6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextTheme.bodyLarge.copyWith(
                            fontWeight: isUnread
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _relativeTime,
                        style: AppTextTheme.labelSmall
                            .copyWith(color: AppTheme.grey500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style:
                        AppTextTheme.bodySmall.copyWith(color: AppTheme.grey700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
