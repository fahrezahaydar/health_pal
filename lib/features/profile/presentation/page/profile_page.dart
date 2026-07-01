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
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/shared/app_divider.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../bloc/profile/profile_cubit.dart';
import '../bloc/profile/profile_state.dart';
import '../dialog/logout_bottom_modal.dart';
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
    final profileCubit = context.read<ProfileCubit>();

    final shouldLogout = await LogOutBottomModal.show(context);
    if (!shouldLogout) return;

    profileCubit.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextTheme.headlineLarge,
        title: const Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProfileCubit>().loadProfile(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocSelector<
                ProfileCubit,
                ProfileState,
                (UserEntity, bool, String?)
              >(
                selector: (state) {
                  final mock = UserEntity.mock();
                  switch (state) {
                    case ProfileError(:final message):
                      return (mock, false, message);
                    case ProfileLoaded(:final user):
                      return (user, false, null);
                    default:
                      return (mock, true, null);
                  }
                },
                builder: (context, state) {
                  final (user, isLoading, error) = state;
                  if (error != null) {
                    return ErrorSection(
                      message: error,
                      onRetry: () => context.read<ProfileCubit>().loadProfile(),
                    );
                  } else {
                    return Skeletonizer(
                      enabled: isLoading,
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: ProfileHeader(
                              user: user,
                              onEditAvatar: () =>
                                  context.push(RoutePaths.editProfile),
                            ),
                          ),
                          Column(
                            children: [
                              ProfileMenuTile(
                                icon: AppIcons.userEdit,
                                label: 'Edit Profile',
                                onTap: () async {
                                  final changed = await context.push<bool>(
                                    RoutePaths.editProfile,
                                  );
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
                                onTap: () => context.push(
                                  RoutePaths.notificationSettings,
                                ),
                              ),
                              const AppDivider(),
                              ProfileMenuTile(
                                icon: AppIcons.settings,
                                label: 'Settings',
                                onTap: () => context.push(RoutePaths.settings),
                              ),
                              const AppDivider(),
                              ProfileMenuTile(
                                icon: AppIcons.messageQuestion,
                                label: 'Help & Support',
                                onTap: () =>
                                    context.push(RoutePaths.helpSupport),
                              ),
                              const AppDivider(),
                              ProfileMenuTile(
                                icon: AppIcons.securitySafe,
                                label: 'Terms & Conditions',
                                onTap: () =>
                                    context.push(RoutePaths.termsAndConditions),
                              ),
                              const AppDivider(),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              LogoutMenuTile(onTap: () => _confirmLogout(context)),
            ],
          ),
        ),
      ),
    );
  }
}
