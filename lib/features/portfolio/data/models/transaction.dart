enum TransactionType { buy, sell }

class Transaction {
  final String coinName;
  final TransactionType type;
  final double amount;
  final String symbol;
  final double valueUSD;
  final String timeAgo;

  Transaction({
    required this.coinName,
    required this.type,
    required this.amount,
    required this.symbol,
    required this.valueUSD,
    required this.timeAgo,
  });
}