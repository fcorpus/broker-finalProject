import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constantes.dart';


void main() {
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fixer.io Demo',
      home: CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController(text: '1.0');
  final List<String> _currencies = ['USD', 'MXN', 'EUR', 'JPY', 'GBP'];
  String _selectedCurrency = 'USD';
  Map<String, double> _rates = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    setState(() => _loading = true);

    final url = Uri.parse(
      'http://data.fixer.io/api/latest?access_key=$apiKey&symbols=${_currencies.join(",")}&base=EUR',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _rates = Map<String, double>.from(data['rates']);
            _loading = false;
          });
        } else {
          _showError("Error de API: ${data['error']['info']}");
        }
      } else {
        _showError("Error HTTP: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Error de red: $e");
    }
  }

  void _showError(String message) {
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final inputAmount = double.tryParse(_amountController.text) ?? 1.0;
    final baseRate = _rates[_selectedCurrency] ?? 1.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Conversor de Divisas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: _currencies.map((currency) {
                    return DropdownMenuItem(value: currency, child: Text(currency));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCurrency = value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: _currencies
                          .where((c) => c != _selectedCurrency)
                          .map((targetCurrency) {
                            final targetRate = _rates[targetCurrency] ?? 1.0;
                            final converted = inputAmount * (targetRate / baseRate);
                            return ListTile(
                              title: Text(targetCurrency),
                              subtitle: Text(converted.toStringAsFixed(2)),
                            );
                          }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

