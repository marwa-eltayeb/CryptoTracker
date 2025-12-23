import 'package:crypto_tracker/core/constants/app_assets.dart';
import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:crypto_tracker/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_tracker/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:crypto_tracker/features/auth/presentation/widgets/primary_button.dart';
import 'package:crypto_tracker/features/auth/presentation/widgets/auth_icon_button.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_state.dart';
import 'package:crypto_tracker/config/routing/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/utils/snackbar_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, Routes.home);
          } else if (state is AuthError) {
            SnackBarUtils.showSnackBar(context, state.message, backgroundColor: AppColors.red);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Decorative Circle at the top-right corner
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8EAF0),
                  ),
                ),
              ),
              SafeArea(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        const SizedBox(height: 80),

                        Text(
                          AppStrings.loginToYourAccount,
                          style: AppTextStyles.bold32.copyWith(
                            color: AppColors.primary,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          AppStrings.welcomeBackMissed,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regular14.copyWith(
                            color: AppColors.black,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 80),

                        AuthTextField(
                          hintText: AppStrings.emailIDHint,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: Validator.validateEmail,
                        ),

                        const SizedBox(height: 20),

                        AuthTextField(
                          hintText: AppStrings.password,
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _passwordController,
                          validator: Validator.validatePassword,
                        ),

                        const SizedBox(height: 20),

                        // Remember Me and Forget Password Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.rememberMe,
                                  style: AppTextStyles.regular14.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // Implement forget password
                              },
                              child: Text(
                                AppStrings.forgetPassword,
                                style: AppTextStyles.semiBold14.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Login Button
                        state is AuthLoading ? const Center(child: CircularProgressIndicator(),)
                            : PrimaryButton(
                          text: AppStrings.login,
                          onPressed: _handleLogin,  // No context parameter
                        ),

                        const SizedBox(height: 32),

                        Text(
                          AppStrings.orLoginWith,
                          style: AppTextStyles.regular14.copyWith(
                            color: AppColors.greyText,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Authentication Options
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AuthIconButton(
                              iconPath: AppAssets.fingerprintIcon,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, Routes.biometric);
                              },
                            ),

                            const SizedBox(width: 40),

                            AuthIconButton(
                              iconPath: AppAssets.faceIdIcon,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, Routes.faceId);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Sign Up Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.dontHaveAccount,
                              style: AppTextStyles.regular14.copyWith(
                                color: AppColors.greyMedium,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.register);
                              },
                              child: Text(
                                AppStrings.signUp,
                                style: AppTextStyles.semiBold14.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
