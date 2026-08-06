import 'package:expense_tracker_app/services/database_service.dart';
import 'package:expense_tracker_app/models/budget.dart';
import 'package:flutter/material.dart';

class BudgetProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<BudgetModel> _budgets = [];
  List<BudgetModel> get budgets => _budgets;

  // Load budgets from the database when the provider is initialized
  Future<void> loadBudgets() async {
    final budgets = await _databaseService.getBudgets();
    _budgets.clear();
    _budgets.addAll(budgets);
    notifyListeners();
  }

  // Add, update, and delete budgets
  Future<void> addBudget(BudgetModel budget) async {
    await _databaseService.insertBudget(budget);
    await loadBudgets();
  }
  Future<void> updateBudget(BudgetModel budget) async {
    await _databaseService.updateBudget(budget);
    await loadBudgets();
  }
  Future<void> deleteBudget(int id) async {
    await _databaseService.deleteBudget(id);
    await loadBudgets();
  }

  bool budgetExists({
    required String category, 
    required int month, 
    required int year,
    int? excludeId,
  }){
    return _budgets.any((budget){
      if(excludeId != null && budget.id == excludeId){
        return false;
      }
      return budget.category == category && 
      budget.month == month && 
      budget.year == year;
    });
  }

}
  
