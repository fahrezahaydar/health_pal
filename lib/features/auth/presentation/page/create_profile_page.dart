import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax.dart';

import 'package:get_it/get_it.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/services/app_services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/dialog/app_loading_dialog.dart';
import '../../../../widgets/dialog/app_succes_dialog.dart';
import '../../../../widgets/form/app_dropdown_field.dart';
import '../../../../widgets/form/app_form.dart';
import '../../../../widgets/form/app_form_field.dart';
import '../../../../widgets/input/app_date_picker_form_field.dart';
import '../../../../widgets/picker/app_image_picker.dart';
import '../../presentation/bloc/create_profile/create_profile_cubit.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({
    super.key,
    this.email = '',
    this.password = '',
    this.fullname = '',
  });

  final String email;
  final String password;
  final String fullname;

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<AppFormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  File? _localPhoto;
  String? _remotePhotoUrl;

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(value);
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.fullname;
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSaveProfile(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final values = _formKey.currentState!.values;
    final dob = values['dob'] as DateTime?;
    if (dob == null) {
      // Shouldn't happen — validator catches null. Guard biar cast aman.
      return;
    }

    // FIX-8 safety belt: kunci status ke `profileIncomplete` SEBELUM
    // signUp. Tanpa ini, race condition: _onAuthStateChange(signedIn)
    // → _setStatusFromProfile() akan fetch user_profiles (row belum
    // ada, INSERT sedang berjalan) → Failure → upgrade status ke
    // `authenticated` ❌. Dengan setProfileIncomplete() dulu, status
    // sudah `profileIncomplete` saat _setStatusFromProfile() Failure
    // → KEEP (existing logic di app_services.dart:122-125).
    GetIt.instance<AppServices>().setProfileIncomplete();

    context.read<CreateProfileCubit>().registerAndCreateProfile(
      email: widget.email,
      password: widget.password,
      fullName: values['Name'] ?? '',
      nickname: values['Nickname'] ?? '',
      gender: values['gender'] as String,
      dob: dob,
      photo: _localPhoto,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateProfileCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<CreateProfileCubit, CreateProfileState>(
            listener: (context, state) {
              switch (state) {
                case CreateProfileLoading():
                  AppLoadingDialog.show(context);
                case CreateProfileSuccess():
                  AppLoadingDialog.dismiss(context);
                  GetIt.instance<AppServices>().markProfileComplete();
                  context.go(RoutePaths.home);
                case CreateProfileFailure():
                  AppLoadingDialog.dismiss(context);
                  final msg = state.message.toLowerCase();
                  final isAlreadyRegistered =
                      msg.contains('already registered') ||
                      msg.contains('user already');
                  AppCustomDialog.show(
                    context,
                    type: AppDialogType.error,
                    title: isAlreadyRegistered
                        ? 'Email Sudah Terdaftar'
                        : 'Gagal Mendaftar',
                    subtitle: isAlreadyRegistered
                        ? 'Email ini sudah terdaftar. Silakan login atau gunakan email lain.'
                        : state.message,
                  );
                default:
                  break;
              }
            },
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ColoredBox(
                color: AppTheme.white,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        spacing: 16,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: const Icon(
                                    Iconsax.arrowLeft01Style4,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            spacing: 24,
                            children: [
                              Center(
                                child: AppPhotoPicker(
                                  size: 160,
                                  localFile: _localPhoto,
                                  remoteUrl: _remotePhotoUrl,
                                  onPhotoSelected: (f) =>
                                      setState(() => _localPhoto = f),
                                  onPhotoRemoved: () =>
                                      setState(() => _localPhoto = null),
                                ),
                              ),
                              AppForm(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  spacing: 16,
                                  children: [
                                    AppTextFormField(
                                      name: 'Name',
                                      hintText: 'Your Name',
                                      isShowError: false,
                                      controller: _nameController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Nama wajib diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                    AppTextFormField(
                                      name: 'Email',
                                      controller: _emailController,
                                      hintText: 'Your Email',
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
                                    AppTextFormField(
                                      name: 'Nickname',
                                      controller: _nicknameController,
                                      hintText: 'Your Nickname',
                                      isShowError: false,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Nickname wajib diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                    AppDropdownFormField<String>(
                                      name: 'gender',
                                      hintText: 'Pilih Gender',
                                      items: const [
                                        AppDropdownItem(
                                          label: 'Laki-Laki',
                                          value: 'male',
                                        ),
                                        AppDropdownItem(
                                          label: 'Perempuan',
                                          value: 'female',
                                        ),
                                      ],
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Gender wajib dipilih';
                                        }
                                        return null;
                                      },
                                    ),
                                    AppDatePickerFormField(
                                      name: 'dob',
                                      hintText: 'Date of Birth',
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Tanggal lahir wajib diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                    LightFilledButton(
                                      onTap: () => _onSaveProfile(context),
                                      label: 'Save Profile',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
