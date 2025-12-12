import 'coin_search_model.dart';

class CoinSearchResponse {
  final List<CoinSearchModel> coins;

  CoinSearchResponse({
    required this.coins,
  });

  factory CoinSearchResponse.fromJson(Map<String, dynamic> json) {
    return CoinSearchResponse(
      coins: (json['coins'] as List<dynamic>?)
          ?.map((coin) => CoinSearchModel.fromJson(coin as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coins': coins.map((coin) => coin.toJson()).toList(),
    };
  }
}