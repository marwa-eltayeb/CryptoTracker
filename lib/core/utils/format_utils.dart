class NumberFormatter {

  NumberFormatter._();

  static String formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(0);
  }

  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${formatLargeNumber(amount)}';
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(2)}%';
  }
}
