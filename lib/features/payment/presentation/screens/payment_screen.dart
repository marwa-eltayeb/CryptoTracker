import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../data/models/payment_body.dart';
import '../widgets/buy_button.dart';
import '../widgets/payment_header.dart';
import '../widgets/payment_option_list.dart';
import '../widgets/send_receipt.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.paymentBody});

  final PaymentBody paymentBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paymentBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PaymentHeader(),
                      SizedBox(height: 32),
                      PaymentOptionList(),
                    ],
                  ),
                ),
              ),
              SendReceipt(),
              SizedBox(height: 20),
              BuyButton(
                  paymentBody: paymentBody,
                  onPressed:(){

                  }
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

