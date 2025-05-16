import 'package:broker/constantes.dart';
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
      color: backgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: grayMargins, width: 2)
      ),
      child: ListTile(
        leading: Icon(
          isIngreso ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIngreso ? purpleBroker : yellowBroker,
        ),
        title: Text('${isIngreso ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)} mxn', style: TextStyle(color: Colors.white),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isIngreso) ...[
            Text('Categoría: ${transaction.category}', style: TextStyle(color: yellowBroker),),
            ],
            if (transaction.note.isNotEmpty) Text('Nota: ${transaction.note}', style: TextStyle(color: Colors.white60),),
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(transaction.date)}', style: TextStyle(color: purpleBroker),),
          ],
        ),
      ),
    );
  }
}
