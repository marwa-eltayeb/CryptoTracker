import 'package:crypto_tracker/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/payment_body.dart';
import '../../data/repository/email_repository.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/buy_button.dart';
import '../widgets/payment_header.dart';
import '../widgets/payment_option_list.dart';
import '../widgets/send_receipt.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.paymentBody});

  final PaymentBody paymentBody;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool sendReceipt = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PaymentCubit>(),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) async {
          if (state is PaymentSuccess) {
            launchUrl(Uri.parse(state.paymentUrl));

            // Send receipt email if user opted in
            if (sendReceipt) {
              final emailRepository = sl<EmailRepository>();
              final result = await emailRepository.sendPaymentReceipt(
                userEmail: widget.paymentBody.email,
                amount: widget.paymentBody.amount,
                currency: widget.paymentBody.currency,
                transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
              );

              result.fold(
                    (failure) {
                  SnackBarUtils.showSnackBar(
                    context,
                    'Payment successful! Failed to send receipt email.',
                    backgroundColor: Colors.orange,
                  );
                },
                    (success) {
                  SnackBarUtils.showSnackBar(
                    context,
                    'Payment successful! Receipt sent to ${widget.paymentBody.email}',
                    backgroundColor: Colors.green,
                  );
                },
              );
            }
          } else if (state is PaymentFailure) {
            SnackBarUtils.showSnackBar(
              context,
              state.errorMessage,
              backgroundColor: AppColors.red,
            );
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
                    SendReceipt(
                      value: sendReceipt,
                      onChanged: (value) {
                        setState(() {
                          sendReceipt = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    state is PaymentLoading
                        ? Center(child: CircularProgressIndicator())
                        : BuyButton(
                      paymentBody: widget.paymentBody,
                      onPressed: () {
                        context.read<PaymentCubit>().processPayment(widget.paymentBody);
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