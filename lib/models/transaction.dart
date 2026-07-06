class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map,) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'] ?? 'Other', // Default to 'Other' if no category is provided
      date: DateTime.parse(map['date']),
    );
  }
}