import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_style.dart';
import '../../data/models/price_chart_model.dart';

class PriceChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final double currentPrice;
  final String selectedPeriod;

  const PriceChart({
    super.key,
    required this.data,
    required this.currentPrice,
    required this.selectedPeriod,
  });

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  late double minY;
  late double maxY;
  late double minX;
  late double maxX;
  late List<FlSpot> spots;

  @override
  void initState() {
    super.initState();
    _calculateChartData();
  }

  @override
  void didUpdateWidget(PriceChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _calculateChartData();
    }
  }

  String _formatBottomTitle(double value, String period) {
    if (value < 0 || value >= widget.data.length) return '';
    final point = widget.data[value.toInt()];
    final date = point.dateTime;

    switch (period) {
      case '1d':
        int hour = date.hour;
        String amPm = hour >= 12 ? 'PM' : 'AM';
        if (hour > 12) hour -= 12;
        if (hour == 0) hour = 12;
        return '$hour${amPm.toLowerCase()}';
      case '1w':
        return '${date.day}/${date.month}';
      case '1m':
        return '${date.day}/${date.month}';
      case '1y':
        return '${date.month}/${date.year % 100}';
      default:
        return '';
    }
  }

  void _calculateChartData() {
    if (widget.data.isEmpty) return;

    final prices = widget.data.map((e) => e.price).toList();
    minY = prices.reduce((a, b) => a < b ? a : b) * 0.98;
    maxY = prices.reduce((a, b) => a > b ? a : b) * 1.02;

    // Ensure current price is within the Y-axis range
    spots = List.generate(widget.data.length, (index) {
      return FlSpot(index.toDouble(), widget.data[index].price);
    });

    minX = 0;
    maxX = (widget.data.length - 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox(height: 250);
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 4,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: AppColors.chartGridLine,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: maxX / 6,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _formatBottomTitle(value, widget.selectedPeriod),
                      style: AppTextStyles.medium11.copyWith(
                        color: AppColors.chartAxisLabel,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              gradient: const LinearGradient(
                colors: [AppColors.chartLineStart, AppColors.chartLineEnd],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.chartGradientStart,
                    AppColors.chartGradientEnd,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => AppColors.chartTooltip,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    '\$${touchedSpot.y.toStringAsFixed(2)}',
                    AppTextStyles.bold12.copyWith(color: AppColors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}