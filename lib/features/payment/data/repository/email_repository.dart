import 'package:crypto_tracker/core/network/api_constant.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../../core/constants/email_templates.dart';
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
      final smtpServer = SmtpServer(
        APIConstants.smtpHost,
        port: APIConstants.smtpPort,
        username: APIConstants.smtpUsername,
        password: APIConstants.smtpPassword,
      );

      final formattedDate = DateTime.now().toString().split('.')[0];

      final message = Message()
        ..from = Address(APIConstants.smtpUsername, 'Crypto Tracker')
        ..recipients.add(userEmail)
        ..subject = 'Payment Receipt - Transaction #$transactionId'
        ..html = EmailTemplates.paymentReceipt(
          amount: amount,
          currency: currency,
          transactionId: transactionId,
          date: formattedDate,
        );

      final sendReport = await send(message, smtpServer);
      print('Sending Email SUCCESS! Message ID: ${sendReport.toString()}');
      return Success(true);

    } catch (e) {
      print('Sending Email Exception: $e');
      return FailureResult(
        GeneralFailure(errMessage: 'Failed to send email: ${e.toString()}'),
      );
    }
  }
}