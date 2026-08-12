import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/budget.dart';
import 'package:expense_tracker_app/constants/categories.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/budget_provider.dart';

class AddEditBudgetScreen extends StatefulWidget {
  final BudgetModel? budget; 
  
  const AddEditBudgetScreen({
    super.key, this.budget
  });

  @override
  State<AddEditBudgetScreen> createState() => _AddEditBudgetScreenState();
}

class _AddEditBudgetScreenState extends State<AddEditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;

  // Initialize the form with existing budget data if editing
  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _amountController.text = widget.budget!.amount.toString();
      _selectedCategory = widget.budget!.category;
    }else {
      _selectedCategory = Categories.expense.first;
    }
  }

  // Dispose controllers to free up resources
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

 // Save or update button logic
  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = double.parse(_amountController.text);
    final now = DateTime.now();
    final budgetProvider = context.read<BudgetProvider>();
    final exists = budgetProvider.budgetExists(
      category: _selectedCategory!,
      month: now.month,
      year: now.year,
      excludeId: widget.budget?.id,
    );
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A budget for $_selectedCategory already exists for this month.'),
        ),
      );
      return;
    }
    if (widget.budget == null) {
      await budgetProvider.addBudget(
        BudgetModel(
          category: _selectedCategory!,
          amount: amount,
          month: now.month,
          year: now.year,
        ),
      );  
    } else {
      await budgetProvider.updateBudget(
        widget.budget!.copyWith(
          category: _selectedCategory,
          amount: amount,
        ),
      );
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.budget != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing 
         ? 'Edit Budget' 
         : 'Add Budget'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[

             //Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: Categories.expense.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              //Amount TextField
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Budget Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ), 
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a budget amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ), 

              const SizedBox(height: 20),

              // save update button
              ElevatedButton(
                onPressed: () {
                  _saveBudget();
                },
                child: Text(
                  isEditing
                  ? 'Update Budget'
                  : 'Save Budget', 
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}