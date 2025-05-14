import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:broker/screens/dashboard_screen.dart';

import '../constantes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();

  void _register() async {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.login(username);
      await context.read<TransactionProvider>().loadTransactions();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Broker", style: TextStyle(fontSize: 32)),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purpleBroker)),
                child: const Text('Crear cuenta'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver a iniciar sesión', style: TextStyle(color: purpleBroker),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
