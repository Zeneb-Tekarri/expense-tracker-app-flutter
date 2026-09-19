import 'package:expense_tracker_app/screens/add_transaction_screen.dart';
import 'package:expense_tracker_app/screens/transactions_screen.dart';
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

    final provider = context.watch<TransactionProvider>();
    //// Display only the 5 most recent transactions
    final recentTransactions = [...provider.transactions]..sort((a, b) => b.date.compareTo(a.date));
    final latestTransactions = recentTransactions.take(5).toList();

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text('Expense Tracker'),
      ),

      body:Column(
        children: [

          // Display the balance card with current balance, income, and expense
          BalanceCard(balance: provider.balance, income: provider.totalIncome, expense: provider.totalExpense),
          
          // Recent transactions header
          Padding( 
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8), 
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [ 
                const Text( 
                  'Recent Transactions', 
                  style: TextStyle( 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                  ), 
                ),
                TextButton(
                  onPressed:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransactionsScreen())
                    );
                  }, 
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ), 

          // Display the list of recent transactions 
          Expanded(
            child: TransactionList(
              transactions: latestTransactions,
              isSearching : false,
              hasActiveFilters: false,
            ),
          ),
        ],
      ),

      // Floating action button to navigate to the AddTransactionScreen
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const AddTransactionScreen())
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}