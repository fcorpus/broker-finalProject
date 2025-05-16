import 'package:broker/constantes.dart';
import 'package:broker/models/transaction_model.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Gasto';
  final _amountController = TextEditingController();
  String _category = 'Entretenimiento';
  final _noteController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<AuthProvider>().username;

      final tx = TransactionModel(
        userId: userId,
        type: _type,
        amount: double.parse(_amountController.text),
        category: _type == 'Gasto' ? _category : '',
        note: _noteController.text,
        date: DateTime.now(),
      );

      await context.read<TransactionProvider>().addTransaction(tx);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final saldoDisponible = txProvider.total;
    return Scaffold(
      appBar: AppBar(title: const Text('transacción', style: TextStyle(color: purpleBroker, fontSize: 40),), backgroundColor: backgroundColor,
      iconTheme: const IconThemeData(color: Colors.white),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                dropdownColor: Colors.black,
                items: const [
                  DropdownMenuItem(value: 'Ingreso', child: Text('Ingreso', style: TextStyle(color: Colors.white),)),
                  DropdownMenuItem(value: 'Gasto', child: Text('Gasto', style: TextStyle(color: Colors.white),)),
                ],
                onChanged: (val) => setState(() => _type = val!),
                decoration: const InputDecoration(labelText: 'Tipo', labelStyle: TextStyle(color: Colors.white60)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Monto', labelStyle: TextStyle(color: Colors.white60),
                  hintText: _type == 'Gasto' ? 'Máx: \$${saldoDisponible.toStringAsFixed(2)}' : null,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Campo obligatorio';
                  final parsed = double.tryParse(val);
                  if (parsed == null) return 'Debe ser un número válido';
                  if (_type == 'Gasto' && parsed > saldoDisponible) {
                    return 'No puedes gastar más de tu saldo (\$${saldoDisponible.toStringAsFixed(2)})';
                  }
                  return null;
                },
              ),
              if (_type == 'Gasto') 
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '*maximo: \$${saldoDisponible.toStringAsFixed(2)}',
                    style: const TextStyle(color: purpleBroker, ),
                  ),
                ),
              const SizedBox(height: 12),
              if (_type == 'Gasto') ...[
                DropdownButtonFormField<String>(
                  value: _category,
                  dropdownColor: Colors.black, // Fondo del menú desplegable
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(), // Opcional para bordes
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Entretenimiento', child: Text('Entretenimiento', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'Comida', child: Text('Comida', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'Ropa', child: Text('Ropa', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'Salud', child: Text('Salud', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'Educación', child: Text('Educación', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'Hogar', child: Text('Hogar', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(value: 'Mascotas', child: Text('Mascotas', style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (val) => setState(() => _category = val!),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Nota (opcional)', labelStyle: TextStyle(color: Colors.white60)),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(backgroundColor: purpleBroker),
                child: const Text('Registrar', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
