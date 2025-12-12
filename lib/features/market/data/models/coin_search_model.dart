class CoinSearchModel {
  final String id;
  final String name;
  final String symbol;
  final int marketCapRank;
  final String? thumb;

  CoinSearchModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.marketCapRank,
    this.thumb,
  });

  factory CoinSearchModel.fromJson(Map<String, dynamic> json) {
    return CoinSearchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      marketCapRank: json['market_cap_rank'] ?? 0,
      thumb: json['thumb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'market_cap_rank': marketCapRank,
      'thumb': thumb,
    };
  }
}