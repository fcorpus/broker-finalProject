import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:broker/models/transaction_model.dart';

class ChartWidget extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ChartWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = <String, double>{};

    for (var tx in transactions.where((t) => t.type == 'Gasto')) {
      categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    final sections = categoryTotals.entries.map((e) {
      final value = e.value;
      return PieChartSectionData(
        value: value,
        title: e.key,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      );
    }).toList();

    if (sections.isEmpty) {
      return const Text('No hay gastos para graficar');
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 30,
        ),
      ),
    );
  }
}
