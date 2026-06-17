// lib/features/profile/presentation/page/profile_page.dart
//
// Halaman Profile (Shell Tab 4). Per wireframe 14-profile.md.
// - Avatar + nama + email
// - Menu list: Edit Profile, Favorites, Notifications, Settings, Help, T&C, Logout
//
// Pola: Stateless wrapper (BlocProvider) + StatefulWidget view (logic + UI).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialog/app_confirm_dialog.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/app_divider.dart';
import '../../../../widgets/shared/menu_item_tile.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../bloc/profile/profile_cubit.dart';
import '../bloc/profile/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Yakin ingin logout?',
      message: 'Kamu akan keluar dari akun ini.',
      confirmLabel: 'Logout',
    );
    if (confirmed == true && context.mounted) {
      await context.read<ProfileCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text('Profile', style: AppTextTheme.titleLarge),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() || ProfileLoading() => const Skeletonizer(
              enabled: true,
              child: _ProfileSkeleton(),
            ),
            ProfileError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ErrorSection(
                      message: message,
                      onRetry: () =>
                          context.read<ProfileCubit>().loadProfile(),
                    ),
                    const SizedBox(height: 24),
                    _logoutButton(context),
                  ],
                ),
              ),
            ),
            ProfileLoaded(:final user) => _loaded(context, user),
          };
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, UserEntity user) {
    return RefreshIndicator(
      onRefresh: () => context.read<ProfileCubit>().loadProfile(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _userCard(user),
          const SizedBox(height: 16),
          _menuList(context),
          const SizedBox(height: 16),
          _logoutButton(context),
        ],
      ),
    );
  }

  Widget _userCard(UserEntity user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        children: [
          // ── Avatar ──
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.grey100,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.grey200, width: 2),
            ),
            child: user.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      user.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _avatarPlaceholder(user),
                    ),
                  )
                : _avatarPlaceholder(user),
          ),
          const SizedBox(height: 12),
          Text(user.fullName, style: AppTextTheme.titleLarge),
          if (user.nickname != null) ...[
            const SizedBox(height: 2),
            Text(
              '@${user.nickname}',
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            user.email,
            style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(UserEntity user) {
    final initial = user.fullName.isNotEmpty
        ? user.fullName[0].toUpperCase()
        : '?';
    return Center(
      child: Text(
        initial,
        style: AppTextTheme.headlineLarge.copyWith(color: AppTheme.primary),
      ),
    );
  }

  Widget _menuList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        children: [
          MenuItemTile(
            icon: Icons.person, // TODO: change to iconsax
            label: 'Edit Profile',
            onTap: () async {
              // EditProfilePage.pop(true) menandakan data telah berubah.
              // Refresh ProfileCubit biar UI tampil data terbaru tanpa
              // harus pull-to-refresh manual.
              final changed = await context.push<bool>(RoutePaths.editProfile);
              if (changed == true && context.mounted) {
                context.read<ProfileCubit>().loadProfile();
              }
            },
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.favorite , // TODO: change to iconsax
            label: 'Favorite',
            onTap: () => context.push(RoutePaths.favorite),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.notifications , // TODO: change to iconsax
            label: 'Notification',
            onTap: () => context.push(RoutePaths.notificationSettings),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.settings , // TODO: change to iconsax
            label: 'Settings',
            onTap: () => context.push(RoutePaths.settings),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.help , // TODO: change to iconsax
            label: 'Help and Support',
            onTap: () => context.push(RoutePaths.helpSupport),
          ),
          const AppDivider(),
          MenuItemTile(
            icon: Icons.description , // TODO: change to iconsax
            label: 'T & C',
            onTap: () => context.push(RoutePaths.termsAndConditions),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _confirmLogout(context),
      // TODO: change to iconsax — currently Material fallback
      icon: const Icon(Icons.logout, color: AppTheme.darkRed),
      label: const Text(
        'Logout',
        style: TextStyle(color: AppTheme.darkRed, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.darkRed),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.grey200),
          ),
          child: const Column(
            children: [
              CircleAvatar(radius: 40),
              SizedBox(height: 12),
              Text('Full Name', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.grey200),
          ),
        ),
      ],
    );
  }
}


