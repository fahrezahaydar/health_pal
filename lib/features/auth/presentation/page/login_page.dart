import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/loader/error_section.dart';
import '../../presentation/bloc/sign_in/sign_in_bloc.dart';
import '../../presentation/bloc/sign_in/sign_in_event.dart';
import '../../presentation/bloc/sign_in/sign_in_state.dart';
import '../widget/auth_title.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInBloc>(),
      child: const Scaffold(body: LoginView()),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isShowPassword = ValueNotifier(false);

  void _onSignIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SignInBloc>().add(
        SignInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
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
    final ts = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
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
            child: Column(
              spacing: 24,
              children: [
                // Header Section
                Column(
                  spacing: 32,
                  children: [
                    const AuthTitle(
                      title: 'Hi, Welcome Back!',
                      subtitle: "Hope you're doing fine.",
                    ),
                    // Input Section
                    Column(
                      spacing: 20,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          style: ts.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email wajib diisi';
                            }
                            if (Validators.email(value) != null) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Your Email',
                            prefixIcon: Icon(AppIcons.email),
                          ),
                        ),

                        ValueListenableBuilder(
                          valueListenable: _isShowPassword,
                          builder: (context, value, child) {
                            return TextFormField(
                              controller: _passwordController,
                              obscureText: !value,
                              style: ts.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password wajib diisi';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Password',
                                prefixIcon: const Icon(AppIcons.lock),
                                suffixIcon: GestureDetector(
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
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ErrorSection(
                                message: state.message,
                                onRetry: () => _onSignIn(context),
                              ),
                            ),
                          FilledButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                            onPressed: state is SignInLoading
                                ? null
                                : () => _onSignIn(context),
                            child: const Text('Sign In'),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Divider Section
                const AuthDivider(),

                // Social Login Section
                Column(
                  spacing: 16,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: Image.asset(
                        'assets/icon/google.png',
                        width: 20,
                        height: 20,
                      ),
                      label: const Text('Sign In with Google'),
                      onPressed: _onSignInWithGoogle,
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: Image.asset(
                        'assets/icon/facebook.png',
                        width: 20,
                        height: 20,
                      ),
                      label: const Text('Sign In with Facebook'),
                      onPressed: () {},
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () => context.go(RoutePaths.forgotPassword),
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
                          ..onTap = () => context.go(RoutePaths.signUp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24,
      children: [
        const Expanded(
          child: SizedBox(
            height: 1,
            child: ColoredBox(color: AppTheme.grey200),
          ),
        ),
        Text(
          'or',
          style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
        ),
        const Expanded(
          child: SizedBox(
            height: 1,
            child: ColoredBox(color: AppTheme.grey200),
          ),
        ),
      ],
    );
  }
}
