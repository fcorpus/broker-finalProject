import 'package:flutter/material.dart';
import 'package:broker/models/transaction_model.dart';
import 'package:broker/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  double get total => _transactions.fold(0, (sum, t) {
        return t.type == 'Ingreso' ? sum + t.amount : sum - t.amount;
      });

  double get ingresos => _transactions
      .where((t) => t.type == 'Ingreso')
      .fold(0, (sum, t) => sum + t.amount);

  double get gastos => _transactions
      .where((t) => t.type == 'Gasto')
      .fold(0, (sum, t) => sum + t.amount);

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username != null) {
      _transactions = await DatabaseService().getTransactionsByUser(username);
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await DatabaseService().insertTransaction(tx);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseService().deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
