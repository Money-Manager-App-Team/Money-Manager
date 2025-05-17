import 'package:flutter/material.dart';

class BalanceItem extends StatelessWidget {
  final String label;
  final String value;

  const BalanceItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isExpense = label.toLowerCase().contains('wydat');
    final String displayedValue = isExpense ? '-$value' : value;
    final Icon arrowIcon = isExpense
        ? const Icon(Icons.arrow_downward, color: Colors.white)
        : const Icon(Icons.expand_less, color: Colors.white);

    return Column(
      children: [
        arrowIcon,
        Text(label, style: const TextStyle(color: Colors.white)),
        Text(displayedValue, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
