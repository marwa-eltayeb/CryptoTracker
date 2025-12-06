import 'package:crypto_tracker/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer circle
            Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: Color(0xFFDEDEDE).withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),

            // Inner circle
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0xFFD5D5D5).withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),

            // App icon
            SvgPicture.asset(
              AppAssets.appIcon,
              width: 120,
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}