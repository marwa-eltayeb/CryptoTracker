import 'package:flutter/material.dart';
import '../../../../config/theme/app_style.dart';
import '../../../../core/constants/app_strings.dart';
import 'credit_card_brand_logos.dart';
import 'payment_option_item.dart';
import 'credit_card_preview.dart';

class PaymentOptionList extends StatelessWidget {
  const PaymentOptionList({super.key});

  @override
  Widget build(BuildContext context) {
    List<PaymentOptionItem> paymentMethodList = [
      PaymentOptionItem(
        name: AppStrings.creditCard,
        children: [
          CreditCardBrandLogos(),
          CreditCardPreview(),
        ],
      ),
      PaymentOptionItem(
        name: AppStrings.googlePay,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 18.0),
            child: Text(
              AppStrings.googlePaySettings,
              style: AppTextStyles.regular14,
            ),
          )
        ],
      ),
      PaymentOptionItem(
        name: AppStrings.mobileBanking,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 18.0),
            child: Text(
              AppStrings.mobileBankingSettings,
              style: AppTextStyles.regular14,
            ),
          )
        ],
      ),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return paymentMethodList[index];
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16);
      },
      itemCount: paymentMethodList.length,
    );
  }
}