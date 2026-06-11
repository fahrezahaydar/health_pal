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
                  GetIt.instance<AppServices>().login();
                  context.go(RoutePaths.home);
                case CreateProfileFailure():
                  AppLoadingDialog.dismiss(context);
                  AppCustomDialog.show(
                    context,
                    type: AppDialogType.error,
                    title: 'Failed',
                    subtitle: state.message,
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
                                    LightFilledButton(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          final values =
                                              _formKey.currentState!.values;
                                          context
                                              .read<CreateProfileCubit>()
                                              .saveProfile({
                                                'full_name':
                                                    values['Name'] ?? '',
                                                'nickname':
                                                    values['Nickname'] ?? '',
                                                'gender': values['gender'],
                                              }, photo: _localPhoto);
                                        }
                                      },
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
