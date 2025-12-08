class CoinMarketModel {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double priceChange;
  final bool isPositive;

  CoinMarketModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.priceChange,
    required this.isPositive,
  });

  factory CoinMarketModel.fromJson(Map<String, dynamic> json) {
    final price = (json['current_price'] ?? 0).toDouble();
    final priceChangePercent = (json['price_change_percentage_24h'] ?? 0).toDouble();

    return CoinMarketModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: (json['symbol'] ?? '').toUpperCase(),
      imageUrl: json['image'] ?? '',
      price: price,
      priceChange: priceChangePercent,
      isPositive: priceChangePercent >= 0,
    );
  }
}
