import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  final ValueNotifier<bool> isChecking = ValueNotifier(false);

  Future<void> _retry(BuildContext context) async {
    isChecking.value = true;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      final hasConnection = connectivityResult.any(
        (result) => result != ConnectivityResult.none,
      );

      if (!context.mounted) return;

      if (hasConnection) {
        Navigator.of(context).pop();
        return;
      }
    } catch (_) {
      // Ignore
    }

    if (!context.mounted) return;

    isChecking.value = false;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Masih tidak ada koneksi. Periksa WiFi atau data seluler.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.grey100,
                ),
                child: const Icon(
                  AppIcons.wifiOff,
                  size: 80,
                  color: AppTheme.grey400,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Tidak Ada Koneksi',
                style: AppTextTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'Periksa koneksi internetmu dan coba lagi.',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder<bool>(
                  valueListenable: isChecking,
                  builder: (context, loading, _) {
                    if (loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return LightFilledButton(
                      label: 'Coba Lagi',
                      onTap: () => _retry(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
