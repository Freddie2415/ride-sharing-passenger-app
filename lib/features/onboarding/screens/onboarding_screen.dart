import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:passenger/app/router/app_router.dart';
import 'package:passenger/core/constants/app_spacing.dart';
import 'package:passenger/core/theme/app_colors.dart';
import 'package:passenger/core/widgets/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      icon: Icons.location_on_rounded,
      title: 'Travel Between Cities',
      description:
          'Find rides between cities at affordable prices. Share the journey, split the cost.',
    ),
    _OnboardingSlide(
      icon: Icons.savings_rounded,
      title: 'Save Money',
      description:
          'Cheaper than rental cars, more flexible than buses. Travel your way.',
    ),
    _OnboardingSlide(
      icon: Icons.verified_user_rounded,
      title: 'Safe & Verified',
      description:
          'All drivers are background-checked with verified reviews and ratings.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToPhoneInput();
    }
  }

  void _navigateToPhoneInput() {
    context.go(AppRoutes.phoneInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: TextButton(
                  onPressed: _navigateToPhoneInput,
                  child: Text(
                    'Skip',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.gray500),
                  ),
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(slide: _slides[index]);
                },
              ),
            ),
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _slides.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.primary600,
                  dotColor: AppColors.gray300,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: AppButton(
                onPressed: _onNextPressed,
                label: _currentPage == _slides.length - 1
                    ? 'Get Started'
                    : 'Next',
                icon: Icons.arrow_forward_rounded,
                iconPosition: IconPosition.right,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Sign in link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: _navigateToPhoneInput,
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.slide});
  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder with icon
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 100, color: AppColors.primary600),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          // Title
          Text(
            slide.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          // Description
          Text(
            slide.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.gray600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
