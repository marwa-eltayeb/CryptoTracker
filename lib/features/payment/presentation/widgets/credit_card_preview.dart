import 'package:crypto_tracker/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class CreditCardPreview extends StatelessWidget {
  const CreditCardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Image.asset(
        AppAssets.visaCreditCard,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }
}