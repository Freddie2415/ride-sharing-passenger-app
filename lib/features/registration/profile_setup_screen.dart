import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/widgets.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  bool _isLoading = false;
  String? _avatarPath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid => _nameController.text.trim().isNotEmpty;

  void _onPickAvatar() {
    // Mock: Show bottom sheet for avatar selection
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Add Photo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary600,
                  ),
                ),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // Mock: Set avatar
                  setState(() {
                    _avatarPath = 'camera';
                  });
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primary600,
                  ),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Mock: Set avatar
                  setState(() {
                    _avatarPath = 'gallery';
                  });
                },
              ),
              if (_avatarPath != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.errorBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                  ),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _avatarPath = null;
                    });
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Mock registration delay
    // Real API flow:
    // 1. POST /api/v1/passenger/register { name, email }
    // 2. If avatar selected: PUT /api/v1/passenger/profile (multipart with avatar)
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Mock: Show success and navigate
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile created successfully! (Mock)'),
          backgroundColor: AppColors.success,
        ),
      );

      // In real app: navigate to home
      // context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // Title
                      Text(
                        'Tell us about yourself',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      // Avatar
                      Center(
                        child: GestureDetector(
                          onTap: _onPickAvatar,
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.gray100,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.gray200,
                                    width: 2,
                                  ),
                                ),
                                child: _avatarPath != null
                                    ? ClipOval(
                                        child: Container(
                                          color: AppColors.primary100,
                                          child: const Center(
                                            child: Icon(
                                              Icons.person,
                                              size: 50,
                                              color: AppColors.primary600,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person_outline,
                                        size: 50,
                                        color: AppColors.gray400,
                                      ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary600,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Center(
                        child: Text(
                          'Add photo',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary600,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      // Full Name field
                      AppTextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        label: 'Full Name *',
                        hint: 'John Smith',
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) {
                          _emailFocusNode.requestFocus();
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Email field
                      AppTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: 'Email (optional)',
                        hint: 'john@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _onContinue(),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'For receipts and notifications',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.gray500,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              // Continue button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: AppButton(
                  onPressed: _isFormValid && !_isLoading ? _onContinue : null,
                  label: 'Continue',
                  isLoading: _isLoading,
                  isDisabled: !_isFormValid,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
