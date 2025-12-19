import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';

class PaymentOptionItem extends StatelessWidget {
  const PaymentOptionItem({
    super.key,
    required this.name,
    required this.children,
  });

  final String name;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          shape: Border(),
          collapsedShape: Border(),
          title: Text(
            name,
            style: AppTextStyles.semiBold18.copyWith(color: AppColors.primary),
          ),
          trailing: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          children: children,
        ),
      ),
    );
  }
}