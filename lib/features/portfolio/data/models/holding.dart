class Holding {
  final String coinId;
  final String name;
  final String symbol;
  final String iconPath;
  final double amount;
  final double valueUSD;
  final double changeAmount;
  final double changePercentage;
  final double percentage;

  Holding({
    required this.coinId,
    required this.name,
    required this.symbol,
    required this.iconPath,
    required this.amount,
    required this.valueUSD,
    required this.changeAmount,
    required this.changePercentage,
    required this.percentage,
  });
}