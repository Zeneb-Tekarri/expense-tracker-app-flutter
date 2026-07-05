class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'] ?? 'Other', // Default to 'Other' if no category is provided
    );
  }
}