import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:broker/widgets/transaction_tile.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final txs = txProvider.transactions;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Transacciones')),
      body: txs.isEmpty
          ? const Center(child: Text('No hay transacciones registradas.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: txs.length,
              itemBuilder: (_, index) {
                final tx = txs[index];
                return TransactionTile(transaction: tx);
              },
            ),
    );
  }
}
