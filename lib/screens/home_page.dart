import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/models/balance.dart';
import 'package:money_manager/services/transaction_service.dart';
import 'package:money_manager/services/budget_service.dart';
import 'package:money_manager/widgets/add_transaction_dialog.dart';
import 'package:money_manager/widgets/balance_item.dart';
import 'package:money_manager/widgets/transaction_item.dart';
import 'package:money_manager/screens/budget_page.dart';
import 'package:money_manager/screens/graph_page.dart';
import 'package:money_manager/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionService transactionService = TransactionService();
  int _currentIndex = 2; // domyślnie widok home

  final List<Widget> _pages = const [
    GraphPage(),
    BudgetPage(),
    _MainHomeContent(),
    ProfilePage(),
    Center(child: Text('Ustawienia (w przygotowaniu)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddTransactionDialog(),
                ).then((_) => setState(() {}));
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF1976D2),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}

class _MainHomeContent extends StatefulWidget {
  const _MainHomeContent();

  @override
  State<_MainHomeContent> createState() => _MainHomeContentState();
}

class _MainHomeContentState extends State<_MainHomeContent> {
  final TransactionService transactionService = TransactionService();
  TransactionSort _currentSort = TransactionSort.newest;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppTransaction>>(
      stream: transactionService.getTransactions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final transactions = List<AppTransaction>.from(snapshot.data!);
        final balance = Balance.fromTransactions(transactions);
        final budget = BudgetService().budget;
        final bool overBudget = balance.expense.abs() > budget.value;
        final bool negativeBalance = balance.expense.abs() > balance.income;

        transactions.sort((a, b) {
          switch (_currentSort) {
            case TransactionSort.newest:
              return b.date.compareTo(a.date);
            case TransactionSort.oldest:
              return a.date.compareTo(b.date);
            case TransactionSort.alphabetical:
              return a.title.toLowerCase().compareTo(b.title.toLowerCase());
            case TransactionSort.amountAsc:
              return _extractAmount(a).compareTo(_extractAmount(b));
            case TransactionSort.amountDesc:
              return _extractAmount(b).compareTo(_extractAmount(a));
          }
        });

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                width: double.infinity,
                color: const Color(0xFF42A5F5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cześć, użytkowniku!', style: TextStyle(color: Colors.white, fontSize: 18)),
                    PopupMenuButton<String>(
                      offset: const Offset(-40, 0),
                      onSelected: (_) {},
                      itemBuilder: (context) {
                        if (overBudget) {
                          return [
                            const PopupMenuItem<String>(
                              value: 'budget',
                              child: Text('Twoje wydatki przekroczyły budżet'),
                            ),
                          ];
                        } else {
                          return [
                            const PopupMenuItem<String>(
                              value: 'empty',
                              child: Text('Brak powiadomień'),
                            ),
                          ];
                        }
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: overBudget ? Colors.yellowAccent : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: negativeBalance ? Colors.redAccent : const Color(0xFF42A5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('Saldo', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${balance.total.toStringAsFixed(2)} PLN',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BalanceItem(label: 'Wydatki', value: '${balance.expense.abs().toStringAsFixed(2)} PLN'),
                        BalanceItem(label: 'Przychody', value: '${balance.income.toStringAsFixed(2)} PLN'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Historia transakcji', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    PopupMenuButton<TransactionSort>(
                      onSelected: (sort) => setState(() => _currentSort = sort),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: TransactionSort.newest, child: Text('Od najnowszych')),
                        const PopupMenuItem(value: TransactionSort.oldest, child: Text('Od najstarszych')),
                        const PopupMenuItem(value: TransactionSort.alphabetical, child: Text('Alfabetycznie')),
                        const PopupMenuItem(value: TransactionSort.amountAsc, child: Text('Od najmniejszych')),
                        const PopupMenuItem(value: TransactionSort.amountDesc, child: Text('Od największych')),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...transactions.map((tx) => TransactionItem(transaction: tx)).toList(),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  double _extractAmount(AppTransaction tx) {
    return double.tryParse(tx.amount.replaceAll(RegExp(r'[^0-9.,-]'), '').replaceAll(',', '.')) ?? 0.0;
  }
}
