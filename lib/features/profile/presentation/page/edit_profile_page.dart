// lib/features/profile/presentation/page/edit_profile_page.dart
//
// Halaman Edit Profile. Per wireframe 15-profile-edit.md.
// Pola: Stateless wrapper (BlocProvider) + StatefulWidget view.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_latest/iconsax_latest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/enums/gender.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialog/app_loading_dialog.dart';
import '../../../../widgets/dialog/app_succes_dialog.dart';
import '../../../../widgets/form/app_dropdown_field.dart';
import '../../../../widgets/form/date_picker_field.dart';
import '../../../../widgets/form/labeled_text_field.dart';
import '../../../../widgets/picker/app_image_picker.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../bloc/edit_profile/edit_profile_cubit.dart';
import '../bloc/edit_profile/edit_profile_state.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileCubit>(
      create: (_) => getIt<EditProfileCubit>()..loadEdit(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  File? _newPhoto;
  UserEntity? _initialUser;

  void _populateFrom(UserEntity user) {
    if (_initialUser?.id == user.id) return; // already populated
    _initialUser = user;
    _nameController.text = user.fullName;
    _nicknameController.text = user.nickname ?? '';
    _selectedDate = user.dateOfBirth;
    _selectedGender = user.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: now,
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'Pilih tanggal';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final user = _initialUser;
    if (user == null) return;
    final session = getIt<SupabaseClient>().auth.currentSession;
    final authId = session?.user.id ?? user.authId;

    // Tampilkan loading dialog
    AppLoadingDialog.show(context);

    context.read<EditProfileCubit>().updateProfile(
      authId: authId,
      fullName: _nameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      dateOfBirth: _selectedDate != null
          ? '${_selectedDate!.year.toString().padLeft(4, '0')}-'
                '${_selectedDate!.month.toString().padLeft(2, '0')}-'
                '${_selectedDate!.day.toString().padLeft(2, '0')}'
          : null,
      gender: _selectedGender,
      photo: _newPhoto,
      onSuccess: () async {
        if (!mounted) return;
        await AppLoadingDialog.dismiss(context);
        if (!mounted) return;
        await AppCustomDialog.show(
          context,
          type: AppDialogType.success,
          title: 'Berhasil',
          subtitle: 'Profil berhasil disimpan',
        );
        if (!mounted) return;
        // Pop dengan `true` agar Profile page tahu harus refresh
        // (lihat _EditProfile tap handler di profile_page.dart).
        context.pop(true);
      },
      onError: (message) async {
        if (!mounted) return;
        await AppLoadingDialog.dismiss(context);
        if (!mounted) return;
        await AppCustomDialog.show(
          context,
          type: AppDialogType.error,
          title: 'Gagal',
          subtitle: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        // Populate form fields once we have data.
        if (state is EditProfileLoaded) _populateFrom(state.user);

        return Scaffold(
          backgroundColor: AppTheme.grey50,
          appBar: AppBar(
            backgroundColor: AppTheme.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Iconsax.arrowLeft01, color: AppTheme.grey900),
              onPressed: () => context.pop(),
            ),
            title: Text('Edit Profile', style: AppTextTheme.titleLarge),
          ),
          body: switch (state) {
            EditProfileInitial() || EditProfileLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            EditProfileError(:final message) => _errorView(context, message),
            _ => _formView(context, state),
          },
        );
      },
    );
  }

  Widget _formView(BuildContext context, EditProfileState state) {
    final user = _initialUser;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar picker ──
            Center(
              child: AppPhotoPicker(
                localFile: _newPhoto,
                remoteUrl: user?.avatarUrl,
                size: 100,
                onPhotoSelected: (file) => setState(() => _newPhoto = file),
                onPhotoRemoved: () => setState(() => _newPhoto = null),
              ),
            ),
            const SizedBox(height: 24),
            LabeledTextField(
              label: 'Full Name',
              controller: _nameController,
              required: true,
            ),
            const SizedBox(height: 12),
            LabeledTextField(
              label: 'Nickname',
              controller: _nicknameController,
              required: true,
            ),
            const SizedBox(height: 12),
            DatePickerField(
              label: 'Date of Birth',
              valueText: _formatDate(_selectedDate),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            _genderField(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: AppTextTheme.bodyMedium),
        const SizedBox(height: 4),
        AppDropdownFormField<String>(
          name: 'gender',
          initialValue: _selectedGender,
          hintText: 'Pilih gender',
          items: Gender.values
              .map(
                (g) => AppDropdownItem<String>(
                  value: g.value.toLowerCase(),
                  label: g.value,
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectedGender = v),
        ),
      ],
    );
  }

  Widget _errorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.warning2, size: 64, color: AppTheme.darkRed),
            const SizedBox(height: 16),
            Text('Gagal memuat profil', style: AppTextTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.read<EditProfileCubit>().loadEdit(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
