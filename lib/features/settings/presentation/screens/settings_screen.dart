import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_toggle.dart';
import '../widgets/section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.settingsBackground,
      appBar: AppBar(
        backgroundColor: AppColors.settingsBackground,
        elevation: 0,
        title: Text(
          AppStrings.settings,
          style: AppTextStyles.bold32.copyWith(
            color: AppColors.balanceGradientStart,
          ),
        ),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Profile Header
              const Center(
                child: ProfileHeader(
                  imageUrl: AppStrings.profileImagePath,
                  name: AppStrings.sophiaIsabella,
                ),
              ),

              const SizedBox(height: 32),

              // General Section
              const SectionHeader(title: AppStrings.general),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [

                    SettingsItem(
                      icon: Icons.person_outline,
                      title: AppStrings.myAccount,
                      onTap: () {
                        SnackbarUtils.showSnackbar(context, AppStrings.navigateToMyAccount);
                      },
                    ),

                    const Divider(height: 1, indent: 72),

                    SettingsItem(
                      icon: Icons.account_balance_wallet_outlined,
                      title: AppStrings.billingPayment,
                      onTap: () {
                        SnackbarUtils.showSnackbar(context, AppStrings.navigateToBillingPayment);
                      },
                    ),

                    const Divider(height: 1, indent: 72),

                    SettingsItem(
                      icon: Icons.help_outline,
                      title: AppStrings.faqSupport,
                      onTap: () {
                        SnackbarUtils.showSnackbar(context, AppStrings.navigateToFaqSupport);
                      },
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings Section
              const SectionHeader(title: AppStrings.settingsSection),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SettingsItem(
                      icon: Icons.language,
                      title: AppStrings.language,
                      onTap: () {
                        SnackbarUtils.showSnackbar(context, AppStrings.navigateToLanguage);
                      },
                    ),

                    const Divider(height: 1, indent: 72),

                    SettingsToggle(
                      icon: Icons.dark_mode_outlined,
                      title: AppStrings.darkMode,
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}