import 'package:crypto_tracker/config/theme/app_colors.dart';
import 'package:crypto_tracker/config/theme/app_style.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final VoidCallback? onTogglePasswordVisibility;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.controller,
    this.keyboardType,
    this.onTogglePasswordVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
        validator: validator,
        style: AppTextStyles.regular14.copyWith(color: AppColors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.regular14.copyWith(color: AppColors.greyMedium,),
          prefixIcon: Icon(icon, color: AppColors.greyMedium, size: 24),
          border: InputBorder.none,
          suffixIcon: isPassword ?
          IconButton(
            icon: Icon(isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF999999),
              size: 20,
            ),
            onPressed: onTogglePasswordVisibility,
          ) : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}