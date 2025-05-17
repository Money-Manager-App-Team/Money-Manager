import 'package:money_manager/models/budget.dart';

class BudgetService {
  static final BudgetService _instance = BudgetService._internal();
  factory BudgetService() => _instance;

  Budget _budget = Budget(max: 1000, value: 0);

  Budget get budget => _budget;

  void updateBudget(Budget newBudget) {
    _budget = newBudget;
  }

  BudgetService._internal();
}
