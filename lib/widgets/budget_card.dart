import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/models/budget.dart';



class BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final double totalSpent;
  final VoidCallback onEdit;
  const BudgetCard({
    super.key, 
    required this.budget, 
    required this.totalSpent,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final remainingAmount = budget.amount - totalSpent;

    final progress = budget.amount == 0
    ? 0.0
    : (totalSpent / budget.amount).clamp(0.0, 1.0);

    final percentage = budget.amount == 0
    ? 0.0
    : (totalSpent / budget.amount) * 100;

    final isExceeded = totalSpent > budget.amount;
    
    Color progressColor;
    if (isExceeded || progress >= 0.8) {
      progressColor = colorScheme.error;
    } else if (progress >= 0.5) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Display the category and an edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.category,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Budget',
                  onPressed: onEdit,
                ),
              ],
            ),

            const SizedBox(height: 4.0),

            // Display the month and year of the budget
            Text(
              DateFormat.yMMMM().format(
                DateTime(budget.year, budget.month)
              ),
              style: TextStyle(
                fontSize: 16.0,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 8.0),
            
            //Financial details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _BudgetValue(
                    label: 'Budget',
                    value: budget.amount,
                  ),
                ),
                Expanded(
                  child: _BudgetValue(
                    label: 'Spent',
                    value: totalSpent,
                  ),
                ),
                Expanded(
                  child: _BudgetValue(
                    label: 'Remaining',
                    value: remainingAmount,
                    valueColor: isExceeded ? colorScheme.error : colorScheme.onSurface,
                  ),
                ),
              ], 
            ),

            const SizedBox(height: 8.0),
            
            // Display the progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10.0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),

            const SizedBox(height: 8.0),

            // Display the percentage used and budget exceeded message
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}% used',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isExceeded) Text(
                  'Budget Exceeded!',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _BudgetValue extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;
  const _BudgetValue({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: valueColor ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
      
    