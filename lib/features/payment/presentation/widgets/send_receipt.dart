import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';

class SendReceipt extends StatefulWidget {
  const SendReceipt({super.key});

  @override
  State<SendReceipt> createState() => _SendReceiptState();
}

class _SendReceiptState extends State<SendReceipt> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            AppStrings.sendReceipt,
            style: AppTextStyles.regular14.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: _onChanged,
            activeColor: AppColors.primary,
          )
        ],
      ),
    );
  }

  void _onChanged(value) {
    setState(() {
      this.value = value;
    });
  }
}