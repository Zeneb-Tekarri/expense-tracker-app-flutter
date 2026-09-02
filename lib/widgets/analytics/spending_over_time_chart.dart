import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingOverTimeChart extends StatelessWidget {
  final Map<DateTime, double> dailyExpenses;
  const SpendingOverTimeChart({
    super.key,
    required this.dailyExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child:Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              
            ),
          ),
        ),
      ), 
    );
  }
}