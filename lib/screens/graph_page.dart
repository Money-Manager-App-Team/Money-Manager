import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/budget.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/services/transaction_service.dart';
import 'package:money_manager/services/budget_service.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    final budget = BudgetService().budget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wizualizacja finansowa'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<AppTransaction>>(
        stream: TransactionService().getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else {
            final transactions = snapshot.data ?? [];

            // Always sort oldest to newest
            final sortedTransactions = List.of(transactions)
              ..sort((a, b) {
                try {
                  return DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
                } catch (_) {
                  return 0;
                }
              });

            final groupedData = _groupBalances(sortedTransactions);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                _createLineChartData(groupedData, budget, sortedTransactions),
              ),
            );
          }
        },
      ),
    );
  }

  Map<String, double> _groupBalances(List<AppTransaction> transactions) {
    Map<String, double> data = {};
    double runningBalance = 0.0;

    for (var i = 0; i < transactions.length; i++) {
      final tx = transactions[i];
      final amount = double.tryParse(
            tx.amount.replaceAll(RegExp(r'[^0-9.,-]'), '').replaceAll(',', '.')) ??
          0.0;
      runningBalance += amount;
      data[i.toString()] = runningBalance;
    }

    return data;
  }

  LineChartData _createLineChartData(
    Map<String, double> data,
    Budget budget,
    List<AppTransaction> transactions,
  ) {
    final spots = <FlSpot>[];

    final keys = data.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    for (int i = 0; i < keys.length; i++) {
      final y = data[keys[i]]!;
      final x = i.toDouble();
      spots.add(FlSpot(x, y));
    }

    bool isUnderBudget = spots.any((spot) => spot.y < budget.max);

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.grey.shade200,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              int index = spot.x.toInt();
              String tooltipText;
              if (index < transactions.length) {
                final tx = transactions[index];
                tooltipText =
                    '${tx.title}\n${tx.amount} PLN\n${DateFormat.yMMMd().format(DateTime.parse(tx.date))}';
              } else {
                tooltipText = 'Saldo: ${spot.y.toStringAsFixed(2)} PLN';
              }
              return LineTooltipItem(
                tooltipText,
                const TextStyle(color: Colors.black),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          if (event is FlTapUpEvent &&
              response != null &&
              response.lineBarSpots != null) {
            final tappedSpot = response.lineBarSpots!.first;
            int index = tappedSpot.x.toInt();
            if (index < transactions.length) {
              final tx = transactions[index];
              _showTransactionDetailsDialog(tx);
            }
          }
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: Colors.blue,
          belowBarData: BarAreaData(
            show: isUnderBudget,
            color: Colors.blue.withOpacity(0.2),
          ),
          dotData: FlDotData(show: true),
        ),
      ],
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
    );
  }

  void _showTransactionDetailsDialog(AppTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(transaction.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (transaction.subtitle.isNotEmpty)
                Text(
                  transaction.subtitle,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 8),
              Text('Kwota: ${transaction.amount}'),
              Text(
                'Data: ${DateFormat.yMMMd().format(DateTime.parse(transaction.date))}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zamknij'),
            ),
          ],
        );
      },
    );
  }
}
