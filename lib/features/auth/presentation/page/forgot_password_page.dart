import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/dialog/app_loading_dialog.dart';
import '../../../../widgets/form/app_form.dart';
import '../../../../widgets/form/app_form_field.dart';
import '../../../../widgets/form/app_form_pin_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/forget_password/forget_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<AppFormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ForgotPasswordCubit>(),
      child: Builder(
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: ColoredBox(
              color: AppTheme.white,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      spacing: 32,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: GestureDetector(
                                onTap: () {
                                  final step = context
                                      .read<ForgotPasswordCubit>()
                                      .state;
                                  if (step == ForgotPasswordStep.initial) {
                                    context.pop();
                                  } else {
                                    context.read<ForgotPasswordCubit>().back();
                                  }
                                },
                                // TODO: change to iconsax — currently Material fallback
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/logo-dark.png',
                          width: 108,
                          height: 108,
                          fit: BoxFit.fitHeight,
                        ),
                        AppForm(
                          key: _formKey,

                          child: Column(
                            spacing: 24,
                            children: [
                              // Header Section
                              BlocBuilder<
                                ForgotPasswordCubit,
                                ForgotPasswordStep
                              >(
                                builder: (context, state) {
                                  switch (state) {
                                    case ForgotPasswordStep.initial:
                                      return const ForgetPassword();
                                    case ForgotPasswordStep.verify:
                                      return const VerifyCode();
                                    case ForgotPasswordStep.newPassword:
                                      return const CreateNewPassword();
                                  }
                                },
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
        },
      ),
    );
  }
}

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  'Forget Password?',
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
            AppTextFormField(
              name: 'Email',
              controller: TextEditingController(),
              // TODO: change to iconsax — currently Material fallback
              prefix: const Icon(Icons.email),
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
            LightFilledButton(
              onTap: () async {
                final form = AppForm.of(context);
                if (form.validate()) {
                  final email = form.values['Email']!;
                  AppLoadingDialog.show(context);
                  await context.read<ForgotPasswordCubit>().sendEmail(
                    email,
                    onSuccess: (value) {
                      AppLoadingDialog.dismiss(context);
                    },
                  );
                } else {
                  Map<String, String>? errors = form.errors;
                  if (errors != null) {
                    // errors handled by AppForm via state
                  }
                }
              },
              label: 'Send Code',
            ),
          ],
        ),
      ],
    );
  }
}

class VerifyCode extends StatelessWidget {
  const VerifyCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(
              'Verify Code',
              style: AppTextTheme.headlineLarge.copyWith(
                color: AppTheme.primary,
              ),
            ),
            Text(
              'Enter the the code\nwe just sent you on your registered Email',
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // Input Section
        AppFormPinField(
          name: 'Code',
          controller: TextEditingController(),
          length: 5,

          validator: (value) {
            if (value.length < 5) {
              return 'OTP tidak valid';
            }
            return null;
          },
        ),
        LightFilledButton(
          onTap: () async {
            final form = AppForm.of(context);
            if (form.validate()) {
              final code = form.values['Code']!;
              AppLoadingDialog.show(context);
              await context.read<ForgotPasswordCubit>().verifyCode(
                code,
                onSuccess: (value) {
                  AppLoadingDialog.dismiss(context);
                },
              );
            } else {
              Map<String, String>? errors = form.errors;
              if (errors != null) {
                // errors handled by AppForm via state
              }
            }
          },
          label: 'Verify Code',
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Didn’t get the Code? ',
                style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              ),
              TextSpan(
                text: 'Resend',
                style: AppTextTheme.bodySmall.copyWith(
                  color: AppTheme.blue,
                  fontWeight: FontWeight.w500,
                ),
                recognizer: TapGestureRecognizer()..onTap = () => {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _isShowNewPassword = ValueNotifier(false);
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _isShowConfirmNewPassword = ValueNotifier(false);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _isShowConfirmNewPassword.dispose();
    _isShowNewPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(
              'Create new password',
              style: AppTextTheme.headlineLarge.copyWith(
                color: AppTheme.primary,
              ),
            ),
            Text(
              'Your new password must be different form previously used password',
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // Input Section
        Column(
          spacing: 20,
          children: [
            ValueListenableBuilder(
              valueListenable: _isShowNewPassword,
              builder: (context, value, child) {
                return AppTextFormField(
                  name: 'New Password',
                  controller: _newPasswordController,
                  // TODO: change to iconsax — currently Material fallback
                  prefix: const Icon(Icons.lock),
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
                      _isShowNewPassword.value = !_isShowNewPassword.value;
                    },
                    child: Icon(
                      // TODO: change to iconsax — currently Material fallback
                      value ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.grey500,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _isShowConfirmNewPassword,
              builder: (context, value, child) {
                return AppTextFormField(
                  name: 'Confirm New Password',
                  controller: _confirmNewPasswordController,
                  // TODO: change to iconsax — currently Material fallback
                  prefix: const Icon(Icons.lock),
                  hintText: 'Confirm Password',
                  isPassword: !value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password wajib diisi';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Invalid Confirm Password';
                    }
                    return null;
                  },
                  suffix: GestureDetector(
                    onTap: () {
                      _isShowConfirmNewPassword.value =
                          !_isShowConfirmNewPassword.value;
                    },
                    child: Icon(
                      // TODO: change to iconsax — currently Material fallback
                      value ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.grey500,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        LightFilledButton(
          onTap: () async {
            final form = AppForm.of(context);
            if (form.validate()) {
              final password = form.values['New Password']!;
              AppLoadingDialog.show(context);
              await context.read<ForgotPasswordCubit>().resetPassword(
                password,
                onSuccess: (value) async {
                  await AppLoadingDialog.dismiss(context);
                  if (context.mounted) {
                    context.pop();
                  }
                },
              );
            } else {
              Map<String, String>? errors = form.errors;
              if (errors != null) {
                // errors handled by AppForm via state
              }
            }
          },
          label: 'Reset Password',
        ),
      ],
    );
  }
}
