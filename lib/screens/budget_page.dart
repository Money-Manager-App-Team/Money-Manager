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
    final double percentage = _budget.percentage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budżet'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ustal maksymalny budżet (PLN)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'np. 1000',
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Wydzielona część budżetu:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: percentage),
                      duration: const Duration(milliseconds: 400),
                      builder: (context, value, _) => Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                value > 0.9 ? Colors.redAccent : const Color(0xFF1976D2),
                              ),
                            ),
                          ),
                          Text('${(value * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Slider(
                      value: percentage,
                      onChanged: (value) {
                        setState(() {
                          _budget.value = value * _budget.max;
                          BudgetService().updateBudget(_budget);
                        });
                      },
                      min: 0.0,
                      max: 1.0,
                      divisions: 100,
                      label: '${(percentage * 100).toStringAsFixed(0)}%',
                      activeColor: const Color(0xFF1976D2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ustalona wartość: ${_budget.value.toStringAsFixed(2)} PLN',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
