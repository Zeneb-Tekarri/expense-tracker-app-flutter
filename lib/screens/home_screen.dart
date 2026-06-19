
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_list.dart';
import 'package:provider/provider.dart';
import'package:expense_tracker_app/providers/transaction_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load transactions when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }
  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<TransactionProvider>().transactions;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body:Column(
        children: [
          const BalanceCard(balance: 1000.0, income: 2000.0, expense: 1000.0),
          Expanded(
            child: TransactionList(transactions: transactions,),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddTransactionScreen())
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}