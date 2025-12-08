import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(AppStrings.defaultAvatar),
          ),

          const SizedBox(width: 12),

          Text(
            '${AppStrings.greeting}$userName${AppStrings.waveEmoji}',
            style: AppTextStyles.semiBold18.copyWith(
              color: AppColors.black,
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),

        ],
      ),
    );
  }
}
