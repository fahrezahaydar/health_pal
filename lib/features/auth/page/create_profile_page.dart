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

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<AppFormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _isShowPassword = ValueNotifier(false);

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(value);
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                                style: AppTextTheme.headlineLarge?.copyWith(
                                  color: AppTheme.primary,
                                ),
                              ),
                              Text(
                                "We are here to help you!",
                                style: AppTextTheme.bodySmall?.copyWith(
                                  color: AppTheme.grey500,
                                ),
                              ),
                            ],
                          ),
                          // Input Section
                          AppForm(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              spacing: 20,
                              children: [
                                AppFormField(
                                  name: "Name",
                                  hintText: "Your Name",
                                  isShowError: false,
                                  prefix: Icon(Iconsax.user),
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Nama wajib diisi';
                                    }

                                    return null;
                                  },
                                ),
                                AppFormField(
                                  name: "Email",
                                  controller: _emailController,
                                  prefix: const Icon(Iconsax.user),
                                  hintText: "Your Email",
                                  keyboardType: TextInputType.emailAddress,
                                  isShowError: false,

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
                                    return AppFormField(
                                      name: "Password",
                                      controller: _passwordController,
                                      isShowError: false,
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
                          ),
                        ],
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
