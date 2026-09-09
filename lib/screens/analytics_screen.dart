import 'package:expense_tracker_app/widgets/analytics/spending_over_time_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/analytics_provider.dart';
import 'package:expense_tracker_app/widgets/balance_card.dart';
import 'package:expense_tracker_app/constants/month_names.dart';
import 'package:expense_tracker_app/widgets/analytics/income_expense_chart.dart';
import 'package:expense_tracker_app/widgets/analytics/expense_by_category_chart.dart';
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsProvider = context.watch<AnalyticsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Analytics")),

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
            const SizedBox(height: 12,),
            ExpenseByCategoryChart(
              expenseByCategory: analyticsProvider.getExpensesByCategory(),
              totalExpenses: analyticsProvider.totalExpense, 
            ),

            const SizedBox(height: 24),

            //Spending over time line chart 
            _sectionTitle("Spending Over Time"),
            const SizedBox(height: 12,),
            //Date Range Selector
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                     const Icon(Icons.date_range_outlined, size: 20,),
                     const SizedBox(width: 10),
                     Expanded(
                       child: Text(
                          '${_formatDate(analyticsProvider.startDate)} → '
                          '${_formatDate(analyticsProvider.endDate)}',
                         style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                     ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:(){ 
                            _selectDateRange(context, analyticsProvider);
                          },
                          icon: Icon(Icons.date_range_outlined), 
                          label: const Text("Select"),
                        ),
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: (){
                            analyticsProvider.resetDateRangeToSelectedMonth();
                          }, 
                          icon: Icon(Icons.refresh_outlined),
                          label: const Text("Reset")
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16,),
            SpendingOverTimeChart(
              dailyExpenses: analyticsProvider.getDailyExpenses(),
            ),


          ],
        ),
        
      )
    );
  }
}
String _formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
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
Future<void> _selectDateRange(
  BuildContext context,
  AnalyticsProvider analyticsProvider,
  ) async {
  final today = DateTime.now();
  final endDate = analyticsProvider.endDate.isAfter(today)
    ? today
    : analyticsProvider.endDate;
  final selectedRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    initialDateRange: DateTimeRange(
      start: analyticsProvider.startDate, 
      end: endDate
    )
  );

  if (selectedRange == null) {
    return;
  }

  analyticsProvider.setDateRange(
    selectedRange.start,
    selectedRange.end,
  );
}