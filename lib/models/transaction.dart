class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
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
    );
  }
}