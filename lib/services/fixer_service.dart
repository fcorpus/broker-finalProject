import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:broker/constantes.dart';


class FixerService {
  static const String baseUrl = 'http://data.fixer.io/api';

  static Future<double> getConversionRate(String toCurrency) async {
    final response = await http.get(
      Uri.parse('$baseUrl/latest?access_key=$apiKey&symbols=$toCurrency,MXN'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final rates = data['rates'];
        if (rates['MXN'] != null && rates[toCurrency] != null) {
          return rates[toCurrency] / rates['MXN'];
        }
      }
      throw Exception('Error en datos de la API Fixer');
    } else {
      throw Exception('Error al conectar con Fixer.io');
    }
  }
}
