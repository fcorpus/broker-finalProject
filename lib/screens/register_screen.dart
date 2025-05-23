import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:broker/screens/dashboard_screen.dart';
import 'package:broker/constantes.dart';

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
      await authProvider.addUser(username);
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
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/registro_banner.jpg',
                        fit: BoxFit.cover,
                        height: 400,
                        width: double.infinity,
                      ),
                      Container(
                        height: 400,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              backgroundColor
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 220, 24, 24),
            child: Column(
              children: [
                const Text('Broker', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),),
                const SizedBox(height: 24,),
                const Text("Crea una cuenta", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(backgroundColor: purpleBroker),
                  child: const Text('Crear cuenta', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver a iniciar sesión', style: TextStyle(color: purpleBroker)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
