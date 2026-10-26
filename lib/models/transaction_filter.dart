class TransactionFilter {
  final String? category;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
  static const _unset = Object();

  const TransactionFilter({
    this.category,
    this.type,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
  });
  // Method to create a copy of the current filter with updated values
  TransactionFilter copyWith({
    Object? category = _unset,
    Object? type = _unset,
    Object? startDate = _unset,
    Object? endDate = _unset,
    Object? minAmount = _unset,
    Object? maxAmount = _unset,
  }) {
    return TransactionFilter(
      category: category == _unset ? this.category : category as String?,
      type: type == _unset ? this.type : type as String?,
      startDate: startDate == _unset ? this.startDate : startDate as DateTime?,
      endDate: endDate == _unset ? this.endDate : endDate as DateTime?,
      minAmount: minAmount == _unset ? this.minAmount : minAmount as double?,
      maxAmount: maxAmount == _unset ? this.maxAmount : maxAmount as double?,
    );
  }
 // Method to check if the filter is empty 
  bool get isEmpty {
   return category == null && type == null && startDate == null && endDate == null && minAmount == null && maxAmount == null;
  }
  //no filter applied
  static const empty = TransactionFilter();
}