import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/budget_provider.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final budgets = context.watch<BudgetProvider>().budgets;
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
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            final budget = budgets[index];
            return ListTile(
              title: Text('${budget.category} - ${budget.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat.yMMM().format(
                  DateTime(budget.year, budget.month)
                ),
              ),
              trailing: const Icon(Icons.edit),
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