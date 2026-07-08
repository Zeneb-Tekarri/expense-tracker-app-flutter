
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
  String _searchQuery = '';// State variable to hold the search query
  final TextEditingController _searchController = TextEditingController();// Controller for the search TextField
  @override
  void initState() {
    super.initState();
    // Load transactions when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }
  // Dispose the controller when the widget is disposed
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<TransactionProvider>().transactions;
    // Filter transactions based on the search query
    final filteredTransactions = transactions.where((transaction) {
      final searchLower = _searchQuery.toLowerCase().trim();
      if (searchLower.isEmpty) {
        return true; // Show all transactions if search query is empty
      }
      return transaction.title.toLowerCase().contains(searchLower) || transaction.category.toLowerCase().contains(searchLower);
    }).toList();
    final provider = context.watch<TransactionProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body:Column(
        children: [
          // Display the balance card with current balance, income, and expense
          BalanceCard(balance: provider.balance, income: provider.totalIncome, expense: provider.totalExpense),

          // Search bar for filtering transactions
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0, 
              vertical: 8.0),
            child: TextField(
              controller: _searchController,
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
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Display the list of transactions, filtered based on the search query
          Expanded(
            child: TransactionList(
              transactions: filteredTransactions,
              isSearching: _searchQuery.isNotEmpty,
            ),
          ),
        ],
      ),
      // Floating action button to navigate to the AddTransactionScreen
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