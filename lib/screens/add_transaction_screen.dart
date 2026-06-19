import 'package:expense_tracker_app/widgets/transaction_form.dart';
import 'package:expense_tracker_app/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isLoading = false;
  String selectedType = 'Expense';
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

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
        title: titleController.text.trim(),
        amount: amount,
        type: selectedType,
      );
      await context.read<TransactionProvider>().addTransaction(transaction);
      
      if (!mounted) return;
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
        title: const Text('Add Transaction'),
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