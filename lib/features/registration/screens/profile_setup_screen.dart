import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/di/injection.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/core/widgets/widgets.dart';
import 'package:passenger/features/registration/cubit/registration_cubit.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegistrationCubit>(),
      child: const _ProfileSetupBody(),
    );
  }
}

class _ProfileSetupBody extends StatefulWidget {
  const _ProfileSetupBody();

  @override
  State<_ProfileSetupBody> createState() => _ProfileSetupBodyState();
}

class _ProfileSetupBodyState extends State<_ProfileSetupBody> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  File? _avatarFile;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty;

  Future<void> _onPickAvatar() async {
    final result = await AvatarPicker.showPickerBottomSheet(
      context,
      currentImage: _avatarFile,
    );
    if (result != _avatarFile) {
      setState(() {
        _avatarFile = result;
      });
    }
  }

  void _onContinue() {
    if (!_isFormValid) return;

    final email = _emailController.text.trim();

    context.read<RegistrationCubit>().register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: email.isNotEmpty ? email : null,
      avatar: _avatarFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state.status == RegistrationStatus.success) {
          context.go(AppRoutes.home);
        } else if (state.status == RegistrationStatus.error) {
          final hasFieldErrors = state.fieldErrors?.isNotEmpty ?? false;
          if (!hasFieldErrors) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Registration failed'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Create Account'),
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
                        Text(
                          'Tell us about yourself',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        Center(
                          child: AvatarPicker(
                            imageFile: _avatarFile,
                            onTap: _onPickAvatar,
                            label: _avatarFile != null
                                ? 'Change photo'
                                : 'Add photo',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        BlocBuilder<RegistrationCubit, RegistrationState>(
                          buildWhen: (prev, curr) =>
                              prev.fieldErrors != curr.fieldErrors,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  controller: _firstNameController,
                                  focusNode: _firstNameFocusNode,
                                  label: 'First Name *',
                                  hint: 'John',
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) => setState(() {}),
                                  onSubmitted: (_) =>
                                      _lastNameFocusNode.requestFocus(),
                                  errorText:
                                      state.fieldErrors?['first_name']?.first,
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                AppTextField(
                                  controller: _lastNameController,
                                  focusNode: _lastNameFocusNode,
                                  label: 'Last Name *',
                                  hint: 'Smith',
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) => setState(() {}),
                                  onSubmitted: (_) =>
                                      _emailFocusNode.requestFocus(),
                                  errorText:
                                      state.fieldErrors?['last_name']?.first,
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                AppTextField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  label: 'Email (optional)',
                                  hint: 'john@example.com',
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _onContinue(),
                                  errorText: state.fieldErrors?['email']?.first,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'For receipts and notifications',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.gray500),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: BlocBuilder<RegistrationCubit, RegistrationState>(
                    buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
                    builder: (context, state) {
                      return AppButton(
                        onPressed: _isFormValid && !state.isLoading
                            ? _onContinue
                            : null,
                        label: 'Continue',
                        isLoading: state.isLoading,
                        isDisabled: !_isFormValid,
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
