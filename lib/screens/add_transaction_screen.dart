import 'package:expense_tracker_app/widgets/transaction_form.dart';
import 'package:expense_tracker_app/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  // Optional transaction parameter for editing an existing transaction
  final TransactionModel? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isLoading = false;
  String selectedType = 'Expense';
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
    setState(() {
      isLoading = true;
    });
    try{
      final amount = double.parse(
        amountController.text.trim(),
      );
      final transaction = TransactionModel(
        id: widget.transaction?.id, // Use existing ID if editing
        title: titleController.text.trim(),
        amount: amount,
        type: selectedType,
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
            TransactionForm(
              formKey: _formKey,
              titleController: titleController,
              amountController: amountController,
            ),

            const SizedBox(height: 16),
            
            TransactionTypeSelector(
              selectedType: selectedType,
              onTypeChanged: (newType) {
                setState(() {
                  selectedType = newType;
                });
              },
            ),
            
            const SizedBox(height: 24),
      
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