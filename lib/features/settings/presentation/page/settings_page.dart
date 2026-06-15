// lib/features/settings/presentation/page/settings_page.dart
//
// Halaman Settings. Per wireframe 18-settings.md.
// - Section Akun: Edit Profile, Ubah Password
// - Section Preferensi: Toggle Notifikasi, Toggle Dark Mode (disabled)
// - Section Aplikasi: Versi, S&K, Bantuan
// - Logout di paling bawah
//
// Pola: Stateless wrapper (BlocProvider) + StatefulWidget view.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialog/app_confirm_dialog.dart';
import '../../../../widgets/layouts/card_container.dart';
import '../../../../widgets/shared/app_divider.dart';
import '../../../../widgets/shared/menu_item_tile.dart';
import '../../../../widgets/shared/section_label.dart';
import '../../../../widgets/shared/switch_tile.dart';
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) =>
          getIt<SettingsCubit>()..loadSettings(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Yakin ingin logout?',
      message: 'Anda akan keluar dari akun ini.',
      confirmLabel: 'Logout',
    );
    if (confirmed == true && context.mounted) {
      await context.read<SettingsCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text('Settings', style: AppTextTheme.titleLarge),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return switch (state) {
            SettingsInitial() ||
            SettingsLoading() =>
              const Center(child: CircularProgressIndicator()),
            SettingsError(:final message) => _errorState(context, message),
            SettingsLoaded() => _loaded(context, state),
          };
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, SettingsLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Section: Akun ──
        const SectionLabel(text: 'Akun'),
        CardContainer(children: [
          MenuItemTile(
            icon: Iconsax.user,
            label: 'Edit Profile',
            onTap: () => context.push(RoutePaths.editProfile),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Iconsax.lock,
            label: 'Ubah Password',
            onTap: () => context.push(RoutePaths.forgotPassword),
          ),
        ]),
        const SizedBox(height: 16),

        // ── Section: Preferensi ──
        const SectionLabel(text: 'Preferensi'),
        CardContainer(children: [
          SwitchTile(
            icon: Iconsax.notification,
            label: 'Push Notification',
            value: state.notifEnabled,
            onChanged: (v) =>
                context.read<SettingsCubit>().toggleNotification(v),
          ),
          const AppDivider(),
          SwitchTile(
            icon: Iconsax.moon,
            label: 'Dark Mode',
            value: state.darkMode,
            onChanged: null,
            disabledHint: 'Segera Hadir',
          ),
        ]),
        const SizedBox(height: 16),

        // ── Section: Aplikasi ──
        const SectionLabel(text: 'Aplikasi'),
        CardContainer(children: [
          const MenuItemTile(
            icon: Iconsax.infoCircle,
            label: 'Versi Aplikasi',
            trailing: Text(
              'v1.0.0 (build 1)',
              style: TextStyle(color: AppTheme.grey500, fontSize: 12),
            ),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Iconsax.documentText,
            label: 'Syarat & Ketentuan',
            onTap: () => context.push(RoutePaths.termsAndConditions),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Iconsax.messageQuestion,
            label: 'Bantuan & Dukungan',
            onTap: () => context.push(RoutePaths.helpSupport),
          ),
        ]),
        const SizedBox(height: 24),

        // ── Section: Logout ──
        OutlinedButton.icon(
          onPressed: () => _confirmLogout(context),
          icon: const Icon(Iconsax.logout01, color: AppTheme.darkRed),
          label: const Text(
            'Logout',
            style: TextStyle(
              color: AppTheme.darkRed,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.darkRed),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 16),
      ],
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
            Text('Gagal memuat pengaturan', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () =>
                  context.read<SettingsCubit>().loadSettings(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

// (SupabaseClient moved to SettingsCubit — not used in this page)
