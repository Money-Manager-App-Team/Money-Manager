import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // TODO: Add transaction
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                width: double.infinity,
                color: const Color(0xFF1976D2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Cześć, użytkowniku!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
              ),

              // Balance Card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF42A5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Saldo',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '1592,00 PLN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _BalanceItem(label: 'Wydatki', value: '100,00 PLN'),
                        _BalanceItem(label: 'Przychody', value: '200,00 PLN'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Transaction History Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Historia transakcji',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.more_vert),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Transaction List
              ..._transactions.map((tx) => _TransactionItem(transaction: tx)),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// Balance item widget
class _BalanceItem extends StatelessWidget {
  final String label;
  final String value;

  const _BalanceItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.expand_less, color: Colors.white),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Data model for transactions
class Transaction {
  final String title;
  final String subtitle;
  final String date;
  final String amount;

  Transaction(this.title, this.subtitle, this.date, this.amount);
}

// Sample data
final List<Transaction> _transactions = [
  Transaction('Stokrotka', 'PŁATNOŚĆ KARTĄ', '14/01/2025', '15,50 PLN'),
  Transaction('Allegro', 'PŁATNOŚĆ INTERNETOWA', '12/01/2025', '125,00 PLN'),
  Transaction('Komputronik', 'PŁATNOŚĆ KARTĄ', '12/01/2025', '467,00 PLN'),
  Transaction('BLIK', 'PŁATNOŚĆ INTERNETOWA', '10/01/2025', '25,00 PLN'),
  Transaction('PayPal', 'PŁATNOŚĆ INTERNETOWA', '09/01/2025', '100,00 PLN'),
  Transaction('Sklep mięsny Pani Jadzi', 'PŁATNOŚĆ GOTÓWKĄ', '09/01/2025', '22,25 PLN'),
  Transaction('Biedronka', 'PŁATNOŚĆ KARTĄ', '06/01/2025', '112,79 PLN'),
  Transaction('Od Mamy', 'PRZELEW', '03/01/2025', '200,00 PLN'),
];

// Transaction list item widget
class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transaction.subtitle),
          Text(transaction.date, style: const TextStyle(fontSize: 12)),
        ],
      ),
      trailing: Text('🕒 ${transaction.amount}'),
    );
  }
}
