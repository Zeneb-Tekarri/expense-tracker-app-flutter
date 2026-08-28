import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/analytics_provider.dart';
import 'package:expense_tracker_app/widgets/balance_card.dart';
import 'package:expense_tracker_app/constants/month_names.dart';
import 'package:expense_tracker_app/widgets/analytics/income_expense_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsProvider = context.watch<AnalyticsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Month Selector 
            _sectionTitle("Monthly Selector"),
            const SizedBox(height: 12),
            _monthSelector(context, analyticsProvider),

            const SizedBox(height: 24),

            // Monthly Overview
            _sectionTitle("Monthly Overview"),
            const SizedBox(height: 12),
            BalanceCard(
              balance: analyticsProvider.balance, 
              income: analyticsProvider.totalIncome, 
              expense: analyticsProvider.totalExpense
            ),

            const SizedBox(height: 24),

            //Income vs Expense bar chart
            _sectionTitle("Income vs Expense"),
            const SizedBox(height: 12,),
            IncomeExpenseChart(
              income: analyticsProvider.totalIncome, 
              expense: analyticsProvider.totalExpense,
            ),

            const SizedBox(height: 24),

            //Spending by Category pie chart
            _sectionTitle("Spending By Category"),

            const SizedBox(height: 24),

            //Spending over time line chart 
            _sectionTitle("Spending Over Time")



          ],
        ),
        
      )
    );
  }
}
Widget _sectionTitle (String title){
  return Text(
    title,
    style: TextStyle(
      color: const Color.fromARGB(217, 4, 29, 71),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _monthSelector (
  BuildContext context,
  AnalyticsProvider analyticsProvider,
){
  final selectedMonth = analyticsProvider.selectedMonth;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Previous month
      IconButton(
        onPressed:(){
          context.read<AnalyticsProvider>().setSelectedMonth(
            DateTime(
             selectedMonth.year,
             selectedMonth.month-1,
            ),
          );
        }, 
        icon: const Icon(Icons.chevron_left), 
      ),

      //current month 
      Text(
        '${MonthNames.monthNames[selectedMonth.month-1]} ${selectedMonth.year}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      //next month
      IconButton(
        onPressed:(){
          context.read<AnalyticsProvider>().setSelectedMonth(
           DateTime(
              selectedMonth.year,
              selectedMonth.month+1,
            ),
          );

        }, 
        icon: const Icon(Icons.chevron_right), 
      ),
    ],
  );

}