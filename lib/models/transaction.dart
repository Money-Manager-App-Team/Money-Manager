class AppTransaction {
  final String title;
  final String subtitle;
  final String date;
  final String amount;
  final String? userId; // Dodane pole

  AppTransaction({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    this.userId,
  });

  factory AppTransaction.fromMap(Map<String, dynamic> map) {
    return AppTransaction(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      date: map['date'] ?? '',
      amount: map['amount'] ?? '',
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'date': date,
      'amount': amount,
      'userId': userId,
    };
  }
}
