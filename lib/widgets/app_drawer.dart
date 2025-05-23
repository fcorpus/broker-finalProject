import 'package:broker/constantes.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final currencyProvider = context.watch<CurrencyProvider>();

    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          const Text("Broker", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("Moneda preferida:"),
          DropdownButton<String>(
            dropdownColor: Colors.black,
            value: currencyProvider.selectedCurrency,
            style: TextStyle(color: Colors.white),
            isExpanded: true,
            items: currencyProvider.availableCurrencies
                .map((currency) => DropdownMenuItem(value: currency, child: Text(currency)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                currencyProvider.setCurrency(value);
              }
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );
  }
}
