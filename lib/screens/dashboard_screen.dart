import 'package:broker/constantes.dart';
import 'package:broker/models/transaction_model.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/currency_provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:broker/screens/login_screen.dart';
import 'package:broker/screens/transaction_form_screen.dart';
import 'package:broker/screens/transaction_history_screen.dart';
import 'package:broker/widgets/app_drawer.dart';
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
    final currencyProvider = context.watch<CurrencyProvider>();
    
    

    final moneda = currencyProvider.selectedCurrency;
    final convert = currencyProvider.convertFromMXN;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false, // Evita back button automático
        leading: IconButton(
          color: purpleBroker,
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
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: const Text(
              'Broker',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await txProvider.loadTransactions();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('bienvenido de vuelta', style: TextStyle(fontSize: 30, color: purpleBroker), textAlign: TextAlign.right,),
            Text(auth.username, style: TextStyle(color: purpleBroker, fontSize: 35)),
            Card(
              elevation: 30,
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: grayMargins, width: 2)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total:', style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text(' \$ ${convert(txProvider.total).toStringAsFixed(2)} $moneda', style: TextStyle(fontSize: 30, color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text('Ultimos 30 días', style: TextStyle(fontSize: 30, color: purpleBroker),),
            BalanceCard(
              balance: convert(txProvider.total),
              ingresos: convert(txProvider.ingresos30),
              gastos: convert(txProvider.gastos30),
              moneda: moneda,
            ),
            const SizedBox(height: 24),
            const Text(
              'Gastos por categoría',
              style: TextStyle(fontSize: 30, color: purpleBroker),
            ),
            const SizedBox(height: 16),
            ChartWidget(transactions: txProvider.transactions),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Registrar',
                        style: TextStyle(color: purpleBroker),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: grayMargins, width: 2),
                          color: Colors.transparent,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TransactionFormScreen()),
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Nueva transacción',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Historial',
                        style: TextStyle(color: purpleBroker),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: grayMargins, width: 2),
                          color: Colors.transparent,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Ver transacciones',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
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
