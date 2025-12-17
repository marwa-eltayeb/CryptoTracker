import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CoinHoldingData {
  final String coinId;
  final String name;
  final String symbol;
  final double amount;
  final String imageUrl;

  CoinHoldingData({
    required this.coinId,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'coinId': coinId,
    'name': name,
    'symbol': symbol,
    'amount': amount,
    'imageUrl': imageUrl,
  };

  factory CoinHoldingData.fromJson(Map<String, dynamic> json) => CoinHoldingData(
    coinId: json['coinId'],
    name: json['name'],
    symbol: json['symbol'],
    amount: (json['amount'] as num).toDouble(),
    imageUrl: json['imageUrl'] ?? '',
  );
}

class PortfolioStorage {
  static const String _holdingsKey = 'user_holdings';
  static const int maxCoinsAllowed = 3;

  Future<List<CoinHoldingData>> getUserHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? holdingsJson = prefs.getString(_holdingsKey);

    if (holdingsJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(holdingsJson);
    return decoded.map((item) => CoinHoldingData.fromJson(item)).toList();
  }

  Future<void> saveUserHoldings(List<CoinHoldingData> holdings) async {
    final prefs = await SharedPreferences.getInstance();
    final String holdingsJson = json.encode(
      holdings.map((h) => h.toJson()).toList(),
    );
    await prefs.setString(_holdingsKey, holdingsJson);
  }

  Future<bool> canAddNewCoin(String coinId) async {
    final holdings = await getUserHoldings();

    // If coin already exists, we can add to it
    if (holdings.any((h) => h.coinId == coinId)) {
      return true;
    }

    // Check if we've reached the limit for new coins
    return holdings.length < maxCoinsAllowed;
  }

  Future<int> getHoldingsCount() async {
    final holdings = await getUserHoldings();
    return holdings.length;
  }

  Future<void> addHolding(String coinId, String name, String symbol, double amount, String imageUrl) async {
    final holdings = await getUserHoldings();

    // Check if coin already exists
    final existingIndex = holdings.indexWhere((h) => h.coinId == coinId);

    if (existingIndex != -1) {
      // Update existing holding
      holdings[existingIndex] = CoinHoldingData(
          coinId: coinId,
          name: name,
          symbol: symbol,
          amount: holdings[existingIndex].amount + amount,
          imageUrl: imageUrl
      );
    } else {
      // Check limit before adding new coin
      if (holdings.length >= maxCoinsAllowed) {
        throw Exception('Cannot add more than $maxCoinsAllowed coins to portfolio');
      }

      // Add new holding
      holdings.add(CoinHoldingData(
          coinId: coinId,
          name: name,
          symbol: symbol,
          amount: amount,
          imageUrl: imageUrl
      ));
    }

    await saveUserHoldings(holdings);
  }

  Future<void> removeHolding(String coinId) async {
    final holdings = await getUserHoldings();
    holdings.removeWhere((h) => h.coinId == coinId);
    await saveUserHoldings(holdings);
  }

  Future<void> updateHolding(String coinId, double amount) async {
    final holdings = await getUserHoldings();
    final index = holdings.indexWhere((h) => h.coinId == coinId);

    if (index != -1) {
      if (amount <= 0) {
        holdings.removeAt(index);
      } else {
        holdings[index] = CoinHoldingData(
          coinId: holdings[index].coinId,
          name: holdings[index].name,
          symbol: holdings[index].symbol,
          amount: amount,
          imageUrl: holdings[index].imageUrl,
        );
      }
      await saveUserHoldings(holdings);
    }
  }

  Future<void> clearAllHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_holdingsKey);
  }
}