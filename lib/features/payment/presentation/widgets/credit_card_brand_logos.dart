import 'package:crypto_tracker/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class CreditCardBrandLogos extends StatelessWidget {
  const CreditCardBrandLogos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            AppAssets.visaLogo,
            width: 93,
            height: 50,
            fit: BoxFit.contain,
          ),
          Image.asset(
            AppAssets.masterLogo,
            width: 93,
            height: 50,
            fit: BoxFit.contain,
          ),
          Image.asset(
            AppAssets.applePayLogo,
            width: 93,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}