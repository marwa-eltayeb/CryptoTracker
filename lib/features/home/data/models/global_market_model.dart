class GlobalMarketModel {
  final String marketCap;
  final String marketCapChange;
  final String volume24h;
  final String volumeChange;
  final String btcDominance;
  final int activeCoins;

  GlobalMarketModel({
    required this.marketCap,
    required this.marketCapChange,
    required this.volume24h,
    required this.volumeChange,
    required this.btcDominance,
    required this.activeCoins,
  });

  factory GlobalMarketModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    // Get the nested maps
    final totalMarketCap = data['total_market_cap'] as Map<String, dynamic>? ?? {};
    final totalVolume = data['total_volume'] as Map<String, dynamic>? ?? {};
    final marketCapPercentage = data['market_cap_percentage'] as Map<String, dynamic>? ?? {};

    // Extract values
    final marketCapUsd = (totalMarketCap['usd'] ?? 0.0) as num;
    final volumeUsd = (totalVolume['usd'] ?? 0.0) as num;
    final btcDominanceValue = (marketCapPercentage['btc'] ?? 0.0) as num;
    final marketCapChangePercent = (data['market_cap_change_percentage_24h_usd'] ?? 0.0) as num;

    return GlobalMarketModel(
      marketCap: _formatToTrillions(marketCapUsd.toDouble()),
      marketCapChange: '${marketCapChangePercent.toStringAsFixed(2)}%',
      volume24h: _formatToBillions(volumeUsd.toDouble()),
      volumeChange: '${marketCapChangePercent.toStringAsFixed(2)}%',
      btcDominance: '${btcDominanceValue.toStringAsFixed(1)}%',
      activeCoins: data['active_cryptocurrencies'] as int? ?? 0,
    );
  }

  static String _formatToTrillions(double value) {
    return '\$${(value / 1e12).toStringAsFixed(1)}T';
  }

  static String _formatToBillions(double value) {
    return '\$${(value / 1e9).toStringAsFixed(1)}B';
  }
}