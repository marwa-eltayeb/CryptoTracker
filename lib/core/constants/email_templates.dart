class EmailTemplates {
  static String paymentReceipt({
    required double amount,
    required String currency,
    required String transactionId,
    required String date,
  }) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
          }
          .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f9f9f9;
          }
          .header {
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 5px 5px 0 0;
          }
          .content {
            background-color: white;
            padding: 30px;
            border-radius: 0 0 5px 5px;
          }
          .detail-row {
            margin: 15px 0;
            padding: 10px;
            background-color: #f5f5f5;
            border-left: 4px solid #4CAF50;
          }
          .footer {
            text-align: center;
            margin-top: 30px;
            color: #666;
            font-size: 14px;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h2>Payment Receipt</h2>
          </div>
          <div class="content">
            <p>Thank you for your payment!</p>
            
            <div class="detail-row">
              <strong>Amount:</strong> $amount $currency
            </div>
            
            <div class="detail-row">
              <strong>Transaction ID:</strong> $transactionId
            </div>
            
            <div class="detail-row">
              <strong>Date:</strong> $date
            </div>
            
            <div class="footer">
              <p>Best regards,<br><strong>Crypto Tracker Team</strong></p>
            </div>
          </div>
        </div>
      </body>
      </html>
    ''';
  }
}