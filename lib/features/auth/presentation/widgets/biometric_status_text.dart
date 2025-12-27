import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class BiometricStatusText extends StatelessWidget {
  final String message;
  final Color? color;

  const BiometricStatusText({
    super.key,
    required this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: AppTextStyles.regular16.copyWith(
        color: color ?? AppColors.grey,
      ),
    );
  }
}