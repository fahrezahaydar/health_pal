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
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart' show getIt;
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialog/app_confirm_dialog.dart';
import '../../../../widgets/layouts/card_container.dart';
import '../../../../widgets/loader/error_section.dart';
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

  Future<void> _showEmergencyPhoneDialog(BuildContext context) async {
    final controller = TextEditingController(
      text: context.read<SettingsCubit>().getEmergencyPhone(),
    );
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Telepon Darurat'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+62 812-xxxx-xxxx',
            labelText: 'Nomor Telepon',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (result != null && context.mounted) {
      await context.read<SettingsCubit>().setEmergencyPhone(result);
    }
  }

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
              Skeletonizer(
                enabled: true,
                child: _loaded(
                  context,
                  const SettingsLoaded(
                    notifEnabled: false,
                    darkMode: false,
                    email: 'email@example.com',
                  ),
                ),
              ),
            SettingsError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: ErrorSection(
                    message: message,
                    onRetry: () =>
                        context.read<SettingsCubit>().loadSettings(),
                  ),
                ),
              ),
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
            icon: Icons.person, // TODO: change to iconsax
            label: 'Edit Profile',
            onTap: () => context.push(RoutePaths.editProfile),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.lock , // TODO: change to iconsax
            label: 'Ubah Password',
            onTap: () => context.push(RoutePaths.forgotPassword),
          ),
          if (state.email.isNotEmpty) ...[
            const AppDivider(),
            MenuItemTile(
              icon: Icons.email , // TODO: change to iconsax
              label: 'Email Terdaftar',
              trailing: Text(
                state.email,
                style: const TextStyle(color: AppTheme.grey500, fontSize: 12),
              ),
            ),
          ],
          const AppDivider(),
          MenuItemTile(
            icon: Icons.phone , // TODO: change to iconsax
            label: 'Telepon Darurat',
            trailing: Text(
              context.read<SettingsCubit>().getEmergencyPhone() ?? '+62 8xx-xxxx',
              style: const TextStyle(color: AppTheme.grey500, fontSize: 12),
            ),
            onTap: () => _showEmergencyPhoneDialog(context),
          ),
        ]),
        const SizedBox(height: 16),

        // ── Section: Preferensi ──
        const SectionLabel(text: 'Preferensi'),
        CardContainer(children: [
          SwitchTile(
            icon: Icons.notifications , // TODO: change to iconsax
            label: 'Push Notification',
            value: state.notifEnabled,
            onChanged: (v) =>
                context.read<SettingsCubit>().toggleNotification(v),
          ),
          const AppDivider(),
          SwitchTile(
            icon: Icons.dark_mode , // TODO: change to iconsax
            label: 'Dark Mode',
            value: state.darkMode,
            onChanged: null,
            disabledHint: 'Segera Hadir',
          ),
        ]),
        const SizedBox(height: 16),

        // ── Section: Data & Cache (Sprint 3 — S3.5) ──
        const SectionLabel(text: 'Data & Cache'),
        CardContainer(children: [
          MenuItemTile(
            icon: Icons.delete , // TODO: change to iconsax
            label: 'Hapus Cache',
            onTap: () async {
              final confirmed = await AppConfirmDialog.show(
                context,
                title: 'Hapus Cache?',
                message:
                    'Cache akan dihapus. Data login dan appointment tidak terpengaruh.',
                confirmLabel: 'Hapus',
              );
              if (confirmed == true && context.mounted) {
                await context.read<SettingsCubit>().clearCache();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache berhasil dihapus')),
                  );
                }
              }
            },
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.storage , // TODO: change to iconsax
            label: 'Hapus Data Lokal',
            onTap: () async {
              final confirmed = await AppConfirmDialog.show(
                context,
                title: 'Hapus Data Lokal?',
                message:
                    'Semua data lokal akan dihapus. Anda tetap login.',
                confirmLabel: 'Hapus',
              );
              if (confirmed == true && context.mounted) {
                await context.read<SettingsCubit>().clearLocalData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Data lokal berhasil dihapus')),
                  );
                }
              }
            },
          ),
        ]),
        const SizedBox(height: 16),

        // ── Section: Aplikasi ──
        const SectionLabel(text: 'Aplikasi'),
        CardContainer(children: [
          const MenuItemTile(
            icon: Icons.info , // TODO: change to iconsax
            label: 'Versi Aplikasi',
            trailing: Text(
              'v1.0.0 (build 1)',
              style: TextStyle(color: AppTheme.grey500, fontSize: 12),
            ),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.description , // TODO: change to iconsax
            label: 'Syarat & Ketentuan',
            onTap: () => context.push(RoutePaths.termsAndConditions),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.help , // TODO: change to iconsax
            label: 'Bantuan & Dukungan',
            onTap: () => context.push(RoutePaths.helpSupport),
          ),
        ]),
        const SizedBox(height: 24),

        // ── Section: Logout ──
        OutlinedButton.icon(
          onPressed: () => _confirmLogout(context),
          // TODO: change to iconsax — currently Material fallback
          icon: const Icon(Icons.logout, color: AppTheme.darkRed),
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

}
