import 'package:flutter/material.dart'; 
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math'as math;

class IncomeExpenseChart extends StatelessWidget {
  final double income;
  final double expense;
  const IncomeExpenseChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              maxY: _calculateMaxY(),
              borderData: FlBorderData(
                show: false,
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
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
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      String text;
                      switch(value.toInt()){
                        case 0: 
                          text = 'Income';
                          break;
                        case 1 :
                          text = 'Expense';
                          break;
                        default :
                          text ='';
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ), 
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: income,
                      width: 45,
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.green,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: expense,
                      width: 45,
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final label = groupIndex == 0
                      ? 'Income' 
                      : 'Expense';
                    final formattedAmount = NumberFormat.currency(
                      symbol: '\$',
                      decimalDigits: 2,
                    ).format(rod.toY);
                    return BarTooltipItem(
                      '$label\n$formattedAmount', 
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,

                      )
                    );
                  },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
        ),

      ),
    );
  }

  double _calculateInterval() {
    final maximum = income > expense ? income : expense;

    if (maximum == 0) {
      return 20;
    }

    final roughInterval = maximum / 5;
    final magnitude = math.pow(10, (math.log(roughInterval) / math.ln10).floor());
    final normalized = roughInterval / magnitude;
    double niceNumber;

    if (normalized <= 1) {
      niceNumber = 1;
    } else if (normalized <= 2) {
      niceNumber = 2;
    } else if (normalized <= 5) {
      niceNumber = 5;
    } else {
      niceNumber = 10;
    }

    return niceNumber * magnitude;
  }
  double _calculateMaxY(){
    final maximum = income > expense ? income : expense;
    
    if(maximum ==  0){
      return 100;
    }

    final interval = _calculateInterval();
    return (maximum/interval).ceil()*interval;

  }
}
