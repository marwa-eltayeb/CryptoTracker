import 'package:crypto_tracker/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/payment_body.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/buy_button.dart';
import '../widgets/payment_header.dart';
import '../widgets/payment_option_list.dart';
import '../widgets/send_receipt.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.paymentBody});

  final PaymentBody paymentBody;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PaymentCubit>(),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            launchUrl(Uri.parse(state.paymentUrl));
          } else if (state is PaymentFailure) {
            SnackbarUtils.showSnackbar(context, state.errorMessage, backgroundColor: AppColors.red);
          }
        },
        builder: (context, state) {
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
                    state is PaymentLoading
                        ? Center(child: CircularProgressIndicator())
                        : BuyButton(
                      paymentBody: paymentBody,
                      onPressed: () {
                        context.read<PaymentCubit>().processPayment(paymentBody);
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}