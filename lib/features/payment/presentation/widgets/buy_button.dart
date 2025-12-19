import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/payment_body.dart';

class BuyButton extends StatelessWidget {

  const BuyButton({super.key, required this.paymentBody, required this.onPressed});

  final PaymentBody paymentBody;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          AppStrings.buyNow,
          style: AppTextStyles.semiBold18.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}