import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class CoinHeader extends StatelessWidget {
  final String name;
  final String thumb;

  const CoinHeader({super.key, required this.name, required this.thumb});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Coin Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: thumb,
                width: 48,
                height: 48,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Coin Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A5F),
            ),
          ),
        ],
      ),
    );
  }
}
