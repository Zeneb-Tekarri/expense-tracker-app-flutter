import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction_filter.dart';
import 'package:expense_tracker_app/constants/categories.dart';

class TransactionFilterSheet extends StatefulWidget {
  final TransactionFilter initialFilter;
  const TransactionFilterSheet({
    super.key, 
    required this.initialFilter
  });

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late TransactionFilter _currentFilter;
  String? _selectedType;
  String? _selectedCategory;
  
  // State variables to hold the selected type and category
  @override
  void initState() {
    _currentFilter = widget.initialFilter;
    _selectedType = _currentFilter.type;
    _selectedCategory = _currentFilter.category;
    super.initState();
  }
  
  // Getter to return the available categories based on the selected type
  List<String> get _availableCategories {
    if (_selectedType == null) {
      return [
        ...Categories.income,
        ...Categories.expense,
      ];
    }
    return _selectedType == 'Income' 
    ? Categories.income 
    : Categories.expense;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title for the filter sheet
            const Text(
              'Filter Transactions',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            // filter for  type (income/expense)
            // Title for the transaction type filter
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transaction Type',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Wrap widget to display the choice chips for transaction type
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedType == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = null;
                      _selectedCategory = null; // Reset the selected category when the type is changed to all
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _selectedType == 'Income',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = 'Income';
                      _selectedCategory = null; // Reset the selected category when the type is changed to income
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: _selectedType == 'Expense',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = 'Expense';
                      _selectedCategory = null; // Reset the selected category when the type is changed to expense
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16.0),

            // filter for  category
            // Title for the category filter
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Wrap widget to display the choice chips for categories
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
                ..._availableCategories.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null; // Set the selected category when the chip is selected, or reset it to null when deselected
                      });
                    },
                  );
                })
              ],
            ),

            const SizedBox(height: 16.0),

            // filter for  start and end dates

            const SizedBox(height: 16.0),

            // Row containing the Clear and Apply buttons
            Row(
              children: [
                // Clear button to reset the filter
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context, TransactionFilter.empty); // Reset the filter to empty when the button is pressed
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ),

                const SizedBox(width: 8),
                // Apply button to apply the selected filter
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context, 
                        _currentFilter.copyWith(
                          type: _selectedType,
                          category: _selectedCategory,
                        )
                      ); // Return the selected filter when the button is pressed
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}