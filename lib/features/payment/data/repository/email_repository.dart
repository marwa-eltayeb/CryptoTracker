import 'package:crypto_tracker/core/network/api_constant.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import '../../../../core/errors/failures.dart';
import '../../../../core/network/result.dart';

class EmailRepository {
  EmailRepository();

  Future<Result<bool>> sendPaymentReceipt({
    required String userEmail,
    required double amount,
    required String currency,
    required String transactionId,
  }) async {
    try {
      print('Sending Email === Starting ===');
      print('Sending Email Service ID: ${APIConstants.serviceId}');
      print('Sending Email Template ID: ${APIConstants.templateId}');
      print('Sending Email Public Key: ${APIConstants.publicKey}');
      print('Sending Email To Email: $userEmail');

      final templateParams = {
        'to_email': userEmail,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        'transaction_id': transactionId,
        'date': DateTime.now().toString(),
      };

      print('Sending Email Template Params: $templateParams');

      await emailjs.send(
        APIConstants.serviceId,
        APIConstants.templateId,
        templateParams,
        emailjs.Options(
          publicKey: APIConstants.publicKey,
          privateKey: APIConstants.privateKey,
        ),
      );

      print('Sending Email SUCCESS!');
      return Success(true);

    } catch (e) {
      print('Sending Email Exception: $e');
      return FailureResult(
        GeneralFailure(errMessage: 'Failed to send email: ${e.toString()}'),
      );
    }
  }
}