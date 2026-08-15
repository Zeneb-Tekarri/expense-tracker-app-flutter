import 'package:flutter/material.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';

class AnalyticsProvider extends ChangeNotifier {
  
  final TransactionProvider _transactionProvider;
  AnalyticsProvider(this._transactionProvider);

  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;
  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    _startDate = DateTime(
     month.year,
     month.month,
      1,
    );
    _endDate = DateTime(
      month.year,
      month.month + 1,
      0,
    );
    notifyListeners();
    
  }
  
  DateTime _startDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime _endDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  );
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  void setDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }
  
  void resetDateRangeToSelectedMonth() {
    _startDate = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );

    _endDate = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );

    notifyListeners();
  }

  Map<String, double> getExpenseByCategory(){
    final Map<String, double> expensesByCategory = {};
    for (final transaction in _transactionProvider.transactions) {
      if (transaction.type.toLowerCase() != 'expense') {
        continue;
      }

      if (transaction.date.year != _selectedMonth.year ||transaction.date.month != _selectedMonth.month) {
        continue;
      }

     expensesByCategory[transaction.category] =(expensesByCategory[transaction.category] ?? 0) + transaction.amount;
    }
    return expensesByCategory;
  }
}