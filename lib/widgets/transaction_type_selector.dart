import 'package:flutter/material.dart';

class TransactionTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;
  const TransactionTypeSelector({
    super.key, 
    required this.selectedType, 
    required this.onTypeChanged
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'Income', label: Text('Income'), icon: Icon(Icons.arrow_upward)),
        ButtonSegment(value: 'Expense', label: Text('Expense'), icon: Icon(Icons.arrow_downward)),
      ],
      selected: {selectedType},
      onSelectionChanged: (newSelection) {
        onTypeChanged(newSelection.first);
      },
    );
  }
}