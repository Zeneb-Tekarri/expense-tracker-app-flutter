
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/widgets/transaction_tile.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions yet\nTap + to add your first transaction',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionTile(transaction: transaction);
      },
    );
  }
}