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
    final transaction = TransactionModel(
      title: titleController.text.trim(),
      amount: double.parse(amountController.text.trim()),
      type: selectedType,
    );
      await context.read<TransactionProvider>().addTransaction(transaction);
      if (!mounted) return;
      Navigator.pop(context); // Close the screen after saving
  
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
                onPressed: saveTransaction,
                child: const Text('Save Transaction'),
              ),
            )
          ],
        ),
      ),
    );
  }
  

}