import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTile({super.key, required this.transaction});

  

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'Income';
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: 8,
      ),
      child: ListTile(
        title: Text(transaction.title),
        subtitle: Text(transaction.type),
        trailing: Text(
          '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}'
        ),
      ),
    );
  }
}