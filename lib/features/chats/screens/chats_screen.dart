import 'package:flutter/material.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: AppSpacing.xxxxl,
              color: AppColors.gray300,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Chats', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Coming soon...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.gray500),
            ),
          ],
        ),
      ),
    );
  }
}
