import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction.dart';

enum TransactionSort { newest, oldest, alphabetical, amountAsc, amountDesc }

class TransactionItem extends StatelessWidget {
  final AppTransaction transaction;

  const TransactionItem({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transaction.subtitle),
          Text(transaction.date.substring(0, 10), style: const TextStyle(fontSize: 12)),
        ],
      ),
      trailing: Text(transaction.amount),
    );
  }
}