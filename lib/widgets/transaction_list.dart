
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isSearching;
  final bool hasActiveFilters;
  const TransactionList({super.key, required this.transactions, required this.isSearching, required this.hasActiveFilters});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          isSearching 
            ? 'No transactions found\nTry a different search term' 
            : hasActiveFilters
              ? 'No transactions match your filters\nTry changing or clearing your filters'
              : 'No transactions yet\nTap + to add your first transaction',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Dismissible(
          key: ValueKey(transaction.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
          onDismissed: (direction) {
            context
            .read<TransactionProvider>()
            .deleteTransaction(transaction.id!);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${transaction.title} deleted',
                ),
                duration: const Duration(seconds: 2),
              ),  
            );  
           
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Transaction'),
                content: const Text(
                  'Are you sure you want to remove this transaction?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          child: TransactionTile(transaction: transaction),
        );
      },
    );
  }
}