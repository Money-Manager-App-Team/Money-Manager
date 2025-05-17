import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/services/transaction_service.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _amountController = TextEditingController();
  final TransactionService _service = TransactionService();

  bool _isIncome = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowa transakcja'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Tytuł'),
          ),
          TextField(
            controller: _subtitleController,
            decoration: const InputDecoration(labelText: 'Opis'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Kwota'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Typ transakcji: '),
              Expanded(
                child: DropdownButton<bool>(
                  value: _isIncome,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Przychód')),
                    DropdownMenuItem(value: false, child: Text('Wydatek')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _isIncome = value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () async {
            double parsedAmount = double.tryParse(
              _amountController.text.replaceAll(',', '.')) ?? 0.0;
            if (!_isIncome) parsedAmount *= -1;

            final tx = AppTransaction(
              title: _titleController.text,
              subtitle: _subtitleController.text,
              date: DateTime.now().toIso8601String(),
              amount: '${parsedAmount.toStringAsFixed(2)} PLN',
            );
            await _service.addTransaction(tx);
            Navigator.of(context).pop();
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
