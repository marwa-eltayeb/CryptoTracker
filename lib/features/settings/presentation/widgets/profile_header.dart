import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ProfileHeader({super.key, required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.balanceGradientStart,
            boxShadow: [
              BoxShadow(
                color: AppColors.black10Shadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          name,
          style: AppTextStyles.semiBold28.copyWith(
            color: AppColors.balanceGradientStart,
          ),
        ),
      ],
    );
  }
}

