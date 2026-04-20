import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
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
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppTheme.white,
        body: Column(
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
                  Column(
                    spacing: 32,
                    children: [
                      Column(
                        mainAxisSize: .min,
                        spacing: 8,
                        children: [
                          Text(
                            "Hi, Welcome Back! ",
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

                  PrimaryButton(onTap: () {}, label: "Sign In"),
                  Row(
                    spacing: 24,
                    children: [
                      Expanded(child: Divider()),
                      Text(
                        "or",
                        style: ts.bodySmall?.copyWith(color: AppTheme.grey500),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  Column(children: []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
