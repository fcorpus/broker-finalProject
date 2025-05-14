import 'package:broker/constantes.dart';
import 'package:broker/models/transaction_model.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:broker/screens/login_screen.dart';
import 'package:broker/screens/transaction_form_screen.dart';
import 'package:broker/screens/transaction_history_screen.dart';
import 'package:broker/widgets/balance_card.dart';
import 'package:broker/widgets/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final txProvider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broker'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: Text(auth.username)),
          ),
          IconButton(
            onPressed: () async {
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await txProvider.loadTransactions();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Total: ${txProvider.total.toStringAsFixed(2)}'),
            Text('Ultimos 30 días', style: TextStyle(fontSize: 30, color: purpleBroker),),
            BalanceCard(
              balance: txProvider.total,
              ingresos: txProvider.ingresos30,
              gastos: txProvider.gastos30,
            ),
            const SizedBox(height: 24),
            const Text(
              'Gastos por categoría',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: purpleBroker),
            ),
            const SizedBox(height: 16),
            ChartWidget(transactions: txProvider.transactions),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionFormScreen()),
                );
              },
              child: const Text('Registrar nueva transacción'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                );
              },
              child: const Text('Revisar historial de transacciones'),
            ),
          ],
        ),
      ),
    );
  }
}
