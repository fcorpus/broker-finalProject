//import 'dart:ffi';

import 'package:broker/constantes.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double ingresos;
  final double gastos;
  final String moneda;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.ingresos,
    required this.gastos,
    required this.moneda,
  });

  BarChart _buildHorizontalBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: (ingresos > gastos ? ingresos : gastos) * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Ingresos');
                  case 1:
                    return const Text('Gastos');
                  default:
                    return const SizedBox.shrink();
                }
              },
              reservedSize: 42,
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: ingresos,
                color: purpleBroker,
                width: 22,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: gastos,
                color: yellowBroker,
                width: 22,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double localBalance = ingresos - gastos;
    Color balanceColor = localBalance >= 0 ? purpleBroker : yellowBroker;
    return Card(
      color: backgroundColor,
      elevation: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: grayMargins, width: 2)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: _buildHorizontalBarChart(),
                ),
            ),
            Text('Ingresos: \$${ingresos.toStringAsFixed(2)} $moneda', style: const TextStyle(color: purpleBroker)),
            Text('Gastos: \$${gastos.toStringAsFixed(2)} $moneda', style: const TextStyle(color: yellowBroker)),
            Text('Balance: \$${localBalance.toStringAsFixed(2)} $moneda',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: balanceColor)),
            const SizedBox(height: 12),
            
          ],
        ),
      ),
    );
  }
}
