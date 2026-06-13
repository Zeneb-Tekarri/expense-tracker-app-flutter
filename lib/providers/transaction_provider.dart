import 'package:expense_tracker_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    final transactions = await _databaseService.getTransactions();
    _transactions.clear();
    _transactions.addAll(transactions);
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
   await _databaseService.insertTransaction(transaction, );
   await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
   await _databaseService.deleteTransaction(id,);
   await loadTransactions();
  }
}