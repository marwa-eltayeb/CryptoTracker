import 'package:crypto_tracker/config/routing/routes.dart';
import 'package:crypto_tracker/features/details/presentation/screens/details_screen.dart';
import 'package:crypto_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:crypto_tracker/features/market/presentation/screens/market_screen.dart';
import 'package:crypto_tracker/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:crypto_tracker/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:crypto_tracker/features/payment/presentation/screens/payment_screen.dart';
import 'package:crypto_tracker/features/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:crypto_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:crypto_tracker/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../features/payment/data/models/payment_body.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const Scaffold());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const Scaffold());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.market:
        return MaterialPageRoute(builder: (_) => const MarketScreen());

      case Routes.details:
        final coinId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DetailsScreen(coinId: coinId));

      case Routes.portfolio:
        return MaterialPageRoute(builder: (_) => const PortfolioScreen());

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case Routes.payment:
        return MaterialPageRoute(builder: (_) => PaymentScreen(
          paymentBody: PaymentBody(),
        ));
      default:
        return null;
    }
  }
}

