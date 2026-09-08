import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class SpendingOverTimeChart extends StatelessWidget {
  final Map<DateTime, double> dailyExpenses;
  const SpendingOverTimeChart({
    super.key,
    required this.dailyExpenses,
  });

  @override
  Widget build(BuildContext context) {
    //Empty State
    if(dailyExpenses.isEmpty){
      return Card(
        child: SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'No expenses for this period',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
    
    final entries = dailyExpenses.entries.toList();
    final spots = List.generate(
      entries.length, 
      (index) => FlSpot(
        index.toDouble(),
        entries[index].value,
      ),
    );
    
    return Card(
      child:Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              maxY: _calculateMaxY(),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: dailyExpenses.length > 7
                    ? (dailyExpenses.length / 6).ceilToDouble()
                    : 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      final entries = dailyExpenses.entries.toList();
                      if(index < 0 || index >= entries.length){
                        return const SizedBox.shrink();
                      }
                      final date = entries[index].key;
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          '${date.day}/${date.month}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: _calculateInterval(),
                    getTitlesWidget: (value, meta) {
                       final formattedValue = NumberFormat.currency(
                        symbol: '\$',
                        decimalDigits: 0,  
                      ).format(value);
                      return Text(
                        formattedValue,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                ),
              ]
            ),
          ),
        ),
      ), 
    );
  }
  double _calculateInterval(){
    final maxSpending = dailyExpenses.values.isEmpty
    ? 0.0
    : dailyExpenses.values.reduce((a, b) => a > b ? a : b);
    if (maxSpending == 0) {
      return 20;
    }
    final roughInterval = maxSpending / 5;
    final magnitude = math.pow(10, (math.log(roughInterval) / math.log(10)).floor());
    // Normalize the interval to a value between 1 and 10
    final normalized = roughInterval / magnitude;

    double niceNormalized;
    if (normalized <= 1) {
      niceNormalized = 1;
    } else if (normalized <= 2) {
      niceNormalized = 2;
    } else if (normalized <= 5) {
      niceNormalized = 5;
    } else {
      niceNormalized = 10;
    }
    return (niceNormalized * magnitude).toDouble();
  }
  double _calculateMaxY(){
    final maxSpending = dailyExpenses.values.isEmpty
    ? 0.0
    : dailyExpenses.values.reduce((a, b) => a > b ? a : b);
    if(maxSpending == 0){
      return 100;
    }
    final interval = _calculateInterval();
    return (maxSpending/interval).ceil()*interval;
  }
}