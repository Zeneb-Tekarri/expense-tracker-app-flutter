class BudgetModel {
  final int? id;
  final String category;
  final double amount;
  final int month;
  final int year;

  BudgetModel({
    this.id,
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });
   
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'month': month,
      'year': year,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      month: map['month'],
      year: map['year'],
    );
  }

  BudgetModel copyWith({
    int? id,
    String? category,
    double? amount,
    int? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }  

}