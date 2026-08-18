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

    while (!currentDate.isAfter(lastDate)){
      dailyExpenses[currentDate] =0.0;
      currentDate = currentDate.add(Duration(days: 1));
    }

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
        )
      )|| transactionDate.isAfter(lastDate)){
        continue;
      }
      dailyExpenses[transactionDate]= (dailyExpenses[transactionDate] ?? 0.0) + transaction.amount;  
    }
    

    return dailyExpenses;
  }
}