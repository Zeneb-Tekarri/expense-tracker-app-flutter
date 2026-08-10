import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/budget_provider.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:expense_tracker_app/screens/add_edit_budget_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {

  @override
  void initState() {
    super.initState();
    // Load budgets when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetProvider>().loadBudgets();
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final budgets = context.watch<BudgetProvider>().budgets;
    final transactionProvider = context.watch<TransactionProvider>();

    return Scaffold(

      appBar: AppBar(
        title: const Text('Budgets'),
      ),

      body: budgets.isEmpty

       ? const Center(
          child: Text(
            'No budgets yet.\n\nTap + to create your first budget.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )
       )

       :ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            final budget = budgets[index];
            final totalSpent = transactionProvider.getMonthlySpent(category: budget.category, month: budget.month, year: budget.year);
            return ListTile(
              title: Text(budget.category, 
               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMM().format(
                      DateTime(budget.year, budget.month)
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Budget: \$${budget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Spent: \$${totalSpent.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              trailing: Text('\$${totalSpent.toStringAsFixed(2)}'),
              onTap: () async {
                //implement edit budget functionality
                await Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => AddEditBudgetScreen(budget: budget)
                  )
                );
                if (mounted) {
                  context.read<BudgetProvider>().loadBudgets();
                }
              },  
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Implement add budget functionality
          await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddEditBudgetScreen())
          );
          if (mounted) {
            context.read<BudgetProvider>().loadBudgets();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}