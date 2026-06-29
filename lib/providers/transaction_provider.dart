import 'package:expense_tracker_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  // Load transactions from the database when the provider is initialized
  Future<void> loadTransactions() async {
    final transactions = await _databaseService.getTransactions();
    _transactions.clear();
    _transactions.addAll(transactions);
    notifyListeners();
    
  }
  // Add, update, and delete transactions
  Future<void> addTransaction(TransactionModel transaction) async {
   await _databaseService.insertTransaction(transaction, );
   // Reload transactions after adding a new one
   await loadTransactions();
  }
  Future<void> updateTransaction(TransactionModel transaction) async {
   await _databaseService.updateTransaction(transaction, );
   // Reload transactions after updating
   await loadTransactions();
  }
  Future<void> deleteTransaction(int id) async {
   await _databaseService.deleteTransaction(id,);
   // Reload transactions after deleting
   await loadTransactions();
  }
  // Calculate total income, total expense, and balance
  double get totalIncome {
  return _transactions
      .where((t) => t.type.toLowerCase() == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);
  }
  double get totalExpense {
  return _transactions
      .where((t) => t.type.toLowerCase() == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);
  }
  double get balance {
    return totalIncome - totalExpense;
  }
}