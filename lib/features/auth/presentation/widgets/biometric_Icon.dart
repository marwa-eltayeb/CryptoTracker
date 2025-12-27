import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../screens/biometric_screen.dart';

class BiometricIcon extends StatelessWidget {
  final BiometricIconState iconState;
  final VoidCallback? onTap;

  const BiometricIcon({
    super.key,
    required this.iconState,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (iconState) {
      case BiometricIconState.scanning:
        icon = Icons.fingerprint;
        color = AppColors.primary;
        break;
      case BiometricIconState.complete:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case BiometricIconState.idle:
      default:
        icon = Icons.fingerprint;
        color = Colors.grey;
    }

    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 120,
        color: color,
      ),
    );
  }
}