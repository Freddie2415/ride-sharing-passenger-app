import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/services/passenger_service.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/core/widgets/widgets.dart';
import 'package:passenger/features/profile/cubit/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  File? _avatarFile;
  String? _networkAvatarUrl;
  bool _avatarChanged = false;

  String _initialName = '';
  String _initialEmail = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().state.user;
    if (user != null) {
      final displayName =
          user.name ??
          [user.firstName, user.lastName].where((s) => s != null).join(' ');
      _nameController.text = displayName;
      _emailController.text = user.email ?? '';
      _networkAvatarUrl = user.avatar;

      _initialName = displayName;
      _initialEmail = user.email ?? '';
    }

    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool get _hasChanges =>
      _nameController.text != _initialName ||
      _emailController.text != _initialEmail ||
      _avatarChanged;

  void _onFieldChanged() {
    setState(() {});
  }

  bool get _isFormValid => _nameController.text.trim().isNotEmpty;

  Future<void> _onPickAvatar() async {
    final result = await AvatarPicker.showPickerBottomSheet(
      context,
      currentImage: _avatarFile,
    );
    // null means removal was chosen
    if (result == null && (_avatarFile != null || _networkAvatarUrl != null)) {
      setState(() {
        _avatarFile = null;
        _networkAvatarUrl = null;
        _avatarChanged = true;
      });
    } else if (result != null && result != _avatarFile) {
      setState(() {
        _avatarFile = result;
        _networkAvatarUrl = null;
        _avatarChanged = true;
      });
    }
  }

  void _onSave() {
    if (!_isFormValid) return;

    final fullName = _nameController.text.trim();
    final spaceIndex = fullName.indexOf(' ');
    final firstName = spaceIndex == -1
        ? fullName
        : fullName.substring(0, spaceIndex);
    final lastName = spaceIndex == -1
        ? ''
        : fullName.substring(spaceIndex + 1).trim();

    context.read<ProfileCubit>().updateProfile(
      ProfileUpdateRequest(
        firstName: firstName,
        lastName: lastName.isNotEmpty ? lastName : firstName,
        email: _emailController.text.trim(),
        avatar: _avatarChanged ? _avatarFile : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<ProfileCubit>().state.user;
    final phone = user?.phone ?? '';

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => prev.isSaving && !curr.isSaving,
      listener: (context, state) {
        final saveError = state.saveError;
        if (saveError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(saveError),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<ProfileCubit>().clearSaveError();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Personal Info'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        Center(
                          child: _EditAvatar(
                            avatarFile: _avatarFile,
                            networkAvatarUrl: _networkAvatarUrl,
                            onTap: _onPickAvatar,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        AppTextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          label: 'Name',
                          hint: 'John Smith',
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            _emailFocusNode.requestFocus();
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Phone (read-only)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.lg,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd,
                                ),
                                border: Border.all(color: AppColors.gray200),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      phone,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppColors.gray600),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Contact support to change',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.gray500),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppTextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          label: 'Email',
                          hint: 'john@example.com',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _onSave(),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    buildWhen: (prev, curr) => prev.isSaving != curr.isSaving,
                    builder: (context, state) {
                      return AppButton(
                        onPressed:
                            _isFormValid && _hasChanges && !state.isSaving
                            ? _onSave
                            : null,
                        label: 'Save',
                        isLoading: state.isSaving,
                        isDisabled: !_isFormValid || !_hasChanges,
                      );
                    },
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

class _EditAvatar extends StatelessWidget {
  const _EditAvatar({
    required this.onTap,
    this.avatarFile,
    this.networkAvatarUrl,
  });

  final File? avatarFile;
  final String? networkAvatarUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AvatarPicker(
      imageFile: avatarFile,
      networkImageUrl: networkAvatarUrl,
      onTap: onTap,
      label: 'Change photo',
    );
  }
}
