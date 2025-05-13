import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double ingresos;
  final double gastos;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.ingresos,
    required this.gastos,
  });

  @override
  Widget build(BuildContext context) {
    Color balanceColor = balance >= 0 ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance: \$${balance.toStringAsFixed(2)} MXN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: balanceColor)),
            const SizedBox(height: 12),
            Text('Ingresos: \$${ingresos.toStringAsFixed(2)} MXN', style: const TextStyle(color: Colors.green)),
            Text('Gastos: \$${gastos.toStringAsFixed(2)} MXN', style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
