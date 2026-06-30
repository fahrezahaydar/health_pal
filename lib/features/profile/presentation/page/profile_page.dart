// lib/features/profile/presentation/page/profile_page.dart
//
// Halaman Profile (Shell Tab 4). Per wireframe 14-profile.md v2.0.
// - ProfileHeader (avatar + edit overlay + nama + phone)
// - Menu list: Edit Profile, Favorite, Notifications, Settings,
//   Help & Support, Terms & Conditions, Log Out
//
// Pola: Stateless wrapper (BlocProvider) + StatelessWidget view.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialog/app_confirm_dialog.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/app_divider.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../bloc/profile/profile_cubit.dart';
import '../bloc/profile/profile_state.dart';
import '../widget/logout_menu_tile.dart';
import '../widget/profile_header.dart';
import '../widget/profile_menu_tile.dart';

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
      title: 'Logout',
      message: 'Are you sure you want to log out?',
      confirmLabel: 'Yes, Logout',
      cancelLabel: 'Cancel',
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
            ProfileInitial() || ProfileLoading() => Skeletonizer(
              enabled: true,
              child: _loaded(context, UserEntity.mock()),
            ),
            ProfileError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ErrorSection(
                      message: message,
                      onRetry: () => context.read<ProfileCubit>().loadProfile(),
                    ),
                    const SizedBox(height: 24),
                    LogoutMenuTile(
                      onTap: () => _confirmLogout(context),
                    ),
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
          ProfileHeader(
            user: user,
            onEditAvatar: () => context.push(RoutePaths.editProfile),
          ),
          const SizedBox(height: 24),
          _menuList(context),
          const SizedBox(height: 24),
          LogoutMenuTile(onTap: () => _confirmLogout(context)),
        ],
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
          ProfileMenuTile(
            icon: AppIcons.person,
            label: 'Edit Profile',
            onTap: () async {
              final changed = await context.push<bool>(RoutePaths.editProfile);
              if (changed == true && context.mounted) {
                context.read<ProfileCubit>().loadProfile();
              }
            },
          ),
          const AppDivider(),
          ProfileMenuTile(
            icon: AppIcons.favorite,
            label: 'Favorite',
            onTap: () => context.push(RoutePaths.favorite),
          ),
          const AppDivider(),
          ProfileMenuTile(
            icon: AppIcons.notification,
            label: 'Notifications',
            onTap: () => context.push(RoutePaths.notificationSettings),
          ),
          const AppDivider(),
          ProfileMenuTile(
            icon: AppIcons.settings,
            label: 'Settings',
            onTap: () => context.push(RoutePaths.settings),
          ),
          const AppDivider(),
          ProfileMenuTile(
            icon: AppIcons.help,
            label: 'Help & Support',
            onTap: () => context.push(RoutePaths.helpSupport),
          ),
          const AppDivider(),
          ProfileMenuTile(
            icon: AppIcons.description,
            label: 'Terms & Conditions',
            onTap: () => context.push(RoutePaths.termsAndConditions),
          ),
        ],
      ),
    );
  }
}
