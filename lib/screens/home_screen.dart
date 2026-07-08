
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
  String _searchQuery = '';
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
    final provider = context.watch<TransactionProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body:Column(
        children: [
          BalanceCard(balance: provider.balance, income: provider.totalIncome, expense: provider.totalExpense),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title or category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
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