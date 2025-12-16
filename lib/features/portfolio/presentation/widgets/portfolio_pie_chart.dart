import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Pie Chart with centered text
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
          // Legend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: holdings.map((holding) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [

                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getColor(holding.symbol),
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '\$${holding.valueUSD.toStringAsFixed(2)} ${holding.symbol}',
                        style: AppTextStyles.semiBold14.copyWith(
                          color: AppColors.balanceGradientStart,
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
    return holdings.map((holding) {
      return PieChartSectionData(
        value: holding.percentage,
        color: _getColor(holding.symbol),
        radius: 18,
        title: '',
        showTitle: false,
      );
    }).toList();
  }

  Color _getColor(String symbol) {
    switch (symbol) {
      case 'BTC':
        return AppColors.pieChartPurple;
      case 'ETH':
        return AppColors.pieChartCyan;
      case 'LTC':
        return AppColors.pieChartPink;
      default:
        return AppColors.greyMedium;
    }
  }
}