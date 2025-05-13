//import 'dart:ffi';

import 'package:broker/constantes.dart';
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
    final double localBalance = ingresos - gastos;
    Color balanceColor = localBalance >= 0 ? purpleBroker : yellowBroker;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance: \$${localBalance.toStringAsFixed(2)} MXN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: balanceColor)),
            const SizedBox(height: 12),
            Text('Ingresos: \$${ingresos.toStringAsFixed(2)} MXN', style: const TextStyle(color: purpleBroker)),
            Text('Gastos: \$${gastos.toStringAsFixed(2)} MXN', style: const TextStyle(color: yellowBroker)),
          ],
        ),
      ),
    );
  }
}
