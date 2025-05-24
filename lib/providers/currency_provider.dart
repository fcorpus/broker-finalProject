import 'dart:convert';
import 'package:broker/constantes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  final List<String> availableCurrencies = ['MXN', 'USD', 'EUR', 'GBP', 'JPY'];
  String _selectedCurrency = 'MXN';
  Map<String, double> _rates = {};
  bool _loading = false;

  String get selectedCurrency => _selectedCurrency;
  bool get isLoading => _loading;
  double getRate(String currency) => _rates[currency] ?? 1.0;

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCurrency = prefs.getString('currency') ?? 'MXN';
    await fetchRates();
  }

  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCurrency = currency;
    await prefs.setString('currency', currency);
    notifyListeners();
  }

  Future<void> fetchRates() async {
    _loading = true;
    notifyListeners();

    final uri = Uri.parse(
        'http://data.fixer.io/api/latest?access_key=$apiKey&symbols=${availableCurrencies.join(",")}&base=EUR');

    try {
      final response = await http.get(uri);
      //print('Response body: ${response.body}'); //ver respuesta era para testeo
      final data = jsonDecode(response.body);
      if (data['success']) {
        _rates = (data['rates'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble()));
        //print('Rates: $_rates'); //ver los rates de las monedas era para testeo
      } else {
        debugPrint("Error: ${data['error']['info']}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    _loading = false;
    notifyListeners();
  }

  double convertFromMXN(double amount) {
    final eurToMXN = _rates['MXN'] ?? 1.0;
    final eurToTarget = _rates[_selectedCurrency] ?? 1.0;
    return amount / eurToMXN * eurToTarget;
  }
}
