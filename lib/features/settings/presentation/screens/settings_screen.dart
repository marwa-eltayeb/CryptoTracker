import 'package:crypto_tracker/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_tracker/config/routing/routes.dart';
import 'package:crypto_tracker/config/theme/app_colors.dart';
import 'package:crypto_tracker/config/theme/app_style.dart';
import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:crypto_tracker/core/utils/snackbar_utils.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_state.dart';
import 'package:crypto_tracker/features/settings/presentation/widgets/profile_header.dart';
import 'package:crypto_tracker/features/settings/presentation/widgets/settings_item.dart';
import 'package:crypto_tracker/features/settings/presentation/widgets/settings_toggle.dart';
import 'package:crypto_tracker/features/settings/presentation/widgets/section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {

    final authState = context.watch<AuthCubit>().state;
    final userName = authState is AuthAuthenticated ? (authState.user.username?.isNotEmpty == true ? authState.user.username! : 'User') : 'User';
    final userPhoto = authState is AuthAuthenticated ? authState.user.photoUrl : null;

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.greyBackground,
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
              Center(
                child: ProfileHeader(
                  imageUrl: userPhoto ?? AppAssets.profileImagePath,
                  name: userName,
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
                        Navigator.pushNamed(context, Routes.myAccount);
                      },
                    ),

                    const Divider(height: 1, indent: 72),

                    SettingsItem(
                      icon: Icons.account_balance_wallet_outlined,
                      title: AppStrings.billingPayment,
                      onTap: () {
                        SnackBarUtils.showSnackBar(context, AppStrings.navigateToBillingPayment);
                      },
                    ),

                    const Divider(height: 1, indent: 72),

                    SettingsItem(
                      icon: Icons.help_outline,
                      title: AppStrings.faqSupport,
                      onTap: () {
                        SnackBarUtils.showSnackBar(context, AppStrings.navigateToFaqSupport);
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
                        SnackBarUtils.showSnackBar(context, AppStrings.navigateToLanguage);
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
    );
  }
}