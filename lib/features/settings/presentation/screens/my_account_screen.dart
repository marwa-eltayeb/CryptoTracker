import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routing/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/account_menu_item.dart';
import '../widgets/logout_confirmation_dialog.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LogoutConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle logout completion
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false,);
        }
        // Handle logout errors
        else if (state is AuthError) {
          SnackBarUtils.showSnackBar(context, state.message, backgroundColor: AppColors.red,);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.greyBackground,
        appBar: AppBar(
          backgroundColor: AppColors.greyBackground,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppStrings.myAccountTitle,
            style: AppTextStyles.bold32.copyWith(
              color: AppColors.balanceGradientStart,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final userName = authState is AuthAuthenticated ? (authState.user.username?.isNotEmpty == true ? authState.user.username! : AppStrings.defaultUserName) : AppStrings.defaultUserName;
            final userEmail = authState is AuthAuthenticated ? authState.user.email : '';
            final userPhoto = authState is AuthAuthenticated ? authState.user.photoUrl : null;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Profile Picture
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: userPhoto != null ? NetworkImage(userPhoto) : null,
                      child: userPhoto == null ? Icon(Icons.person, size: 60, color: AppColors.primary) : null,
                    ),

                    const SizedBox(height: 20),

                    // User Name
                    Text(
                      userName,
                      style: AppTextStyles.bold32.copyWith(
                        fontSize: 24,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // User Email
                    Text(
                      userEmail,
                      style: AppTextStyles.regular14.copyWith(
                        color: AppColors.greyText,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Account Information Section
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          AccountMenuItem(
                            icon: Icons.person_outline,
                            title: AppStrings.editProfile,
                            onTap: () {
                              SnackBarUtils.showSnackBar(
                                context,
                                AppStrings.editProfileComingSoon,
                              );
                            },
                          ),

                          const Divider(height: 1, indent: 72),

                          AccountMenuItem(
                            icon: Icons.lock_outline,
                            title: AppStrings.changePassword,
                            onTap: () {
                              SnackBarUtils.showSnackBar(
                                context,
                                AppStrings.changePasswordComingSoon,
                              );
                            },
                          ),

                          const Divider(height: 1, indent: 72),

                          AccountMenuItem(
                            icon: Icons.security,
                            title: AppStrings.securitySettings,
                            onTap: () {
                              SnackBarUtils.showSnackBar(
                                context,
                                AppStrings.securitySettingsComingSoon,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Logout Button
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _handleLogout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppStrings.logout,
                              style: AppTextStyles.semiBold14.copyWith(
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}