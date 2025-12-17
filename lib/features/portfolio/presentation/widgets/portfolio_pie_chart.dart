import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../data/models/holding.dart';

class PortfolioPieChart extends StatelessWidget {
  final double totalValue;
  final List<Holding> holdings;

  const PortfolioPieChart({
    super.key,
    required this.totalValue,
    required this.holdings,
  });

  static const List<Color> _colorPalette = [
    AppColors.pieChartPurple,
    AppColors.pieChartCyan,
    AppColors.pieChartPink,
  ];

  @override
  Widget build(BuildContext context) {

    // Don't show pie chart if no holdings
    if (holdings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 65,
                    sections: _getSections(),
                    borderData: FlBorderData(show: false),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '\$${totalValue.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bold20.copyWith(
                      color: AppColors.balanceGradientStart,
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(width: 40),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: holdings.asMap().entries.map((entry) {
                final index = entry.key;
                final holding = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [

                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getColorByIndex(index),
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          '\$${holding.valueUSD.toStringAsFixed(2)} ${holding.symbol}',
                          style: AppTextStyles.semiBold14.copyWith(
                            color: AppColors.balanceGradientStart,
                          ),
                        ),
                      ),

                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    print('Total holdings: ${holdings.length}');
    return holdings.asMap().entries.map((entry) {
      final index = entry.key;
      final holding = entry.value;
      print('Holding $index: ${holding.symbol}, percentage: ${holding.percentage}%, color: ${_getColorByIndex(index)}');
      return PieChartSectionData(
        value: holding.percentage,
        color: _getColorByIndex(index),
        radius: 18,
        title: '',
        showTitle: false,
      );
    }).toList();
  }

  Color _getColorByIndex(int index) {
    return _colorPalette[index % _colorPalette.length];
  }
}