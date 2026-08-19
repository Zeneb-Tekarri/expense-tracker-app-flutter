import 'package:flutter/material.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';

class AnalyticsProvider extends ChangeNotifier {
  
  // Access transaction data from TransactionProvider
  final TransactionProvider _transactionProvider;
  AnalyticsProvider(this._transactionProvider);

  // Selected month for monthly analytics
  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  // Date range for spending-over-time analytics
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

  // Update the selected month and reset the spending range to that month
  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    resetDateRangeToSelectedMonth();
  }
  
  //set a custom date range
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
  
  // Calculate total expenses for each category in the selected month
  Map<String, double> getExpensesByCategory(){
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

  // Calculate total expense, total income and balance in the selected month
  double get totalIncome {
    return _transactionProvider.transactions
    .where((transaction) => 
     transaction.type.toLowerCase() =='income' &&
     transaction.date.year == _selectedMonth.year &&
     transaction.date.month == _selectedMonth.month
    ).fold(0.0, (sum, transaction)=> sum + transaction.amount);
  }

  double get totalExpense {
    return _transactionProvider.transactions
    .where((transaction)=>
      transaction.type.toLowerCase() == 'expense'&&
      transaction.date.year == _selectedMonth.year &&
      transaction.date.month == _selectedMonth.month
    ).fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
  
  double get balance{
    return totalIncome - totalExpense;
  }

  // Calculate daily expenses within the selected date range
  Map<DateTime, double> getDailyExpenses(){
    final Map<DateTime, double> dailyExpenses = {};

    DateTime currentDate = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day
    );

    final DateTime lastDate = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day
    );

    // Initialize every day in the range with zero spending
    while (!currentDate.isAfter(lastDate)){
      dailyExpenses[currentDate] =0.0;
      currentDate = currentDate.add(Duration(days: 1));
    }

    // Add each expense to its corresponding day
    for(final transaction in _transactionProvider.transactions){
      if(transaction.type.toLowerCase() != "expense"){
        continue;
      }
      final DateTime transactionDate = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day
      );
      if(transactionDate.isBefore(
        DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day
        ))|| transactionDate.isAfter(lastDate)){
        continue;
      }
      dailyExpenses[transactionDate]= (dailyExpenses[transactionDate] ?? 0.0) + transaction.amount;  
    }
    

    return dailyExpenses;
  }
}