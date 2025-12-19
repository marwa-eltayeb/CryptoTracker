import 'package:crypto_tracker/features/payment/presentation/cubit/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/payment_body.dart';
import '../../data/repository/payment_repository.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository repository;

  PaymentCubit({required this.repository}) : super(PaymentInitial());

  Future<void> processPayment(PaymentBody paymentBody) async {
    emit(PaymentLoading());

    final result = await repository.getPaymentKey(paymentBody);

    result.fold(
          (failure) {
        emit(PaymentFailure(errorMessage: failure.errMessage));
      },
          (paymentKey) {
        final paymentUrl = repository.getPaymentUrl(paymentKey);
        emit(PaymentSuccess(paymentUrl: paymentUrl));
      },
    );
  }

}