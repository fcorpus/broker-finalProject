import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:broker/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIngreso = transaction.type == 'Ingreso';

    return Card(
      child: ListTile(
        leading: Icon(
          isIngreso ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIngreso ? Colors.green : Colors.red,
        ),
        title: Text('${isIngreso ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)} mxn'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categoría: ${transaction.category}'),
            if (transaction.note.isNotEmpty) Text('Nota: ${transaction.note}'),
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(transaction.date)}'),
          ],
        ),
      ),
    );
  }
}
