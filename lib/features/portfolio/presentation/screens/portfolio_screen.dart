import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../data/models/holding.dart';
import '../../data/models/transaction.dart';
import '../widgets/portfolio_value_card.dart';
import '../widgets/month_selector.dart';
import '../widgets/portfolio_pie_chart.dart';
import '../widgets/holding_item.dart';
import '../widgets/transaction_item.dart';

class PortfolioScreen extends StatelessWidget {

  const PortfolioScreen({super.key});

  // Static data
  static const double totalValue = 143421.20;
  static const double changeAmount = 305.20;
  static const double changePercentage = 2.5;

  static final List<Holding> holdings = [
    Holding(
      name: 'Bitcoin',
      symbol: 'BTC',
      iconPath: '',
      amount: 0.05,
      valueUSD: 2262.53,
      changeAmount: 145.20,
      changePercentage: 6.85,
      percentage: 50,
    ),
    Holding(
      name: 'Ethereum',
      symbol: 'ETH',
      iconPath: '',
      amount: 1.5,
      valueUSD: 3150.75,
      changeAmount: 56.70,
      changePercentage: 1.83,
      percentage: 30,
    ),
    Holding(
      name: 'Litecoin',
      symbol: 'LTC',
      iconPath: '',
      amount: 26.3,
      valueUSD: 2503.76,
      changeAmount: 120.80,
      changePercentage: 5.07,
      percentage: 20,
    ),
  ];

  static final List<Transaction> transactions = [
    Transaction(
      coinName: 'Bitcoin',
      type: TransactionType.buy,
      amount: 0.01,
      symbol: 'BTC',
      valueUSD: 452.50,
      timeAgo: '2 hours ago',
    ),
    Transaction(
      coinName: 'Ethereum',
      type: TransactionType.sell,
      amount: 0.5,
      symbol: 'ETH',
      valueUSD: 1050.25,
      timeAgo: '1 day ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        title: const Text(
          'Portfolio',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A5F),
          ),
        ),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portfolio Value Card
              const PortfolioValueCard(
                totalValue: totalValue,
                changeAmount: changeAmount,
                changePercentage: changePercentage,
              ),

              const SizedBox(height: 24),

              // Month Selector
              const MonthSelector(),

              const SizedBox(height: 24),

              // Pie Chart
              PortfolioPieChart(
                totalValue: totalValue,
                holdings: holdings,
              ),

              const SizedBox(height: 32),

              // My Holdings Section
              const Text(
                'My Holdings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A5F),
                ),
              ),

              const SizedBox(height: 16),

              // Holdings List
              ...holdings.map((holding) => HoldingItem(holding: holding)),

              const SizedBox(height: 32),

              // Recent Transactions Section
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A5F),
                ),
              ),

              const SizedBox(height: 16),

              // Transactions List
              ...transactions.map((transaction) => TransactionItem(transaction: transaction)),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}