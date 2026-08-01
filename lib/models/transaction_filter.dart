class TransactionFilter {
  final String? category;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  static const _unset = Object();

  const TransactionFilter({
    this.category,
    this.type,
    this.startDate,
    this.endDate,
  });
  // Method to create a copy of the current filter with updated values
  TransactionFilter copyWith({
    Object? category = _unset,
    Object? type = _unset,
    Object? startDate = _unset,
    Object? endDate = _unset,
  }) {
    return TransactionFilter(
      category: category == _unset ? this.category : category as String?,
      type: type == _unset ? this.type : type as String?,
      startDate: startDate == _unset ? this.startDate : startDate as DateTime?,
      endDate: endDate == _unset ? this.endDate : endDate as DateTime?,
    );
  }
 // Method to check if the filter is empty 
  bool get isEmpty {
   return category == null && type == null && startDate == null && endDate == null;
  }
  //no filter applied
  static const empty = TransactionFilter();
}