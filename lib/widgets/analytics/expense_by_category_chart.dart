import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseByCategoryChart extends StatelessWidget {
  final Map<String, double> expenseByCategory;
  const ExpenseByCategoryChart({
    super.key, 
    required this.expenseByCategory
  });

  @override
  Widget build(BuildContext context) {
    if(expenseByCategory.isEmpty){
      return Card(
        child: SizedBox(
          height: 300,
          child: Center(
            child: Text(
              "No expenses for this month",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(

            ),
          ) ,

        ),
      ),
    );
  }
}