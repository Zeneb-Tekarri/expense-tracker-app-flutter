import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/budget_provider.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/screens/home_screen.dart';
import 'package:expense_tracker_app/screens/transactions_screen.dart';
import 'package:expense_tracker_app/screens/budget_screen.dart';
import 'package:expense_tracker_app/screens/analytics_screen.dart';
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final transactionProvider = context.read<TransactionProvider>();
      final budgetProvider = context.read<BudgetProvider>();
      transactionProvider.init();
      budgetProvider.init();
      await transactionProvider.loadTransactions(limit: 25);
      await budgetProvider.loadBudgets();
    });
  }
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    TransactionsScreen(),
    BudgetScreen(),
    AnalyticsScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final transactionsInitialized = context.watch<TransactionProvider>().initialized;
    final budgetsInitialized = context.watch<BudgetProvider>().initialized;
    final isReady = transactionsInitialized && budgetsInitialized;
    return isReady
        ? Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [ 
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home), 
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long), 
            label: 'Transactions'
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet), 
            label: 'Budget'
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics), 
            label: 'Analytics'
          ),
        ] 
      ),
    )
    : const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }
}