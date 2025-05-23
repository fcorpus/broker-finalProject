import 'package:broker/constantes.dart';
import 'package:broker/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:broker/models/transaction_model.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIngreso = transaction.type == 'Ingreso';

    final currencyProvider = context.read<CurrencyProvider>();

    final originalCurrency = transaction.currency;
    final targetCurrency = currencyProvider.selectedCurrency;

    final originalRate = currencyProvider.getRate(originalCurrency);
    final mxnRate = currencyProvider.getRate('MXN');
    final currentRate = currencyProvider.getRate(targetCurrency);

    final originalAmount = transaction.amount * originalRate / mxnRate;
    final convertedAmount = transaction.amount * currentRate / mxnRate;

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
        title: Text('${isIngreso ? '+' : '-'}\$${convertedAmount.toStringAsFixed(2)} $targetCurrency', style: TextStyle(color: Colors.white),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isIngreso) ...[
            Text('Categoría: ${transaction.category}', style: TextStyle(color: yellowBroker),),
            ],
            if (transaction.note.isNotEmpty) Text('Nota: ${transaction.note}', style: TextStyle(color: Colors.white60),),
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(transaction.date)}', style: TextStyle(color: purpleBroker),),
            Text('Registrado como: ${originalAmount.toStringAsFixed(2)} $originalCurrency',
                style: const TextStyle(fontSize: 12, color: purpleBroker)),
          ],
        ),
      ),
    );
  }
}
