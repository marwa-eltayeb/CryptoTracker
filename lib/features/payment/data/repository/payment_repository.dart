import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/result.dart';
import '../models/payment_body.dart';

class PaymentRepository {
  final ApiService apiService;

  PaymentRepository({required this.apiService});

  // Get payment key
  Future<Result<String>> getPaymentKey(PaymentBody paymentBody) async {
    try {
      // Get authentication token
      final authTokenResult = await _getAuthenticationToken();
      if (authTokenResult is FailureResult<String>) {
        return FailureResult(authTokenResult.failure);
      }
      final authToken = (authTokenResult as Success<String>).data;

      // Get order ID
      final orderIdResult = await _getOrderId(
        authToken: authToken,
        amount: (100 * paymentBody.amount).toInt().toString(),
        currency: paymentBody.currency,
      );
      if (orderIdResult is FailureResult<int>) {
        return FailureResult(orderIdResult.failure);
      }
      final orderId = (orderIdResult as Success<int>).data;

      // Get payment key
      final paymentKeyResult = await _getPaymentKey(
        authToken: authToken,
        orderId: orderId.toString(),
        amount: (100 * paymentBody.amount).toInt().toString(),
        currency: paymentBody.currency,
        billingData: paymentBody.toBillingData(),
      );

      return paymentKeyResult;
    } catch (e) {
      return FailureResult(
        GeneralFailure(errMessage: 'Payment processing failed: ${e.toString()}'),
      );
    }
  }

  // Get authentication token
  Future<Result<String>> _getAuthenticationToken() async {
    final result = await apiService.post(
      '${APIConstants.paymobBaseUrl}${APIConstants.paymobAuthTokens}',
      data: {
        "api_key": APIConstants.paymobApiKey,
      },
    );

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          return Success(response.data["token"]);
        } catch (e) {
          return FailureResult(
            GeneralFailure(errMessage: 'Failed to parse authentication token: ${e.toString()}'),
          );
        }
      },
    );
  }

  // Get order ID
  Future<Result<int>> _getOrderId({
    required String authToken,
    required String amount,
    required String currency,
  }) async {
    final result = await apiService.post(
      '${APIConstants.paymobBaseUrl}${APIConstants.paymobOrders}',
      data: {
        "auth_token": authToken,
        "amount_cents": amount,
        "currency": currency,
        "delivery_needed": "false",
        "items": [],
      },
    );

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          return Success(response.data["id"]);
        } catch (e) {
          return FailureResult(
            GeneralFailure(errMessage: 'Failed to parse order ID: ${e.toString()}'),
          );
        }
      },
    );
  }

  // Get payment key
  Future<Result<String>> _getPaymentKey({
    required String authToken,
    required String orderId,
    required String amount,
    required String currency,
    required Map<String, dynamic> billingData,
  }) async {
    final result = await apiService.post(
      '${APIConstants.paymobBaseUrl}${APIConstants.paymobPaymentKeys}',
      data: {
        "expiration": 3600,
        "auth_token": authToken,
        "order_id": orderId,
        "integration_id": int.parse(APIConstants.paymobIntegrationId),
        "amount_cents": amount,
        "currency": currency,
        "billing_data": billingData,
      },
    );

    return result.fold(
          (failure) => FailureResult(failure),
          (response) {
        try {
          return Success(response.data["token"]);
        } catch (e) {
          return FailureResult(
            GeneralFailure(errMessage: 'Failed to parse payment key: ${e.toString()}'),
          );
        }
      },
    );
  }

  // Generate payment URL
  String getPaymentUrl(String paymentKey) {
    return '${APIConstants.paymobIframeUrl}?payment_token=$paymentKey';
  }
}