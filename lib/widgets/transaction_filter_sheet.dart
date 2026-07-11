import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction_filter.dart';

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
  @override
  void initState() {
    _currentFilter = widget.initialFilter;
    _selectedType = _currentFilter.type;
    super.initState();
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
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedType == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = null;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _selectedType == 'income',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = 'income';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: _selectedType == 'expense',
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = 'expense';
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16.0),

            // filter for  category
           
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