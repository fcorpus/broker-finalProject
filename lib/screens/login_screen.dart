import 'package:broker/constantes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:broker/screens/dashboard_screen.dart';
import 'package:broker/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> userList = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await context.read<AuthProvider>().getUserList();
    setState(() => userList = users);
  }

  Future<void> _deleteUser(String username) async {
    final auth = context.read<AuthProvider>();
    await auth.deleteUser(username);
    await _loadUsers();
  }

  void _login(String username) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.login(username);
    await context.read<TransactionProvider>().loadTransactions();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
  }

  Widget _buildUserTile(String username) {
    final avatarColor = username.hashCode.isEven ? Colors.blue : Colors.orange;

    return Card(
      color: backgroundColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: grayMargins, width: 1)
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          child: Text(username[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(username), textColor: purpleBroker,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => _confirmDelete(username),
        ),
        onTap: () => _login(username),
      ),
    );
  }

  void _confirmDelete(String username) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: grayMargins,
        title: const Text('Eliminar cuenta', style: TextStyle(color: Colors.white),),
        content: Text('¿Estás seguro de eliminar la cuenta "$username"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(username);
            },
            child: const Text('Eliminar', style: TextStyle(color: yellowBroker)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30,),
              const Text("Broker", style: TextStyle(fontSize: 70, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              userList.isEmpty
                  ? const Text("No hay cuentas guardadas", style: TextStyle(color: Colors.white54))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (_, index) => _buildUserTile(userList[index]),
                      ),
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: purpleBroker),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                },
                child: const Text('Crear cuenta nueva', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
