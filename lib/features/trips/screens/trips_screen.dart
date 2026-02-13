import 'package:flutter/material.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: AppSpacing.xxxxl,
              color: AppColors.gray300,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('My Trips', style: Theme.of(context).textTheme.titleLarge),
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
