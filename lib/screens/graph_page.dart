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
  String _selectedPeriod = 'month';

  final List<String> _periods = ['day', 'week', 'month', 'year'];

  @override
  Widget build(BuildContext context) {
    final budget = BudgetService().budget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wizualizacja finansowa'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items:
                  _periods.map((period) {
                    return DropdownMenuItem<String>(
                      value: period,
                      child: Text(
                        period[0].toUpperCase() + period.substring(1),
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
              onChanged: (newPeriod) {
                setState(() {
                  _selectedPeriod = newPeriod!;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
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
            final groupedData = _groupBalances(transactions, _selectedPeriod);
            final sortedTransactions = List.of(transactions)..sort((a, b) {
              try {
                return DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
              } catch (_) {
                return 0;
              }
            });
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

  Map<String, double> _groupBalances(
    List<AppTransaction> transactions,
    String period,
  ) {
    Map<String, double> data = {};
    double runningBalance = 0.0;

    final sortedTransactions = List.of(transactions)..sort((a, b) {
      try {
        return DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
      } catch (_) {
        return 0;
      }
    });

    DateFormat formatter;
    switch (period) {
      case 'day':
        for (var i = 0; i < sortedTransactions.length; i++) {
          final tx = sortedTransactions[i];
          final amount =
              double.tryParse(
                tx.amount
                    .replaceAll(RegExp(r'[^0-9.,-]'), '')
                    .replaceAll(',', '.'),
              ) ??
              0.0;
          runningBalance += amount;
          data[i.toString()] = runningBalance;
        }
        return data;
      case 'week':
        formatter = DateFormat.E();
        break;
      case 'month':
        formatter = DateFormat.d();
        break;
      case 'year':
        formatter = DateFormat.MMM();
        break;
      default:
        formatter = DateFormat.yMd();
    }

    for (var tx in sortedTransactions) {
      try {
        final parsedDate = DateTime.parse(tx.date);
        final amount =
            double.tryParse(
              tx.amount
                  .replaceAll(RegExp(r'[^0-9.,-]'), '')
                  .replaceAll(',', '.'),
            ) ??
            0.0;
        runningBalance += amount;
        final dateKey = formatter.format(parsedDate);
        data[dateKey] = runningBalance;
      } catch (_) {
        // skip invalid dates
      }
    }

    return data;
  }

  LineChartData _createLineChartData(
    Map<String, double> data,
    Budget budget,
    List<AppTransaction> transactions,
  ) {
    final spots = <FlSpot>[];
    final isDaily = _selectedPeriod == 'day';

    final keys =
        data.keys.toList()..sort((a, b) {
          if (isDaily) {
            return int.parse(a).compareTo(int.parse(b));
          } else {
            try {
              final af = DateFormat.yMd().parse(a);
              final bf = DateFormat.yMd().parse(b);
              return af.compareTo(bf);
            } catch (_) {
              return a.compareTo(b);
            }
          }
        });

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
              if (isDaily && index < transactions.length) {
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
            if (isDaily && index < transactions.length) {
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
          isCurved: !isDaily,
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
