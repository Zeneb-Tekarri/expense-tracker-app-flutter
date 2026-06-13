
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<TransactionModel> dummyTransactions = [
      TransactionModel(id: 1, title: 'Salary', amount: 2000.0, type: 'Income'),
      TransactionModel(id: 2, title: 'Groceries', amount: 150.0, type: 'Expense'),
      TransactionModel(id: 3, title: 'Electricity Bill', amount: 100.0, type: 'Expense'),
      TransactionModel(id: 4, title: 'Transportation', amount: 250.0, type: 'Expense'),
      TransactionModel(id: 5, title: 'Rent', amount: 500.0, type: 'Expense')
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body:Column(
        children: [
          const BalanceCard(balance: 1000.0, income: 2000.0, expense: 1000.0),
          Expanded(
            child: TransactionList(transactions: dummyTransactions,),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}