import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../../core/theme/app_text_theme.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/button/outline_button.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/input/app_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
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
                                  "Hi, Welcome Back!",
                                  style: ts.headlineLarge?.copyWith(
                                    color: AppTheme.primary,
                                  ),
                                ),
                                Text(
                                  "Hope you’re doing fine.",
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
                                  hintText: "Your Email",
                                  controller: _emailController,
                                ),
                                AppInputField(
                                  hintText: "Password",
                                  isPassword: true,
                                  controller: _passwordController,
                                ),
                              ],
                            ),
                          ],
                        ),

                        LightFilledButton(onTap: () {}, label: "Sign In"),

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
                          onTap: () => print("Forgot Password Clicked"),
                          child: Text(
                            "Forgot password?",
                            style: ts.bodySmall?.copyWith(
                              color: AppTheme.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Don’t have an account yet? ",
                                style: ts.bodySmall?.copyWith(
                                  color: AppTheme.grey500,
                                ),
                              ),
                              TextSpan(
                                text: "Sign up",
                                style: ts.bodySmall?.copyWith(
                                  color: AppTheme.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => print("Sign Up Clicked"),
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
