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
        category: _category,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Transacción')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'Ingreso', child: Text('Ingreso')),
                  DropdownMenuItem(value: 'Gasto', child: Text('Gasto')),
                ],
                onChanged: (val) => setState(() => _type = val!),
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
                validator: (val) => val == null || val.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),
              if (_type == 'Gasto') ...[
                DropdownButtonFormField<String>(
                  value: _category,
                  items: const [
                    DropdownMenuItem(value: 'Entretenimiento', child: Text('Entretenimiento')),
                    DropdownMenuItem(value: 'Comida', child: Text('Comida')),
                    DropdownMenuItem(value: 'Ropa', child: Text('Ropa')),
                    DropdownMenuItem(value: 'Salud', child: Text('Salud')),
                    DropdownMenuItem(value: 'Educación', child: Text('Educación')),
                    DropdownMenuItem(value: 'Hogar', child: Text('Hogar')),
                    DropdownMenuItem(value: 'Mascotas', child: Text('Mascotas'))
                  ],
                  onChanged: (val) => setState(() => _category = val!),
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Nota (opcional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
