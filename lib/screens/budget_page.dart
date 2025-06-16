import 'package:flutter/material.dart';
import 'package:money_manager/models/budget.dart';
import 'package:money_manager/services/budget_service.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Budget>(
      stream: BudgetService().budgetStream,
      initialData: BudgetService().budget,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final budget = snapshot.data!;
        if (_controller.text != budget.max.toStringAsFixed(0)) {
          _controller.text = budget.max.toStringAsFixed(0);
        }

        final percentage = budget.max == 0
            ? 0.0
            : (budget.value / budget.max).clamp(0.0, 1.0);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Budżet'),
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      'https://example.com/avatar.jpg',
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ustal maksymalny budżet (PLN)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'np. 1000',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            final parsed = double.tryParse(
                              value.replaceAll(',', '.'),
                            );
                            if (parsed != null && parsed > 0) {
                              BudgetService().updateBudget(
                                Budget(
                                  max: parsed,
                                  value: budget.value.clamp(0, parsed),
                                ),
                              );
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Wydzielona część budżetu:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                    value > 0.9
                                        ? Colors.redAccent
                                        : const Color(0xFF1976D2),
                                  ),
                                ),
                              ),
                              Text(
                                '${(value * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Slider(
                          value: percentage,
                          onChanged: (value) {
                            BudgetService().updateBudget(
                              Budget(
                                max: budget.max,
                                value: value * budget.max,
                              ),
                            );
                          },
                          min: 0.0,
                          max: 1.0,
                          divisions: 100,
                          label: '${(percentage * 100).toStringAsFixed(0)}%',
                          activeColor: const Color(0xFF1976D2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ustalona wartość: ${budget.value.toStringAsFixed(2)} PLN',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
