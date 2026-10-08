import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction_filter.dart';

class SearchFilterProvider extends ChangeNotifier {
 String _searchQuery = '';
 TransactionFilter _filters = TransactionFilter.empty;
  
  String get searchQuery => _searchQuery;
  TransactionFilter get filters => _filters;

  bool get hasActiveFilters {
    return _searchQuery.trim().isNotEmpty || !_filters.isEmpty;
  }
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  void updateFilters(TransactionFilter newFilters) {
    _filters = newFilters;
    notifyListeners();
  }
  void updateTypeFilter(String? type){
    _filters = _filters.copyWith(type: type,
    category: null, );
    notifyListeners();
  }
  void updateCategoryFilter(String? category){
    _filters = _filters.copyWith(category: category);
    notifyListeners();
  }
  void updateDateRangeFilter(DateTime? startDate, DateTime? endDate){
    _filters = _filters.copyWith(startDate: startDate, endDate: endDate);
    notifyListeners();
  }
  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }
  void clearTypeFilter() {
    _filters = _filters.copyWith(type: null, category: null);
    notifyListeners();
  }
  void clearCategoryFilter() {
    _filters = _filters.copyWith(category: null);
    notifyListeners();
  }
  void clearDateRangeFilter() {
    _filters = _filters.copyWith(startDate: null, endDate: null);
    notifyListeners();
  }
  void clearAllFilters() {
    _searchQuery = '';
    _filters = TransactionFilter.empty;
    notifyListeners();
  }
}