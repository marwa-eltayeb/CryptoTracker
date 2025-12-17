import 'package:crypto_tracker/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/storage/portfolio_storage.dart';

class AddToPortfolioDialog extends StatefulWidget {
  final String coinId;
  final String coinName;
  final String coinSymbol;
  final double currentPrice;
  final String imageUrl;
  final Function(String coinId, String name, String symbol, double amount, String imageUrl) onAdd;

  const AddToPortfolioDialog({
    super.key,
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.currentPrice,
    required this.imageUrl,
    required this.onAdd,
  });

  @override
  State<AddToPortfolioDialog> createState() => _AddToPortfolioDialogState();
}

class _AddToPortfolioDialogState extends State<AddToPortfolioDialog> {
  final _amountController = TextEditingController();
  final _portfolioStorage = PortfolioStorage();
  double? _totalValue;
  bool _isChecking = true;
  bool _canAdd = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_calculateTotal);
    _checkIfCanAdd();
  }

  Future<void> _checkIfCanAdd() async {
    final canAdd = await _portfolioStorage.canAddNewCoin(widget.coinId);
    setState(() {
      _canAdd = canAdd;
      _isChecking = false;
    });
  }

  void _calculateTotal() {
    final amount = double.tryParse(_amountController.text);
    setState(() {
      _totalValue = amount != null ? amount * widget.currentPrice : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    if (!_canAdd) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 28),
            const SizedBox(width: 8),
            Text(
              AppStrings.portfolioLimitReached,
              style: AppTextStyles.semiBold18.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        content: Text(
          '${AppStrings.youCanOnlyHaveUpTo}${PortfolioStorage.maxCoinsAllowed} ${AppStrings.portfolioLimitMessage}',
          style: AppTextStyles.regular14.copyWith(color: AppColors.greyMedium),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppStrings.gotIt,
              style: AppTextStyles.medium14.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        '${AppStrings.add} ${widget.coinName} ${AppStrings.toPortfolio}',
        style: AppTextStyles.semiBold18.copyWith(color: AppColors.primary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Price Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.currentPrice,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.greyMedium,
                  ),
                ),
                Text(
                  '\$${widget.currentPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.semiBold16.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Amount Input
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: AppStrings.amount,
              hintText: '${AppStrings.enterAmount}${widget.coinSymbol}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.numbers),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),

          const SizedBox(height: 12),

          // Total Value Display
          if (_totalValue != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.totalValueLabel,
                    style: AppTextStyles.medium14.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '\$${_totalValue!.toStringAsFixed(2)}',
                    style: AppTextStyles.semiBold16.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
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
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            final amount = double.tryParse(_amountController.text);

            if (amount != null && amount > 0) {
              widget.onAdd(
                  widget.coinId,
                  widget.coinName,
                  widget.coinSymbol,
                  amount,
                  widget.imageUrl
              );
              Navigator.pop(context);
              // Show success message
              SnackbarUtils.showSnackbar(context, '${AppStrings.addedToPortfolio}$amount ${widget.coinSymbol}${AppStrings.toPortfolio}');
            } else {
              // Show error
              SnackbarUtils.showSnackbar(context, AppStrings.pleaseEnterValidAmount);
            }
          },
          child: Text(
            AppStrings.addToPortfolio,
            style: AppTextStyles.medium14.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}