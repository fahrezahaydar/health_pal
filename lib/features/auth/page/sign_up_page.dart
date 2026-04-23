import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

import '../../../core/theme/app_text_theme.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/button/outline_button.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/input/app_input_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = AppTextTheme.ts;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: ts.bodyMedium ?? const TextStyle(color: Color(0xFF000000)),
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
                                  "Create Account",
                                  style: ts.headlineLarge?.copyWith(
                                    color: AppTheme.primary,
                                  ),
                                ),
                                Text(
                                  "We are here to help you!",
                                  style: ts.bodySmall?.copyWith(
                                    color: AppTheme.grey500,
                                  ),
                                ),
                              ],
                            ),
                            // Input Section
                            Column(
                              spacing: 20,
                              children: [
                                AppInputField(
                                  hintText: "Your Name",
                                  prefix: Icon(Iconsax.user),
                                  controller: _nameController,
                                ),
                                AppInputField(
                                  hintText: "Your Email",
                                  prefix: Icon(Iconsax.smsStyle5),
                                  controller: _emailController,
                                ),
                                AppInputField(
                                  hintText: "Password",
                                  prefix: Icon(Iconsax.padlockStyle5),

                                  isPassword: true,
                                  controller: _passwordController,
                                ),
                              ],
                            ),
                          ],
                        ),

                        LightFilledButton(
                          onTap: () {},
                          label: "Create Account",
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
                              style: ts.bodySmall?.copyWith(
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
                              label: "Continue with Google",
                              onTap: () {},
                            ),
                            LightOutlineButton(
                              icon: Image.asset(
                                "assets/icon/facebook.png",
                                width: 20,
                                height: 20,
                              ),
                              label: "Continue with Facebook",
                              onTap: () {},
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Do you have an account ? ",
                                style: ts.bodySmall?.copyWith(
                                  color: AppTheme.grey500,
                                ),
                              ),
                              TextSpan(
                                text: "Sign In",
                                style: ts.bodySmall?.copyWith(
                                  color: AppTheme.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.go('/login'),
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
      ),
    );
  }
}
