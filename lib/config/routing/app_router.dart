import 'package:crypto_tracker/config/routing/routes.dart';
import 'package:crypto_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:crypto_tracker/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:crypto_tracker/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

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
        return MaterialPageRoute(builder: (_) => const Scaffold());

      case Routes.details:
        return MaterialPageRoute(builder: (_) => const Scaffold());

      case Routes.portfolio:
        return MaterialPageRoute(builder: (_) => const Scaffold());

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const Scaffold());

      default:
        return null;
    }
  }
}

