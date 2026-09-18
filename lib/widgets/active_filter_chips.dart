import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/transaction_filter.dart';
import 'package:intl/intl.dart';
class ActiveFilterChips extends StatelessWidget {
  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
  final TransactionFilter filters;
  final VoidCallback onClearType;
  final VoidCallback onClearCategory;
  final VoidCallback onClearDate;
  const ActiveFilterChips({ 
    super.key,
    required this.filters,
    required this.onClearType,
    required this.onClearCategory,
    required this.onClearDate,
    });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chips = <Widget>[];

     if (filters.type != null){
          chips.add(
            InputChip(
              label: Text(filters.type!),
              onDeleted: onClearType,
              backgroundColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
              deleteIconColor: colorScheme.onPrimaryContainer,
            ),
          );      
        }
     if (filters.category != null){
          chips.add(
            InputChip(
              label: Text(filters.category!),
              onDeleted: onClearCategory,
              backgroundColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
              deleteIconColor: colorScheme.onPrimaryContainer,
            ),
          );      
        }
        if(filters.startDate != null && filters.endDate != null){
           chips.add(
            InputChip(
              label: Text(
                '${_formatDate(filters.startDate!)}'
                ' - '
                '${_formatDate(filters.endDate!)}',
              ),
              onDeleted: onClearDate,
              backgroundColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
              deleteIconColor: colorScheme.onPrimaryContainer,
            ),
          );   
        }
    return Wrap(
      spacing: 8,
      runSpacing: 4, 
      children: chips,
    );
  }
}