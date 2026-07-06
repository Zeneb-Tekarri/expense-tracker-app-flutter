import 'package:expense_tracker_app/constants/categories.dart';
import 'package:flutter/material.dart';

class TransactionCategorySelector extends StatelessWidget {
  final String selectedType;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  const TransactionCategorySelector({
    super.key, 
    required this.selectedType, 
    required this.selectedCategory, 
    required this.onCategoryChanged});
  @override
  Widget build(BuildContext context) {
    final categories = selectedType == 'Income'
    ? Categories.income
    : Categories.expense;
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map((category) => DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              ))
          .toList(),
      onChanged: onCategoryChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }
}