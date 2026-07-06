import 'package:expense_tracker_app/widgets/transaction_category_selector.dart';
import 'package:expense_tracker_app/widgets/transaction_form.dart';
import 'package:expense_tracker_app/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  // Optional transaction parameter for editing an existing transaction
  final TransactionModel? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // State variables for loading, selected type, selected category,selected date and form controllers
  bool isLoading = false;
  String selectedType = 'Expense';
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();// Default to current date
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Initialize the form with existing transaction data if editing
  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      titleController.text = widget.transaction!.title;
      amountController.text = widget.transaction!.amount.toString();
      selectedType = widget.transaction!.type;
      selectedCategory = widget.transaction!.category;
      selectedDate = widget.transaction!.date;
    } else {
      selectedDate = DateTime.now(); // Default to current date for new transactions
    }
  }

  // Dispose controllers to free up resources
  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // Function to save the transaction
  Future<void> saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Validate that a category is selected
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    // Parse the amount and create a TransactionModel instance
    final text = amountController.text.trim();
    final amount = double.tryParse(text);
      
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid amount')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try{
      // Create a new transaction model with the provided data
      final transaction = TransactionModel(
        id: widget.transaction?.id, // Use existing ID if editing
        title: titleController.text.trim(),
        amount: amount,
        type: selectedType,
        category: selectedCategory ?? 'Other',// Default to 'Other' if no category is selected
        date: selectedDate, 
      );

      // Use the provider to add or update the transaction
      if (widget.transaction != null) {
        await context.read<TransactionProvider>().updateTransaction(transaction);
      } else {
        await context.read<TransactionProvider>().addTransaction(transaction);
      }
      if (!mounted) return; // Check if the widget is still mounted
      Navigator.pop(context);  // Close the screen after saving
    }
    catch (e) {
      debugPrint('Error saving transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save transaction')),
      );
    }finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Change the title based on whether we're adding or editing a transaction
        title: Text(
          widget.transaction != null 
          ? 'Edit Transaction'
          :'Add Transaction'  
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Transaction form for title and amount
            TransactionForm(
              formKey: _formKey,
              titleController: titleController,
              amountController: amountController,
            ),

            const SizedBox(height: 16),
            // Transaction type selector for Income or Expense
            TransactionTypeSelector(
              selectedType: selectedType,
              onTypeChanged: (newType) {
                setState(() {
                  selectedType = newType;
                  selectedCategory = null; // Reset category when type changes
                });
              },
            ),

            const SizedBox(height: 16),
            // Transaction category selector based on the selected type
            TransactionCategorySelector(
              selectedType: selectedType,
              selectedCategory: selectedCategory,
              onCategoryChanged: (newCategory) {
                setState(() {
                  selectedCategory = newCategory;
                });
              },
            ),

            const SizedBox(height: 16),

            // Row to display the selected date and a button to change it
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}',
                ),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text('Change'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Save button to save the transaction     
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveTransaction,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Transaction'),
              ),
            )
          ],
        ),
      ),
    );
  }
  

}