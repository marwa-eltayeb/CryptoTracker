import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';

class AuthIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const AuthIconButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black10Shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 40,
            height: 40,
            colorFilter: const ColorFilter.mode(
              AppColors.greyMedium,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}