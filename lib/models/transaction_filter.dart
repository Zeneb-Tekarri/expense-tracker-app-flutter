class TransactionFilter {
  final String? category;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionFilter({
    this.category,
    this.type,
    this.startDate,
    this.endDate,
  });
  // Method to create a copy of the current filter with updated values
  TransactionFilter copyWith({
    String? category,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TransactionFilter(
      category: category ?? this.category,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
  //no filter applied
  static const empty = TransactionFilter();
}