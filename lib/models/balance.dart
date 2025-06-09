import 'package:money_manager/models/transaction.dart';

class Balance {
  final double total;
  final double income;
  final double expense;

  Balance({required this.total, required this.income, required this.expense});

  factory Balance.fromTransactions(List<AppTransaction> transactions) {
    double total = 0;
    double income = 0;
    double expense = 0;

    for (var tx in transactions) {
      final amount =
          double.tryParse(
            tx.amount.replaceAll(RegExp(r'[^0-9.,-]'), '').replaceAll(',', '.'),
          ) ??
          0.0;

      if (amount >= 0) {
        income += amount;
      } else {
        expense += amount;
      }
      total += amount;
    }

    return Balance(total: total, income: income, expense: expense);
  }
}
