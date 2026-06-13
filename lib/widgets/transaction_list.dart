
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions yet',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(transaction.title),
            subtitle: Text('\$${transaction.amount.toStringAsFixed(2)}'),
            trailing: Text(transaction.type),
          ),
        );
      },
    );
  }
}