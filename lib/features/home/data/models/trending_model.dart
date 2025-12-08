class TrendingModel {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double priceChange;
  final bool isPositive;

  TrendingModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.priceChange,
    required this.isPositive,
  });

  factory TrendingModel.fromJson(Map<String, dynamic> json) {
    final item = json['item'] ?? {};
    final data = item['data'] ?? {};
    final price = (data['price'] ?? 0).toDouble();
    final priceChangeUsd = ((data['price_change_percentage_24h']?['usd'] ?? 0) as num).toDouble();

    return TrendingModel(
      id: item['id'] ?? '',
      name: item['name'] ?? '',
      symbol: (item['symbol'] ?? '').toUpperCase(),
      imageUrl: item['thumb'] ?? '',
      price: price,
      priceChange: priceChangeUsd,
      isPositive: priceChangeUsd >= 0,
    );
  }
}
