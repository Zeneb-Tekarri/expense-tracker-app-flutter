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
    return Card(
     margin: const EdgeInsets.all(16),
     child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
           const Text('Balance'),
           const SizedBox(height: 8),
           Text(
              '\$${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Income'),
                    const SizedBox(height: 8),
                    Text(
                      '\$${income.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Expense'),
                    const SizedBox(height: 8),
                    Text(
                      '\$${expense.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
