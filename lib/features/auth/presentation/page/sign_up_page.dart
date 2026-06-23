import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _isShowPassword = ValueNotifier(false);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _isShowPassword.dispose();
    super.dispose();
  }

  void _onCreateAccount(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.go(
        RoutePaths.createProfile,
        extra: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'name': _nameController.text.trim(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
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
                  Column(
                    spacing: 32,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          Text(
                            'Create Account',
                            style: AppTextTheme.headlineLarge.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(
                            'We are here to help you!',
                            style: AppTextTheme.bodySmall.copyWith(
                              color: AppTheme.grey500,
                            ),
                          ),
                        ],
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          spacing: 20,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Your Name',
                                labelText: 'Full Name',
                                prefix: Icon(AppIcons.person),
                              ),
                              controller: _nameController,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Email wajib diisi';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Your Email',
                                prefix: Icon(AppIcons.email),
                              ),
                              controller: _emailController,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Email wajib diisi';
                                }
                                if (Validators.email(value) != null) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
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
                      ),
                    ],
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () => _onCreateAccount(context),
                    child: const Text('Create Account'),
                  ),
                  const AuthDivider(),
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
                        label: const Text('Continue with Google'),
                        onPressed: () {},
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
                        label: const Text('Continue with Facebook'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Do you have an account ? ',
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppTheme.grey500,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppTheme.blue,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go(RoutePaths.signIn),
                        ),
                      ],
                    ),
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
