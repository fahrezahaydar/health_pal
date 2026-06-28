import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';

class LocPermissionDeniedWidget extends StatelessWidget {
  const LocPermissionDeniedWidget({
    super.key,
    required this.reason,
    required this.onRetry,
  });

  final String reason;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightPink,
            ),
            child: const Icon(
              AppIcons.locationDisabled,
              size: 60,
              color: AppTheme.darkRed,
            ),
          ),
          const SizedBox(height: 24),
          Text('Izin Lokasi Diperlukan', style: AppTextTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            reason,
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: LightFilledButton(
              label: 'Izinkan Lokasi',
              onTap: onRetry,
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('atau', style: TextStyle(color: AppTheme.grey400)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          Text('Cari Klinik Berdasarkan Kota', style: AppTextTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Masukkan nama kota',
              prefixIcon: Icon(AppIcons.search),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (city) {
              if (city.trim().isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mencari klinik di $city...')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
