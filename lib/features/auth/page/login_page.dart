import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../core/theme/app_text_theme.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/button/outline_button.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/input/app_form.dart';
import '../../../widgets/input/app_form_field.dart';

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

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(value);
  }

  void _onSignIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // TODO: submit login
    } else {
      Map<String, String>? errors = _formKey.currentState!.errors;
      if (errors != null) {
        print("Validation Errors: $errors");
      }
    }
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
                    "assets/logo-dark.png",
                    width: 108,
                    height: 108,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AppForm(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  "Hi, Welcome Back!",
                                  style: AppTextTheme.headlineLarge.copyWith(
                                    color: AppTheme.primary,
                                  ),
                                ),
                                Text(
                                  "Hope you're doing fine.",
                                  style: AppTextTheme.bodySmall.copyWith(
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
                                  name: "Email",
                                  controller: _emailController,
                                  prefix: const Icon(Iconsax.smsStyle5),
                                  hintText: "Your Email",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Email wajib diisi';
                                    }
                                    if (!_isValidEmail(value)) {
                                      return 'Format email tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: _isShowPassword,
                                  builder: (context, value, child) {
                                    return AppTextFormField(
                                      name: "Password",
                                      controller: _passwordController,
                                      prefix: const Icon(Iconsax.padlockStyle5),
                                      hintText: "Password",
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
                          ],
                        ),

                        LightFilledButton(
                          onTap: () {
                            _onSignIn(context);
                          },
                          label: "Sign In",
                        ),

                        // Divider Section
                        Row(
                          spacing: 24,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 1,
                                child: ColoredBox(color: AppTheme.grey200),
                              ),
                            ),
                            Text(
                              "or",
                              style: AppTextTheme.bodySmall.copyWith(
                                color: AppTheme.grey500,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 1,
                                child: ColoredBox(color: AppTheme.grey200),
                              ),
                            ),
                          ],
                        ),

                        // Social Login Section
                        Column(
                          spacing: 16,
                          children: [
                            LightOutlineButton(
                              icon: Image.asset(
                                "assets/icon/google.png",
                                width: 20,
                                height: 20,
                              ),
                              label: "Sign In with Google",
                              onTap: () {},
                            ),
                            LightOutlineButton(
                              icon: Image.asset(
                                "assets/icon/facebook.png",
                                width: 20,
                                height: 20,
                              ),
                              label: "Sign In with Facebook",
                              onTap: () {},
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login/forgot-password'),
                          child: Text(
                            "Forgot password?",
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
                                text: "Sign up",
                                style: AppTextTheme.bodySmall.copyWith(
                                  color: AppTheme.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.go('/sign-up'),
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
    );
  }
}
