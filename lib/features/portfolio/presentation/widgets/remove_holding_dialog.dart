import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../data/models/holding.dart';

class RemoveHoldingDialog extends StatelessWidget {
  final Holding holding;
  final VoidCallback onRemove;

  const RemoveHoldingDialog({
    super.key,
    required this.holding,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [

          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.red,
            size: 28,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              AppStrings.removeHolding,
              style: AppTextStyles.semiBold18.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),

        ],
      ),
      content: Text(
        '${AppStrings.areYouSureRemove}${holding.name} (${holding.amount} ${holding.symbol.toUpperCase()})${AppStrings.fromYourPortfolio}',
        style: AppTextStyles.regular14.copyWith(
          color: AppColors.greyMedium,
        ),
      ),
      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppStrings.cancel,
            style: AppTextStyles.medium14.copyWith(
              color: AppColors.greyMedium,
            ),
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onRemove();
            // Show success message
            SnackbarUtils.showSnackbar(context, '${AppStrings.removedFromPortfolio}${holding.name}${AppStrings.fromYourPortfolio}',);
          },
          child: Text(
            AppStrings.remove,
            style: AppTextStyles.medium14.copyWith(
              color: AppColors.white,
            ),
          ),
        ),

      ],
    );
  }
}