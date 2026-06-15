import 'package:expense_tracker_app/widgets/transaction_form.dart';
import 'package:expense_tracker_app/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String selectedType = 'Expense';
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void saveTransaction() {
    print('Type: $selectedType');
    print('Title: ${titleController.text}');
    print('Amount: ${amountController.text}');
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
            TransactionTypeSelector(
              selectedType: selectedType,
              onTypeChanged: (newType) {
                setState(() {
                  selectedType = newType;
                });
              },
            ),
            const SizedBox(height: 16),
            TransactionForm(
              titleController: titleController,
              amountController: amountController,
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