import '../../data/models/holding.dart';
import '../../data/models/transaction.dart';

abstract class PortfolioState {}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final List<Holding> holdings;
  final List<Transaction> transactions;
  final double totalValue;
  final double totalChangeAmount;
  final double totalChangePercentage;

  PortfolioLoaded({
    required this.holdings,
    required this.transactions,
    required this.totalValue,
    required this.totalChangeAmount,
    required this.totalChangePercentage,
  });
}

class PortfolioError extends PortfolioState {
  final String message;

  PortfolioError({required this.message});
}