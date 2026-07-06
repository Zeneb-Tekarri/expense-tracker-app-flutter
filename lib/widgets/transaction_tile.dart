import 'package:expense_tracker_app/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:intl/intl.dart';

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
        subtitle: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: transaction.category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  )
                ),
                const TextSpan(
                  text: ' • ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )
                ),
                TextSpan(
                  text: transaction.type,
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )
                ),
                const TextSpan(
                  text: ' • ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  )
                ),
                TextSpan(
                  text: DateFormat('dd MMM yyyy').format(transaction.date),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ],
            )
          ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}'
            ),
            IconButton(
              icon: Icon(Icons.edit),
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