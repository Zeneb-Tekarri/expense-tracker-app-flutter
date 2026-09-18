import 'package:expense_tracker_app/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTile({
    super.key, 
    required this.transaction
  });

  

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'Income';
    final colorScheme = Theme.of(context).colorScheme;
    final transactionColor = isIncome ? Colors.green : Colors.red;
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16, 
        vertical: 6,
      ),
      elevation: 1,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        //Title 
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        //Category, Type and Date
        subtitle: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
              
                TextSpan(
                  text: transaction.category,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  )
                ),

                TextSpan(
                  text: ' • ',
                  style: TextStyle(
                    color: colorScheme.outline,
                    fontSize: 14,
                  )
                ),

                TextSpan(
                  text: transaction.type,
                  style: TextStyle(
                    color: transactionColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )
                ),

                TextSpan(
                  text: ' • ',
                  style: TextStyle(
                    color: colorScheme.outline,
                    fontSize: 14,
                  )
                ),

                TextSpan(
                  text: DateFormat('dd MMM yyyy').format(transaction.date),
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            )
          ),
        // Amount and Edit button
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: transactionColor,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              tooltip : 'Edit Transaction',
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(transaction: transaction),
                  ),
                );
              },
            ),
          ],
        ),
      ),  
    );
  }
}