import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/constants/chart_colors.dart';

class ExpenseByCategoryChart extends StatelessWidget {
  final Map<String, double> expenseByCategory;
  final double totalExpenses;
  const ExpenseByCategoryChart({
    super.key, 
    required this.expenseByCategory,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if(expenseByCategory.isEmpty){
      return Card(
        child: SizedBox(
          height: 300,
          child: Center(
            child: Text(
              "No expenses for this month",
              style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }
    final sections = expenseByCategory.entries.map((entry){
      final percentage = (entry.value / totalExpenses)*100;
      return PieChartSectionData(
        value : entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 90,
        color: ChartColors.colors[entry.key] ?? colorScheme.outline,
        borderSide: BorderSide.none,
        titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      );
    }).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 45,
                  sectionsSpace: 0,
                  borderData: FlBorderData(
                    show: false,
                  ),
                ),
              ) ,
            ),
            SizedBox(height: 16,),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }
  Widget _buildLegend(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: expenseByCategory.entries.map((entry){
        final color = ChartColors.colors[entry.key] ?? colorScheme.outline;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ), 
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.key,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ),
              Text(
                '\$${entry.value.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}