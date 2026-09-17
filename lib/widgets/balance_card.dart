import 'package:flutter/material.dart';
class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
     margin: const EdgeInsets.all(16),
     elevation: 2,
     color: colorScheme.surfaceContainerLow,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(12),
       side: BorderSide(
         color: colorScheme.outlineVariant,
        ),
      ),
     child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

           //balance
           Icon(
             Icons.paid_outlined,
             size: 28,
             color: colorScheme.primary,
           ),
           const SizedBox(height: 8),
           Text(
             'Balance',
             style: Theme.of(context).textTheme.titleMedium,
            ),
           const SizedBox(height: 4),
           Text(
              '\$${balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                //income
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.attach_money,
                    title: 'Income',
                    amount: income,
                    color: Colors.green,
                  ),
                ),

                // Divider
                Container(
                  height: 65,
                  width: 1,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),

                //expense
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.money_off,
                    title: 'Expense',
                    amount: expense,
                    color: Colors.red,
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

class _SummaryItem extends StatelessWidget{
  final IconData icon;
  final String title;
  final double amount;
  final Color color;
  const _SummaryItem ({
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 26,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
         Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style:TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
