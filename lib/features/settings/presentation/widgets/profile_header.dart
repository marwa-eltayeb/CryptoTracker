import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class ProfileHeader extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const ProfileHeader({super.key, this.imageUrl, required this.name});

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

          child: Image.asset(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'S',
                  style: AppTextStyles.bold48.copyWith(color: AppColors.white),
                ),
              );
            },
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
