// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatelessWidget {
  final String title;
  const ReportPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Sample data: Daily expenses for a month (e.g., 30 days)
    List<double> dailyExpenses = [
      10,
      20,
      15,
      25,
      50,
      35,
      40,
      55,
      65,
      30,
      20,
      80,
      90,
      100,
      95,
      75,
      60,
      50,
      45,
      30,
      25,
      60,
      70,
      85,
      90,
      100,
      110,
      95,
      80,
      60,
    ];

    double monthlyBudget = 1500;
    double totalSpent = dailyExpenses.reduce((a, b) => a + b);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Monthly Budget: \$${monthlyBudget.toStringAsFixed(0)} | Spent: \$${totalSpent.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 18,
                color: totalSpent > monthlyBudget ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 200,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dailyExpenses.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 5 == 0) {
                            return Text('Day ${value.toInt() + 1}');
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
