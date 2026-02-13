import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    required this.onTap,
    super.key,
    this.imageFile,
    this.networkImageUrl,
    this.size = 100,
    this.label = 'Add photo',
  });
  final File? imageFile;
  final String? networkImageUrl;
  final VoidCallback onTap;
  final double size;
  final String label;

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
                  border: Border.all(color: AppColors.gray200, width: 2),
                ),
                child: _AvatarContent(
                  imageFile: imageFile,
                  networkImageUrl: networkImageUrl,
                  size: size,
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
                    border: Border.all(color: Colors.white, width: 2),
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
            style: const TextStyle(
              color: AppColors.primary600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
    var isRemoved = false;

    await showModalBottomSheet<void>(
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
                    final photo = await picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 85,
                    );
                    if (photo != null) {
                      result = File(photo.path);
                    }
                  } on Exception catch (_) {
                    // Camera unavailable or permission denied
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
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 85,
                    );
                    if (image != null) {
                      result = File(image.path);
                    }
                  } on Exception catch (_) {
                    // Gallery unavailable or permission denied
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
                    isRemoved = true;
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );

    if (isRemoved) return null;
    return result ?? currentImage;
  }
}

class _AvatarContent extends StatelessWidget {
  const _AvatarContent({
    this.imageFile,
    this.networkImageUrl,
    this.size = 100,
  });

  final File? imageFile;
  final String? networkImageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final file = imageFile;
    if (file != null) {
      return ClipOval(
        child: Image.file(file, width: size, height: size, fit: BoxFit.cover),
      );
    }

    final url = networkImageUrl;
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.person, size: 50, color: AppColors.gray400),
        ),
      );
    }

    return const Icon(Icons.person_outline, size: 50, color: AppColors.gray400);
  }
}
