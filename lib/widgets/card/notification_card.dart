import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';
import '../../features/profile/domain/entity/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback? onTap;

  factory NotificationCard.skeleton() => NotificationCard(
        notification: NotificationEntity.mock(),
      );

  IconData get _typeIcon => switch (notification.type) {
        'booking_confirmed' => AppIcons.tickCircle,
        'booking_cancelled' => AppIcons.closeCircle,
        'reminder_h1' => AppIcons.clock,
        'booking_reminder' => AppIcons.clock,
        _ => AppIcons.notification,
      };

  Color get _typeColor => switch (notification.type) {
        'booking_confirmed' => AppTheme.green,
        'booking_cancelled' => AppTheme.darkRed,
        'reminder_h1' || 'booking_reminder' => AppTheme.primary,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
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
