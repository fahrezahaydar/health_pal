import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:get_it/get_it.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/services/app_services.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/button/outline_button.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../../../widgets/form/app_form.dart';
import '../../../../widgets/form/app_form_field.dart';
import '../../presentation/bloc/sign_in/sign_in_bloc.dart';
import '../../presentation/bloc/sign_in/sign_in_event.dart';
import '../../presentation/bloc/sign_in/sign_in_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<AppFormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isShowPassword = ValueNotifier(false);

  void _onSignIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SignInBloc>().add(
        SignInWithEmail(_emailController.text.trim(), _passwordController.text),
      );
    }
  }

  void _onSignInWithGoogle() {
    context.read<SignInBloc>().add(const SignInWithGoogle());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isShowPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state is SignInSuccess) {
                final user = state.user;
                if (user.isProfileComplete) {
                  // Profile lengkap: set status ke authenticated dan
                  // navigasi langsung ke /home. Tidak ada race dengan
                  // _setStatusFromProfile() (kedua-duanya akan set
                  // status ke authenticated).
                  GetIt.instance<AppServices>().login();
                  context.go(RoutePaths.home);
                } else {
                  // Profile belum lengkap. JANGAN panggil
                  // AppServices.login() karena akan set status ke
                  // authenticated (konflik dengan _setStatusFromProfile()
                  // di event handler yang set ke profileIncomplete).
                  // Cukup navigasi; router Kondisi 3 akan match dengan
                  // status akhir.
                  context.go(RoutePaths.createProfile);
                }
              }
            },
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ColoredBox(
                color: AppTheme.white,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Image.asset(
                            'assets/logo-dark.png',
                            width: 108,
                            height: 108,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: AppForm(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              spacing: 24,
                              children: [
                                // Header Section
                                Column(
                                  spacing: 32,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 8,
                                      children: [
                                        Text(
                                          'Hi, Welcome Back!',
                                          style: AppTextTheme.headlineLarge
                                              .copyWith(
                                                color: AppTheme.primary,
                                              ),
                                        ),
                                        Text(
                                          "Hope you're doing fine.",
                                          style: AppTextTheme.bodySmall
                                              .copyWith(
                                                color: AppTheme.grey500,
                                              ),
                                        ),
                                      ],
                                    ),
                                    // Input Section
                                    Column(
                                      spacing: 20,
                                      children: [
                                        AppTextFormField(
                                          name: 'Email',
                                          controller: _emailController,
                                          prefix: const Icon(AppIcons.email),
                                          hintText: 'Your Email',
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Email wajib diisi';
                                            }
                                            if (Validators.email(value) !=
                                                null) {
                                              return 'Format email tidak valid';
                                            }
                                            return null;
                                          },
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: _isShowPassword,
                                          builder: (context, value, child) {
                                            return AppTextFormField(
                                              name: 'Password',
                                              controller: _passwordController,
                                              prefix: const Icon(AppIcons.lock),
                                              hintText: 'Password',
                                              isPassword: !value,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Password wajib diisi';
                                                }
                                                return null;
                                              },
                                              suffix: GestureDetector(
                                                onTap: () {
                                                  _isShowPassword.value =
                                                      !_isShowPassword.value;
                                                },
                                                child: Icon(
                                                  value
                                                      ? AppIcons.visibilityOff
                                                      : AppIcons.visibility,
                                                  color: AppTheme.grey500,
                                                  size: 20,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                BlocBuilder<SignInBloc, SignInState>(
                                  builder: (context, state) {
                                    return Skeletonizer(
                                      enabled: state is SignInLoading,
                                      child: Column(
                                        spacing: 8,
                                        children: [
                                          if (state is SignInFailure)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: ErrorSection(
                                                message: state.message,
                                                onRetry: () =>
                                                    _onSignIn(context),
                                              ),
                                            ),
                                          LightFilledButton(
                                            onTap: state is SignInLoading
                                                ? null
                                                : () => _onSignIn(context),
                                            label: 'Sign In',
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                // Divider Section
                                Row(
                                  spacing: 24,
                                  children: [
                                    const Expanded(
                                      child: SizedBox(
                                        height: 1,
                                        child: ColoredBox(
                                          color: AppTheme.grey200,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'or',
                                      style: AppTextTheme.bodySmall.copyWith(
                                        color: AppTheme.grey500,
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox(
                                        height: 1,
                                        child: ColoredBox(
                                          color: AppTheme.grey200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Social Login Section
                                BlocBuilder<SignInBloc, SignInState>(
                                  builder: (context, state) {
                                    return Column(
                                      spacing: 16,
                                      children: [
                                        LightOutlineButton(
                                          icon: Image.asset(
                                            'assets/icon/google.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          label: 'Sign In with Google',
                                          onTap: state is SignInLoading
                                              ? null
                                              : _onSignInWithGoogle,
                                        ),
                                        LightOutlineButton(
                                          icon: Image.asset(
                                            'assets/icon/facebook.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          label: 'Sign In with Facebook',
                                          onTap: () {},
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      context.go(RoutePaths.forgotPassword),
                                  child: Text(
                                    'Forgot password?',
                                    style: AppTextTheme.bodySmall.copyWith(
                                      color: AppTheme.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Don't have an account yet? ",
                                        style: AppTextTheme.bodySmall.copyWith(
                                          color: AppTheme.grey500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Sign up',
                                        style: AppTextTheme.bodySmall.copyWith(
                                          color: AppTheme.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              context.go(RoutePaths.signUp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
