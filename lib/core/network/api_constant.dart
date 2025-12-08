import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {

  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static final String apiKey = (dotenv.env['API_KEY'] ?? '');

  // HOME SCREEN
  static const String marketOverview = '/global';           // Market overview statistics
  static const String trendingCoins = '/search/trending';   // Trending coins list
  static const String topGainers = '/coins/markets';        // Top gainers

  // // MARKET SCREEN
  // static const String coinMarkets = '/coins/markets';      // Coin list
  // static const String searchCoins = '/search';             // Search coins by keyword
  //
  // // COIN DETAILS SCREEN
  // static const String coinDetails = '/coins/{id}';         // Detailed coin information
  // static const String coinMarketChart = '/coins/{id}/market_chart';   // Price chart data
  //
  // //  PORTFOLIO SCREEN
  // static const String simplePrice = '/simple/price';       // Live prices for holdings

}