
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';

class OnboardingModel {
  final String image;
  final String title;

  OnboardingModel({
    required this.image,
    required this.title,
  });

  static List<OnboardingModel> get pages => [
    OnboardingModel(
      image: AppAssets.onboardingFirstPage,
      title: AppStrings.welcomeToCryptoX,
    ),
    OnboardingModel(
      image: AppAssets.onboardingSecondPage,
      title: AppStrings.transactionSecurity,
    ),
    OnboardingModel(
      image: AppAssets.onboardingThirdPage,
      title: AppStrings.fastAndReliableMarketUpdated,
    ),
    OnboardingModel(
      image: AppAssets.onboardingFourthPage,
      title: AppStrings.getStartedNow,
    ),
  ];
}