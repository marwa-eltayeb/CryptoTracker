import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/model/onboarding_model.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_navigation_button.dart';
import '../widgets/onboarding_action_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _pages = OnboardingModel.pages;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {

    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [

            // Skip button
            if (!isLastPage)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 24),
                  child: TextButton(
                    onPressed: _skipToEnd,
                    child: Text(
                      AppStrings.skip,
                      style: AppTextStyles.semiBold16.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 56),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    image: _pages[index].image,
                    title: _pages[index].title,
                  );
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                bottom: 32,
              ),
              child: isLastPage ? const OnboardingActionButtons() :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  OnboardingPageIndicator(
                    currentPage: _currentPage,
                    totalPages: _pages.length,
                  ),
                  // Next button
                  OnboardingNavigationButton(
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}