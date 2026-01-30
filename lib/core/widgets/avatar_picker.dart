import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../constants/app_spacing.dart';

class AvatarPicker extends StatelessWidget {
  final File? imageFile;
  final String? networkImageUrl;
  final VoidCallback onTap;
  final double size;
  final String label;

  const AvatarPicker({
    super.key,
    this.imageFile,
    this.networkImageUrl,
    required this.onTap,
    this.size = 100,
    this.label = 'Add photo',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gray200,
                    width: 2,
                  ),
                ),
                child: _buildAvatarContent(),
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
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: onTap,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.primary600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarContent() {
    if (imageFile != null) {
      return ClipOval(
        child: Image.file(
          imageFile!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          networkImageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person,
            size: 50,
            color: AppColors.gray400,
          ),
        ),
      );
    }

    return const Icon(
      Icons.person_outline,
      size: 50,
      color: AppColors.gray400,
    );
  }

  /// Shows the avatar picker bottom sheet and returns the selected image file
  static Future<File?> showPickerBottomSheet(
    BuildContext context, {
    File? currentImage,
    bool allowRemove = true,
  }) async {
    final picker = ImagePicker();
    File? result;
    bool removed = false;

    await showModalBottomSheet(
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
                currentImage != null ? 'Change Photo' : 'Add Photo',
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
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? photo = await picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 85,
                    );
                    if (photo != null) {
                      result = File(photo.path);
                    }
                  } catch (e) {
                    debugPrint('Camera error: $e');
                  }
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
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 85,
                    );
                    if (image != null) {
                      result = File(image.path);
                    }
                  } catch (e) {
                    debugPrint('Gallery error: $e');
                  }
                },
              ),
              if (allowRemove && currentImage != null)
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
                    removed = true;
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );

    // Return null to indicate removal, otherwise return the result
    if (removed) {
      return null;
    }
    return result ?? currentImage;
  }
}
