import 'package:flutter/material.dart';
import 'package:money_manager/models/budget.dart';
import 'package:money_manager/services/budget_service.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  late Budget _budget;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _budget = BudgetService().budget;
    _controller.text = _budget.max.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ustal budżet maksymalny (PLN):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: 'np. 1000',
            ),
            onChanged: (value) {
              final parsed = double.tryParse(value.replaceAll(',', '.'));
              if (parsed != null && parsed > 0) {
                setState(() {
                  _budget.max = parsed;
                  BudgetService().updateBudget(_budget);
                });
              }
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Dostosuj budżet dla kategorii:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _budget.percentage,
            onChanged: (value) {
              setState(() {
                _budget.value = value * _budget.max;
                BudgetService().updateBudget(_budget);
              });
            },
            min: 0.0,
            max: 1.0,
            divisions: 100,
            label: '${(_budget.percentage * 100).toStringAsFixed(0)}%',
          ),
          const SizedBox(height: 12),
          Text(
            'Ustalona wartość: ${_budget.value.toStringAsFixed(2)} PLN',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
