import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/services/app_services.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../widgets/button/primary_button.dart';
import '../../../../widgets/dialog/app_loading_dialog.dart';
import '../../../../widgets/dialog/app_succes_dialog.dart';
import '../../../../widgets/picker/app_image_picker.dart';
import '../../../../core/utils/validators.dart';
import '../../presentation/bloc/create_profile/create_profile_cubit.dart';

class CreateProfilePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateProfileCubit>(
        param1: CreateProfileArgs(
          fullName: fullname,
          email: email,
          password: password,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(AppIcons.arrowBack, size: 24),
          ),
        ),
        body: const CreateProfileView(),
      ),
    );
  }
}

class CreateProfileView extends StatefulWidget {
  const CreateProfileView({super.key});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateProfileCubit>().state;
    _dateController = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(state.dateOfBirth),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final cubit = context.read<CreateProfileCubit>();

    final result = await showDatePicker(
      context: context,
      initialDate: cubit.state.dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      _dateController.text = DateFormat('dd MMM yyyy').format(result);
      cubit.updateDateOfBirth(result);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    context.read<CreateProfileCubit>().register();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    final cubit = context.read<CreateProfileCubit>();
    return BlocListener<CreateProfileCubit, CreateProfileState>(
      listener: (context, state) {
        if (state.status == CubitStatus.loading) {
          AppLoadingDialog.show(context);
        }

        if (state.status == CubitStatus.success && state.user != null) {
          AppLoadingDialog.dismiss(context);
          GetIt.instance<AppServices>().markProfileComplete();
          context.go(RoutePaths.home);
        }

        if (state.status == CubitStatus.failure) {
          AppLoadingDialog.dismiss(context);
          final msg = state.errorMessage?.toLowerCase() ?? '';
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
                : state.errorMessage ?? '',
          );
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            spacing: 24,
            children: [
              // ================= PHOTO =================
              BlocBuilder<CreateProfileCubit, CreateProfileState>(
                buildWhen: (p, c) => p.photo != c.photo,
                builder: (context, state) {
                  return AppPhotoPicker(
                    size: 140,
                    localFile: state.photo,
                    onPhotoSelected: (File file) {
                      context.read<CreateProfileCubit>().updatePhoto(file);
                    },
                    onPhotoRemoved: () {
                      context.read<CreateProfileCubit>().updatePhoto(null);
                    },
                  );
                },
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  spacing: 16,
                  children: [
                    // ================= FULL NAME =================
                    BlocBuilder<CreateProfileCubit, CreateProfileState>(
                      buildWhen: (p, c) => p.fullName != c.fullName,
                      builder: (context, state) {
                        return TextFormField(
                          initialValue: state.fullName,
                          style: ts.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                          validator: (v) => Validators.required(v, 'Full Name'),
                          onChanged: cubit.updateFullName,
                        );
                      },
                    ),

                    // ================= EMAIL =================
                    BlocBuilder<CreateProfileCubit, CreateProfileState>(
                      buildWhen: (p, c) => p.email != c.email,
                      builder: (context, state) {
                        return TextFormField(
                          style: ts.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          initialValue: state.email,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: Validators.email,
                          onChanged: cubit.updateEmail,
                        );
                      },
                    ),

                    // ================= NICKNAME =================
                    BlocBuilder<CreateProfileCubit, CreateProfileState>(
                      buildWhen: (p, c) => p.nickname != c.nickname,
                      builder: (context, state) {
                        return TextFormField(
                          style: ts.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          initialValue: state.nickname,
                          decoration: const InputDecoration(
                            labelText: 'Nickname',
                          ),
                          validator: (v) => Validators.required(v, 'Nickname'),
                          onChanged: cubit.updateNickname,
                        );
                      },
                    ),
                    // ================= GENDER =================
                    BlocBuilder<CreateProfileCubit, CreateProfileState>(
                      buildWhen: (p, c) => p.gender != c.gender,
                      builder: (context, state) {
                        return DropdownButtonFormField<String>(
                          style: ts.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          initialValue: state.gender.isEmpty
                              ? null
                              : state.gender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                          ),
                          validator: (v) => Validators.required(v, 'Gender'),
                          items: const [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text('Laki-Laki'),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('Perempuan'),
                            ),
                            DropdownMenuItem(
                              value: 'other',
                              child: Text('Lainnya'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              cubit.updateGender(value);
                            }
                          },
                        );
                      },
                    ),
                    // ================= BIRTH DATE =================
                    BlocBuilder<CreateProfileCubit, CreateProfileState>(
                      buildWhen: (p, c) => p.dateOfBirth != c.dateOfBirth,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _dateController,
                          style: ts.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Date of birth is required';
                            }
                            return null;
                          },
                          onTap: _pickDate,
                        );
                      },
                    ),
                    LightFilledButton(onTap: _submit, label: 'Save Profile'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
