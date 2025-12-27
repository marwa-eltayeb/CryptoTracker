import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class BiometricActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const BiometricActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isPrimary ? AppColors.primary : AppColors.greyLight,
          foregroundColor:
          isPrimary ? Colors.white : AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
