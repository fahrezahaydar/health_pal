import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/button/outline_button.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/form/app_form.dart';
import '../../../../widgets/form/app_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<AppFormState>();

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
    return Directionality(
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
                                style: AppTextTheme.headlineLarge
                                    .copyWith(color: AppTheme.primary),
                              ),
                              Text(
                                'We are here to help you!',
                                style: AppTextTheme.bodySmall.copyWith(
                                  color: AppTheme.grey500,
                                ),
                              ),
                            ],
                          ),
                          AppForm(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              spacing: 20,
                              children: [
                                AppTextFormField(
                                  name: 'Name',
                                  isShowError: false,
                                  hintText: 'Your Name',
                                  prefix: const Icon(Iconsax.user),
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Email wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                                AppTextFormField(
                                  name: 'Email',
                                  isShowError: false,
                                  controller: _emailController,
                                  prefix: const Icon(Iconsax.smsStyle5),
                                  hintText: 'Your Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value.isEmpty) {
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
                                    return AppTextFormField(
                                      name: 'Password',
                                      isShowError: false,
                                      controller: _passwordController,
                                      prefix: const Icon(
                                        Iconsax.padlockStyle5,
                                      ),
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
                                              ? Iconsax.eyeSlash
                                              : Iconsax.eye,
                                          color: AppTheme.grey500,
                                          size: 20,
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
                      LightFilledButton(
                        onTap: () => _onCreateAccount(context),
                        label: 'Create Account',
                      ),
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
                      Column(
                        spacing: 16,
                        children: [
                          LightOutlineButton(
                            icon: Image.asset(
                              'assets/icon/google.png',
                              width: 20,
                              height: 20,
                            ),
                            label: 'Continue with Google',
                            onTap: () {},
                          ),
                          LightOutlineButton(
                            icon: Image.asset(
                              'assets/icon/facebook.png',
                              width: 20,
                              height: 20,
                            ),
                            label: 'Continue with Facebook',
                            onTap: () {},
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
                                ..onTap = () =>
                                    context.go(RoutePaths.signIn),
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
        ),
      ),
    );
  }
}
