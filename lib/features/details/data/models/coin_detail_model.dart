class CoinDetailModel {
  final String id;
  final String name;
  final String image;
  final String symbol;
  final double currentPrice;
  final double priceChange24h;
  final double marketCap;
  final double volume24h;
  final double availableSupply;
  final double maxSupply;
  final String about;

  CoinDetailModel({
    required this.id,
    required this.name,
    required this.image,
    required this.symbol,
    required this.currentPrice,
    required this.priceChange24h,
    required this.marketCap,
    required this.volume24h,
    required this.availableSupply,
    required this.maxSupply,
    required this.about,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    final marketData = json['market_data'] as Map<String, dynamic>?;
    final description = json['description'] as Map<String, dynamic>?;
    final aboutText = description?['en'] ?? '';

    return CoinDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      image: image?['small'] ?? '',
      currentPrice: (marketData?['current_price']?['usd'] ?? 0).toDouble(),
      priceChange24h: (marketData?['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (marketData?['market_cap']?['usd'] ?? 0).toDouble(),
      volume24h: (marketData?['total_volume']?['usd'] ?? 0).toDouble(),
      availableSupply: (marketData?['circulating_supply'] ?? 0).toDouble(),
      maxSupply: (marketData?['max_supply'] ?? 0).toDouble(),
      about: aboutText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'small': {'small': image},
      'market_data': {
        'current_price': {'usd': currentPrice},
        'price_change_percentage_24h': priceChange24h,
        'market_cap': {'usd': marketCap},
        'total_volume': {'usd': volume24h},
        'circulating_supply': availableSupply,
        'max_supply': maxSupply,
      },
      'description': {'en': about},
    };
  }
}