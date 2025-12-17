class PortfolioPriceModel {

  final Map<String, CoinPriceData> prices;

  PortfolioPriceModel({required this.prices});

  factory PortfolioPriceModel.fromJson(Map<String, dynamic> json) {
    final Map<String, CoinPriceData> pricesMap = {};

    json.forEach((key, value) {
      pricesMap[key] = CoinPriceData.fromJson(value as Map<String, dynamic>);
    });

    return PortfolioPriceModel(prices: pricesMap);
  }
}

class CoinPriceData {
  final double usd;
  final double usd24hChange;

  CoinPriceData({
    required this.usd,
    required this.usd24hChange,
  });

  factory CoinPriceData.fromJson(Map<String, dynamic> json) {
    return CoinPriceData(
      usd: (json['usd'] as num).toDouble(),
      usd24hChange: (json['usd_24h_change'] as num).toDouble(),
    );
  }
}