import 'package:crypto_tracker/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_tracker/core/constants/app_strings.dart';
import 'package:crypto_tracker/core/utils/validator.dart';
import 'package:crypto_tracker/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:crypto_tracker/features/auth/presentation/widgets/primary_button.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:crypto_tracker/features/auth/presentation/cubit/auth_state.dart';
import 'package:crypto_tracker/config/routing/routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final username = '$firstName $lastName'.trim();

      context.read<AuthCubit>().register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: username.isEmpty ? null : username,
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
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
            Navigator.pushReplacementNamed(
              context,
              Routes.biometric,
              arguments: true,
            );
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
              // Main Content
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              const SizedBox(height: 20),

                              Text(
                                AppStrings.createYourAccount,
                                style: AppTextStyles.bold32.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                AppStrings.signUpToEnjoy,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.regular14.copyWith(
                                  color: AppColors.black,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 40),

                              AuthTextField(
                                hintText: AppStrings.firstName,
                                icon: Icons.person_outline,
                                controller: _firstNameController,
                                validator: Validator.validateName,
                              ),

                              const SizedBox(height: 16),

                              AuthTextField(
                                hintText: AppStrings.lastName,
                                icon: Icons.person_outline,
                                controller: _lastNameController,
                                validator: Validator.validateName,
                              ),

                              const SizedBox(height: 16),

                              AuthTextField(
                                hintText: AppStrings.emailID,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: Validator.validateEmail,
                              ),

                              const SizedBox(height: 16),

                              AuthTextField(
                                controller: _passwordController,
                                hintText: AppStrings.password,
                                icon: Icons.lock_outline,
                                isPassword: true,
                                isPasswordVisible: _isPasswordVisible,
                                onTogglePasswordVisibility: () {
                                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                                },
                                validator: Validator.validatePassword,
                              ),

                              const SizedBox(height: 16),

                              AuthTextField(
                                controller: _confirmPasswordController,
                                hintText: AppStrings.confirmPassword,
                                icon: Icons.lock_outline,
                                isPassword: true,
                                isPasswordVisible: _isConfirmPasswordVisible,
                                onTogglePasswordVisibility: () {
                                  setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                                },
                                validator: (val) => Validator.validateConfirmPassword(val, _passwordController.text),
                              ),

                              const SizedBox(height: 16),

                              AuthTextField(
                                hintText: AppStrings.phoneNumberHint,
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                controller: _phoneController,
                                validator: Validator.validatePhoneNumber,
                              ),

                              const SizedBox(height: 32),

                              // Register Button
                              state is AuthLoading ? const Center(child: CircularProgressIndicator(),)
                                  : PrimaryButton(
                                text: AppStrings.register,
                                onPressed: () => _handleRegister(),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Login Link
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount,
                            style: AppTextStyles.regular14.copyWith(
                              color: AppColors.greyMedium,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.login);
                            },
                            child: Text(
                              AppStrings.loginLink,
                              style: AppTextStyles.semiBold14.copyWith(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}