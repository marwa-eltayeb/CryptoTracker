import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {

  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static final String apiKey = (dotenv.env['API_KEY'] ?? '');

  // HOME SCREEN
  static const String marketOverview = '/global';                         // Market overview statistics
  static const String trendingCoins = '/search/trending';                 // Trending coins list
  static const String topGainers = '/coins/markets';                      // Top gainers

  // MARKET SCREEN
  static const String coinMarkets = '/coins/markets';                     // Coin list
  static const String searchCoins = '/search';                            // Search coins by keyword

  // COIN DETAILS SCREEN
  static const String coinDetails = '/coins/{id}';                       // Detailed coin information
  static const String coinMarketChart = '/coins/{id}/market_chart';      // Price chart data

  // PORTFOLIO SCREEN
  static const String simplePrice = '/simple/price';                     // Live prices for holdings

  // PAYMOB PAYMENT
  static const String paymobBaseUrl = 'https://accept.paymob.com/api';
  static const String paymobAuthTokens = '/auth/tokens';
  static const String paymobOrders = '/ecommerce/orders';
  static const String paymobPaymentKeys = '/acceptance/payment_keys';
  static const String paymobIframeUrl = 'https://accept.paymob.com/api/acceptance/iframes/908052';

  static final String paymobApiKey = (dotenv.env['PAYMOB_API_KEY'] ?? '');
  static final String paymobIntegrationId = (dotenv.env['PAYMOB_INTEGRATION_ID'] ?? '');

  // EMAILJS
  static final String smtpHost = dotenv.env['SMTP_HOST'] ?? 'smtp.gmail.com';
  static final int smtpPort = int.parse(dotenv.env['SMTP_PORT'] ?? '587');
  static final String smtpUsername = dotenv.env['SMTP_USERNAME'] ?? '';
  static final String smtpPassword = dotenv.env['SMTP_PASSWORD'] ?? '';

}

